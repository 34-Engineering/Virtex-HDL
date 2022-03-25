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
import { Fault } from "./util/Fault";
import { Kernel, KERNEL_MAX_X } from "./util/PythonUtil";
import { MAX_BLOBS, MAX_BLOB_POINTER_DEPTH, MAX_RUNS_PER_LINE, NULL_LINE_NUMBER, NULL_BLOB_INDEX, NULL_RUN_BUFFER_PARTION, NULL_TIMESTAMP } from "./BlobConstants";
import { BlobData, BlobMetadata, BlobStatus, mergeBlobs, RunBuffer, runsOverlap, runToBlob, calcBlobAngle, BlobAngle, Target, TargetMode, BlobAnglesEnabled, Run } from "./BlobUtil";
import { inRangeInclusive, overflow, Vector2d10 } from "./util/Math";
import { virtexConfig } from "./util/VirtexConfig";
import { reg1, reg10, BlobIndex, reg24, processRunFIFO, processBlobBRAM, forceAddRunFIFO, RunBufferIndex, makeZeroBlobData, blobBRAMMem } from "./util/VerilogUtil";
import { draw, pythonDone } from "./App";

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
let blobMakerDone = () => (!pythonDone && runFIFOEmpty && blobMakerState == BlobMakerState.NONE);
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

    //Update Target Selector
    // else if (blobMakerDone()) {
    //     updateTargetSelectorSingle();
    // }

    //Update Blob Maker
    else {
        updateBlobMaker();
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
        _("lastLineBuffer <= ", currentLineBuffer);

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
                // console.log("NEW RUN", runFIFOOut, currentLineBufferX, currentLineBufferX + runFIFOOut.length - 1);

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
                //First touching run => Join it's blob
                if (!currentRunHasJoinedBlob()) {
                    //set new state
                    _("blobMakerState <= BlobMakerState.JOIN");

                    //read Blob from BRAM
                    _("blobBRAMPorts[0].addr <= ", i);
                    _("blobSkipCycle <= 1");
                }

                //2nd+ touching run => Merge this blob with master blob
                else if (getBlobPointerIndex(lastLineBuffer.runs[i].blobIndex) != currentLineBuffer.runs[currentLineBuffer.count].blobIndex) {
                    //set new state
                    //FIXME
                    _("blobMakerState <= BlobMakerState.MAKE");
                    // _("blobMakerState <= BlobMakerState.MERGE");

                    //read Blobs from BRAM
                    // _("blobBRAMPorts[0].addr <= ", currentLineBuffer.runs[currentLineBuffer.count].blobIndex);
                    // _("blobBRAMPorts[1].addr <= ", i);
                    // _("blobSkipCycle <= 1");
                }
            }
        }
    }
    
    //Join Blob
    else if (ustate == BlobMakerState.JOIN) {
        //write back to BRAM
        //FIXME
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
        // console.log("MAKE", blobIndex, currentRunAsBlob(), currentLineBufferX, runFIFOOut);
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

//Target Selector (blobs => target)
function updateTargetSelectorDualGroup(): void {
    //TODO
}
function updateTargetSelectorSingle(): void {
    //TODO
    targetSelectorDone = 1;
}

//Combinational Logic
function always_comb(): void {
    //Find New Indexes
    for (let i = 0; i < MAX_BLOBS; i++) {
        //choose target selector indexes
        if (i < blobIndex && (blobMetadatas[i].status == BlobStatus.UNSCANED || blobMetadatas[i].status == BlobStatus.VALID)) {

        }
    }

    //TODO Faults
    //OUT_OF_BLOB_MEM
}

//Get Blob Pointer Index (follow a blob's pointer)
function getBlobPointerIndex(startIndex: BlobIndex): BlobIndex {
    let index: BlobIndex = startIndex;
    for (let i = 0; i < MAX_BLOB_POINTER_DEPTH; i++) {
        if (blobMetadatas[index].status == BlobStatus.POINTER) {
            index = blobMetadatas[index].pointer; //BLOCKING
        }
        else {
            return index;
        }
    }
    //TODO fault
    return NULL_BLOB_INDEX;
}


//Global Reset for New Frame
function frameReset(): void {
    //Flag Reset
    _("justResetFrame <= 0");

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
export { addToRunFIFO, always_ff, isDone, getBlobIndex, blobMetadatas, target };