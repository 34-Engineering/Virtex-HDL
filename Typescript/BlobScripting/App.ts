import express from 'express';
import path from 'path';
import { Server } from 'socket.io';
import * as http from 'http';
import * as fs from 'fs';
import * as BlobProcessor from "./BlobProcessor";
import { Kernel, KERNEL_MAX_X } from './util/PythonUtil';
import { IMAGE_HEIGHT, IMAGE_WIDTH } from './util/Constants';
import { calculateIDX, drawCenterFillSquare, drawEllipse, drawFillRect, drawLine, drawPixel, drawQuad10, drawRect } from './util/DrawUtil';
import { virtexConfig } from './util/VirtexConfig';
import { BlobAngle, BlobStatus, calcBlobAngle } from './BlobUtil';
import { NULL_BLOB_INDEX, NULL_TIMESTAMP } from './BlobConstants';
import { Fault } from './util/Fault';
import { PNG } from 'pngjs';
import { Vector2d10 } from './util/Math';
import { deepCopy } from './util/DrawUtil';
import { blobBRAMMem, boolToReg1, runFIFOLength, runFIFOMem } from './util/VerilogUtil';
const app: express.Application = express();

//Options (+ defaults)
let drawOptions: {[index: string]: boolean} = {
    blobColor: true,
    blobBound: true,
    blobQuad10: false,
    blobAngle: true,
    blobQuad10Corners: false,
    blobEllipse: false,
    target: true,
    crosshair: true,
    kernelPos: false,
    kernelLine: true
};
let imageFile = '2019.png';
const IMAGES_INPUT_PATH = '../images';
const autoStepFrame = true;

//Express (PC->Web)
const imageFiles = fs.readdirSync(IMAGES_INPUT_PATH);
app.use('/assets', express.static('assets', {maxAge: '1d'}));
app.set('view engine', 'ejs');
app.get('/', (req: express.Request, res: express.Response) => res.render(path.join(__dirname, '/App'), { drawOptions, imageFile, imageFiles }));
app.use("/socket.io.js", express.static(path.join(__dirname, 'node_modules/socket.io/client-dist/socket.io.js')));
app.use("/socket.io.js.map", express.static(path.join(__dirname, 'node_modules/socket.io/client-dist/socket.io.js.map')));
const server = http.createServer(app);

//Blob Processor + Python Sim
let kx: number, ky: number; //(0,0) to (79,479)
export let pythonDone: boolean;
let loopCount: number;
let runStart: number;
let runBlack: boolean = false;
let image: any;
function update() {
    //"36MHz" Kernel Reading (PythonManager)
    if (loopCount % 5 == 0 && !pythonDone) {
        for (let ix = 0; ix < 8; ix++) {
            const px = kx * 8 + ix; //kernelPos * kernelSize + intraKernelPos/pixelOffset
            const idx = calculateIDX(px, ky);
            const value = (image.data[idx] + image.data[idx + 1] + image.data[idx + 2]) / 3;
            const threshold = value > virtexConfig.threshold;
            
            //@ line start
            if (px == 0) {
                runStart = px;
                runBlack = !threshold;
            }

            //@ end line 
            else if (px == (IMAGE_WIDTH-1)) {
                BlobProcessor.addToRunFIFO({
                    length: px - runStart, //no +1 because px is after line
                    line: ky,
                    black: boolToReg1(runBlack)
                });
            }

            //@ color change
            else if (runBlack == threshold) {
                BlobProcessor.addToRunFIFO({
                    length: px - runStart, //no +1 because px is after line
                    line: ky,
                    black: boolToReg1(runBlack)
                });

                runStart = px;
                runBlack = !threshold;
            }
        }

        if (kx === KERNEL_MAX_X) {
            if (ky !== IMAGE_HEIGHT - 1) {
                ky = ky + 1;
                if (ky % 80 == 0) console.log("LINE:", ky, runFIFOLength(), BlobProcessor.getBlobIndex());
                kx = 0;
            }
            else pythonDone = true;
        }
        else kx = kx + 1;
    }

    //"180MHz" Always FF
    BlobProcessor.always_ff();

    loopCount = loopCount + 1;
}
function reset() {
    //reset sim
    kx = 0, ky = 0;
    pythonDone = false;
    loopCount = 0;

    //read image
    const imageUrl = path.join(IMAGES_INPUT_PATH, imageFile);
    image = PNG.sync.read(fs.readFileSync(imageUrl));

    //send frame
    sendFrame();
}
function getFaults() {
    const arr: string[] = [];
    //FIXME
    // for (const fault of BlobProcessor.faults) {
    //     if (fault !== Fault.NO_FAULT) {
    //         arr.push(Fault[fault]);
    //     }
    // }
    return arr;
}

