import express from 'express';
import path from 'path';
import { Server } from 'socket.io';
import * as http from 'http';
import * as fs from 'fs';
import * as BlobProcessor from "./src/VisionProcessor";
import { IMAGE_HEIGHT, IMAGE_WIDTH } from './src/Constants';
import { calculateIDX, drawCenterFillSquare, drawEllipse, drawFillRect, drawLine, drawPixel, drawQuad10, drawRect } from './src/DrawUtil';
import { virtexConfig } from './src/VirtexConfig';
import { calcBlobAngle, isTargetNull } from './src/VisionUtil';
import { NULL_BLOB_INDEX, RUN_FIFO_LENGTH } from './src/VisionConstants';
import { Faults } from './src/Fault';
import { PNG } from 'pngjs';
import { deepCopy } from './src/DrawUtil';
import { growingBlobsBRAM, finishedBlobsBRAM, boolToReg1, clearRunFIFO, addToRunFIFO, runFIFOLength, runFIFOMem } from './src/VerilogUtil';
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
    kernelLine: true,
    growingMem: true
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
const KERNEL_MAX_X = IMAGE_WIDTH / 8 - 1;
let kx: number, ky: number; //(0,0) to (79,479)
export let pythonDone: boolean;
let loopCount: number;
let runStart: number;
let runBlack: boolean = false;
let image: any;
function update() {
    //"36MHz" Kernel Reading (PythonManager)
    if (loopCount % 5 == 0 && !pythonDone) {
        if (kx == KERNEL_MAX_X && (ky+1) % 80 == 0) console.log("LINE:", ky, "FIFO LEN:", runFIFOLength(), "BLOBS:", BlobProcessor.getMakerGrowingIndex());

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
                if (runFIFOLength() >= RUN_FIFO_LENGTH) {
                    //TODO fault
                }
                else addToRunFIFO({
                    length: px - runStart + 1,
                    line: ky,
                    black: boolToReg1(runBlack)
                });
            }

            //@ color change
            else if (runBlack == threshold) {
                if (runFIFOLength() >= RUN_FIFO_LENGTH) {
                    //TODO fault
                }
                else addToRunFIFO({
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
    //read image
    const imageUrl = path.join(IMAGES_INPUT_PATH, imageFile);
    image = PNG.sync.read(fs.readFileSync(imageUrl));

    //reset python sim
    kx = 0, ky = 0;
    pythonDone = false;
    loopCount = 0;
    clearRunFIFO();

    //reset blob processor
    BlobProcessor.clearFaults();
    while (BlobProcessor.isDone())
        update();

    //send frame
    sendFrame(true);
}
function getFaults() {
    const arr: (keyof Faults)[] = [];
    for (const fault in BlobProcessor.getFaults()) {
        if (BlobProcessor.getFaults()[fault as keyof Faults] == 1) {
            arr.push(fault as keyof Faults);
        }
    }
    return arr;
}

//Image
function drawImage(clearDraw?: boolean): any {
    if (clearDraw) return image;

    //Deep Copy Image
    let tempImage = deepCopy(image);

    //Draw Blob Color
    if (drawOptions.blobColor) {
        for (let y = 0; y < Math.min(BlobProcessor.getBlobColorBuffer().length, ky); y++) {
            for (let i = 0; i < BlobProcessor.getBlobColorBuffer()[y].count; i++) {
                const run = BlobProcessor.getBlobColorBuffer()[y].runs[i];

                //if run is black ignore it
                if (run.blobIndex !== NULL_BLOB_INDEX && growingBlobsBRAM.mem[run.blobIndex].area !== 0) {                  
                    //if run has valid blobIndex (or valid pointer blobIndex) => draw it
                    for (let x = run.start; x <= run.stop; x++) {
                        drawPixel(tempImage.data, { x, y }, [
                            //generate unique color based on blob index
                            Math.sin(run.blobIndex * 50) * 200 + 55,
                            Math.sin(run.blobIndex * 100) * 200 + 55,
                            Math.sin(run.blobIndex * 200) * 200 + 55,
                            255
                        ]);
                    }
                }
            }      
        }
    }

    //Draw Blob Bounding Box + Polygon + Ellipse
    const bramMem = drawOptions.growingMem ? growingBlobsBRAM.mem : finishedBlobsBRAM.mem;
    const bramMax = drawOptions.growingMem ? BlobProcessor.getMakerGrowingIndex() : BlobProcessor.getTrainFinishedIndex();
    for (let i = 0; i < bramMax; i++) {
        const blob = bramMem[i];
        // console.log(blob);
        if (blob.area != 0) {
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

    //Draw Target
    if (drawOptions.target && !isTargetNull(BlobProcessor.getTarget())) {
        //bound
        drawRect(tempImage.data, {
            x: BlobProcessor.getTarget().center.x - (BlobProcessor.getTarget().width >> 1),
            y: BlobProcessor.getTarget().center.y - (BlobProcessor.getTarget().height >> 1)
        }, {
            x: BlobProcessor.getTarget().center.x + (BlobProcessor.getTarget().width >> 1),
            y: BlobProcessor.getTarget().center.y + (BlobProcessor.getTarget().height >> 1)
        }, [125, 255, 125, 255]);

        //center
        drawCenterFillSquare(tempImage.data, BlobProcessor.getTarget().center, 2, [125, 255, 125, 255]);
    }

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

    //Draw Crosshair
    if (drawOptions.crosshair) {
        drawLine(tempImage.data, {
            x: virtexConfig.targetCenterX,
            y: virtexConfig.targetCenterY - 4.5 
        }, {
            x: virtexConfig.targetCenterX,
            y: virtexConfig.targetCenterY + 5
        }, [0, 255, 100, 255]);
        drawLine(tempImage.data, {
            x: virtexConfig.targetCenterX - 4,
            y: virtexConfig.targetCenterY
        }, {
            x: virtexConfig.targetCenterX + 5,
            y: virtexConfig.targetCenterY
        }, [0, 255, 100, 255]);
    }

    //Return Drawn Image
    return tempImage;
}

//Step
async function step(count: number) {
    //update sim "count" times
    for (let i = 0; i < count; i++) {
        if (!BlobProcessor.isDone()) {
            update();
        }
        else break;
    }
    sendFrame();
    fs.writeFileSync('out.png', PNG.sync.write(drawImage()));
}
//Socket (PC->Web)
const io = new Server(server);
function sendFrame(clearDraw?: boolean) {
    io.emit('frame', { frame: drawImage(clearDraw).data, faults: getFaults() });
}
io.on('connection', (socket) => {
    console.log('Web Connected');
    sendFrame();

    socket.on('disconnect', () => {
        console.log('Web Disconnected');
    });
    socket.on('step', (req) => {
        console.log("Stepping", req.count);
        step(req.count);
    });
    socket.on('reset', () => {
        console.log("Reset");
        reset();
    });
    socket.on('changeImageFile', (req) => {
        console.log("Changing image file to", req.file);
        imageFile = req.file;
        reset();
    });
    socket.on('changeDrawOption', (req) => {
        console.log("Changing draw", req.option, "to", !!req.enabled);
        drawOptions[req.option] = !!req.enabled;
        sendFrame();
    });
});

//Init
reset();
if (autoStepFrame) {
    console.log("Auto Stepping");
    step(Number.MAX_SAFE_INTEGER);
    console.log("Done Auto Stepping");
}

setInterval(() => {
    io.emit('ping', process.pid);
}, 250);

//Host Webapp
server.listen(34, function () {
    console.log(`Hosting @ http://localhost:${34}`);
});