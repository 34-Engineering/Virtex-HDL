//BlobProcessor.ts
import { IMAGE_WIDTH, IMAGE_HEIGHT } from "./util/Constants";
import { Fault } from "./util/Fault";
import { BlobBRAMPort, BLOB_BRAM_PORT_DEFAULT, Kernel, EMPTY_BLOB, KERNEL_MAX_X, drawEllipse, calculateIDX, drawLine } from "./util/OtherUtil";
import { MAX_BLOBS, MAX_BLOB_POINTER_DEPTH, MAX_RUNS_PER_LINE, NULL_LINE_NUMBER, NULL_BLOB_ID, NULL_RUN_BUFFER_PARTION, NULL_BLACK_RUN_BLOB_ID } from "./BlobConstants";
import { BlobData, BlobMetadata, BlobStatus, mergeBlobs, Run, RunBuffer, runsOverlap, runToBlob, doesBlobMatchCriteria } from "./BlobUtil";
import { IMAGE_INPUT_PATH, DRAW_BLOB_COLOR, DRAW_BOUND, DRAW_POLYGON, IMAGE_OUTPUT_PATH, IMAGES_INPUT_PATH, IMAGES_OUTPUT_PATH, DRAW_ELLIPSE, virtexConfig } from "./Config";
import * as fs from "fs";
import * as path from "path";
import { overflow } from "./util/Math";
const drawing = require('pngjs-draw');
const png = drawing(require('pngjs').PNG);

//(scripting only)
let blobColorBuffer: RunBuffer[];
let faults: Fault[] = [...Array(4)].map(_=>Fault.NO_FAULT);
let blobBRAM: BlobData[] = [...Array(MAX_BLOBS)].map(_=>(Object.assign({}, EMPTY_BLOB)));
let blobBRAMPorts: BlobBRAMPort[] = [...Array(2)].map(_=>(Object.assign({}, BLOB_BRAM_PORT_DEFAULT)));
let data: any;

//Blob Processor
enum BlobRunState { IDLE, LAST_LINE, MERGE_READ, MERGE_WRITE_1, MERGE_WRITE_2, JOIN_1, JOIN_2, WRITE };
let blobRunState: BlobRunState = BlobRunState.IDLE; //[1:0]
let blobMetadatas: BlobMetadata[] = [...Array(MAX_BLOBS)].map(_=>({ status: BlobStatus.UNSCANED, pointer: NULL_BLOB_ID }));
let blobIndex: number; //[MAX_BLOB_ID_SIZE-1:0]
let blobRunBuffersPartionCurrent: number; //partion of run buffer (0-2)
let blobRunBuffersPartionLast: number;
let blobRunBufferIndexCurrent: number; //index in run buffer [0-MAX_RUNS_PER_LINE]
let blobRunBufferIndexLast: number;
let blobRunBufferXCurrent: number; //[9:0] counter for RLE x position
let blobRunBufferXLast: number;
let blobMasterBlobID: number; //master blob for run to join into (following joining runs are slaves)
let blobUsingPort1: boolean; //whether blobProcessor is using port1 (so garbage collector won't)

//Target Selector
let targetSelectorDone: boolean; //1-bit

//Garbage Collector
let garbagePort: number; //1-bit
let garbageIndex: number; //[MAX_BLOB_ID_SIZE-1:0]
let lastGarbageIndex: number[] = [0, 0]; //2 x [MAX_BLOB_ID_SIZE-1:0]
let garbageCollectorWasUsingPorts: boolean[] = [false, false]; //BRAM ports
let garbageCollectorDone: boolean;

//Run Length Encoding
let runBuffers: RunBuffer[] = [...Array(3)].map(_=>({
    runs: [...Array(MAX_RUNS_PER_LINE)].map(_=>({ length: 0, blobID: NULL_BLOB_ID })),
    count: 0,
    line: NULL_LINE_NUMBER
}));
let rleRunBuffersPartion: number;
let kernel: Kernel = { value: [...Array(8)].map(_=>false), pos: {x:0, y:0}, valid: false };
let lastKernelValid: boolean;