//FIXME
export function draw(x: number, y: number): void {
    const idx = calculateIDX(x, y);
    image.data[idx] = 255;
    image.data[idx+1] = 0;
}

//Image
function drawImage(): any {
    //Deep Copy Image
    let tempImage = deepCopy(image);

    //Draw Blob Color
    if (drawOptions.blobColor) {
        for (let y = 0; y < BlobProcessor.blobColorBuffer.length; y++) {
            for (let i = 0; i < BlobProcessor.blobColorBuffer[y].count; i++) {
                const run = BlobProcessor.blobColorBuffer[y].runs[i];

                //if run is black ignore it
                if (run.blobIndex !== NULL_BLOB_INDEX || BlobProcessor.blobMetadatas[run.blobIndex]?.status == BlobStatus.POINTER) {                    
                    //if run has pointer blobIndex => follow it
                    const realBlobIndex: number = BlobProcessor.getBlobPointerIndexDebug(run.blobIndex);

                    //if run has valid blobIndex (or valid pointer blobIndex) => draw it
                    if (BlobProcessor.blobMetadatas[realBlobIndex].status !== BlobStatus.GARBAGE) {
                        for (let x = run.start; x <= run.end; x++) {
                            drawPixel(tempImage.data, { x, y }, [
                                //generate unique color based on blob index
                                Math.sin(realBlobIndex * 50) * 200 + 55,
                                Math.sin(realBlobIndex * 100) * 200 + 55,
                                Math.sin(realBlobIndex * 200) * 200 + 55,
                                255
                            ]);
                        }
                    }
                }
            }      
        }
    }

    //Draw Blob Bounding Box + Polygon + Ellipse
    for (let i = 0; i < BlobProcessor.getBlobIndex(); i++) {
        const blob = blobBRAMMem[i];
        // console.log(blob);
        if (BlobProcessor.blobMetadatas[i].status == BlobStatus.VALID ||
            BlobProcessor.blobMetadatas[i].status == BlobStatus.UNSCANED) {
            if (drawOptions.blobAngle) {
                calcBlobAngle(blob, tempImage.data);
            }

            if (drawOptions.blobEllipse) {
                drawEllipse(tempImage.data,
                    blob.boundTopLeft,
                    blob.boundBottomRight,
                    [0, 0, 255, 100]
                );
            }

            if (drawOptions.blobQuad10) {
                drawQuad10(tempImage.data, blob.quad, [0, 255, 0, 100]);
            }

            if (drawOptions.blobBound) {
                drawRect(tempImage.data, blob.boundTopLeft, blob.boundBottomRight, [255, 0, 0, 100]);
            }

            if (drawOptions.blobQuad10Corners) {
                drawCenterFillSquare(tempImage.data, { x: blob.quad.topLeft.x      , y: blob.quad.topLeft.y       }, 2, [255, 255, 0, 255]); //yellow
                drawCenterFillSquare(tempImage.data, { x: blob.quad.topRight.x-1   , y: blob.quad.topRight.y      }, 2, [0, 255, 255, 255]); //cyan
                drawCenterFillSquare(tempImage.data, { x: blob.quad.bottomRight.x-1, y: blob.quad.bottomRight.y-1 }, 2, [0,   0, 255, 255]); //blue
                drawCenterFillSquare(tempImage.data, { x: blob.quad.bottomLeft.x   , y: blob.quad.bottomLeft.y-1  }, 2, [255, 0, 255, 255]); //purple
            }
        }
    }

    // //Draw Target
    // if (drawOptions.target && BlobProcessor.target.timestamp !== NULL_TIMESTAMP) {
    //     //bound
    //     drawRect(tempImage.data, {
    //         x: BlobProcessor.target.center.x - (BlobProcessor.target.width >> 1),
    //         y: BlobProcessor.target.center.y - (BlobProcessor.target.height >> 1)
    //     }, {
    //         x: BlobProcessor.target.center.x + (BlobProcessor.target.width >> 1),
    //         y: BlobProcessor.target.center.y + (BlobProcessor.target.height >> 1)
    //     }, [125, 255, 125, 255]);

    //     //center
    //     drawCenterFillSquare(tempImage.data, BlobProcessor.target.center, 2, [125, 255, 125, 255]);
    // }

    //Draw Kernel Pos & Line
    if (drawOptions.kernelPos) {
        drawCenterFillSquare(tempImage.data, { x: kx*8, y: ky }, 2, [255, 215, 0, 128]);
    }
    if (drawOptions.kernelLine) {
        drawLine(tempImage.data,
            { x: 0, y: ky },
            { x: IMAGE_WIDTH-1, y: ky },
            [255, 215, 0, 128]
        );
    }

    // //Draw Crosshair
    // if (drawOptions.crosshair) {
    //     drawLine(tempImage.data, {
    //         x: virtexConfig.targetCenterX,
    //         y: virtexConfig.targetCenterY - 4.5 
    //     }, {
    //         x: virtexConfig.targetCenterX,
    //         y: virtexConfig.targetCenterY + 5
    //     }, [0, 255, 100, 255]);
    //     drawLine(tempImage.data, {
    //         x: virtexConfig.targetCenterX - 4,
    //         y: virtexConfig.targetCenterY
    //     }, {
    //         x: virtexConfig.targetCenterX + 5,
    //         y: virtexConfig.targetCenterY
    //     }, [0, 255, 100, 255]);
    // }

    //Return Drawn Image
    return tempImage;
}

