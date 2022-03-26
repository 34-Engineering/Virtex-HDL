/* BlobProcessor V3
The Blob Processor is a multi-functional module that takes in an pipelined
run length encoded images (through a run FIFO) and outputs a single target
per image frame: Runs => Blobs => Target

Nomenclature:
 Blob: an isolated white region in the image
 Target: the "best" blob or "best" group of blobs (depending on Virtex Config)

Blob making is a process where blobs are "grown" to cover an entire isolated
white region of the image. Isolated regions are first spotted by runs that
are not touching any another run in the line above them, then following
runs that are touching it are joined onto its blob and the blob
is expanded to cover the entire region.
The Blob making process is also required to merge blobs in certain region
shapes like U, V, W, etc. This is because the regions are initially
seen as two separate blobs but later found to be part of the same region.
Simple metadata about blobs is stored in LUTRAM for quick access but full
blob data is saved in BRAM for FPGA area limitations.

Once the frame is done being read out and the blob making has concluded,
the Target Selector takes over. The Target Selector will search through
all blobs and either mark them as the "best" Target, do nothing, or
mark them as garbage (if they don't meet blob criteria from Virtex Config).
*/

import { IMAGE_HEIGHT } from "./util/Constants";
import { Faults } from "./util/Fault";
import { Kernel, KERNEL_MAX_X } from "./util/PythonUtil";
import { MAX_BLOBS, MAX_BLOB_POINTER_DEPTH, MAX_RUNS_PER_LINE, NULL_LINE_NUMBER, NULL_BLOB_INDEX, NULL_RUN_BUFFER_PARTION, NULL_TIMESTAMP } from "./BlobConstants";
import { BlobData, BlobMetadata, BlobStatus, mergeBlobs, RunBuffer, runsOverlap, runToBlob, calcBlobAngle, BlobAngle, Target, TargetMode, BlobAnglesEnabled, Run } from "./BlobUtil";
import { inRangeInclusive, overflow, Vector2d10 } from "./util/Math";
import { virtexConfig } from "./util/VirtexConfig";
import { reg1, reg10, BlobIndex, reg24, processRunFIFO, processBlobBRAM, forceAddRunFIFO, RunBufferIndex, makeZeroBlobData, blobBRAMMem } from "./util/VerilogUtil";
import { pythonDone } from "./App";
import { deepCopy } from "./util/DrawUtil";

//(scripting only)
let blobColorBuffer: RunBuffer[] = [];
let faults: Faults;

//Run FIFO
let runFIFOEmpty: reg1 = 1, runFIFORead: reg1;
let runFIFOOut: Run = {length:0, line:0, black:0};

//Blob BRAM
interface BlobBRAMPort {
    addr: BlobIndex,
    din: BlobData,
    dout: BlobData,
    we: reg1,
};
let blobBRAMPorts: BlobBRAMPort[] = [{addr:0, din:makeZeroBlobData(), dout:makeZeroBlobData(), we:0}, {addr:0, din:makeZeroBlobData(), dout:makeZeroBlobData(), we:0}];

//Module State
let lastLine: reg10 = 0;
let justResetFrame: reg1 = 0;

//Blob Maker
enum BlobMakerState { NONE, SEARCH, MERGE, JOIN, JOIN_END, MAKE };
let blobMakerState: BlobMakerState = BlobMakerState.NONE;
let blobMakerDone = () => (pythonDone && runFIFOEmpty && blobMakerState == BlobMakerState.NONE);
let blobSkipCycle: reg1 = 0;
let blobJustResetLine: reg1 = 0;

let blobIndex: BlobIndex = 0;
let blobMetadatas: BlobMetadata[] = [...Array(MAX_BLOBS)].map(_=>({ status: BlobStatus.UNSCANED, pointer: NULL_BLOB_INDEX }));