//"180MHz" Always Loop
let lastIsWorkingOnFrame: boolean = false;
function alwaysLoop() {
    //Reset Garbage Collector (when frame finished)
    if (!isWorkingOnFrame() && lastIsWorkingOnFrame) {
        //FORK
        garbagePort = 0;
        garbageIndex = 0;
        lastGarbageIndex = [0, 0];
        garbageCollectorWasUsingPorts = [false, false];
        //JOIN
    }
    lastIsWorkingOnFrame = isWorkingOnFrame();

    //Garbage Collection Loop
    if (!garbageCollectorDone) {
        updateGarbageCollector();
    }

    //Working on Frame
    if (isWorkingOnFrame()) {
        //New Kernel
        if (kernel.valid && !lastKernelValid) {
            //Run Length Encoding Loop
            updateRunLengthEncoder(kernel);
        }
        lastKernelValid = kernel.valid;

        //Blob Processor Loop
        updateBlobProcessor();
    }

    //Done with Frame
    else if (!targetSelectorDone && garbageCollectorDone) {
        //Target Selection Loop
        updateTargetSelector();
    }
}
function isWorkingOnFrame(): boolean {
    //(verilog wire)
    return !isLastKernel() || !blobProcessorDoneWithLine() || !blobProcessorOnLastLine();
}

//Run Length Encoding Loop
function updateRunLengthEncoder(kernel: Kernel) {
    //start of line
    if (kernel.pos.x == 0) {
        //FORK
        //set line number of our RunBuffer
        runBuffers[rleRunBuffersPartion].line = kernel.pos.y;

        //zero count of our RunBuffer
        runBuffers[rleRunBuffersPartion].count = 0;
        //JOIN
    }
    
    //encode every pixel in kernel
    for (let x = 0; x < 8; x++) {
        //FORK
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
        //JOIN
    }

    //end line
    if (kernel.pos.x == KERNEL_MAX_X) {
        //FORK
        if (runBuffers[rleRunBuffersPartion].line === IMAGE_HEIGHT-1) {
            //done with frame => null
            rleRunBuffersPartion = NULL_RUN_BUFFER_PARTION;
        }
        else {
            //increment buffer partion for next line
            rleRunBuffersPartion = overflow(rleRunBuffersPartion + 1, 2);
        }
        //JOIN
    }
}
function isLastKernel() {
    //(verilog wire)
    return kernel?.pos.y === IMAGE_HEIGHT-1 && kernel?.pos.x === KERNEL_MAX_X;
}
function rlePartionValid(): boolean {
    return rleRunBuffersPartion !== NULL_RUN_BUFFER_PARTION;
}