//Step
async function step(count: number) {
    console.log(" ------------------------ PROCESSING ALL ------------------------ ");
    //update sim "count" times
    for (let i = 0; i < count; i++) {
        // if (!BlobProcessor.isDone()) { //FIXME
            update();
        // }
        // else break;
    }
    console.log(" ----------------------------- DONE ----------------------------- ");
    sendFrame();
    fs.writeFileSync('out.png', PNG.sync.write(drawImage()));
}
//Socket (PC->Web)
const io = new Server(server);
function sendFrame() {
    io.emit('frame', { frame: drawImage().data, faults: getFaults() });
}
io.on('connection', (socket) => {
    console.log('Web Connected');
    sendFrame();

    socket.on('disconnect', () => {
        console.log('Web Disconnected');
    });
    socket.on('step', (req) => {
        step(req.count);
    });
    socket.on('reset', () => {
        reset();
    });
    socket.on('changeImageFile', (req) => {
        imageFile = req.file;
        reset();
    });
    socket.on('changeDrawOption', (req) => {
        drawOptions[req.option] = !!req.enabled;
        sendFrame();
    });
});
//init
reset();
if (autoStepFrame) step(5 * 80 * 480 + 50000);

setInterval(() => {
    io.emit('ping', process.pid);
}, 250);

//Host Webapp
server.listen(34, function () {
    console.log(`Hosting @ http://localhost:${34}`);
});