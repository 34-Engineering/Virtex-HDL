//BlobProcessor.ts
import { IMAGE_WIDTH, IMAGE_HEIGHT } from "./util/Constants";
import { Fault } from "./util/Fault";
import { BlobBRAMPort, BLOB_BRAM_PORT_DEFAULT, Kernel, EMPTY_BLOB, KERNEL_MAX_X } from "./util/OtherUtil";
import { MAX_BLOBS, MAX_BLOB_POINTER_DEPTH, MAX_RUNS_PER_LINE, NULL_RUN_START, NULL_LINE_NUMBER, NULL_BLOB_ID, NULL_RUN_BUFFER_PARTION } from "./BlobConstants";
import { BlobData, mergeBlobs, Run, RunBuffer, runsOverlap, runToBlob } from "./BlobUtil";
import { IMAGE_INPUT_PATH, DRAW_BLOB_COLOR, DRAW_BOUND, DRAW_QUAD, IMAGE_OUTPUT_PATH, SINGLE_IMAGE_MODE, IMAGES_INPUT_PATH, IMAGES_OUTPUT_PATH } from "./Config";
import * as fs from "fs";
import * as path from "path";
import { overflow } from "./util/Math";
const drawing = require('pngjs-draw');
const png = drawing(require('pngjs').PNG);

//Variables (scripting only)
let blobColorBuffer: RunBuffer[];
let faults: Fault[] = [...Array(4)].map(_=>Fault.NO_FAULT);
let blobBRAM: BlobData[] = [...Array(MAX_BLOBS)].map(_=>(EMPTY_BLOB));
let blobBRAMPortA: BlobBRAMPort = Object.assign({}, BLOB_BRAM_PORT_DEFAULT);
let blobBRAMPortB: BlobBRAMPort = Object.assign({}, BLOB_BRAM_PORT_DEFAULT);

//Variables
enum BlobState { IDLE, LAST_LINE, MERGE_READ, MERGE_WRITE_1, MERGE_WRITE_2, JOIN_1, JOIN_2, WRITE };
let blobState: BlobState = BlobState.IDLE;
let blobPointers: number[] = [...Array(MAX_BLOBS)].map(_=>(0));
let blobValids: boolean[] = [...Array(MAX_BLOBS)].map(_=>(false));
let blobIndex: number = 0;
let blobRunBuffersPartionCurrent: number = NULL_RUN_BUFFER_PARTION;
let blobRunBuffersPartionLast: number = NULL_RUN_BUFFER_PARTION;
let blobRunBufferIndexCurrent: number = 0;
let blobRunBufferIndexLast: number = 0;
let masterBlobID: number = NULL_BLOB_ID;
let targetSelectorDone: boolean = false;
let runBuffers: RunBuffer[] = [...Array(3)].map(_=>({
    runs: [...Array(MAX_RUNS_PER_LINE)].map(_=>({ start: NULL_RUN_START, stop: 0, blobID: NULL_BLOB_ID })),
    count: 0,
    line: NULL_LINE_NUMBER
}));
let rleRunBuffersPartion: number = 0;
let rleRunStart: number = 0;
let rleInRun: boolean = false;
let kernel: Kernel = { value: [...Array(8)].map(_=>false), pos: {x:0, y:0}, valid: false };
let lastKernelValid: boolean = false;

//Simulated 180MHz Always Loop
function alwaysLoop() {
    //working on frame
    if (kernel?.pos.y !== IMAGE_HEIGHT-1 || kernel?.pos.x !== KERNEL_MAX_X || 
        !blobProcessorDoneWithLine() || runBuffers[blobRunBuffersPartionCurrent].line !== IMAGE_HEIGHT-1) {
        
        //New Kernel
        if (kernel.valid && !lastKernelValid) {
            //Run Length Encoding Loop
            updateRunLengthEncoder(kernel);
        }
        lastKernelValid = kernel.valid;

        //Blob Processor Loop
        updateBlobProcessor();
    }

    //done with frame
    else {
        //Target Selection Loop
        updateTargetSelector();
    }
}

//Run Length Encoding Loop
function updateRunLengthEncoder(kernel: Kernel) {
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

        if (runBuffers[rleRunBuffersPartion].line === IMAGE_HEIGHT-1) {
            //done with frame => null
            rleRunBuffersPartion = NULL_RUN_BUFFER_PARTION;
        }
        else {
            //increment buffer partion for next line
            rleRunBuffersPartion = overflow(rleRunBuffersPartion + 1, 2);
        }
    }
}

