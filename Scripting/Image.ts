import * as fs from "fs";
import * as path from "path";
import { calculateIDX, drawEllipse, drawLine, drawPixel, Kernel, KERNEL_MAX_X } from "./util/OtherUtil";
import * as BlobProcessor from "./BlobProcessor";
import { IMAGE_HEIGHT } from "./util/Constants";
import { NULL_BLACK_RUN_BLOB_ID } from "./BlobConstants";
import { BlobStatus } from "./BlobUtil";
import { Vector } from "./util/Math";
import { Fault } from "./util/Fault";
import { virtexConfig } from "./util/VirtexConfig";

const IMAGES_INPUT_PATH = 'images';
const IMAGES_OUTPUT_PATH = 'output';
const IMAGE_INPUT_PATH = 'images/Angles.png';
const IMAGE_OUTPUT_PATH = 'out.png';
const DRAW_BLOB_COLOR = false;
const DRAW_BOUND = false;
const DRAW_QUAD = true;
const DRAW_QUAD_CENTER_LINES = true;
const DRAW_QUAD_CORNERS = false;
const DRAW_ELLIPSE = false;

const drawing = require('pngjs-draw');
const png = drawing(require('pngjs').PNG);
let data: any;

//Run Image (scripting only)
function runImage(imageInputPath: string, imageOutputPath: string): Promise<void> {
    BlobProcessor.reset();

    return new Promise(function(resolve) {
        const stream = fs.createReadStream(imageInputPath);
        const img = stream.pipe(new png());
        img.on('parsed', function () {
            //@ts-ignore
            data = this.data;
            BlobProcessor.importData(data);

            //"180MHz" Process Loop
            let kx: number = 0, ky: number = 0;
            let pythonDone: boolean = false;
            let loopCount: number = 0;
            let tempKernel: Kernel = {
                value: [...Array(8)].map(_=>false),
                pos: { x: kx, y: ky },
                valid: true
            };
            while (!BlobProcessor.isDone()) {
                //"36MHz" Kernel Reading (PythonManager)
                if (loopCount % 5 == 0 && !pythonDone) {
                    tempKernel.pos = { x: kx, y: ky };
                    tempKernel.valid = true;
                    for (let x = 0; x < 8; x++) {
                        const idx = calculateIDX(kx * 8 + x, ky);
                        //@ts-ignore
                        const value = (this.data[idx] + this.data[idx + 1] + this.data[idx + 2]) / 3;
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
            
            //Logging
            console.log({ blobs: BlobProcessor.blobIndex });
            
            //Draw Blob Color
            if (DRAW_BLOB_COLOR) {
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
                                    const idx = calculateIDX(x, y);
                                    data[idx] = Math.sin(realBlobID * 50) * 200 + 55;
                                    data[idx + 1] = Math.sin(realBlobID * 100) * 200 + 55;
                                    data[idx + 2] = Math.sin(realBlobID * 200) * 200 + 55;
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
                    if (DRAW_BOUND) {
                        // @ts-ignore
                        this.drawRect(
                            blob.boundTopLeft.x,
                            blob.boundTopLeft.y,
                            blob.boundBottomRight.x - blob.boundTopLeft.x,
                            blob.boundBottomRight.y - blob.boundTopLeft.y,
                            [255, 0, 0, 100]
                        );
                    }

                    if (DRAW_ELLIPSE) {
                        drawEllipse(
                            data,
                            blob.quadTopLeft,
                            blob.quadTopRight,
                            blob.quadBottomRight,
                            blob.quadBottomLeft,
                            [0, 0, 255, 100]
                        );
                    }

                    if (DRAW_QUAD) {
                        // @ts-ignore
                        drawLine(
                            data,
                            { x: blob.quadTopLeft.x   , y: blob.quadTopLeft.y },
                            { x: blob.quadTopRight.x-1, y: blob.quadTopRight.y },
                            [0, 255, 0, 100]
                        );

                        //@ts-ignore
                        drawLine(
                            data,
                            { x: blob.quadTopRight.x-1   , y: blob.quadTopRight.y     },
                            { x: blob.quadBottomRight.x-1, y: blob.quadBottomRight.y-1},
                            [0, 255, 0, 100]
                        );

                        //@ts-ignore
                        drawLine(
                            data,
                            { x: blob.quadBottomRight.x-1, y: blob.quadBottomRight.y-1},
                            { x: blob.quadBottomLeft.x   , y: blob.quadBottomLeft.y-1 },
                            [0, 255, 0, 100]
                        );

                        //@ts-ignore
                        drawLine(
                            data,
                            { x: blob.quadBottomLeft.x, y: blob.quadBottomLeft.y-1},
                            { x: blob.quadTopLeft.x   , y: blob.quadTopLeft.y   },
                            [0, 255, 0, 100]
                        );
                    }

                    if (DRAW_QUAD_CENTER_LINES) {
                        const midTop: Vector = {
                            x: ((blob.quadTopLeft.x + blob.quadTopRight.x-1) / 2.0),
                            y: ((blob.quadTopLeft.y + blob.quadTopRight.y) / 2.0)
                        };
                        const midBottom: Vector = {
                            x: ((blob.quadBottomLeft.x + blob.quadBottomRight.x-1) / 2.0),
                            y: ((blob.quadBottomLeft.y-1 + blob.quadBottomRight.y-1) / 2.0)
                        };
                        const midLeft: Vector = {
                            x: ((blob.quadTopLeft.x + blob.quadBottomLeft.x) / 2.0),
                            y: ((blob.quadTopLeft.y + blob.quadBottomLeft.y-1) / 2.0)
                        };
                        const midRight: Vector = {
                            x: ((blob.quadTopRight.x-1 + blob.quadBottomRight.x-1) / 2.0),
                            y: ((blob.quadTopRight.y + blob.quadBottomRight.y-1) / 2.0)
                        };

                        drawLine(data, midTop, midBottom, [0, 0, 255, 255]);
                        drawLine(data, midLeft, midRight, [255, 0, 255, 255]);
                    }

                    if (DRAW_QUAD_CORNERS) {
                        drawPixel(data, { x: blob.quadTopLeft.x      , y: blob.quadTopLeft.y       }, [255, 255, 0, 255]); //yellow
                        drawPixel(data, { x: blob.quadTopRight.x-1   , y: blob.quadTopRight.y      }, [0, 255, 255, 255]); //cyan
                        drawPixel(data, { x: blob.quadBottomRight.x-1, y: blob.quadBottomRight.y-1 }, [0,   0, 255, 255]); //blue
                        drawPixel(data, { x: blob.quadBottomLeft.x   , y: blob.quadBottomLeft.y-1  }, [255, 0, 255, 255]); //purple
                    }
                }
            }

            //@ts-ignore
            this.pack().pipe(fs.createWriteStream(imageOutputPath));

            resolve();
        });
    });
}

(async function run() {
    const runAllMode = process.argv.includes("--all");

    if (runAllMode) {
        //process all images
        const images = fs.readdirSync(IMAGES_INPUT_PATH);
        for (const image of images) {
            console.log(image);
            await runImage(
                path.join(IMAGES_INPUT_PATH, image),
                path.join(IMAGES_OUTPUT_PATH, image)
            );
        }
    }
    else {
        //process single image
        console.log(path.basename(IMAGE_INPUT_PATH));
        await runImage(IMAGE_INPUT_PATH, IMAGE_OUTPUT_PATH);
    }

    //Log Faults
    for (const fault of BlobProcessor.faults) {
        if (fault !== Fault.NO_FAULT) {
            console.log(Fault[fault]);
        }
    }
})();