import express from 'express';
import path from 'path';
import * as fs from 'fs';
import * as v8 from 'v8';
import * as BlobProcessor from "./BlobProcessor";
import { Kernel, KERNEL_MAX_X } from './util/PythonUtil';
import { IMAGE_HEIGHT, IMAGE_WIDTH } from './util/Constants';
import { calculateIDX, drawCenterFillSquare, drawEllipse, drawFillRect, drawLine, drawPixel, drawQuad, drawRect } from './util/OtherUtil';
import { virtexConfig } from './util/VirtexConfig';
import { BlobStatus, calcBlobAngle } from './BlobUtil';
import { NULL_BLACK_RUN_BLOB_ID } from './BlobConstants';
import { Fault } from './util/Fault';
import { PNG } from 'pngjs';
const app: express.Application = express();

//Options (+ defaults)
let drawOptions: {[index: string]: boolean} = {
    blobColor: true,
    bound: true,
    quad: false,
    quadCenterLine: true,
    quadCorners: true,
    ellipse: false,
    centroid: false,
    kernelPos: false,
    kernelLine: true
};
let imageFile = 'Angles.png';
const IMAGES_INPUT_PATH = 'images';
const autoStepFrame = true;

//EJS Page
const imageFiles = fs.readdirSync('images');
app.use('/assets', express.static('assets', {maxAge: '1d'}));
app.set('view engine', 'ejs');
app.get('/', (req: express.Request, res: express.Response) => {
    res.render(path.join(__dirname, '/App'), { drawOptions, imageFile, imageFiles });
});

//Blob Processor + Python Sim
let kx: number, ky: number; //(0,0) to (79,479)
let pythonDone: boolean;
let loopCount: number;
let tempKernel: Kernel;
let image: any;
function update() {
    //"36MHz" Kernel Reading (PythonManager)
    if (loopCount % 5 == 0 && !pythonDone) {
        tempKernel.pos = { x: kx, y: ky };
        tempKernel.valid = true;
        for (let ix = 0; ix < 8; ix++) {
            //kx is kernel pos & ix is interkernel pos
            //so px (pixel x) = kx * kernelSize + ix
            //& kernels are 1 tall so ky == py
            const px = kx * 8 + ix;
            const idx = calculateIDX(px, ky);
            const value = (image.data[idx] + image.data[idx + 1] + image.data[idx + 2]) / 3;
            const threshold = value > virtexConfig.threshold;
            tempKernel.value[ix] = threshold;
        }
        BlobProcessor.sendKernel(tempKernel);

        if (kx === KERNEL_MAX_X) {
            if (ky !== IMAGE_HEIGHT - 1) {
                ky = ky + 1;
                kx = 0;
            }
            else {
                pythonDone = true;
            }
        }
        else  {
            kx = kx + 1;
        }
    }
    else {
        tempKernel.valid = false;
        BlobProcessor.sendKernel(tempKernel);
    }

    //"180MHz" Always Loop
    BlobProcessor.alwaysLoop();

    //"180MHz" Sync BRAM
    BlobProcessor.updateBRAM();

    loopCount = loopCount + 1;
}
function reset() {
    //reset sim
    BlobProcessor.reset();
    BlobProcessor.resetFaults();
    kx = 0, ky = 0;
    pythonDone = false;
    loopCount = 0;
    tempKernel = {
        value: [...Array(8)].map(_=>false),
        pos: { x: kx, y: ky },
        valid: true
    };

    //read image
    const imageUrl = path.join(IMAGES_INPUT_PATH, imageFile);
    image = PNG.sync.read(fs.readFileSync(imageUrl));
}

