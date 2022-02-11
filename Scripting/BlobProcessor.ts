//BlobProcessor.ts

import { BlobData, BlobDataChunk1, BlobDataChunk2, min, max, Run, Vector } from "./Util";
import * as fs from "fs";
const drawing = require('pngjs-draw');
const png = drawing(require('pngjs').PNG);

//Constants
const MIN_AREA = 0;
const MAX_BLOBS = 1000;
const NULL_BLOB_ID = MAX_BLOBS;
const IMAGE_PATH = 'images/2019_Noise2.png';
const IMAGE_WIDTH = 640;
const IMAGE_HEIGHT = 480;
const NULL_RUN_START = IMAGE_WIDTH;
const DRAW_BLOB_COLOR = false;
const DRAW_BOUND = true;
const DRAW_QUAD = true;

//Scripting Only
let frameBuffer: boolean[][] = Array.from(Array(IMAGE_HEIGHT), () => Array(IMAGE_WIDTH).fill(0));
let blobColorBuffer: Run[][] = Array.from(Array(IMAGE_HEIGHT), () => Array(IMAGE_WIDTH / 8).fill({ start: NULL_RUN_START, end: 0, blobID: NULL_BLOB_ID })); //for coloring blobs (only for script version)

//Blobs
let blobPointers: number[] = Array(MAX_BLOBS).fill(0);
let blobValids: boolean[] = Array(MAX_BLOBS).fill(false);
let BRAM1: BlobDataChunk1[] = Array(MAX_BLOBS).fill({
    boundTopLeft: {x:0, y:0},
    boundBottomRight: {x:0, y:0}
});
let BRAM2: BlobDataChunk2[] = Array(MAX_BLOBS).fill({
    quadTopLeft: {x:0, y:0},
    quadTopRight: {x:0, y:0},
    quadBottomLeft: {x:0, y:0},
    quadBottomRight: {x:0, y:0},
    area: 0
});
let blobIndex = 0;
let masterBlobID = NULL_BLOB_ID;

//RLE
let runBuffer: Run[][] = Array.from(Array(2), () => Array(IMAGE_WIDTH / 8).fill({ start: NULL_RUN_START, end: 0, blobID: NULL_BLOB_ID }));
let runBufferPartion: number = 0;
let runStart: number = 0;
let inRun: boolean = false;
let runBufferIndex: number = 0;

