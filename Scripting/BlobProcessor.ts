// BlobProcessor.ts

import { IMAGE_HEIGHT } from "./util/Constants";
import { Fault } from "./util/Fault";
import { BlobBRAMPort, BLOB_BRAM_PORT_DEFAULT, Kernel, EMPTY_BLOB, KERNEL_MAX_X  } from "./util/OtherUtil";
import { MAX_BLOBS, MAX_BLOB_POINTER_DEPTH, MAX_RUNS_PER_LINE, NULL_LINE_NUMBER, NULL_BLOB_ID, NULL_RUN_BUFFER_PARTION, NULL_BLACK_RUN_BLOB_ID } from "./BlobConstants";
import { BlobData, BlobMetadata, BlobStatus, mergeBlobs, Run, RunBuffer, runsOverlap, runToBlob, doesBlobMatchCriteria } from "./BlobUtil";
import { overflow } from "./util/Math";

//(scripting only)
let blobColorBuffer: RunBuffer[];
let faults: Fault[] = [...Array(4)].map(_=>Fault.NO_FAULT);
let blobBRAM: BlobData[] = [...Array(MAX_BLOBS)].map(_=>(Object.assign({}, EMPTY_BLOB)));
let blobBRAMPorts: BlobBRAMPort[] = [...Array(2)].map(_=>(Object.assign({}, BLOB_BRAM_PORT_DEFAULT)));

//Blob Processor (registers + wires)
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
let lastIsWorkingOnFrame: boolean = false;
let blobProcessorDoneWithLine = () => blobRunBuffersPartionCurrent === NULL_RUN_BUFFER_PARTION ||
    blobRunBufferIndexCurrent >= runBuffers[blobRunBuffersPartionCurrent].count; //done with line @ on NULL line OR all runs processed
let blobPartionCurrentValid = () => blobRunBuffersPartionCurrent !== NULL_RUN_BUFFER_PARTION;
let blobNextPartionCurrent = () => overflow(blobRunBuffersPartionCurrent + 1, 2); //note: overflow(NULL+1)=0
let blobNextLineAvailable = () => rleRunBuffersPartion !== blobNextPartionCurrent() &&
    runBuffers[blobNextPartionCurrent()].line !== NULL_LINE_NUMBER; //can move next line @ rle is done with it & its a valid location
let blobProcessorTooSlow = () => rlePartionValid() && rleRunBuffersPartion === blobRunBuffersPartionLast;
let blobProcessorReallyTooSlow = () => rlePartionValid() && rleRunBuffersPartion === blobRunBuffersPartionCurrent;
let blobLastLineRun = () => runBuffers[blobRunBuffersPartionLast].runs[blobRunBufferIndexLast];
let blobLastLineRunRealBlobID = () => getRealBlobID(blobLastLineRun().blobID);
let blobCurrentRun = () => runBuffers[blobRunBuffersPartionCurrent].runs[blobRunBufferIndexCurrent];
let blobCurrentLine = () => runBuffers[blobRunBuffersPartionCurrent].line;
let blobProcessorOnLastLine = () => runBuffers[blobRunBuffersPartionCurrent]?.line === IMAGE_HEIGHT-1;
let isWorkingOnFrame = () => !isLastKernel() || !blobProcessorDoneWithLine() || !blobProcessorOnLastLine();

//Target Selector (registers + wires)
let targetSelectorDone: boolean; //1-bit

//Garbage Collector (registers + wires)
let garbagePort: number; //1-bit
let garbageIndex: number; //[MAX_BLOB_ID_SIZE-1:0]
let lastGarbageIndex: number[] = [0, 0]; //2 x [MAX_BLOB_ID_SIZE-1:0]
let garbageCollectorWasUsingPorts: boolean[] = [false, false]; //BRAM ports
let garbageCollectorDone: boolean;
let garbageCollectorCanUsePorts = () => [!isWorkingOnFrame(), !blobUsingPort1];
let garbageCollectorUsingPorts = () => [garbageCollectorWasUsingPorts[0] && garbageCollectorCanUsePorts()[0],
    garbageCollectorWasUsingPorts[1] && garbageCollectorCanUsePorts()[1]]; //if read from Port A & can still use it
let nextValidGarbageIndex = () => getNextValidGarbageIndex(garbageIndex + 1);
let firstValidGarbageIndex = () => getNextValidGarbageIndex(0);

//Run Length Encoding (registers + wires)
let runBuffers: RunBuffer[] = [...Array(3)].map(_=>({
    runs: [...Array(MAX_RUNS_PER_LINE)].map(_=>({ length: 0, blobID: NULL_BLOB_ID })),
    count: 0,
    line: NULL_LINE_NUMBER
}));
let rleRunBuffersPartion: number;
let kernel: Kernel = { value: [...Array(8)].map(_=>false), pos: {x:0, y:0}, valid: false };
let lastKernelValid: boolean;
let isLastKernel = () => kernel?.pos.y === IMAGE_HEIGHT-1 && kernel?.pos.x === KERNEL_MAX_X;
let rlePartionValid = () => rleRunBuffersPartion !== NULL_RUN_BUFFER_PARTION;

//"180MHz" Always Loop
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
    if (garbageIndex === NULL_BLOB_ID || nextValidGarbageIndex() === NULL_BLOB_ID) {
        //still on frame => keep doing garbage duty :(
        if (isWorkingOnFrame()) {
            garbageIndex = firstValidGarbageIndex();
        }

        //done with frame => stop garbage duty :)
        else {
            garbageCollectorDone = true;
        }
    }
    else {
        garbageIndex = nextValidGarbageIndex();
    }
    //JOIN
}
function getNextValidGarbageIndex(startIndex: number): number {
    //find next unscaned blob >= startIndex
    //(and < blobIndex because anything above that is invalid)
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

//Resetting for New Frame
function reset() {
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

//Get Real Blob ID
function getRealBlobID(startID: number): number {
    //without recursion for FPGA :(
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

//Module (scripting only)
let sendKernel = (newKernel: Kernel) => kernel = Object.assign({}, newKernel);
let isDone = () => targetSelectorDone;
let getRealBlobIDDebug = (startID: number): number => blobMetadatas[startID].status == BlobStatus.POINTER ? 
    getRealBlobIDDebug(blobMetadatas[startID].pointer) : startID;
let lastAddresses: number[] = [0, 0];
function updateBRAM() {
    for (const p in blobBRAMPorts) {
        if (blobBRAMPorts[p].wea) {
            //write to din
            blobBRAM[blobBRAMPorts[p].addr] = Object.assign({}, blobBRAMPorts[p].din);
        }
        else {
            //read to dout
            blobBRAMPorts[p].dout = Object.assign({}, blobBRAM[lastAddresses[p]]);
        }
        lastAddresses[p] = blobBRAMPorts[p].addr;
    }
}
export { sendKernel, isDone, getRealBlobIDDebug, updateBRAM };
export { blobColorBuffer, faults, blobBRAM, blobMetadatas, blobIndex };
export { alwaysLoop, reset };