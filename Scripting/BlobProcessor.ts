//BlobProcessor.ts
import { IMAGE_WIDTH, IMAGE_HEIGHT } from "./util/Constants";
import { Fault } from "./util/Fault";
import { BlobBRAMPort, BLOB_BRAM_PORT_DEFAULT, Kernel, EMPTY_BLOB, KERNEL_MAX_X, drawEllipse, calculateIDX, drawLine } from "./util/OtherUtil";
import { MAX_BLOBS, MAX_BLOB_POINTER_DEPTH, MAX_RUNS_PER_LINE, NULL_LINE_NUMBER, NULL_BLOB_ID, NULL_RUN_BUFFER_PARTION, NULL_BLACK_RUN_BLOB_ID } from "./BlobConstants";
import { BlobData, mergeBlobs, Run, RunBuffer, runsOverlap, runToBlob } from "./BlobUtil";
import { IMAGE_INPUT_PATH, DRAW_BLOB_COLOR, DRAW_BOUND, DRAW_POLYGON, IMAGE_OUTPUT_PATH, IMAGES_INPUT_PATH, IMAGES_OUTPUT_PATH, DRAW_ELLIPSE } from "./Config";
import * as fs from "fs";
import * as path from "path";
import { overflow } from "./util/Math";
import { DefaultVirtexConfig } from "./util/VirtexConfig";
const drawing = require('pngjs-draw');
const png = drawing(require('pngjs').PNG);

//Variables (scripting only)
let blobColorBuffer: RunBuffer[];
let faults: Fault[] = [...Array(4)].map(_=>Fault.NO_FAULT);
let blobBRAM: BlobData[] = [...Array(MAX_BLOBS)].map(_=>(EMPTY_BLOB));
let blobBRAMPortA: BlobBRAMPort = Object.assign({}, BLOB_BRAM_PORT_DEFAULT);
let blobBRAMPortB: BlobBRAMPort = Object.assign({}, BLOB_BRAM_PORT_DEFAULT);
let data: any;

//Variables
enum BlobState { IDLE, LAST_LINE, MERGE_READ, MERGE_WRITE_1, MERGE_WRITE_2, JOIN_1, JOIN_2, WRITE };
let blobState: BlobState = BlobState.IDLE;
let blobPointers: number[] = [...Array(MAX_BLOBS)].map(_=>(0));
let blobValids: boolean[] = [...Array(MAX_BLOBS)].map(_=>(false));
let blobIndex: number;
let blobRunBuffersPartionCurrent: number;
let blobRunBuffersPartionLast: number;
let blobRunBufferIndexCurrent: number;
let blobRunBufferXCurrent: number;
let blobRunBufferIndexLast: number;
let blobRunBufferXLast: number;
let masterBlobID: number;
let targetSelectorDone: boolean;
let garbageIndex: number;
let runBuffers: RunBuffer[] = [...Array(3)].map(_=>({
    runs: [...Array(MAX_RUNS_PER_LINE)].map(_=>({ length: 0, blobID: NULL_BLOB_ID })),
    count: 0,
    line: NULL_LINE_NUMBER
}));
let rleRunBuffersPartion: number;
let kernel: Kernel = { value: [...Array(8)].map(_=>false), pos: {x:0, y:0}, valid: false };
let lastKernelValid: boolean;

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
    else if (!garbageCollectorDone()) {
        //Garbage Collection Loop
        updateGarbageCollector();
    }
    else if (!targetSelectorDone) {
        //Target Selection Loop
        updateTargetSelector();
    }
}