//Image
function drawImage(): any {
    //Copy Image
    let tempImage = v8.deserialize(v8.serialize(image));

    //Draw Blob Color
    if (drawOptions.blobColor) {
        for (let y = 0; y < BlobProcessor.blobColorBuffer.length; y++) {
            let runBufferX: number = 0;
            for (let i = 0; i < BlobProcessor.blobColorBuffer[y].count; i++) {
                const run = BlobProcessor.blobColorBuffer[y].runs[i];

                //if run is black ignore it
                if (run.blobID !== NULL_BLACK_RUN_BLOB_ID) {                    
                    //if run has pointer blobID => follow it
                    const realBlobID: number = BlobProcessor.blobMetadatas[run.blobID].status == 
                        BlobStatus.POINTER ? BlobProcessor.getRealBlobIDDebug(run.blobID) : run.blobID;

                    //if run has valid blobID (or valid pointer blobID) => draw it
                    if (BlobProcessor.blobMetadatas[realBlobID].status !== BlobStatus.GARBAGE) {
                        for (let x = runBufferX; x < runBufferX + run.length; x++) {
                            drawPixel(tempImage.data, { x, y }, [
                                //generate unique color based on pos
                                Math.sin(realBlobID * 50) * 200 + 55,
                                Math.sin(realBlobID * 100) * 200 + 55,
                                Math.sin(realBlobID * 200) * 200 + 55,
                                255
                            ]);
                        }
                    }
                }
                
                runBufferX = runBufferX + run.length;
            }      
        }
    }

    //Draw Blob Bounding Box + Polygon + Ellipse
    for (let i = 0; i < BlobProcessor.blobIndex; i++) {
        const blob = BlobProcessor.blobBRAM[i];
        if (BlobProcessor.blobMetadatas[i].status == BlobStatus.VALID ||
            BlobProcessor.blobMetadatas[i].status == BlobStatus.UNSCANED) {
            if (drawOptions.quadCenterLine) {
                console.log(calcBlobAngle(blob, tempImage.data) * (180 / Math.PI));
            }

            if (drawOptions.ellipse) {
                drawEllipse(tempImage.data,
                    blob.boundTopLeft,
                    blob.boundBottomRight,
                    [0, 0, 255, 100]
                );
            }

            if (drawOptions.quad) {
                drawQuad(tempImage.data, blob.quad, [0, 255, 0, 100]);
            }

            if (drawOptions.bound) {
                drawRect(tempImage.data, blob.boundTopLeft, blob.boundBottomRight, [255, 0, 0, 100]);
            }

            if (drawOptions.quadCorners) {
                drawCenterFillSquare(tempImage.data, { x: blob.quad.topLeft.x      , y: blob.quad.topLeft.y       }, 2, [255, 255, 0, 255]); //yellow
                drawCenterFillSquare(tempImage.data, { x: blob.quad.topRight.x-1   , y: blob.quad.topRight.y      }, 2, [0, 255, 255, 255]); //cyan
                drawCenterFillSquare(tempImage.data, { x: blob.quad.bottomRight.x-1, y: blob.quad.bottomRight.y-1 }, 2, [0,   0, 255, 255]); //blue
                drawCenterFillSquare(tempImage.data, { x: blob.quad.bottomLeft.x   , y: blob.quad.bottomLeft.y-1  }, 2, [255, 0, 255, 255]); //purple
            }

            if (drawOptions.centroid) {
                //draw bound center + centroid
                drawCenterFillSquare(tempImage.data, {
                    x: (blob.boundTopLeft.x + blob.boundBottomRight.x) >> 1,
                    y: (blob.boundTopLeft.y + blob.boundBottomRight.y) >> 1
                }, 2, [255,255,0,255]);
                drawCenterFillSquare(tempImage.data, blob.centroid, 2, [0,255,255,255]);
            }
        }
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

    //Return Drawn Image
    return tempImage;
}

//Step
function step(count: number) {
    //update sim "count" times
    for (let i = 0; i < count; i++) {
        if (!BlobProcessor.isDone()) {
            update();
        }
        else break;
    }
}

//Actions
app.use(express.json());
app.post('/step', (req: express.Request, res: express.Response) => {
    try {
        step(req.body.count);
        res.send({ image: drawImage(), faults: getFaults(), error: false });
    }
    catch (e) { res.send({ error: e }); }
});
app.post('/reset', (req: express.Request, res: express.Response) => {
    try {
        reset();
        if (autoStepFrame) {
            step(Number.MAX_SAFE_INTEGER);
        }
        res.send({ image: drawImage(), faults: getFaults(), error: false });
    }
    catch (e) { res.send({ error: e }); }
});
app.post('/changeImageFile', (req: express.Request, res: express.Response) => {
    try {
        imageFile = req.body.file;
        reset();
        res.send({ image: drawImage(), faults: getFaults(), error: false });
    }
    catch (e) { res.send({ error: e }); }
});
app.post('/changeDrawOption', (req: express.Request, res: express.Response) => {
    try {
        drawOptions[req.body.option] = !!req.body.enabled;
        res.send({ image: drawImage(), faults: getFaults(), error: false });
    }
    catch (e) { res.send({ error: e }); }
});
function getFaults() {
    const arr: string[] = [];
    for (const fault of BlobProcessor.faults) {
        if (fault !== Fault.NO_FAULT) {
            arr.push(Fault[fault]);
        }
    }
    return arr;
}

//Host Webapp
app.post('/ping', (req: express.Request, res: express.Response) => {
    res.send({ pid: process.pid });
});
const port: number = 34;
app.listen(port, () => {
  return console.log(`Blob App @ http://localhost:${port}`);
});