let currentLineBuffer: RunBuffer = {
    runs: [...Array(MAX_RUNS_PER_LINE)].map(_=>({ start:0, end:0, blobIndex:NULL_BLOB_INDEX })),
    count:0,
    line:0
};
let currentLineBufferX: reg10 = 0;
let lastLineBuffer: RunBuffer = {
    runs: [...Array(MAX_RUNS_PER_LINE)].map(_=>({ start:0, end:0, blobIndex:NULL_BLOB_INDEX })),
    count:0,
    line:0
};
let currentRunAsBlob = () => runToBlob(currentLineBufferX, runFIFOOut.length, runFIFOOut.line);
let currentRunHasJoinedBlob = () => currentLineBuffer.runs[currentLineBuffer.count]?.blobIndex != NULL_BLOB_INDEX;

//Target Selector
let target: Target; //"best" target for the last frame
let targetCurrent: Target; //"best" target for the current frame
let targetChain: Target; //the current chain for group mode (may be invalid)
let targetChainValid: Target; //the last valid chain target in group mode
let targetSelectorIndexA: BlobIndex;
let targetSelectorIndexB: BlobIndex;
let nextTargetSelectorIndex: BlobIndex;
let targetSelectorDone: reg1 = 0;
//TODO

//200MHz Clocked Loop
function always_ff(): void {
    //defaults & counters
    _("blobBRAMPorts[0].we <= 0");
    _("blobBRAMPorts[1].we <= 0");
    _("justResetFrame <= 0");
    _("lastLine <= ", runFIFOOut.line);
    _("runFIFORead <= 0");
    _("blobSkipCycle <= 0");
    _("blobJustResetLine <= 0");

    //Reset @ New Frame
    if (runFIFOOut.line == 0 && lastLine != 0) {
        frameReset();
    }

    //Update Blob Maker
    else if (!blobMakerDone()) {
        updateBlobMaker();
    }
    
    //Update Target Selector
    else if (!targetSelectorDone) {
        updateTargetSelector();
    }

    //(scripting only)
    processNonblocking();
    always_comb();
    [ runFIFOEmpty, runFIFOOut ] = processRunFIFO({ read: runFIFORead });
    [ blobBRAMPorts[0].dout, blobBRAMPorts[1].dout ] = processBlobBRAM({
        addra: blobBRAMPorts[0].addr, dina: blobBRAMPorts[0].din, wea: blobBRAMPorts[0].we, 
        addrb: blobBRAMPorts[1].addr, dinb: blobBRAMPorts[1].din, web: blobBRAMPorts[1].we
    });
}

