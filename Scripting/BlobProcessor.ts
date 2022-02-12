//BlobProcessor.ts

import { BlobData, min, max, Run, Vector, Kernel, EMPTY_BLOB, BlobBRAMPort, BLOB_BRAM_PORT_DEFAULT } from "./Util";
import * as fs from "fs";
const drawing = require('pngjs-draw');
const png = drawing(require('pngjs').PNG);

const MIN_AREA = 0;
const MAX_BLOBS = 2000;
const NULL_BLOB_ID = MAX_BLOBS;
const IMAGE_PATH = 'images/Test.png';
const IMAGE_WIDTH = 640;
const IMAGE_HEIGHT = 480;
const NULL_RUN_START = IMAGE_WIDTH;
const DRAW_BLOB_COLOR = false;
const DRAW_BOUND = true;
const DRAW_QUAD = false;

let frameBuffer: boolean[][] = Array.from(Array(IMAGE_HEIGHT), () => Array(IMAGE_WIDTH).fill(0));
let blobColorBuffer: Run[][] = Array.from(Array(IMAGE_HEIGHT), () => Array(IMAGE_WIDTH / 8)
    .fill({ start: NULL_RUN_START, end: 0, blobID: NULL_BLOB_ID })); //for coloring blobs (only for script version)

let blobPointers: number[] = Array(MAX_BLOBS).fill(0);
let blobValids: boolean[] = Array(MAX_BLOBS).fill(false);
let blobBRAM: BlobData[] = Array(MAX_BLOBS).fill(EMPTY_BLOB);
let blobBRAMA: BlobBRAMPort = BLOB_BRAM_PORT_DEFAULT;
let blobBRAMB: BlobBRAMPort = BLOB_BRAM_PORT_DEFAULT;
let blobIndex = 0;
let masterBlobID = NULL_BLOB_ID;
let blobRunBufferIndex: number = 0, blobRunBufferPartion: number = 0; //where the blobProcessor is in the runBuffer

let runBuffer: Run[][] = Array.from(Array(2), () => Array(IMAGE_WIDTH / 8).fill({ start: NULL_RUN_START, end: 0, blobID: NULL_BLOB_ID }));
let runBufferIndex: number[] = [0, 0]; //where the RLE is in the runBuffer
let runBufferPartion: number = 0; //swap between using index 0 & 1 of runBuffer & runBufferIndex
let runStart: number = 0;
let inRun: boolean = false;

let kernel: Kernel;
let kernelValid: boolean = false, lastKernelValid: boolean = false;

let loopCount: number = 0;

//Read Image (scripting only)
fs.createReadStream(IMAGE_PATH)
    .pipe(new png())
    .on('parsed', function () {
        let kx: number = 0, ky: number = 0;
        //"180MHz" Process Loop
        while (ky < IMAGE_HEIGHT) {
            //Simulate PythonManager; read new kernel at 36MHz (0.2 * 180MHz) clock cycles
            if (loopCount % 5 == 0 && ky < IMAGE_HEIGHT) {
                let tempKernel: Kernel = {
                    value: Array(8).fill(false),
                    pos: { x: kx, y: ky }
                };
                for (let x = 0; x < 8; x++) {
                    const px = (kx * 8) + x;
                    const idx = (IMAGE_WIDTH * ky + px) << 2;
                    //@ts-ignore
                    const value = (this.data[idx] + this.data[idx + 1] + this.data[idx + 2]) / 3;
                    const threshold = value > 128;
                    frameBuffer[ky][px] = threshold;
                    tempKernel.value[x] = threshold;
                }
                kernel = tempKernel;
                kernelValid = true;

                if (kx == IMAGE_WIDTH / 8 - 1) {
                    ky = ky + 1;
                    kx = 0;
                }
                else {
                    kx = kx + 1;
                }
            }
            else {
                kernelValid = false;
            }

            //Call Blob Always Loop at 180MHz
            alwaysLoop();

            //Update Simulated BRAM
            updateBRAM();

            loopCount = loopCount + 1;
        }

        //Draw Blob Color
        if (DRAW_BLOB_COLOR) {
            for (let y = 0; y < blobColorBuffer.length; y++) {
                for (let i = 0; i < blobColorBuffer[y].length; i++) {
                    const run = blobColorBuffer[y][i];
                    if (run.start !== NULL_RUN_START) {
                        for (let x = run.start; x <= run.end; x++) {
                            const idx = (IMAGE_WIDTH * y + x) << 2;
                            const realBlobID = getRealBlobID(run.blobID);
                            //@ts-ignore
                            this.data[idx] = Math.sin(realBlobID * 50) * 200 + 55;
                            //@ts-ignore
                            this.data[idx + 1] = Math.sin(realBlobID * 100) * 200 + 55;
                            //@ts-ignore
                            this.data[idx + 2] = Math.sin(realBlobID * 200) * 200 + 55;
                        }
                    }
                }
            }
        }

        //Draw Blob Bounding Box + Quad
        for (let i = 0; i <= blobIndex; i++) {
            const blob = readBlob(i);
            const area = (blob?.boundBottomRight.x - blob?.boundTopLeft.x) * (blob?.boundBottomRight.y - blob?.boundTopLeft.y);
            if (blobValids[i] && area >= MIN_AREA) {
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

                if (DRAW_QUAD) {
                    // @ts-ignore
                    this.drawLine(
                        blob.quadTopLeft.x,
                        blob.quadTopLeft.y,
                        blob.quadTopRight.x,
                        blob.quadTopRight.y,
                        [0, 255, 0, 100]
                    );

                    //@ts-ignore
                    this.drawLine(
                        blob.quadTopRight.x,
                        blob.quadTopRight.y,
                        blob.quadBottomRight.x,
                        blob.quadBottomRight.y,
                        [0, 255, 0, 100]
                    );

                    //@ts-ignore
                    this.drawLine(
                        blob.quadBottomRight.x,
                        blob.quadBottomRight.y,
                        blob.quadBottomLeft.x,
                        blob.quadBottomLeft.y,
                        [0, 255, 0, 100]
                    );

                    //@ts-ignore
                    this.drawLine(
                        blob.quadBottomLeft.x,
                        blob.quadBottomLeft.y,
                        blob.quadTopLeft.x,
                        blob.quadTopLeft.y,
                        [0, 255, 0, 100]
                    );
                }
            }
        }

        //@ts-ignore
        this.pack().pipe(fs.createWriteStream('out.png'));
    });