//Blob Processor Loop
function updateBlobProcessor() {
    blobBRAMPortA.wea = false;
    blobBRAMPortB.wea = false;

    //(verilog wires)
    const partionCurrentValid: boolean = blobRunBuffersPartionCurrent !== NULL_RUN_BUFFER_PARTION;
    const nextPartionCurrent: number = overflow(blobRunBuffersPartionCurrent + 1, 2); //note: overflow(NULL+1)=0

    const nextLineAvailable: boolean = rleRunBuffersPartion !== nextPartionCurrent && //can move next line @ rle is done with it
                              runBuffers[nextPartionCurrent].line !== NULL_LINE_NUMBER; //& its a valid location

    const rlePartionValid: boolean = rleRunBuffersPartion !== NULL_RUN_BUFFER_PARTION;
    const blobProcessorTooSlow: boolean = rlePartionValid && rleRunBuffersPartion === blobRunBuffersPartionLast;
    const blobProcessorReallyTooSlow: boolean = rlePartionValid && rleRunBuffersPartion === blobRunBuffersPartionCurrent;
    
    //Next Line
    if ((blobProcessorDoneWithLine() && nextLineAvailable) || blobProcessorTooSlow || blobProcessorReallyTooSlow) {
        //Fault
        if ((blobProcessorReallyTooSlow || blobProcessorTooSlow) && !(blobProcessorDoneWithLine() && nextLineAvailable)) {
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

        // if (currentLine == 479)
        //     process.stdout.write(currentLine + ",");

        //start run (if done with last one, or last one timed out)
        if (blobState == BlobState.IDLE) {
            masterBlobID = NULL_BLOB_ID;
            blobRunBufferIndexLast = 0;
            blobState = (blobRunBuffersPartionLast == NULL_RUN_BUFFER_PARTION) ? BlobState.WRITE : BlobState.LAST_LINE;
        }

        //loop through all runs that were filled up in the last run buffer (line above)
        if (blobState == BlobState.LAST_LINE) {
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
                            blobState = BlobState.MERGE_WRITE_1;
                            break;
                        }
                    }
                }
            }

            //done looping last line => write blob
            if (blobState == BlobState.LAST_LINE) {
                blobState = masterBlobID == NULL_BLOB_ID ? BlobState.WRITE : BlobState.JOIN_1;
            }
        }

        else if (blobState == BlobState.MERGE_WRITE_1) {
            //account for read delay
            blobState = BlobState.MERGE_WRITE_2;
        }

        else if (blobState == BlobState.MERGE_WRITE_2) {
            blobBRAMPortB.din = mergeBlobs(blobBRAMPortA.dout, blobBRAMPortB.dout);
            blobBRAMPortB.wea = true;
            blobState = BlobState.LAST_LINE;
        }

        if (blobState == BlobState.JOIN_1) {
            //account for read delay
            blobBRAMPortB.addr = masterBlobID;
            blobState = BlobState.JOIN_2;
        }

        else if (blobState == BlobState.JOIN_2) {
            blobState = BlobState.WRITE;
        }

        else if (blobState == BlobState.WRITE) {
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
            blobState = BlobState.IDLE;
        }
    }
}
//(verilog wires)
function blobProcessorDoneWithLine(): boolean {
    //done with line @ on NULL line OR all runs processed
    return blobRunBuffersPartionCurrent === NULL_RUN_BUFFER_PARTION ||
           blobRunBufferIndexCurrent >= runBuffers[blobRunBuffersPartionCurrent].count;
}

//Target Selector Loop
function updateTargetSelector() {
    targetSelectorDone = true;
}

//Resetting
function resetForNewFrame() {
    blobIndex = 0;
    blobRunBuffersPartionCurrent = NULL_RUN_BUFFER_PARTION;
    blobRunBuffersPartionLast = NULL_RUN_BUFFER_PARTION;
    blobRunBufferIndexCurrent = 0;
    blobRunBufferIndexLast = 0;
    masterBlobID = NULL_BLOB_ID;
    targetSelectorDone = false;
    rleRunBuffersPartion = 0;
    rleRunStart = 0;
    rleInRun = false;
    kernel.valid = false;
    lastKernelValid = false;
    for (let i = 0; i < 3; i++) {
        runBuffers[i].count = 0;
        runBuffers[i].line = NULL_LINE_NUMBER;
    }

    //(scripting only)
    blobColorBuffer = [...Array(IMAGE_HEIGHT)].map(_=>({
        runs: [...Array(MAX_RUNS_PER_LINE)].map(_=>({ start: NULL_RUN_START, stop: 0, blobID: NULL_BLOB_ID })),
        count: 0,
        line: NULL_LINE_NUMBER
    }));
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
    //(scripting only) real recursive version
    //for drawing blob colors
    return blobValids[startID] ? startID : getRealBlobIDDebug(blobPointers[startID]);
}

//BRAM Simulation (scripting only)
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

//Run Image (scripting only)
function runImage(imageInputPath: string, imageOutputPath: string): Promise<void> {
    resetForNewFrame();

    return new Promise(function(resolve) {
        const stream = fs.createReadStream(imageInputPath);
        const img = stream.pipe(new png());
        img.on('parsed', function () {
            //"180MHz" Process Loop
            let kx: number = 0, ky: number = 0;
            let pythonDone: boolean = false;
            let loopCount: number = 0;
            while (!targetSelectorDone) {
                //"36MHz" Kernel Reading (PythonManager)
                if (loopCount % 5 == 0 && !pythonDone) {
                    let tempKernel: Kernel = {
                        value: [...Array(8)].map(_=>false),
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
                    kernel = Object.assign({}, tempKernel);

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
                    kernel.valid = false;
                }

                //"180MHz" Always Loop
                alwaysLoop();

                //"180MHz" Sync BRAM
                updateBRAM();

                loopCount = loopCount + 1;
            }
            
            //Logging
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
            this.pack().pipe(fs.createWriteStream(imageOutputPath));

            resolve();
        });
    });
}

(async function run() {
    if (SINGLE_IMAGE_MODE) {
        //process single image
        console.log(path.basename(IMAGE_INPUT_PATH));
        await runImage(IMAGE_INPUT_PATH, IMAGE_OUTPUT_PATH);
    }
    else {
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

    //Log Faults
    for (const fault of faults) {
        if (fault !== Fault.NO_FAULT) {
            console.log(Fault[fault]);
        }
    }
})();