//Blob Maker (runs => blobs)
function updateBlobMaker(): void {
    //New Line*
    if (runFIFOOut.line != lastLine) {
        //flag reset
        _("blobJustResetLine <= 1");

        //transfer current line buffer => last line buffer
        if (runFIFOOut.line != 0) {
            _("lastLineBuffer <= ", currentLineBuffer);
            //(scripting only)
            blobColorBuffer[currentLineBuffer.line] = deepCopy(currentLineBuffer);
        }

        //reset current line buffer
        _("currentLineBufferX <= 0");
        _("currentLineBuffer.count <= 0");
        _(`currentLineBuffer.runs[0] <= `, {start:0, end:0, blobIndex:NULL_BLOB_INDEX});
        _("currentLineBuffer.line <= ", (runFIFOOut.line));
    }

    else if (!blobSkipCycle) {
        //New Run*
        if (blobMakerState == BlobMakerState.NONE) {
            //Process FIFO Read
            if (blobJustResetLine || justResetFrame || runFIFORead) {
                //Run is Black => Continue
                if (runFIFOOut.black) {
                    _(`currentLineBuffer.runs[${currentLineBuffer.count}] <= `, {
                        start: currentLineBufferX,
                        end: currentLineBufferX + runFIFOOut.length - 1,
                        blobIndex: NULL_BLOB_INDEX
                    });
                    _("currentLineBufferX <= ", (currentLineBufferX + runFIFOOut.length));
                    _("currentLineBuffer.count <= ", (currentLineBuffer.count + 1));
                    _(`currentLineBuffer.runs[${currentLineBuffer.count+1}] <= `, {start:0, end:0, blobIndex:NULL_BLOB_INDEX});

                    if (!runFIFOEmpty) _("runFIFORead <= 1");
                }
                
                //Run is White => Search & Join OR Make new Blob
                else if (runFIFOOut.line > 0) {
                    _("blobMakerState <= BlobMakerState.SEARCH");
                    updateOnBlobMakerState(BlobMakerState.SEARCH);
                }

                //Run is White (and no line above) => Make new Blob
                else {
                    _("blobMakerState <= BlobMakerState.MAKE");
                    updateOnBlobMakerState(BlobMakerState.MAKE);
                }
            }

            //Read from FIFO
            else if (!runFIFOEmpty) {
                _("runFIFORead <= 1");
            }
        }

        //Working on Run
        else updateOnBlobMakerState(blobMakerState);
    }
}
function updateOnBlobMakerState(ustate: BlobMakerState): void {
    //Search through runs from last line & Check if this run is touching them
    if (ustate == BlobMakerState.SEARCH) {
        //defaults
        if (currentRunHasJoinedBlob()) {
            _("blobMakerState <= BlobMakerState.JOIN_END");
        }
        else _("blobMakerState <= BlobMakerState.MAKE");

        //Search
        for (let i = 0; i < MAX_RUNS_PER_LINE; i++) {
            if (i < lastLineBuffer.count && lastLineBuffer.runs[i].blobIndex != NULL_BLOB_INDEX && //if valid index in lastLineBuffer
                runsOverlap(currentLineBufferX, currentLineBufferX + runFIFOOut.length - 1, //if this run is touching it
                    lastLineBuffer.runs[i].start, lastLineBuffer.runs[i].end))
            {
                const iBlobIndex: BlobIndex = getBlobPointerIndex(lastLineBuffer.runs[i].blobIndex);

                //First touching run => Join it's blob
                if (!currentRunHasJoinedBlob()) {
                    //set new state
                    _("blobMakerState <= BlobMakerState.JOIN");

                    //read Blob from BRAM
                    _("blobBRAMPorts[0].addr <= ", iBlobIndex);
                    _("blobSkipCycle <= 1");
                }

                //2nd+ touching run => Merge this blob with master blob
                else if (iBlobIndex != currentLineBuffer.runs[currentLineBuffer.count].blobIndex) {
                    // set new state
                    _("blobMakerState <= BlobMakerState.MERGE");

                    // read Blobs from BRAM
                    _("blobBRAMPorts[0].addr <= ", currentLineBuffer.runs[currentLineBuffer.count].blobIndex);
                    _("blobBRAMPorts[1].addr <= ", iBlobIndex);
                    _("blobSkipCycle <= 1");
                }
            }
        }
    }
    
    //Join Blob
    else if (ustate == BlobMakerState.JOIN) {
        //write back to BRAM
        _("blobBRAMPorts[0].din <= ", mergeBlobs(currentRunAsBlob(), blobBRAMPorts[0].dout));
        _("blobBRAMPorts[0].we <= 1");

        //save to current line run buffer
        _(`currentLineBuffer.runs[${currentLineBuffer.count}] <= `, {
            start: currentLineBufferX,
            end: currentLineBufferX + runFIFOOut.length - 1,
            blobIndex: blobBRAMPorts[0].addr
        });

        //go back to searching
        _("blobMakerState <= BlobMakerState.SEARCH");
    }

    //Merge two intersecting Blobs (U/V/W Case)
    else if (ustate == BlobMakerState.MERGE) {
        //mark slave as pointer
        _(`blobMetadatas[${blobBRAMPorts[1].addr}].status <= `, BlobStatus.POINTER);
        _(`blobMetadatas[${blobBRAMPorts[1].addr}].pointer <= `, blobBRAMPorts[0].addr);

        //write back master to BRAM
        _("blobBRAMPorts[0].din <= ", mergeBlobs(blobBRAMPorts[1].dout, blobBRAMPorts[0].dout));
        _("blobBRAMPorts[0].we <= 1");

        //go back to searching
        _("blobMakerState <= BlobMakerState.SEARCH");
    }

    //Join End (had joined a blob & is done now)
    else if (ustate == BlobMakerState.JOIN_END) {
        //prepare for new run
        _("currentLineBufferX <= ", (currentLineBufferX + runFIFOOut.length));
        _("currentLineBuffer.count <= ", (currentLineBuffer.count + 1));
        _(`currentLineBuffer.runs[${currentLineBuffer.count+1}] <= `, {start:0, end:0, blobIndex:NULL_BLOB_INDEX});
        _("blobMakerState <= BlobMakerState.NONE");
        if (!runFIFOEmpty) _("runFIFORead <= 1");
    }

    //Make new Blob
    else if (ustate == BlobMakerState.MAKE) {
        //write to BRAM
        _("blobBRAMPorts[0].din <= ", currentRunAsBlob());
        _("blobBRAMPorts[0].addr <= ", blobIndex);
        _("blobBRAMPorts[0].we <= 1");

        //write metadata
        _(`blobMetadatas[${blobIndex}].status <= `, BlobStatus.UNSCANED);

        //save to current line run buffer
        _(`currentLineBuffer.runs[${currentLineBuffer.count}] <= `, {
            start: currentLineBufferX,
            end: currentLineBufferX + runFIFOOut.length - 1,
            blobIndex: blobIndex
        });

        //increment blob counter
        _("blobIndex <= ", (blobIndex + 1));

        //prepare for new run
        _("currentLineBufferX <= ", (currentLineBufferX + runFIFOOut.length));
        _("currentLineBuffer.count <= ", (currentLineBuffer.count + 1));
        _(`currentLineBuffer.runs[${currentLineBuffer.count+1}] <= `, {start:0, end:0, blobIndex:NULL_BLOB_INDEX});
        _("blobMakerState <= BlobMakerState.NONE");
        if (!runFIFOEmpty) _("runFIFORead <= 1");
    }
}
function getBlobPointerIndex(startIndex: BlobIndex): BlobIndex {
    //follow a blob's pointer
    let index: BlobIndex = startIndex;
    for (let i = 0; i < MAX_BLOB_POINTER_DEPTH; i++) {
        if (blobMetadatas[index].status == BlobStatus.POINTER) {
            index = blobMetadatas[index].pointer; //BLOCKING
        }
        else {
            return index;
        }
    }
    _("faults.BLOB_POINTER_DEPTH_FAULT <= 1");
    return NULL_BLOB_INDEX;
}