//Simulated 180MHz Always Loop
function alwaysLoop() {
    //New Kernel
    if (kernelValid && !lastKernelValid) {
        encodeKernel(kernel);
    }
    lastKernelValid = kernelValid;

    //Process Loop
    updateBlobProcessor();
}

//Encode Kernel (RLE)
function encodeKernel(kernel: Kernel) {
    const endLine = kernel.pos.x == IMAGE_WIDTH / 8 - 1;

    //encode every pixel in kernel
    for (let x = 0; x < 8; x++) {
        //start run @ white pixel
        if (!inRun && kernel.value[x]) {
            inRun = true;
            
            //set run start to the pixel coordinate
            runStart = (kernel.pos.x * 8) + x;
        }
        
        //end run @ end of line & black pixel
        if (inRun && (kernel.value[x] ? (x == 7 && endLine) : true)) {
            inRun = false;

            //push run to buffer
            runBuffer[runBufferPartion][runBufferIndex[runBufferPartion]] = {
                start: runStart,
                end: (kernel.pos.x * 8) + x - (kernel.value[x]?0:1),
                blobID: NULL_BLOB_ID
            };

            //increment our buffer index for next run
            runBufferIndex[runBufferPartion] = runBufferIndex[runBufferPartion] + 1;
        }
    }

    //end line
    if (endLine) {
        //zero index we are working on for next line
        runBufferIndex[runBufferPartion==0?1:0] = 0;

        //swap buffer partion for next line
        runBufferPartion = runBufferPartion==0?1:0;
    }
}

//Blob Processor Loop
enum State { NONE, MERGE, JOIN, WRITE };
let state: State = State.NONE;
function updateBlobProcessor() {
    //blobBRAMA, blobBRAMB
    if (blobRunBufferIndex <= runBufferIndex[blobRunBufferPartion]) {
        switch(state) {
            case State.NONE: {
                //start run
                masterBlobID = NULL_BLOB_ID;

                break; 
            } 
            case State.MERGE: { 
                

                break; 
            }
            case State.JOIN: { 
                readBlob(masterBlobID)

                break; 
            }
            case State.WRITE: {
                //add this pixel to blob if we have a valid blob to join
                if (masterBlobID !== NULL_BLOB_ID) {
                    //FIXME
                    writeBlob(masterBlobID, mergeBlobs(runToBlob(line, run), ));

                    //set ID of the blob we joined
                    return masterBlobID;
                }
                
                //not touching a blob => make new blob
                else {
                    //create blob at next available index
                    //FIXME
                    writeBlob(blobIndex, runToBlob(line, run));
                    blobValids[blobIndex] = true;

                    //set ID of the blob we made in runBuffer
                    runBuffer[blobRunBufferPartion][blobRunBufferIndex].blobID = blobIndex;

                    //increment index for next blob
                    blobIndex = blobIndex + 1;
                }

                //end run
                
                blobRunBufferIndex = blobRunBufferIndex + 1;

                //push to blob color buffer (scripting only)
                // blobColorBuffer[kernel.pos.y] = runBuffer[runBufferPartion];

                break;
            }
        } 
    }
    else if (blobRunBufferPartion !== runBufferPartion) {
        //next line
        blobRunBufferPartion = runBufferPartion;
        blobRunBufferIndex = 0;
    }

    //runBuffer[runBufferPartion][i].blobID = processRun(kernel.pos.y, runBuffer[runBufferPartion][i]);
    //blobRunBufferIndex
    /*
    let blobBRAMWriteAddress: number = 0, blobBRAMReadAddress: number = 0;
    let blobBRAMWriteValid: boolean = false;
    let blobBRAMReadData: BlobData = EMPTY_BLOB, blobBRAMWriteData: BlobData = EMPTY_BLOB;
    */

    //loop through all runs that were filled up in the last run buffer (line above)
    for (let i = 0; i < runBufferIndex[runBufferPartion==0?1:0]; i++) {
        const lastRunBufferI = runBuffer[runBufferPartion==0?1:0][i];
        if (lastRunBufferI.blobID !== NULL_BLOB_ID) {
            if (runsOverlap(run, lastRunBufferI)) {
                //find which blob to join, and merge blobs if it is touching mutliple
                if (lastRunBufferI.blobID !== NULL_BLOB_ID) {
                    //found master (1st valid blob)
                    if (masterBlobID === NULL_BLOB_ID) {
                        masterBlobID = getRealBlobID(lastRunBufferI.blobID);
                    }

                    //found another valid blob => merge with master
                    else if (getRealBlobID(lastRunBufferI.blobID) !== masterBlobID) {
                        //merge slave into master
                        //FIXME
                        writeBlob(masterBlobID, mergeBlobs(readBlob(lastRunBufferI.blobID), readBlob(masterBlobID)));

                        //mark slave as pointer to master
                        blobPointers[lastRunBufferI.blobID] = masterBlobID;
                        blobValids[lastRunBufferI.blobID] = false;
                    }
                }
            }
        }
    }
}

