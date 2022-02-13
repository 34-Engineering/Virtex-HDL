//BlobProcessor.ts

import { BlobData, min, max, Run, Vector, Kernel, EMPTY_BLOB, BlobBRAMPort, BLOB_BRAM_PORT_DEFAULT, overflow, RunBuffer, Fault } from "./Util";
import * as fs from "fs";
const drawing = require('pngjs-draw');
const png = drawing(require('pngjs').PNG);

const MIN_AREA = 0;
const MAX_BLOBS = 4000;
const MAX_BLOB_POINTER_DEPTH = 5; //under normal cond: max needed ~3
const IMAGE_PATH = 'images/2019_Noise2.png';
const IMAGE_WIDTH = 640;
const IMAGE_HEIGHT = 480;
const KERNEL_MAX_X = IMAGE_WIDTH / 8 - 1;
const MAX_RUNS_PER_LINE = 40; //under normal cond: max needed ~26
const NULL_RUN_START = IMAGE_WIDTH;
const NULL_LINE_NUMBER = IMAGE_HEIGHT;
const NULL_BLOB_ID = MAX_BLOBS;
const NULL_RUN_BUFFER_PARTION = 3;
const DRAW_BLOB_COLOR = false;
const DRAW_BOUND = true;
const DRAW_QUAD = true;

let blobColorBuffer: RunBuffer[] = [...Array(IMAGE_HEIGHT)].map(_=>({
    runs: [...Array(MAX_RUNS_PER_LINE)].map(_=>({ start: NULL_RUN_START, end: 0, blobID: NULL_BLOB_ID })),
    count: 0,
    line: NULL_LINE_NUMBER
}));
let faults: Fault[] = [...Array(4)].map(_=>Fault.NO_FAULT);

let blobPointers: number[] = [...Array(MAX_BLOBS)].map(_=>(0));
let blobValids: boolean[] = [...Array(MAX_BLOBS)].map(_=>(false));
let blobBRAM: BlobData[] = [...Array(MAX_BLOBS)].map(_=>(EMPTY_BLOB));
let blobBRAMPortA: BlobBRAMPort = Object.assign({}, BLOB_BRAM_PORT_DEFAULT);
let blobBRAMPortB: BlobBRAMPort = Object.assign({}, BLOB_BRAM_PORT_DEFAULT);
let blobIndex: number = 0;
let blobRunBuffersPartionCurrent: number = NULL_RUN_BUFFER_PARTION, blobRunBuffersPartionLast: number = NULL_RUN_BUFFER_PARTION;
let blobRunBufferIndexCurrent: number = 0, blobRunBufferIndexLast: number = 0;

let runBuffers: RunBuffer[] = [...Array(3)].map(_=>({
    runs: [...Array(MAX_RUNS_PER_LINE)].map(_=>({ start: NULL_RUN_START, end: 0, blobID: NULL_BLOB_ID })),
    count: 0,
    line: NULL_LINE_NUMBER
}));
let rleRunBuffersPartion: number = 0; //which run buffer we are on

let kernel: Kernel;
let kernelValid: boolean = false, lastKernelValid: boolean = false;