//Target Selector (blobs => target)
function updateTargetSelector(): void {
    //READ BLOB ON A/B

    //if doesBlobMatchCriteria() => updateTargetSelector() ELSE flag GARBAGE
}
function updateTargetSelectorDualGroup(): void {
    //TODO
}
function updateTargetSelectorSingle(): void {
    //Convert Blob A Bounding Box from TopLeft/BottomRight => Center/Width/Height
    const center: Vector = {
        x: (blob.boundBottomRight.x + blob.boundTopLeft.x) >> 1,
        y: (blob.boundBottomRight.y + blob.boundTopLeft.y) >> 1
    };
    const width:  number = blob.boundBottomRight.x - blob.boundTopLeft.x + 1;
    const height: number = blob.boundBottomRight.y - blob.boundTopLeft.y + 1;

    //aspect ratio valid
    const aspectRatioValid: boolean = inRangeInclusive(width, //TODO fixed point mult
        virtexConfig.targetAspectRatioMin*height, virtexConfig.targetAspectRatioMax*height);

    //bound area valid
    const boundAreaValid: boolean = inRangeInclusive((width * height) >> 1,
        virtexConfig.targetBoundAreaMin, virtexConfig.targetBoundAreaMax);

    //if this target is valid AND this target is better OR we dont have a target yet
    if (aspectRatioValid && boundAreaValid &&
        (targetCurrent.timestamp === NULL_TIMESTAMP || distSqToTargetCenter(center) < distSqToTargetCenter(targetCurrent.center))) {
        targetCurrent = {
            center, width, height,
            timestamp: 10,
            blobCount: 2,
            angle: calcBlobAngle(blob)
        };
    }

    //TODO
    targetSelectorDone = 1;
}
function doesBlobMatchCriteria(blob: BlobData): boolean {
    const boundWidth: number = blob.boundBottomRight.x - blob.boundTopLeft.x;
    const boundHeight: number = blob.boundBottomRight.y - blob.boundTopLeft.y;

    //TODO fixed point mult
    const inAspectRatioRange: boolean = inRangeInclusive(boundWidth,
        virtexConfig.blobAspectRatioMin*boundHeight, virtexConfig.blobAspectRatioMax*boundHeight);

    const boundAreaUnshifted: number = boundWidth * boundHeight;
    const inBoundAreaRange: boolean = inRangeInclusive(boundAreaUnshifted >> 1,
        virtexConfig.blobBoundAreaMin, virtexConfig.blobBoundAreaMax);

    //TODO fixed point mult
    const inFullnessRange: boolean = inRangeInclusive(blob.area,
        virtexConfig.blobFullnessMin*boundAreaUnshifted, virtexConfig.blobFullnessMax*boundAreaUnshifted);

    const isValidAngle: boolean = virtexConfig.blobAnglesEnabled[(Object.keys(virtexConfig.blobAnglesEnabled) as Array<keyof BlobAnglesEnabled>)[calcBlobAngle(blob)]];

    return inAspectRatioRange && inBoundAreaRange && inFullnessRange && isValidAngle;
}