//Merging
function mergeBlobs(blob1: BlobData, blob2: BlobData): BlobData {
    return {
        boundTopLeft: {
            x: min(blob1.boundTopLeft.x, blob2.boundTopLeft.x),
            y: min(blob1.boundTopLeft.y, blob2.boundTopLeft.y)
        },
        boundBottomRight: {
            x: max(blob1.boundBottomRight.x, blob2.boundBottomRight.x),
            y: max(blob1.boundBottomRight.y, blob2.boundBottomRight.y)
        },
        quadTopLeft: mergeQuadTopLeft(blob1.quadTopLeft, blob2.quadTopLeft),
        quadTopRight: mergeQuadTopRight(blob1.quadTopRight, blob2.quadTopRight),
        quadBottomLeft: mergeQuadBottomLeft(blob1.quadBottomLeft, blob2.quadBottomLeft),
        quadBottomRight: mergeQuadBottomRight(blob1.quadBottomRight, blob2.quadBottomRight),
        area: blob1.area + blob2.area
    };
}
function mergeQuadTopLeft(a: Vector, b: Vector): Vector {
    //(sqrt(x^2 + y^2) is too expensive => using x + y which gives similar quality)
    return (a.x + a.y < b.x + b.y) ? a : b;
}
function mergeQuadTopRight(a: Vector, b: Vector): Vector {
    return (a.x - a.y > b.x - b.y) ? a : b;
}
function mergeQuadBottomRight(a: Vector, b: Vector): Vector {
    return (a.x + a.y > b.x + b.y) ? a : b;
}
function mergeQuadBottomLeft(a: Vector, b: Vector): Vector {
    return (a.x - a.y < b.x - b.y) ? a : b;
}

//Overlap
function runsOverlap(run1: Run, run2: Run): boolean {
    //widen run1 to join diagonals, then check overlap
    return (run2.start >= run1.start-(run1.start==0?0:1) && run2.start <= run1.end+1) ||
           (run2.end   >= run1.start-(run1.start==0?0:1) && run2.end   <= run1.end+1) ||
           (run2.start <  run1.start-(run1.start==0?0:1) && run2.end   >  run1.end+1);
}

//Run to Blob
function runToBlob(line: number, run: Run): BlobData {
    return {
        boundTopLeft:     {x:run.start, y:line  },
        boundBottomRight: {x:run.end+1, y:line+1},
        quadTopLeft:      {x:run.start, y:line  },
        quadTopRight:     {x:run.end  , y:line  },
        quadBottomLeft:   {x:run.start, y:line  },
        quadBottomRight:  {x:run.end  , y:line  },
        area: run.end - run.start + 1
    };
}

//Get Real Blob ID "Recursively" (max ~3 recursions, but 5 for safety)
let currentID: number;
function getRealBlobID(startID: number) {
    currentID = startID;

    for (let i = 0; i < 5; i++) {
        if (blobValids[currentID]) {
            return currentID;
        }
        else {
            currentID = blobPointers[currentID];
        }
    }
    
    console.error("ERROR: BLOB_POINTER_DEPTH_FAULT");
    return NULL_BLOB_ID;
}

//BRAM
function readBlob (index: number): BlobData {
    return blobBRAM[index];
}
function writeBlob (index: number, blob: BlobData) {
    blobBRAM[index] = blob;
}


let blobBRAMWriteValidR: boolean[];
function updateBRAM() {
    //blobBRAMA, blobBRAMB

}