//Read Image (Scripting)
fs.createReadStream(IMAGE_PATH)
    .pipe(new png())
    .on('parsed', function () {
        //PythonManager Sim
        for (let y = 0; y < IMAGE_HEIGHT; y++) {
            for (let x = 0; x < IMAGE_WIDTH; x++) {
                const idx = (IMAGE_WIDTH * y + x) << 2;
                //@ts-ignore
                const value = (this.data[idx] + this.data[idx + 1] + this.data[idx + 2]) / 3;
                frameBuffer[y][x] = value > 128;
            }

            processLine(y);
        }

        //Blob Processing + RLE
        // runBlobProcessing();

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

//Run Blob Processing
function runBlobProcessing() {

}

//Process Line
function processLine(line: number) {
    runBuffer[runBufferPartion] = Array(IMAGE_WIDTH / 8).fill({ start: NULL_RUN_START, end: 0, blobID: NULL_BLOB_ID });
    runBufferIndex = 0;

    //encode line into runs
    for (let x = 0; x < IMAGE_WIDTH; x++) {
        if (frameBuffer[line][x]) {
            if (!inRun) {
                inRun = true;
                runStart = x;
            }
            
            if (x == IMAGE_WIDTH-1) {
                endRun(line, runStart, x);
            }
        }
        else if (inRun) {
            endRun(line, runStart, x-1);
        }
    }

    blobColorBuffer[line] = runBuffer[runBufferPartion];

    //Swap run buffer partion
    runBufferPartion = runBufferPartion==0?1:0;
}

function endRun(line: number, start: number, end: number) {
    inRun = false;
    runBuffer[runBufferPartion][runBufferIndex] = {
        start, end,
        blobID: processRun(line, { start, end, blobID: NULL_BLOB_ID })
    };
    runBufferIndex++;
}

//Process Run & Return BlobID
function processRun(line: number, run: Run): number {
    masterBlobID = NULL_BLOB_ID;

    for (let i = 0; i < runBuffer[0].length; i++) {
        const lastRunBufferI = runBuffer[runBufferPartion==0?1:0][i];
        if (lastRunBufferI.blobID !== NULL_BLOB_ID) {
            //widen run to join other runs its touching but not overlapping
            let realStart = run.start - (run.start == 0 ?0:1);
            let realEnd = run.end + 1;

            //check if lines overlap
            if ((lastRunBufferI.start >= realStart && lastRunBufferI.start <= realEnd) ||
                (lastRunBufferI.end   >= realStart && lastRunBufferI.end   <= realEnd) ||
                (lastRunBufferI.start <  realStart && lastRunBufferI.end   > realEnd)) {
                joinRun(line, run, lastRunBufferI);
            }
        }
    }

    //add this pixel to blob if we have a valid blob to join
    if (masterBlobID !== NULL_BLOB_ID) {
        writeBlob(masterBlobID, mergeBlobs(runToBlob(line, run), readBlob(masterBlobID)));

        return masterBlobID;
    }
    
    //not touching a blob => make new blob
    else {
        //create blob at next available index
        writeBlob(blobIndex, runToBlob(line, run));
        blobValids[blobIndex] = true;

        //increment index for next blob
        blobIndex++;
        
        //return the index that we used
        return blobIndex - 1;
    }
}

//Join Run (from row above)
function joinRun(line: number, run: Run, topRun: Run) {
    //find which blob to join, and merge blobs if it is touching mutliple
    if (topRun.blobID !== NULL_BLOB_ID) {
        //found master (1st valid blob)
        if (masterBlobID === NULL_BLOB_ID) {
            masterBlobID = getRealBlobID(topRun.blobID);
        }

        //found another valid blob => merge with master
        else if (getRealBlobID(topRun.blobID) !== masterBlobID) {
            //merge slave into master
            writeBlob(masterBlobID, mergeBlobs(readBlob(topRun.blobID), readBlob(masterBlobID)));

            //mark slave as pointer to master
            blobPointers[topRun.blobID] = masterBlobID;
            blobValids[topRun.blobID] = false;
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

//Run to Blob
function runToBlob(line: number, run: Run): BlobData {
    return {
        boundTopLeft:     {x:run.start, y:line  },
        boundBottomRight: {x:run.end+1, y:line+1},
        quadTopLeft:      {x:run.start, y:line  },
        quadTopRight:     {x:run.end  , y:line  },
        quadBottomLeft:   {x:run.start, y:line  },
        quadBottomRight:  {x:run.end  , y:line  },
        area: run.end - run.start + 1 //FIXME
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
    return {
        boundTopLeft: BRAM1[index].boundTopLeft,
        boundBottomRight: BRAM1[index].boundBottomRight,
        quadTopLeft: BRAM2[index].quadTopLeft,
        quadTopRight: BRAM2[index].quadTopRight,
        quadBottomLeft: BRAM2[index].quadBottomLeft,
        quadBottomRight: BRAM2[index].quadBottomRight,
        area: BRAM2[index].area
    };
}
function writeBlob (index: number, blob: BlobData) {
    BRAM1[index] = {
        boundTopLeft: blob.boundTopLeft,
        boundBottomRight: blob.boundBottomRight
    };

    BRAM2[index] = {
        quadTopLeft: blob.quadTopLeft,
        quadTopRight: blob.quadTopRight,
        quadBottomLeft: blob.quadBottomLeft,
        quadBottomRight: blob.quadBottomRight,
        area: blob.area
    };
}