//Read Image (scripting only)
fs.createReadStream(IMAGE_PATH)
    .pipe(new png())
    .on('parsed', function () {
        //"180MHz" Process Loop
        let kx: number = 0, ky: number = 0;
        let loopCount: number = 0;
        while (ky < IMAGE_HEIGHT) { //TODO
            //"36MHz" Kernel Reading (PythonManager)
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
                    tempKernel.value[x] = threshold;
                }
                kernel = tempKernel;
                kernelValid = true;

                if (kx == KERNEL_MAX_X) {
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

            //"180MHz" Always Loop
            alwaysLoop();

            //"180MHz" Sync BRAM
            updateBRAM();

            loopCount = loopCount + 1;
        }

        //Logging
        for (const fault of faults) {
            if (fault !== Fault.NO_FAULT) {
                console.log(Fault[fault]);
            }
        }
        console.log({ blobIndex });
        
        //Draw Blob Color
        if (DRAW_BLOB_COLOR) {
            for (let y = 0; y < blobColorBuffer.length; y++) {
                for (let i = 0; i < blobColorBuffer[y].count; i++) {
                    const run = blobColorBuffer[y].runs[i];
                    for (let x = run.start; x <= run.end; x++) {
                        const idx = (IMAGE_WIDTH * y + x) << 2;
                        const realBlobID = getRealBlobIDDebug(run.blobID);
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

        //Draw Blob Bounding Box + Quad
        for (let i = 0; i <= blobIndex; i++) {
            const blob = blobBRAM[i];
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

    //Blob Processor Loop
    updateBlobProcessor();
}

//Encode Kernel (RLE)
let rleRunStart: number = 0;
let rleInRun: boolean = false;
function encodeKernel(kernel: Kernel) {
    //save line number
    if (kernel.pos.x == 0) {
        runBuffers[rleRunBuffersPartion].line = kernel.pos.y;
    }
    
    //encode every pixel in kernel
    for (let x = 0; x < 8; x++) {
        //start run @ white pixel
        if (!rleInRun && kernel.value[x]) {
            rleInRun = true;
            
            //set run start to the pixel coordinate
            rleRunStart = (kernel.pos.x * 8) + x;
        }
        
        //end run @ end of line & black pixel
        if (rleInRun && (kernel.value[x] ? (x == 7 && kernel.pos.x == KERNEL_MAX_X) : true)) {
            rleInRun = false;

            //push run to buffer
            runBuffers[rleRunBuffersPartion].runs[runBuffers[rleRunBuffersPartion].count] = {
                start: rleRunStart,
                end: (kernel.pos.x * 8) + x - (kernel.value[x]?0:1),
                blobID: NULL_BLOB_ID
            };

            //increment our buffer count for next run
            if (runBuffers[rleRunBuffersPartion].count == MAX_RUNS_PER_LINE) {
                faults[1] = Fault.OUT_OF_RLE_MEM_FAULT;
            }
            else {
                runBuffers[rleRunBuffersPartion].count = runBuffers[rleRunBuffersPartion].count + 1;
            }
        }
    }

    //end line
    if (kernel.pos.x == KERNEL_MAX_X) {
        //zero count we are working on for next line
        runBuffers[overflow(rleRunBuffersPartion + 1, 2)].count = 0;

        //increment buffer partion for next line
        rleRunBuffersPartion = overflow(rleRunBuffersPartion + 1, 2);
    }
}

//Blob Processor Loop
enum State { IDLE, LAST_LINE, MERGE_READ, MERGE_WRITE, JOIN, WRITE };
let state: State = State.IDLE;
let masterBlobID = NULL_BLOB_ID;
function updateBlobProcessor() {
    blobBRAMPortA.wea = false;
    blobBRAMPortB.wea = false;

    const partionCurrentValid: boolean = blobRunBuffersPartionCurrent !== NULL_RUN_BUFFER_PARTION;
    const nextPartionCurrent: number = overflow(blobRunBuffersPartionCurrent + 1, 2); //note: overflow(NULL+1)=0

    const doneWithLine: boolean = !partionCurrentValid || //done with line @ all runs processed OR on NULL line
                         blobRunBufferIndexCurrent >= runBuffers[blobRunBuffersPartionCurrent].count;

    const nextLineAvailable: boolean = rleRunBuffersPartion !== nextPartionCurrent && //can move next line @ rle is done with it
                              runBuffers[nextPartionCurrent].line !== NULL_LINE_NUMBER; //& its a valid location

    const rlePartionValid: boolean = rleRunBuffersPartion !== NULL_RUN_BUFFER_PARTION;
    const blobProcessorTooSlow: boolean = rlePartionValid && rleRunBuffersPartion === blobRunBuffersPartionLast;
    const blobProcessorReallyTooSlow: boolean = rlePartionValid && rleRunBuffersPartion === blobRunBuffersPartionCurrent;
    
    //Next Line
    if ((doneWithLine && nextLineAvailable) || blobProcessorTooSlow || blobProcessorReallyTooSlow) {
        //Fault
        if (!(doneWithLine && nextLineAvailable) && (blobProcessorReallyTooSlow || blobProcessorTooSlow)) {
            faults[3] = Fault.BLOB_PROCESSOR_TOO_SLOW_FAULT;
        }

        //Get partions for new line
        if (blobProcessorReallyTooSlow) {
            //blob processor is so slow that we it caught up to our current position
            // => skip 2 lines so we can still use the last line wo/ RLE overwriting it
            //this can happen on the first line of the image, where blobRunBuffersPartionLast is NULL
            //get partions for new line
            const nextPartionLast = nextPartionCurrent;
            blobRunBuffersPartionLast = 
                (nextPartionLast !== overflow(nextPartionCurrent + 1, 2) && runBuffers[nextPartionLast].line !== NULL_LINE_NUMBER) ?
                nextPartionLast : NULL_RUN_BUFFER_PARTION;
            blobRunBuffersPartionCurrent = overflow(nextPartionCurrent + 1, 2);
        }
        else {
            const nextPartionLast = overflow(blobRunBuffersPartionCurrent, 2);
            blobRunBuffersPartionLast = 
                (nextPartionLast !== nextPartionCurrent && runBuffers[nextPartionLast].line !== NULL_LINE_NUMBER) ?
                nextPartionLast : NULL_RUN_BUFFER_PARTION;
            blobRunBuffersPartionCurrent = nextPartionCurrent;
        }

        //Reset Intra-Buffer Indexes
        blobRunBufferIndexCurrent = 0;
        blobRunBufferIndexLast = 0;
    }

    //Process Run
    if (partionCurrentValid && blobRunBufferIndexCurrent < runBuffers[blobRunBuffersPartionCurrent].count) {
        const currentRun: Run = runBuffers[blobRunBuffersPartionCurrent].runs[blobRunBufferIndexCurrent];
        const currentLine: number = runBuffers[blobRunBuffersPartionCurrent].line;

        //start run (if done with last one, or last one timed out)
        if (state == State.IDLE) {
            masterBlobID = NULL_BLOB_ID;
            blobRunBufferIndexLast = 0;
            state = (blobRunBuffersPartionLast == NULL_RUN_BUFFER_PARTION) ? State.WRITE : State.LAST_LINE;
        }

        //loop through all runs that were filled up in the last run buffer (line above)
        if (state == State.LAST_LINE) {
            for (blobRunBufferIndexLast; blobRunBufferIndexLast < runBuffers[blobRunBuffersPartionLast].count; blobRunBufferIndexLast++) {
                const lastRun: Run = runBuffers[blobRunBuffersPartionLast].runs[blobRunBufferIndexLast];
                if (lastRun.blobID !== NULL_BLOB_ID) {
                    if (runsOverlap(currentRun, lastRun)) {
                        const lastRunRealBlobID = getRealBlobID(lastRun.blobID);
                        //pointer fault
                        if (lastRunRealBlobID == NULL_BLOB_ID) {
                            break;
                        }

                        //found master (1st valid blob)
                        else if (masterBlobID === NULL_BLOB_ID) {
                            masterBlobID = lastRunRealBlobID;
                        }

                        //found another valid blob => merge with master
                        else if (lastRunRealBlobID !== masterBlobID) {
                            //read slave & master blobs
                            blobBRAMPortA.addr = lastRunRealBlobID;
                            blobBRAMPortB.addr = masterBlobID;

                            //mark slave as pointer to master
                            blobPointers[lastRunRealBlobID] = masterBlobID;
                            blobValids[lastRunRealBlobID] = false;

                            //go merge blobs & write once we read them
                            state = State.MERGE_WRITE;
                            break;
                        }
                    }
                }
            }

            //done looping last line => write blob
            if (state == State.LAST_LINE) {
                state = masterBlobID == NULL_BLOB_ID ? State.WRITE : State.JOIN;
            }
        }

        else if (state == State.MERGE_WRITE) {
            //TODO read delay
            blobBRAMPortB.din = mergeBlobs(blobBRAMPortA.dout, blobBRAMPortB.dout);
            blobBRAMPortB.wea = true;
            state = State.LAST_LINE;
        }

        if (state == State.JOIN) {
            //TODO read delay
            blobBRAMPortB.addr = masterBlobID;
            state = State.WRITE;
        }

        else if (state == State.WRITE) {
            //add this pixel to blob if we have a valid blob to join
            if (masterBlobID !== NULL_BLOB_ID) {
                blobBRAMPortB.din = mergeBlobs(runToBlob(currentRun, currentLine), blobBRAMPortB.dout);
                blobBRAMPortB.wea = true;

                //set ID of the blob we joined
                runBuffers[blobRunBuffersPartionCurrent].runs[blobRunBufferIndexCurrent].blobID = masterBlobID;
            }
            
            //not touching a blob => make new blob
            else {
                //create blob at next available index
                blobBRAMPortA.addr = blobIndex;
                blobBRAMPortA.din = runToBlob(currentRun, currentLine);
                blobBRAMPortA.wea = true;
                blobValids[blobIndex] = true;

                //set ID of the blob we made in runBuffer
                runBuffers[blobRunBuffersPartionCurrent].runs[blobRunBufferIndexCurrent].blobID = blobIndex;

                
                if (blobIndex == MAX_BLOBS-1) {
                    //fault
                    faults[0] = Fault.OUT_OF_BLOB_MEM_FAULT;
                    blobIndex = 0;
                }
                else {
                    //increment index for next blob
                    blobIndex = blobIndex + 1;
                }  
            }

            //push to blob color buffer (scripting only)
            blobColorBuffer[currentLine].runs[blobRunBufferIndexCurrent] = 
                Object.assign({}, runBuffers[blobRunBuffersPartionCurrent].runs[blobRunBufferIndexCurrent]);
            blobColorBuffer[currentLine].count = blobRunBufferIndexCurrent  + 1;

            //end run
            blobRunBufferIndexCurrent = blobRunBufferIndexCurrent + 1;
            state = State.IDLE;
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
function runToBlob(run: Run, line: number): BlobData {
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

//Get Real Blob ID "Recursively"
let currentID: number;
function getRealBlobID(startID: number): number {
    currentID = startID;

    for (let i = 0; i < MAX_BLOB_POINTER_DEPTH; i++) {
        if (blobValids[currentID]) {
            return currentID;
        }
        else {
            currentID = blobPointers[currentID];
        }
    }
    
    faults[2] = Fault.BLOB_POINTER_DEPTH_FAULT;
    return NULL_BLOB_ID;
}
function getRealBlobIDDebug(startID: number): number {
    return blobValids[startID] ? startID : getRealBlobIDDebug(blobPointers[startID]);
}

//BRAM
function updateBRAM() {
    const ports: BlobBRAMPort[] = [blobBRAMPortA, blobBRAMPortB];

    //TODO read/write clock delay
    for (const port of ports) {
        if (port.wea) {
            //write from din
            blobBRAM[port.addr] = port.din;
        }

        else {
            //read to dout
            port.dout = blobBRAM[port.addr];
        }
    }
}