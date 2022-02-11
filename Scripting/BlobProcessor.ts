//BlobProcessor.ts

//Imports
const fs = require('fs');
const drawing = require('pngjs-draw');
const png = drawing(require('pngjs').PNG);

//Constants
const MIN_AREA = 0;
const MAX_BLOBS = 1000;
const NULL_BLOB_ID = MAX_BLOBS;
const IMAGE_WIDTH = 640;
const IMAGE_HEIGHT = 480;
const IMAGE_PATH = 'images/Test2.png';
const DRAW_BLOB_COLOR = true;
const DRAW_BOUND = true;
const DRAW_QUAD = false;

//Interfaces
interface Vector {
    x: number,
    y: number
}
interface BlobData {
    boundTopLeft: Vector,
    boundBottomRight: Vector,
    quadTopLeft: Vector,
    quadTopRight: Vector,
    quadBottomLeft: Vector,
    quadBottomRight: Vector,
    area: number,
    pointer: number,
    valid: boolean
}
interface Run {
    start: number,
    end: number,
    blobID: number
}

//Variables
let frameBuffer: boolean[][] = Array.from(Array(IMAGE_HEIGHT), () => Array(IMAGE_WIDTH).fill(0));
let blobColorBuffer: number[][] = Array.from(Array(IMAGE_WIDTH), () => Array(IMAGE_HEIGHT).fill(0)); //for coloring blobs (only for script version)
let blobs: BlobData[] = Array(MAX_BLOBS).fill({
    boundTopLeft: {x:0, y:0},
    boundBottomRight: {x:0, y:0},
    quadTopLeft: {x:0, y:0},
    quadTopRight: {x:0, y:0},
    quadBottomLeft: {x:0, y:0},
    quadBottomRight: {x:0, y:0},
    area: 0,
    pointer: 0,
    valid: false
});
let blobIndex = 0;

//Read Image
fs.createReadStream(IMAGE_PATH)
    .pipe(new png())
    .on('parsed', function () {
        //Process all Pixels
        for (let y = 0; y < IMAGE_HEIGHT; y++) {
            for (let x = 0; x < IMAGE_WIDTH; x++) {
                const idx = (IMAGE_WIDTH * y + x) << 2;
                //@ts-ignore
                const value = (this.data[idx] + this.data[idx + 1] + this.data[idx + 2]) / 3;
                const threshold = value > 128;
                frameBuffer[y][x] = threshold;
            }

            processLine(y);
        }

        //Log Data
        console.log("blob count: ", blobIndex - 1);

        //Draw Blob Color
        if (DRAW_BLOB_COLOR) {
            for (let y = 0; y < IMAGE_HEIGHT; y++) {
                for (let x = 0; x < IMAGE_WIDTH; x++) {
                    if (blobColorBuffer[x][y] !== MAX_BLOBS) {
                        const idx = (IMAGE_WIDTH * y + x) << 2;
                        const blobIndex = getRealBlobID(blobColorBuffer[x][y]);
                        // const blobIndex = blobColorBuffer[x][y];
                        //@ts-ignore
                        this.data[idx] = Math.sin(blobIndex * 50) * 255;
                        //@ts-ignore
                        this.data[idx + 1] = Math.sin(blobIndex * 100) * 255;
                    }
                }
            }
        }

        //Draw Blob Bounding Box + Quad
        for (let i = 0; i < blobs.length; i++) {
            const area = (blobs[i]?.boundBottomRight.x - blobs[i]?.boundTopLeft.x) * (blobs[i]?.boundBottomRight.y - blobs[i]?.boundTopLeft.y);
            if (blobs[i]?.valid && area >= MIN_AREA) {
                if (DRAW_BOUND) {
                    // @ts-ignore
                    this.drawRect(
                        blobs[i].boundTopLeft.x,
                        blobs[i].boundTopLeft.y,
                        blobs[i].boundBottomRight.x - blobs[i].boundTopLeft.x,
                        blobs[i].boundBottomRight.y - blobs[i].boundTopLeft.y,
                        [255, 0, 0, 255]
                    );
                }

                if (DRAW_QUAD) {
                    // @ts-ignore
                    this.drawLine(
                        blobs[i].quadTopLeft.x,
                        blobs[i].quadTopLeft.y,
                        blobs[i].quadTopRight.x,
                        blobs[i].quadTopRight.y,
                        [0, 255, 0, 255]
                    );

                    //@ts-ignore
                    this.drawLine(
                        blobs[i].quadTopRight.x,
                        blobs[i].quadTopRight.y,
                        blobs[i].quadBottomRight.x,
                        blobs[i].quadBottomRight.y,
                        [0, 255, 0, 255]
                    );

                    //@ts-ignore
                    this.drawLine(
                        blobs[i].quadBottomRight.x,
                        blobs[i].quadBottomRight.y,
                        blobs[i].quadBottomLeft.x,
                        blobs[i].quadBottomLeft.y,
                        [0, 255, 0, 255]
                    );

                    //@ts-ignore
                    this.drawLine(
                        blobs[i].quadBottomLeft.x,
                        blobs[i].quadBottomLeft.y,
                        blobs[i].quadTopLeft.x,
                        blobs[i].quadTopLeft.y,
                        [0, 255, 0, 255]
                    );
                }
            }
        }

        //@ts-ignore
        this.pack().pipe(fs.createWriteStream('out.png'));
    });

