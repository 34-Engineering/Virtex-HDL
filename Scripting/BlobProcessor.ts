//BlobProcessor.ts

import { IMAGE_WIDTH, IMAGE_HEIGHT } from "./util/Constants";
import { Fault } from "./util/Fault";
import { BlobBRAMPort, BLOB_BRAM_PORT_DEFAULT, Kernel, EMPTY_BLOB, KERNEL_MAX_X } from "./util/OtherUtil";
import { MAX_BLOBS, MAX_BLOB_POINTER_DEPTH, MAX_RUNS_PER_LINE, NULL_RUN_START, NULL_LINE_NUMBER, NULL_BLOB_ID, NULL_RUN_BUFFER_PARTION } from "./BlobConstants";
import { BlobData, mergeBlobs, Run, RunBuffer, runsOverlap, runToBlob } from "./BlobUtil";
import * as fs from "fs";
import { overflow } from "./util/Math";
const drawing = require('pngjs-draw');
const png = drawing(require('pngjs').PNG);

const IMAGE_PATH = 'images/2019_Noise.png';
const DRAW_BLOB_COLOR = true;
const DRAW_BOUND = true;
const DRAW_QUAD = true;

let blobColorBuffer: RunBuffer[] = [...Array(IMAGE_HEIGHT)].map(_=>({
    runs: [...Array(MAX_RUNS_PER_LINE)].map(_=>({ start: NULL_RUN_START, stop: 0, blobID: NULL_BLOB_ID })),
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
    runs: [...Array(MAX_RUNS_PER_LINE)].map(_=>({ start: NULL_RUN_START, stop: 0, blobID: NULL_BLOB_ID })),
    count: 0,
    line: NULL_LINE_NUMBER
}));
let rleRunBuffersPartion: number = 0; //which run buffer we are on

let kernel: Kernel;
let lastKernelValid: boolean = false;

//Read Image (scripting only)
fs.createReadStream(IMAGE_PATH)
    .pipe(new png())
    .on('parsed', function () {
        //"180MHz" Process Loop
        let kx: number = 0, ky: number = 0;
        let loopCount: number = 0;
        while (loopCount / 5 < IMAGE_WIDTH * IMAGE_HEIGHT + 100) { //TODO check me
            //"36MHz" Kernel Reading (PythonManager)
            if (loopCount % 5 == 0 && ky < IMAGE_HEIGHT) {
                let tempKernel: Kernel = {
                    value: Array(8).fill(false),
                    pos: { x: kx, y: ky },
                    valid: true
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

                if (kx == KERNEL_MAX_X) {
                    ky = ky + 1;
                    kx = 0;
                }
                else {
                    kx = kx + 1;
                }
            }
            else {
                kernel.valid = false;
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
                    for (let x = run.start; x <= run.stop; x++) {
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
            if (blobValids[i]) {
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
    if (kernel.valid && !lastKernelValid) {
        encodeKernel(kernel);
    }
    lastKernelValid = kernel.valid;

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
                stop: (kernel.pos.x * 8) + x - (kernel.value[x]?0:1),
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
enum State { IDLE, LAST_LINE, MERGE_READ, MERGE_WRITE_1, MERGE_WRITE_2, JOIN_1, JOIN_2, WRITE };
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
                            state = State.MERGE_WRITE_1;
                            break;
                        }
                    }
                }
            }

            //done looping last line => write blob
            if (state == State.LAST_LINE) {
                state = masterBlobID == NULL_BLOB_ID ? State.WRITE : State.JOIN_1;
            }
        }

        else if (state == State.MERGE_WRITE_1) {
            //account for read delay
            state = State.MERGE_WRITE_2;
        }

        else if (state == State.MERGE_WRITE_2) {
            blobBRAMPortB.din = mergeBlobs(blobBRAMPortA.dout, blobBRAMPortB.dout);
            blobBRAMPortB.wea = true;
            state = State.LAST_LINE;
        }

        if (state == State.JOIN_1) {
            //account for read delay
            blobBRAMPortB.addr = masterBlobID;
            state = State.JOIN_2;
        }

        else if (state == State.JOIN_2) {
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
let lastAddresses: number[] = [0, 0];
function updateBRAM() {
    const ports: BlobBRAMPort[] = [blobBRAMPortA, blobBRAMPortB];

    for (const p in ports) {
        const port = ports[p];

        if (port.wea) {
            //write from din
            blobBRAM[port.addr] = port.din;
        }

        else {
            //read to dout
            port.dout = blobBRAM[lastAddresses[p]];
        }

        lastAddresses[p] = port.addr;
    }
}