import express from 'express';
import path from 'path';
import * as fs from 'fs';
import * as v8 from 'v8';
import * as BlobProcessor from "../BlobProcessor";
import { Kernel, KERNEL_MAX_X } from '../util/PythonUtil';
import { IMAGE_HEIGHT } from '../util/Constants';
import { calculateIDX, drawEllipse, drawLine, drawPixel, drawQuad } from '../util/OtherUtil';
import { virtexConfig } from '../util/VirtexConfig';
import { BlobStatus } from '../BlobUtil';
import { NULL_BLACK_RUN_BLOB_ID } from '../BlobConstants';
import { Fault } from '../util/Fault';
const png = require('pngjs').PNG;
const app: express.Application = express();
const port: number = 34;

//Options
let drawOptions: {[index: string]: boolean} = {
    blobColor: false,
    bound: false,
    quad: true,
    quadCenterLines: true,
    quadCorners: false,
    ellipse: false
};
const IMAGES_INPUT_PATH = 'images';
let imageFile = 'Angles.png';
let imageUrl = () => path.join(IMAGES_INPUT_PATH, imageFile);

//EJS Page
const imageFiles = fs.readdirSync('images');
app.use('/assets', express.static('app/assets', {maxAge: '1d'}));
app.set('view engine', 'ejs');
app.get('/', (req: express.Request, res: express.Response) => {
    res.render(path.join(__dirname, '/App'), { drawOptions, imageFiles });
});

//Blob Processor + Python Sim
let kx: number, ky: number;
let pythonDone: boolean;
let loopCount: number;
let tempKernel: Kernel;
let image: any;
function update() {
    //"36MHz" Kernel Reading (PythonManager)
    if (loopCount % 5 == 0 && !pythonDone) {
        tempKernel.pos = { x: kx, y: ky };
        tempKernel.valid = true;
        for (let x = 0; x < 8; x++) {
            const idx = calculateIDX(kx * 8 + x, ky);
            const value = (image.data[idx] + image.data[idx + 1] + image.data[idx + 2]) / 3;
            const threshold = value > virtexConfig.threshold;
            tempKernel.value[x] = threshold;
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
    kx = 0, ky = 0;
    pythonDone = false;
    loopCount = 0;
    tempKernel = {
        value: [...Array(8)].map(_=>false),
        pos: { x: kx, y: ky },
        valid: true
    };

    //read image
    image = png.sync.read(fs.readFileSync(imageUrl()));
}

//Image
function drawImage(): any {
    let tempImage = v8.deserialize(v8.serialize(image));

    //Draw Blob Color
    if (drawOptions.blobColor) {
        for (let y = 0; y < BlobProcessor.blobColorBuffer.length; y++) {
            let runBufferX = 0;
            for (let i = 0; i < BlobProcessor.blobColorBuffer[y].count; i++) {
                const run = BlobProcessor.blobColorBuffer[y].runs[i];

                //if run is black ignore it
                if (run.blobID !== NULL_BLACK_RUN_BLOB_ID) {
                    //if run has pointer blobID => follow it
                    const realBlobID = BlobProcessor.blobMetadatas[run.blobID].status == 
                        BlobStatus.POINTER ? BlobProcessor.getRealBlobIDDebug(run.blobID) : run.blobID;

                    //if run has valid blobID (or valid pointer blobID) => draw it
                    if (BlobProcessor.blobMetadatas[realBlobID].status == BlobStatus.VALID) {
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
        if (BlobProcessor.blobMetadatas[i].status == BlobStatus.VALID) {
            if (drawOptions.bound) {
                drawQuad(tempImage.data,
                    {
                        topLeft: blob.boundTopLeft,
                        topRight: { x: blob.boundBottomRight.x, y: blob.boundTopLeft.y },
                        bottomRight: blob.boundBottomRight,
                        bottomLeft: { x: blob.boundTopLeft.x, y: blob.boundBottomRight.y }
                    },
                    [255, 0, 0, 100]
                );
            }

            if (drawOptions.ellipse) {
                drawEllipse(tempImage.data,
                    blob.quad.topLeft,
                    blob.quad.topRight,
                    blob.quad.bottomRight,
                    blob.quad.bottomLeft,
                    [0, 0, 255, 100]
                );
            }

            if (drawOptions.quad) {
                drawQuad(tempImage.data, blob.quad, [0, 255, 0, 100]);
            }

            if (drawOptions.quadCenterLines) {
                drawLine(tempImage.data,
                    { x: ((blob.quad.topLeft.x + blob.quad.topRight.x-1) / 2.0),
                      y: ((blob.quad.topLeft.y + blob.quad.topRight.y) / 2.0) },
                    { x: ((blob.quad.bottomLeft.x + blob.quad.bottomRight.x-1) / 2.0),
                      y: ((blob.quad.bottomLeft.y-1 + blob.quad.bottomRight.y-1) / 2.0) },
                    [0, 0, 255, 255]
                );
                drawLine(tempImage.data,
                    { x: ((blob.quad.topLeft.x + blob.quad.bottomLeft.x) / 2.0),
                      y: ((blob.quad.topLeft.y + blob.quad.bottomLeft.y-1) / 2.0) },
                    { x: ((blob.quad.topRight.x-1 + blob.quad.bottomRight.x-1) / 2.0),
                      y: ((blob.quad.topRight.y + blob.quad.bottomRight.y-1) / 2.0)},
                    [255, 0, 255, 255]
                );
            }

            if (drawOptions.quadCorners) {
                drawPixel(tempImage.data, { x: blob.quad.topLeft.x      , y: blob.quad.topLeft.y       }, [255, 255, 0, 255]); //yellow
                drawPixel(tempImage.data, { x: blob.quad.topRight.x-1   , y: blob.quad.topRight.y      }, [0, 255, 255, 255]); //cyan
                drawPixel(tempImage.data, { x: blob.quad.bottomRight.x-1, y: blob.quad.bottomRight.y-1 }, [0,   0, 255, 255]); //blue
                drawPixel(tempImage.data, { x: blob.quad.bottomLeft.x   , y: blob.quad.bottomLeft.y-1  }, [255, 0, 255, 255]); //purple
            }
        }
    }

    return tempImage;
}
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

//Host
app.listen(port, () => {
  return console.log(`Blob App @ http://localhost:${port}`);
});