//Blob Processor Loop
function updateBlobProcessor() {
    blobBRAMPorts[0].wea = false;

    //Next Line
    if ((blobProcessorDoneWithLine() && blobNextLineAvailable()) || blobProcessorTooSlow() || blobProcessorReallyTooSlow()) {
        //FORK
        //Fault
        if ((blobProcessorReallyTooSlow() || blobProcessorTooSlow()) && !(blobProcessorDoneWithLine() && blobNextLineAvailable())) {
            faults[3] = Fault.BLOB_PROCESSOR_TOO_SLOW_FAULT;
        }

        //Get partions for new line
        if (blobProcessorReallyTooSlow()) {
            //blob processor is so slow that we it caught up to our current position
            // => skip 2 lines so we can still use the last line wo/ RLE overwriting it
            //this can happen on the first line of the image, where blobRunBuffersPartionLast is NULL
            //get partions for new line
            const nextPartionLast = blobNextPartionCurrent();
            blobRunBuffersPartionLast = 
                (nextPartionLast !== overflow(blobNextPartionCurrent() + 1, 2) && runBuffers[nextPartionLast].line !== NULL_LINE_NUMBER) ?
                nextPartionLast : NULL_RUN_BUFFER_PARTION;
            blobRunBuffersPartionCurrent = overflow(blobNextPartionCurrent() + 1, 2);
        }
        else {
            const nextPartionLast = overflow(blobRunBuffersPartionCurrent, 2);
            blobRunBuffersPartionLast = 
                (nextPartionLast !== blobNextPartionCurrent() && runBuffers[nextPartionLast].line !== NULL_LINE_NUMBER) ?
                nextPartionLast : NULL_RUN_BUFFER_PARTION;
            blobRunBuffersPartionCurrent = blobNextPartionCurrent();
        }

        //Reset Intra-Buffer Indexes
        blobRunBufferIndexCurrent = 0;
        blobRunBufferXCurrent = 0;
        blobRunState = BlobRunState.IDLE;
        //JOIN
    }

    //Handle Run (if we are on a valid partion of the RunBuffer & there are more Runs to handle)
    if (blobPartionCurrentValid() && blobRunBufferIndexCurrent < runBuffers[blobRunBuffersPartionCurrent].count) {
        //run is black => continue to next run
        if (blobCurrentRun().blobID == NULL_BLACK_RUN_BLOB_ID) {
            //push to blob color buffer (scripting only)
            blobColorBuffer[blobCurrentLine()].runs[blobRunBufferIndexCurrent] = 
                Object.assign({}, runBuffers[blobRunBuffersPartionCurrent].runs[blobRunBufferIndexCurrent]);
            blobColorBuffer[blobCurrentLine()].count = blobRunBufferIndexCurrent + 1;

            //continue to next run
            blobRunBufferXCurrent = blobRunBufferXCurrent + runBuffers[blobRunBuffersPartionCurrent].runs[blobRunBufferIndexCurrent].length;
            blobRunBufferIndexCurrent = blobRunBufferIndexCurrent + 1;
        }

        //run is white => process
        else {
            //start run (if done with last one, or last one timed out)
            if (blobRunState == BlobRunState.IDLE) {
                //FORK
                //mark this run as doesn't have another run to join
                blobMasterBlobID = NULL_BLOB_ID;

                //reset last run buffer indexes
                blobRunBufferIndexLast = 0;
                blobRunBufferXLast = 0;

                //proceed to look for runs to join OR go straight to writing if on the first line of image
                blobRunState = (blobRunBuffersPartionLast == NULL_RUN_BUFFER_PARTION) ? BlobRunState.WRITE : BlobRunState.LAST_LINE;
                //JOIN
            }

            //loop through all runs that were filled up in the last run buffer (line above)
            if (blobRunState == BlobRunState.LAST_LINE) {
                //FORK
                //TODO TODO TODO SIZEME SIZEME
                for (blobRunBufferIndexLast; blobRunBufferIndexLast < runBuffers[blobRunBuffersPartionLast].count; blobRunBufferIndexLast++) {
                    //FORK
                    if (blobLastLineRun().blobID !== NULL_BLACK_RUN_BLOB_ID) {
                        if (runsOverlap(blobCurrentRun(), blobRunBufferXCurrent, blobLastLineRun(), blobRunBufferXLast)) {
                            //pointer fault
                            if (blobLastLineRunRealBlobID() == NULL_BLOB_ID) {
                                faults[2] = Fault.BLOB_POINTER_DEPTH_FAULT;
                            }

                            //found master (1st valid blob)
                            else if (blobMasterBlobID === NULL_BLOB_ID) {
                                blobMasterBlobID = blobLastLineRunRealBlobID();
                            }

                            //found another valid blob => merge with master
                            else if (blobLastLineRunRealBlobID() !== blobMasterBlobID) {
                                //read slave & master blobs
                                blobBRAMPorts[0].addr = blobMasterBlobID;
                                blobBRAMPorts[1].addr = blobLastLineRunRealBlobID();
                                blobUsingPort1 = true;

                                //mark slave as pointer to master
                                blobMetadatas[blobLastLineRunRealBlobID()] = {
                                    status: BlobStatus.POINTER,
                                    pointer: blobMasterBlobID
                                };

                                //go merge blobs & write once we read them
                                blobRunState = BlobRunState.MERGE_WRITE_1;
                            }
                        }
                    }
                    //JOIN
                    blobRunBufferXLast = blobRunBufferXLast + runBuffers[blobRunBuffersPartionLast].runs[blobRunBufferIndexLast].length; //BLOCKING
                }
                //JOIN

                //done looping last line => write blob
                if (blobRunState == BlobRunState.LAST_LINE) {
                    //FORK
                    blobRunState = blobMasterBlobID == NULL_BLOB_ID ? BlobRunState.WRITE : BlobRunState.JOIN_1;
                    //JOIN
                }
            }

            else if (blobRunState == BlobRunState.MERGE_WRITE_1) {
                //account for read delay
                //FORK
                blobRunState = BlobRunState.MERGE_WRITE_2;
                //JOIN
            }

            else if (blobRunState == BlobRunState.MERGE_WRITE_2) {
                //FORK
                blobBRAMPorts[0].din = mergeBlobs(blobBRAMPorts[1].dout, blobBRAMPorts[0].dout);
                blobBRAMPorts[0].wea = true;
                blobUsingPort1 = false;
                blobRunState = BlobRunState.LAST_LINE;
                //JOIN
            }

            if (blobRunState == BlobRunState.JOIN_1) {
                //FORK
                //account for read delay
                blobBRAMPorts[0].addr = blobMasterBlobID;
                blobRunState = BlobRunState.JOIN_2;
                //JOIN
            }

            else if (blobRunState == BlobRunState.JOIN_2) {
                //FORK
                blobRunState = BlobRunState.WRITE;
                //JOIN
            }

            else if (blobRunState == BlobRunState.WRITE) {
                //FORK
                //add this pixel to blob if we have a valid blob to join
                if (blobMasterBlobID !== NULL_BLOB_ID) {
                    blobBRAMPorts[0].din = mergeBlobs(runToBlob(blobCurrentRun(), blobRunBufferXCurrent, blobCurrentLine()), blobBRAMPorts[0].dout);
                    blobBRAMPorts[0].wea = true;

                    //set ID of the blob we joined
                    runBuffers[blobRunBuffersPartionCurrent].runs[blobRunBufferIndexCurrent].blobID = blobMasterBlobID;
                }
                
                //not touching a blob => make new blob
                else {
                    //create blob at next available index
                    blobBRAMPorts[0].addr = blobIndex;
                    blobBRAMPorts[0].din = runToBlob(blobCurrentRun(), blobRunBufferXCurrent, blobCurrentLine());
                    blobBRAMPorts[0].wea = true;
                    blobMetadatas[blobIndex].status = BlobStatus.UNSCANED; //tell garbage collector to check this once it is done

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
                //JOIN

                //push to blob color buffer (scripting only)
                blobColorBuffer[blobCurrentLine()].runs[blobRunBufferIndexCurrent] = 
                    Object.assign({}, runBuffers[blobRunBuffersPartionCurrent].runs[blobRunBufferIndexCurrent]);
                blobColorBuffer[blobCurrentLine()].count = blobRunBufferIndexCurrent + 1;

                //FORK
                //continue to next run
                blobRunBufferXCurrent = blobRunBufferXCurrent + runBuffers[blobRunBuffersPartionCurrent].runs[blobRunBufferIndexCurrent].length;
                blobRunBufferIndexCurrent = blobRunBufferIndexCurrent + 1;
                blobRunState = BlobRunState.IDLE;
                //JOIN
            }
        }
    }
}
//(verilog wires)
function blobProcessorDoneWithLine(): boolean {
    //done with line @ on NULL line OR all runs processed
    return blobRunBuffersPartionCurrent === NULL_RUN_BUFFER_PARTION ||
           blobRunBufferIndexCurrent >= runBuffers[blobRunBuffersPartionCurrent].count;
}
function blobPartionCurrentValid(): boolean {
    return blobRunBuffersPartionCurrent !== NULL_RUN_BUFFER_PARTION;
}
function blobNextPartionCurrent(): number {
    //note: overflow(NULL+1)=0
    return overflow(blobRunBuffersPartionCurrent + 1, 2);
}
function blobNextLineAvailable(): boolean {
    //can move next line @ rle is done with it
    return rleRunBuffersPartion !== blobNextPartionCurrent() &&
    //& its a valid location
    runBuffers[blobNextPartionCurrent()].line !== NULL_LINE_NUMBER; 
}
function blobProcessorTooSlow(): boolean {
    return rlePartionValid() && rleRunBuffersPartion === blobRunBuffersPartionLast;
}
function blobProcessorReallyTooSlow(): boolean {
    return rlePartionValid() && rleRunBuffersPartion === blobRunBuffersPartionCurrent;
}
function blobLastLineRun(): Run {
    return runBuffers[blobRunBuffersPartionLast].runs[blobRunBufferIndexLast];
}
function blobLastLineRunRealBlobID(): number {
    return getRealBlobID(blobLastLineRun().blobID);
}
function blobCurrentRun(): Run {
    return runBuffers[blobRunBuffersPartionCurrent].runs[blobRunBufferIndexCurrent];
}
function blobCurrentLine(): number {
    return runBuffers[blobRunBuffersPartionCurrent].line;
}
function blobProcessorOnLastLine(): boolean {
    return runBuffers[blobRunBuffersPartionCurrent]?.line === IMAGE_HEIGHT-1;
}

//Garbage Collector Loop
function updateGarbageCollector() {
    //Process Port X (if read from)
    if (garbageCollectorUsingPorts()[garbagePort]) {
        //if blob is finished adding to
        if (blobPartionCurrentValid() && blobBRAMPorts[garbagePort].dout.boundBottomRight.y + 1 < blobCurrentLine()) {
            blobMetadatas[lastGarbageIndex[1]].status = doesBlobMatchCriteria(blobBRAMPorts[garbagePort].dout) ? BlobStatus.VALID : BlobStatus.GARBAGE;
        }
    }

    //Read Port X (if available)
    if (garbageCollectorCanUsePorts()[garbagePort]) {
        //Next Garbage Index
        setNextGarbageIndex();

        //Read Port X
        if (garbageIndex !== NULL_BLOB_ID && !garbageCollectorDone) {
            blobBRAMPorts[garbagePort].addr = garbageIndex;
            blobBRAMPorts[garbagePort].wea = false;
            garbageCollectorWasUsingPorts[garbagePort] = true;
        }
        else {
            garbageCollectorWasUsingPorts[garbagePort] = false;
        }
    }

    // console.log(`[0] (${lastGarbageIndex[0]}) => [1], gb (${garbageIndex}) => [0]`);
    lastGarbageIndex[1] = lastGarbageIndex[0];
    lastGarbageIndex[0] = garbageIndex;
    garbagePort = garbagePort == 1 ? 0 : 1;
}
function setNextGarbageIndex(): void {
    //FORK
    if (garbageIndex === NULL_BLOB_ID || nextValidGarbageIndex(garbageIndex + 1) === NULL_BLOB_ID) {
        //still on frame => keep doing garbage duty :(
        if (isWorkingOnFrame()) {
            garbageIndex = nextValidGarbageIndex(0);
        }

        //done with frame => stop garbage duty :)
        else {
            garbageCollectorDone = true;
        }
    }
    else {
        garbageIndex = nextValidGarbageIndex(garbageIndex + 1);
    }
    //JOIN
}
//(verilog wires)
function garbageCollectorCanUsePorts(): boolean[] {
    return [!isWorkingOnFrame(), !blobUsingPort1];
}
function garbageCollectorUsingPorts(): boolean[] {
    //if read from Port A & can still use it
    return [garbageCollectorWasUsingPorts[0] && garbageCollectorCanUsePorts()[0],
            garbageCollectorWasUsingPorts[1] && garbageCollectorCanUsePorts()[1]];
}
function nextValidGarbageIndex(startIndex: number): number {
    //find next unscaned blob
    for (let i = 0; i < MAX_BLOBS; i++) {
        if (i >= startIndex && i <= blobIndex && blobMetadatas[i].status == BlobStatus.UNSCANED) {
            return i;
        }
    }
    return NULL_BLOB_ID;
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
    //FORK
    blobIndex = 0;
    blobRunBuffersPartionCurrent = NULL_RUN_BUFFER_PARTION;
    blobRunBuffersPartionLast = NULL_RUN_BUFFER_PARTION;
    blobUsingPort1 = false;
    targetSelectorDone = false;
    rleRunBuffersPartion = 0;
    garbagePort = 0;
    garbageIndex = 0;
    lastGarbageIndex = [0, 0];
    garbageCollectorWasUsingPorts[0] = false;
    garbageCollectorWasUsingPorts[1] = false;
    garbageCollectorDone = false;
    kernel.valid = false;
    lastKernelValid = false;
    for (let i = 0; i < 3; i++) {
        runBuffers[i].count = 0;
        runBuffers[i].line = NULL_LINE_NUMBER;
    }
    //JOIN

    //(scripting only)
    blobColorBuffer = [...Array(IMAGE_HEIGHT)].map(_=>({
        runs: [...Array(MAX_RUNS_PER_LINE)].map(_=>({ length: 0, blobID: NULL_BLOB_ID })),
        count: 0,
        line: NULL_LINE_NUMBER
    }));
}

//Get Real Blob ID "Recursively"
function getRealBlobID(startID: number): number {
    for (let i = 0; i < MAX_BLOB_POINTER_DEPTH; i++) {
        if (blobMetadatas[startID].status == BlobStatus.POINTER) {
            startID = blobMetadatas[startID].pointer; //BLOCKING
        }
        else {
            return startID;
        }
    }
    
    return NULL_BLOB_ID;
}
function getRealBlobIDDebug(startID: number): number {
    //(scripting only) real recursive version
    //for drawing blob colors
    return blobMetadatas[startID].status == BlobStatus.POINTER ? getRealBlobIDDebug(blobMetadatas[startID].pointer) : startID;
}

//BRAM Simulation (scripting only)
let lastAddresses: number[] = [0, 0];
function updateBRAM() {
    for (const p in blobBRAMPorts) {
        const port = blobBRAMPorts[p];

        if (port.wea) {
            //write from din
            blobBRAM[port.addr] = Object.assign({}, port.din);
        }

        else {
            //read to dout
            port.dout = Object.assign({}, blobBRAM[lastAddresses[p]]);
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
                        const threshold = value > virtexConfig.threshold;
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

                        //if run is black ignore it
                        if (run.blobID !== NULL_BLACK_RUN_BLOB_ID) {
                            //if run has pointer blobID => follow it
                            const realBlobID = blobMetadatas[run.blobID].status == BlobStatus.POINTER ? getRealBlobIDDebug(run.blobID) : run.blobID;

                            //if run has valid blobID (or valid pointer blobID) => draw it
                            if (blobMetadatas[realBlobID].status == BlobStatus.VALID) {
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
            for (let i = 0; i < blobIndex; i++) {
                const blob = blobBRAM[i];
                if (blobMetadatas[i].status == BlobStatus.VALID) {
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