//Combinational Logic
function always_comb(): void {
    //Find New Indexes
    for (let i = 0; i < MAX_BLOBS; i++) {
        //choose target selector indexes
        if (i < blobIndex && (blobMetadatas[i].status == BlobStatus.UNSCANED || blobMetadatas[i].status == BlobStatus.VALID)) {

        }
    }

    if (blobIndex >= NULL_BLOB_INDEX) {
        faults.OUT_OF_BLOB_MEM_FAULT = 1;
    }
    if (currentLineBuffer.count >= MAX_RUNS_PER_LINE) {
        faults.OUT_OF_RLE_MEM_FAULT = 1;
    }
}

//Global Reset for New Frame
function frameReset(): void {
    //TODO blob processor too slow fault

    //Flag Reset
    _("justResetFrame <= 1");

    //Blob Maker Reset (everything else is reset in on New Line* updateBlobMaker())
    _("blobIndex <= 0");
    _("blobSkipCycle <= 0");
    _("blobMakerState <= BlobMakerState.NONE");

    //Target Selector Reset
    _("targetSelectorDone <= 0");
    //TODO
}

//(scripting only)
let addToRunFIFO = (run: Run) => forceAddRunFIFO(run);
let nonblockingQueue: {name: string, val: string}[] = [];
function _(ass: string, val?: any) {
    const arr = ass.split(" <= ");
    nonblockingQueue.push({
        name: arr[0],
        val: (val !== undefined) ? JSON.stringify(val) : arr[1]
    });
}
function processNonblocking() {
    for (const assignment of nonblockingQueue) {
        //TODO overflow
        try { eval(`${assignment.name} = ${assignment.val};`); }
        catch (e) { console.error(`Error evaluating "${assignment.name}" to "${assignment.val}"`); }
    }
    nonblockingQueue = [];
}
let isDone = () => Boolean(targetSelectorDone);
let getBlobIndex = () => blobIndex;
let getBlobPointerIndexDebug = (startID: number): number => blobMetadatas[startID].status == BlobStatus.POINTER ? 
    getBlobPointerIndexDebug(blobMetadatas[startID].pointer) : startID;
let clearFaults = () => faults = {
    PYTHON_300_PLL_FAULT: 0,
    IR_LED_FAULT: 0,
    OUT_OF_BLOB_MEM_FAULT: 0,
    OUT_OF_RLE_MEM_FAULT: 0,
    BLOB_POINTER_DEPTH_FAULT: 0,
    BLOB_PROCESSOR_TOO_SLOW_FAULT: 0
};
clearFaults();
export { addToRunFIFO, always_ff, isDone, getBlobIndex, blobMetadatas, target, blobColorBuffer, getBlobPointerIndexDebug, faults, clearFaults };