//Process Line
let lastRunBuffer: Run[] = Array(IMAGE_WIDTH / 8).fill({ start: 0, end: 0, blobID: NULL_BLOB_ID });
let runBuffer: Run[] = Array(IMAGE_WIDTH / 8).fill({ start: 0, end: 0, blobID: NULL_BLOB_ID });
function processLine(line: number) {
    lastRunBuffer = runBuffer;

    //encode line into runs
    let inRun: boolean = false;
    let start: number = 0, runBufferIndex: number = 0;
    for (let x = 0; x < IMAGE_WIDTH; x++) {
        if (frameBuffer[line][x]) {
            if (!inRun) {
                inRun = true;
                start = x;
            }
        }
        else if (inRun) {
            inRun = false;
            runBuffer[runBufferIndex] = { start: start, end: x-1, blobID: NULL_BLOB_ID };
            processRun(line, runBuffer[runBufferIndex]);
            runBufferIndex++;
        }
    }
}

//Process Pixel & Return BlobID
let masterBlobID = NULL_BLOB_ID;
function processRun(line: number, run: Run): number {
    masterBlobID = NULL_BLOB_ID;

    // for (let i = 0; i < lastRunBuffer.length; i++) {
    //     //widen run to join other runs its touching but not overlapping
    //     let realStart = run.start - (run.start == 0 ?0:1);
    //     let realEnd = run.end + (run.end == IMAGE_WIDTH-1 ?0:1);

    //     //check if lines overlap
    //     if ((lastRunBuffer[i].start >= realStart && lastRunBuffer[i].start <= realEnd) ||
    //         (lastRunBuffer[i].end   >= realStart && lastRunBuffer[i].end   <= realEnd)) {
    //         joinTopRun(line, run, lastRunBuffer[i]);
    //     }
    // }

    //add this pixel to blob if we have a valid blob to join
    if (masterBlobID !== NULL_BLOB_ID) {
        blobs[masterBlobID] = mergeBlobs(runToBlob(line, run), blobs[masterBlobID]);

        return masterBlobID;
    }
    
    //not touching a blob => make new blob
    else {
        //create blob at next available index
        blobs[blobIndex] = runToBlob(line, run);

        //increment index for next blob
        blobIndex++;
        
        //return the index that we used
        return blobIndex - 1;
    }
}


function joinTopRun(line: number, run: Run, topRun: Run) {
    //find which blob to join, and merge blobs if it is touching mutliple
    if (topRun.blobID !== NULL_BLOB_ID) {
        //found master (1st valid blob)
        if (masterBlobID === NULL_BLOB_ID) {
            masterBlobID = getRealBlobID(topRun.blobID);
        }

        //found another valid blob => merge with master
        else if (getRealBlobID(topRun.blobID) !== masterBlobID) {
            // //merge slave into master
            // blobs[masterBlobID] = mergeBlobs(blobs[topRun.blobID], blobs[masterBlobID]);

            // //mark slave as pointer to master
            // blobs[topRun.blobID] = {
            //     boundTopLeft: {x:0, y:0},
            //     boundBottomRight: {x:0, y:0},
            //     quadTopLeft: {x:0, y:0},
            //     quadTopRight: {x:0, y:0},
            //     quadBottomLeft: {x:0, y:0},
            //     quadBottomRight: {x:0, y:0},
            //     area: 0,
            //     pointer: masterBlobID,
            //     valid: false
            // };
        }
    }
}

//Merge Blobs
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
        area: blob1.area + blob2.area,
        pointer: 0,
        valid: true
    };
}

//Merge Quads
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
    const width = (run.start-run.end)+1
    ;
    return {
        boundTopLeft:     {x:run.start      , y:line      },
        boundBottomRight: {x:run.start+width, y:line+width},
        quadTopLeft:      {x:run.start      , y:line      },
        quadTopRight:     {x:run.start+width, y:line      },
        quadBottomLeft:   {x:run.start      , y:line+width},
        quadBottomRight:  {x:run.start+width, y:line+width},
        area: width,
        pointer: 0,
        valid: true
    };
}

//Get Real Blob ID "Recursively" (max ~3 recursions, but 5 for safety)
let currentID: number;
function getRealBlobID(startID: number) {
    currentID = startID;

    for (let i = 0; i < 5; i++) {
        if (blobs[currentID].valid) {
            return currentID;
        }
        else {
            currentID = blobs[currentID].pointer;
        }
    }
    
    console.error("ERROR: BLOB_POINTER_DEPTH_FAULT");
    return NULL_BLOB_ID;
}

//Range Functions
function min(num1: number, num2: number): number {
    return num1 < num2 ? num1 : num2;
}

function max(num1: number, num2: number): number {
    return num1 > num2 ? num1 : num2;
}