//Run Length Encoding Loop
function updateRunLengthEncoder(kernel: Kernel) {
    //start of line
    if (kernel.pos.x == 0) {
        //set line number of our RunBuffer
        runBuffers[rleRunBuffersPartion].line = kernel.pos.y;

        //zero count of our RunBuffer
        runBuffers[rleRunBuffersPartion].count = 0;
    }
    
    //encode every pixel in kernel
    for (let x = 0; x < 8; x++) {
        //new run @ start of line OR color transition
        if ((kernel.pos.x == 0 && x == 0) ||
            kernel.value[x] !== (runBuffers[rleRunBuffersPartion].runs[runBuffers[rleRunBuffersPartion].count-1].blobID !== NULL_BLACK_RUN_BLOB_ID)) {

            //push run to buffer
            runBuffers[rleRunBuffersPartion].runs[runBuffers[rleRunBuffersPartion].count] = {
                length: 1,
                blobID: kernel.value[x] ? NULL_BLOB_ID : NULL_BLACK_RUN_BLOB_ID
            };

            //increment our buffer count for next run
            if (runBuffers[rleRunBuffersPartion].count == MAX_RUNS_PER_LINE) {
                faults[1] = Fault.OUT_OF_RLE_MEM_FAULT;
            }
            else {
                runBuffers[rleRunBuffersPartion].count = runBuffers[rleRunBuffersPartion].count + 1;
            }
        }

        //extend length of last run
        else {
            runBuffers[rleRunBuffersPartion].runs[runBuffers[rleRunBuffersPartion].count-1].length = 
            runBuffers[rleRunBuffersPartion].runs[runBuffers[rleRunBuffersPartion].count-1].length + 1;
        }
    }

    //end line
    if (kernel.pos.x == KERNEL_MAX_X) {
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
        blobRunBufferXCurrent = 0;
        blobState = BlobState.IDLE;
    }

    //Handle Run (if we are on a valid partion of the RunBuffer & there are more Runs to handle)
    if (partionCurrentValid && blobRunBufferIndexCurrent < runBuffers[blobRunBuffersPartionCurrent].count) {
        const currentRun: Run = runBuffers[blobRunBuffersPartionCurrent].runs[blobRunBufferIndexCurrent];
        const currentLine: number = runBuffers[blobRunBuffersPartionCurrent].line;

        //run is black => continue to next run
        if (currentRun.blobID == NULL_BLACK_RUN_BLOB_ID) {
            //push to blob color buffer (scripting only)
            blobColorBuffer[currentLine].runs[blobRunBufferIndexCurrent] = 
                Object.assign({}, runBuffers[blobRunBuffersPartionCurrent].runs[blobRunBufferIndexCurrent]);
            blobColorBuffer[currentLine].count = blobRunBufferIndexCurrent + 1;

            //continue to next run
            blobRunBufferXCurrent = blobRunBufferXCurrent + runBuffers[blobRunBuffersPartionCurrent].runs[blobRunBufferIndexCurrent].length;
            blobRunBufferIndexCurrent = blobRunBufferIndexCurrent + 1;
        }

        //run is white => process
        else {
            //start run (if done with last one, or last one timed out)
            if (blobState == BlobState.IDLE) {
                //mark this run as doesn't have another run to join
                masterBlobID = NULL_BLOB_ID;

                //reset last run buffer indexes
                blobRunBufferIndexLast = 0;
                blobRunBufferXLast = 0;

                //proceed to look for runs to join OR go straight to writing if on the first line of image
                blobState = (blobRunBuffersPartionLast == NULL_RUN_BUFFER_PARTION) ? BlobState.WRITE : BlobState.LAST_LINE;
            }

            //loop through all runs that were filled up in the last run buffer (line above)
            if (blobState == BlobState.LAST_LINE) {
                for (blobRunBufferIndexLast; blobRunBufferIndexLast < runBuffers[blobRunBuffersPartionLast].count; blobRunBufferIndexLast++) {
                    const lastRun: Run = runBuffers[blobRunBuffersPartionLast].runs[blobRunBufferIndexLast];
                    if (lastRun.blobID !== NULL_BLACK_RUN_BLOB_ID) {
                        if (runsOverlap(currentRun, blobRunBufferXCurrent, lastRun, blobRunBufferXLast)) {
                            const lastRunRealBlobID = getRealBlobID(lastRun.blobID);
                            //pointer fault
                            if (lastRunRealBlobID == NULL_BLOB_ID) {
                                faults[2] = Fault.BLOB_POINTER_DEPTH_FAULT;
                            }

                            //found master (1st valid blob)
                            else if (masterBlobID === NULL_BLOB_ID) {
                                masterBlobID = lastRunRealBlobID;
                            }

                            //found another valid blob => merge with master
                            else if (lastRunRealBlobID !== masterBlobID) {
                                //read slave & master blobs
                                blobBRAMPortA.addr = masterBlobID;
                                blobBRAMPortB.addr = lastRunRealBlobID;

                                //mark slave as pointer to master
                                blobPointers[lastRunRealBlobID] = masterBlobID;
                                blobValids[lastRunRealBlobID] = false;

                                //go merge blobs & write once we read them
                                blobState = BlobState.MERGE_WRITE_1;
                            }
                        }
                    }
                    blobRunBufferXLast = blobRunBufferXLast + runBuffers[blobRunBuffersPartionLast].runs[blobRunBufferIndexLast].length;
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
                blobBRAMPortA.din = mergeBlobs(blobBRAMPortB.dout, blobBRAMPortA.dout);
                blobBRAMPortA.wea = true;
                //TODO blobBRAMPortB.wea = false;
                blobState = BlobState.LAST_LINE;
            }

            if (blobState == BlobState.JOIN_1) {
                //account for read delay
                blobBRAMPortA.addr = masterBlobID;
                blobState = BlobState.JOIN_2;
            }

            else if (blobState == BlobState.JOIN_2) {
                blobState = BlobState.WRITE;
            }

            else if (blobState == BlobState.WRITE) {
                //add this pixel to blob if we have a valid blob to join
                if (masterBlobID !== NULL_BLOB_ID) {
                    blobBRAMPortA.din = mergeBlobs(runToBlob(currentRun, blobRunBufferXCurrent, currentLine), blobBRAMPortA.dout);
                    blobBRAMPortA.wea = true;

                    //set ID of the blob we joined
                    runBuffers[blobRunBuffersPartionCurrent].runs[blobRunBufferIndexCurrent].blobID = masterBlobID;
                }
                
                //not touching a blob => make new blob
                else {
                    //create blob at next available index
                    blobBRAMPortA.addr = blobIndex;
                    blobBRAMPortA.din = runToBlob(currentRun, blobRunBufferXCurrent, currentLine);
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
                blobColorBuffer[currentLine].count = blobRunBufferIndexCurrent + 1;

                //continue to next run
                blobRunBufferXCurrent = blobRunBufferXCurrent + runBuffers[blobRunBuffersPartionCurrent].runs[blobRunBufferIndexCurrent].length;
                blobRunBufferIndexCurrent = blobRunBufferIndexCurrent + 1;
                blobState = BlobState.IDLE;
            }
        }
    }
}
function blobProcessorDoneWithLine(): boolean {
    //(verilog wire)
    //done with line @ on NULL line OR all runs processed
    return blobRunBuffersPartionCurrent === NULL_RUN_BUFFER_PARTION ||
           blobRunBufferIndexCurrent >= runBuffers[blobRunBuffersPartionCurrent].count;
}

//Garbage Collector Loop //TODO
function updateGarbageCollector() {
    garbageIndex++;
    /*
    DefaultVirtexConfig

    Garbage collector
     - blobs that are "done" & don't match min criteria are invalidated
     - run inside blobProcessor (if it has free BRAM port) & in targetSelector (if garbage is not done yet gbIndex < blobIndex)
    
     */
}
function garbageCollectorDone(): boolean {
    //(verilog wire)
    return garbageIndex == blobIndex;
}

//Target Selector Loop //TODO
function updateTargetSelector() {

    /*
    DefaultVirtexConfig

    Now Target Selector has a list of clean blobs (blobValids)
     - Run thru all combinatations listed below
     - TARGET_SELECTOR_TOO_SLOW_FAULT (aka garbage criteria isnt precise enough for targetBlobs)

    */

    /*
    (blobs, targetBlobs) => # blob combinations for target selection (max 4000)

    (b,t) => (b!)/((t!)(b-t)!)
    */

    //TODO
    targetSelectorDone = true;
}

//Resetting
function resetForNewFrame() {
    blobIndex = 0;
    blobRunBuffersPartionCurrent = NULL_RUN_BUFFER_PARTION;
    blobRunBuffersPartionLast = NULL_RUN_BUFFER_PARTION;
    targetSelectorDone = false;
    rleRunBuffersPartion = 0;
    garbageIndex = 0;
    kernel.valid = false;
    lastKernelValid = false;
    for (let i = 0; i < 3; i++) {
        runBuffers[i].count = 0;
        runBuffers[i].line = NULL_LINE_NUMBER;
    }

    //(scripting only)
    blobColorBuffer = [...Array(IMAGE_HEIGHT)].map(_=>({
        runs: [...Array(MAX_RUNS_PER_LINE)].map(_=>({ length: 0, blobID: NULL_BLOB_ID })),
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
            //@ts-ignore
            data = this.data;

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
                        const idx = calculateIDX(kx * 8 + x, ky);
                        //@ts-ignore
                        const value = (this.data[idx] + this.data[idx + 1] + this.data[idx + 2]) / 3;
                        const threshold = value > DefaultVirtexConfig.threshold;
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
                    let runBufferX = 0;
                    for (let i = 0; i < blobColorBuffer[y].count; i++) {
                        const run = blobColorBuffer[y].runs[i];

                        if (run.blobID !== NULL_BLACK_RUN_BLOB_ID) {
                            for (let x = runBufferX; x < runBufferX + run.length; x++) {
                                const idx = calculateIDX(x, y);
                                const realBlobID = getRealBlobIDDebug(run.blobID);
                                data[idx] = Math.sin(realBlobID * 50) * 200 + 55;
                                data[idx + 1] = Math.sin(realBlobID * 100) * 200 + 55;
                                data[idx + 2] = Math.sin(realBlobID * 200) * 200 + 55;
                            }
                        }
                        
                        runBufferX = runBufferX + run.length;
                    }
                }
            }

            //Draw Blob Bounding Box + Polygon + Ellipse
            for (let i = 0; i < blobIndex; i++) {
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

                    if (DRAW_POLYGON) {
                        // @ts-ignore
                        drawLine(
                            data,
                            blob.extremeTopLeft,
                            blob.extremeTopRight,
                            [0, 255, 0, 100]
                        );

                        //@ts-ignore
                        drawLine(
                            data,
                            blob.extremeTopRight,
                            blob.extremeBottomRight,
                            [0, 255, 0, 100]
                        );

                        //@ts-ignore
                        drawLine(
                            data,
                            blob.extremeBottomRight,
                            blob.extremeBottomLeft,
                            [0, 255, 0, 100]
                        );

                        //@ts-ignore
                        drawLine(
                            data,
                            blob.extremeBottomLeft,
                            blob.extremeTopLeft,
                            [0, 255, 0, 100]
                        );
                    }

                    if (DRAW_ELLIPSE) {
                        drawEllipse(
                            data,
                            blob.extremeTopRight,
                            blob.extremeTopLeft,
                            blob.extremeBottomRight,
                            blob.extremeBottomLeft,
                            [0, 0, 255, 100]
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
    for (const fault of faults) {
        if (fault !== Fault.NO_FAULT) {
            console.log(Fault[fault]);
        }
    }
})();