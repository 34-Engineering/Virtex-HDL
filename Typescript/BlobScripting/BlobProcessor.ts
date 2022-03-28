/* BlobProcessor V3
The Blob Processor is a multi-functional module that takes in an pipelined
run length encoded images (through a run FIFO) and outputs a single target
per image frame: Runs => Blobs => Target

Nomenclature:
 Blob: an isolated white region in the image
 Target: a blob or group of blobs

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

The Target Selector has 3 modes: SINGLE, DUAL, & GROUP. SINGLE will make a
target from a single blob, DUAL will make a target from two blobs (by looping
over every combination of two blobs), and GROUP will make a target by
"chaining" together every valid blob within a gap (Virtex Config) to every
valid blob.

Target Selection Process Breakdown:
SINGLE:
 - loop through every valid blob (A)
 - make a target from A directly
 - choose the best target based off center distance
DUAL:
 - loop through every valid blob (A)
 - for each A, loop through every valid blob with indexes > A (B)
 - make a target from every A & B
 - choose the best target based off center distance
GROUP:
 - loop through every valid blob (A)
 - for each A, loop through every valid blob, except index == A (B)
 - chain every B blob (within gap) to A
 - save the biggest valid chain for each A as the target
 - choose the best target based off center distance

Note: The Artix-7/Vivado BRAM IP has a 2 clock cycle read delay
(cycle 1 (request): old data, cycle 2: old data, cycle 3: new data)

//TODO remove Math (abs -> diff)
//TODO blob 1 line short?
*/

import { IMAGE_HEIGHT } from "./util/Constants";
import { Faults } from "./util/Fault";
import { Kernel, KERNEL_MAX_X } from "./util/PythonUtil";
import { MAX_BLOBS, MAX_RUNS_PER_LINE, NULL_LINE_NUMBER, NULL_BLOB_INDEX, NULL_RUN_BUFFER_PARTION, NULL_TIMESTAMP } from "./BlobConstants";
import { BlobData, mergeBlobs, RunBuffer, runsOverlap, runToBlob, calcBlobAngle, BlobAngle, Target, TargetMode, BlobAnglesEnabled, Run, isTargetNull } from "./BlobUtil";
import { inRangeInclusive, overflow, Vector2d10 } from "./util/Math";
import { virtexConfig } from "./util/VirtexConfig";
import { reg1, reg10, BlobIndex, reg24, processRunFIFO, processBlobBRAM, addToRunFIFO, RunBufferIndex, makeZeroBlobData, blobBRAMMem, boolToReg1, makeZeroTarget, reg2, invertReg1 } from "./util/VerilogUtil";
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
let lastLine: reg10 = 479;
let justResetFrame: reg1 = 0;

//Blob Maker
enum BlobMakerState { NONE, SEARCH, MERGE, JOIN, JOIN_END, MAKE };
let blobMakerState: BlobMakerState = BlobMakerState.NONE;
let blobMakerDone = () => (pythonDone && runFIFOEmpty && blobMakerState == BlobMakerState.NONE);
let blobSkipCycle: reg1 = 0;
let blobJustResetLine: reg1 = 0;
let blobIndex: BlobIndex = 0;
let blobGarbageList: reg1[] = [...Array(MAX_RUNS_PER_LINE)].map(_=>0);
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
let currentRunAsBlob = (): BlobData => runToBlob(currentLineBufferX, runFIFOOut.length, runFIFOOut.line);
let currentRunHasJoinedBlob = (): reg1 => boolToReg1(currentLineBuffer.runs[currentLineBuffer.count]?.blobIndex != NULL_BLOB_INDEX);

//Target Selector
let target: Target = makeZeroTarget(); //"best" target for the last frame
let targetCurrent: Target = makeZeroTarget(); //"best" target for the current frame
let targetChain: Target = makeZeroTarget(); //the current chain for group mode (may be invalid)
let targetChainValid: Target = makeZeroTarget(); //the last valid chain target in group mode
let targetIndexA: BlobIndex = NULL_BLOB_INDEX;
let targetIndexBs: BlobIndex[] = [NULL_BLOB_INDEX, NULL_BLOB_INDEX];
let targetWantsNewA: reg1 = 1;
let firstTargetIndex = (): BlobIndex => getNextValidTargetIndex(0);
let nextTargetIndexA = (): BlobIndex => (targetIndexA == NULL_BLOB_INDEX) ? firstTargetIndex() : getNextValidTargetIndex(targetIndexA+1); //if @ start frame init with first target index, else use next target index
let initTargetIndexB = (): BlobIndex => (virtexConfig.targetMode === TargetMode.GROUP && firstTargetIndex() !== targetIndexA) ? firstTargetIndex() : nextTargetIndexA();
let nextTargetIndexBsUnaccounted = [ //unaccounted for possible overlap with targetIndexA
    (): BlobIndex => getNextValidTargetIndex(targetIndexBs[1]+1), //opposite so they will skip ahead of eachother (AKA: (0,1), (2,3) ...)
    (): BlobIndex => getNextValidTargetIndex(targetIndexBs[0]+1)
];
let nextTargetIndexBs = [
    (): BlobIndex => (nextTargetIndexBsUnaccounted[0]() == targetIndexA) ? getNextValidTargetIndex(targetIndexBs[1]+2) : nextTargetIndexBsUnaccounted[0](),
    (): BlobIndex => (targetInitStep == 1) ? initTargetIndexB() :
                     (nextTargetIndexBsUnaccounted[1]() == targetIndexA) ? getNextValidTargetIndex(targetIndexBs[0]+2) : nextTargetIndexBsUnaccounted[1]()
]; 
let targetBlobA: BlobData;
let targetBlobAAngle: BlobAngle;
let targetInitStep: reg2 = 0; //stops counting @ 3
let targetPartion: reg1 = 0;
let targetSingleAlmostDone: reg1 = 0; //will be done next loop (single mode only)
let targetSelectorDone: reg1 = 0;

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
            blobColorBuffer[lastLineBuffer.line] = deepCopy(lastLineBuffer);
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
                const iBlobIndex: BlobIndex = lastLineBuffer.runs[i].blobIndex;

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
        //flag slave as garbage
        _(`blobGarbageList[${blobBRAMPorts[1].addr}] <= 1`);

        //update all pointers to slave
        for (let i = 0; i < MAX_RUNS_PER_LINE; i++) {
            if (lastLineBuffer.runs[i].blobIndex == blobBRAMPorts[1].addr) {
                _(`lastLineBuffer.runs[${i}].blobIndex <= `, blobBRAMPorts[0].addr);
            }
        }

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

        //flag not garbage
        _(`blobGarbageList[${blobIndex}] <= 0`);

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
function updateTargetSelector(): void {
    //TODO double processing/speed? (but doubles area)

    //Increment Init Step
    if (targetInitStep != 3) {
        _("targetInitStep <= ", targetInitStep+1);
    }

    //Swap Partion
    _("targetPartion <= ", boolToReg1(!targetPartion));

    //Update Respective Modes
    if (virtexConfig.targetMode == TargetMode.SINGLE) {
        updateTargetSelectorSingle();
    }
    else {
        updateTargetSelectorDualGroup();
    }
}
function updateTargetSelectorDualGroup(): void {
    // console.log(targetInitStep, targetPartion?'+':'-', targetIndexA, targetIndexBs, [nextTargetIndexBs[0](), nextTargetIndexBs[1]()], [nextTargetIndexBsUnaccounted[0](), nextTargetIndexBsUnaccounted[1]()], targetWantsNewA);

    /*  DUAL/GROUP Breakdown (A = target1/chainStart, B = target2/chainJoiner, 0|1 = BRAM ports)
        Note: @ PROCESS 0|1 & !doesBlobMatchCriteria() -> Skip & Flag GARBAGE (for future loops)
        targetInitStep, targetPartion, commands
        ------------------------------------------------------
        0 - READ New A on 1
        1 +                                 READ New B1 on 1
        2 - SAVE A from 1                   READ New B0 on 0
        3 +                 PROCESS B1 on 1 READ New B1 on 1
        3 -                 PROCESS B0 on 0 READ New B0 on 0
        3 +                 PROCESS B1 on 1 READ New B1 on 1
        3 -                 PROCESS B0 on 0 READ New B0 on 0
          ... till B0|B1 == NULL_BLOB_INDEX
        ---- till A == NULL_BLOB_INDEX */
    
    //SAVE A from 1
    if (targetInitStep == 2) {
        let newTargetBlobA: BlobData = blobBRAMPorts[1].dout;
        let newTargetBlobAAngle: BlobAngle = calcBlobAngle(newTargetBlobA);

        //Garbage A => Skip & Flag Garbage
        if (!doesBlobMatchCriteria(blobBRAMPorts[1].dout)) {
            // console.log("GARBAGE A");

            //Flag Garbage
            _(`blobGarbageList[${blobBRAMPorts[1].addr}] <= 1`);
    
            //Request New A
            _("targetWantsNewA <= 1");
    
            //Nullify B0&1
            _("targetIndexBs[0] <= ", NULL_BLOB_INDEX);
            _("targetIndexBs[1] <= ", NULL_BLOB_INDEX);
        }

        //Wrap up + Reset for GROUP Mode
        else if (virtexConfig.targetMode === TargetMode.GROUP) {
            //Chain is Done. Make it the target if we made a valid target AND
            //its better than the current one OR we dont have a current one
            if (!isTargetNull(targetChainValid) &&
                (isTargetNull(targetCurrent) || distSqToTargetCenter(targetChainValid.center) < distSqToTargetCenter(targetCurrent.center))) {
                _("targetCurrent <= ", targetChainValid);
            }

            //Reset Group Target Selector
            _("targetChain <= ", {
                center: {
                    x: (newTargetBlobA.boundBottomRight.x + newTargetBlobA.boundTopLeft.x) >> 1,
                    y: (newTargetBlobA.boundBottomRight.y + newTargetBlobA.boundTopLeft.y) >> 1
                },
                width:  newTargetBlobA.boundBottomRight.x - newTargetBlobA.boundTopLeft.x + 1,
                height: newTargetBlobA.boundBottomRight.y - newTargetBlobA.boundTopLeft.y + 1,
                angle: newTargetBlobAAngle,
                blobCount: 1
            });
            _("targetChainValid <= ", makeZeroTarget());
        }

        _("targetBlobAAngle <= ", newTargetBlobAAngle);
        _("targetBlobA <= ", newTargetBlobA);
    }

    //PROCESS
    if (targetInitStep == 3) {
        console.log("PROCESS B" + targetPartion, "<->", targetIndexA, "AGAINST", targetIndexBs[targetPartion]);
        //Get Blob
        let targetBlobB: BlobData = blobBRAMPorts[targetPartion].dout;
        let targetBlobBAngle: BlobAngle = calcBlobAngle(targetBlobB);

        //Skip & Flag Garbage
        if (!doesBlobMatchCriteria(targetBlobB)) {
            _(`blobGarbageList[${blobBRAMPorts[targetPartion].addr}] <= 1`);
        }

        //GROUP: chain other blobs together starting a Blob A
        else if (virtexConfig.targetMode == TargetMode.GROUP) {
            //make new enclosing bound that includes currentTarget & blobB
            const chainTopLeft: Vector2d10 = {
                x: targetChain.center.x - (targetChain.width >> 1),
                y: targetChain.center.y - (targetChain.height >> 1)
            };
            const chainBottomRight: Vector2d10 = {
                x: targetChain.center.x + (targetChain.width >> 1),
                y: targetChain.center.y + (targetChain.height >> 1)
            };
            const newTopLeft: Vector2d10 = {
                x: Math.min(targetBlobB.boundTopLeft.x, chainTopLeft.x),
                y: Math.min(targetBlobB.boundTopLeft.y, chainTopLeft.y)
            };
            const newBottomRight: Vector2d10 = {
                x: Math.max(targetBlobB.boundBottomRight.x, chainBottomRight.x),
                y: Math.max(targetBlobB.boundBottomRight.y, chainBottomRight.y)
            };
            const newCenter: Vector2d10 = {
                x: (newTopLeft.x + newBottomRight.x) >> 1,
                y: (newTopLeft.y + newBottomRight.y) >> 1
            };
            const newWidth: reg10 = newBottomRight.x - newTopLeft.x + 1;
            const newHeight: reg10 = newBottomRight.y - newTopLeft.y + 1;

            //gap valid between Blob B & target
            const gapX: reg10 = Math.min(
                Math.abs(targetBlobB.boundTopLeft.x - chainBottomRight.x),
                Math.abs(targetBlobB.boundBottomRight.x - chainTopLeft.x)
            );
            const gapY: reg10 = Math.min(
                Math.abs(targetBlobB.boundTopLeft.y - chainBottomRight.y),
                Math.abs(targetBlobB.boundBottomRight.y - chainTopLeft.y)
            );
            const gapValid: reg1 = inRangeInclusive(gapX, virtexConfig.targetBlobXGapMin, virtexConfig.targetBlobXGapMax) &&
                inRangeInclusive(gapY, virtexConfig.targetBlobYGapMin, virtexConfig.targetBlobYGapMax);

            //area diff between Blob A & B
            const areaBlobA = (targetBlobA.boundBottomRight.x - targetBlobA.boundTopLeft.x + 1) * (targetBlobA.boundBottomRight.y - targetBlobA.boundTopLeft.y + 1);
            const areaBlobB = (targetBlobB.boundBottomRight.x - targetBlobB.boundTopLeft.x + 1) * (targetBlobB.boundBottomRight.y - targetBlobB.boundTopLeft.y + 1);
            const areaDiffValid: reg1 = inRangeInclusive(Math.abs(areaBlobA - areaBlobB),
                virtexConfig.targetBlobAreaDiffMin, virtexConfig.targetBlobAreaDiffMax);

            if (gapValid && areaDiffValid) {
                //aspect ratio of new currentTarget valid
                const newAspectRatioValid: reg1 = inRangeInclusive(newWidth, //TODO fixed point mult
                    virtexConfig.targetAspectRatioMin*newHeight, virtexConfig.targetAspectRatioMax*newHeight);

                //bound area of new currentTarget valid
                const newBoundAreaValid: reg1 = inRangeInclusive((newWidth * newHeight) >> 1,
                    virtexConfig.targetBoundAreaMin, virtexConfig.targetBoundAreaMax);

                //set current valid target
                if (newAspectRatioValid && newBoundAreaValid) {
                    _("targetChainValid <= ", targetChain);
                }

                //join current target
                _("targetChain <= ", {
                    center: newCenter,
                    width: newWidth,
                    height: newHeight,
                    blobCount: targetChain.blobCount + 1,
                    angle: targetBlobAAngle
                });
            }
        }

        //DUAL: make all combinations of two blobs
        else {
            //pick left & right
            const targetBlobACenterX: reg10 = (targetBlobA.boundTopLeft.x + targetBlobA.boundBottomRight.x) >> 1;
            const blobBCenterX: reg10 = (targetBlobB.boundTopLeft.x + targetBlobB.boundBottomRight.x) >> 1;
            const leftBlob : BlobData       = targetBlobACenterX < blobBCenterX ? targetBlobA : targetBlobB;
            const leftBlobAngle : BlobAngle = targetBlobACenterX < blobBCenterX ? targetBlobAAngle : targetBlobBAngle;
            const rightBlob: BlobData       = targetBlobACenterX < blobBCenterX ? targetBlobB : targetBlobA;
            const rightBlobAngle: BlobAngle = targetBlobACenterX < blobBCenterX ? targetBlobBAngle : targetBlobAAngle;

            //make enclosing bound
            const topLeft: Vector2d10 = {
                x: Math.min(leftBlob.boundTopLeft.x, rightBlob.boundTopLeft.x),
                y: Math.min(leftBlob.boundTopLeft.y, rightBlob.boundTopLeft.y)
            };
            const bottomRight: Vector2d10 = {
                x: Math.max(leftBlob.boundBottomRight.x, rightBlob.boundBottomRight.x),
                y: Math.max(leftBlob.boundBottomRight.y, rightBlob.boundBottomRight.y)
            };
            const center: Vector2d10 = {
                x: (topLeft.x + bottomRight.x) >> 1,
                y: (topLeft.y + bottomRight.y) >> 1
            };
            const width: reg10 = bottomRight.x - topLeft.x + 1;
            const height: reg10 = bottomRight.y - topLeft.y + 1;

            //find if angles are valid
            const isAngleValid: reg1 = boolToReg1(virtexConfig.targetMode === TargetMode.DUAL_UP ?
                leftBlobAngle == BlobAngle.FORWARD && rightBlobAngle == BlobAngle.BACKWARD :
                virtexConfig.targetMode === TargetMode.DUAL_DOWN ?
                leftBlobAngle == BlobAngle.BACKWARD && rightBlobAngle == BlobAngle.FORWARD : true);

            //gap valid
            const gapX: reg10 = Math.abs(rightBlob.boundTopLeft.x - leftBlob.boundBottomRight.x);
            const gapY: reg10 = Math.abs(rightBlob.boundTopLeft.y - leftBlob.boundBottomRight.y);
            const gapValid: reg1 = inRangeInclusive(gapX, virtexConfig.targetBlobXGapMin, virtexConfig.targetBlobXGapMax) &&
                inRangeInclusive(gapY, virtexConfig.targetBlobYGapMin, virtexConfig.targetBlobYGapMax);

            //aspect ratio valid
            const aspectRatioValid: reg1 = inRangeInclusive(width, //TODO fixed point mult
                virtexConfig.targetAspectRatioMin*height, virtexConfig.targetAspectRatioMax*height);

            //bound area valid
            const boundAreaValid: reg1 = inRangeInclusive((width * height) >> 1,
                virtexConfig.targetBoundAreaMin, virtexConfig.targetBoundAreaMax);

            //area diff valid
            const areaLeft = (leftBlob.boundBottomRight.x - leftBlob.boundTopLeft.x + 1) * (leftBlob.boundBottomRight.y - leftBlob.boundTopLeft.y + 1);
            const areaRight = (rightBlob.boundBottomRight.x - rightBlob.boundTopLeft.x + 1) * (rightBlob.boundBottomRight.y - rightBlob.boundTopLeft.y + 1);
            const areaDiffValid: reg1 = inRangeInclusive(Math.abs(areaRight - areaLeft),
                virtexConfig.targetBlobAreaDiffMin, virtexConfig.targetBlobAreaDiffMax);
            
            //if this target is valid AND this target is better OR we dont have a target yet
            if (isAngleValid && gapValid && aspectRatioValid && boundAreaValid && areaDiffValid &&
                (isTargetNull(targetCurrent) || distSqToTargetCenter(center) < distSqToTargetCenter(targetCurrent.center))) {
                _("targetCurrent <= ", {
                    center, width, height,
                    blobCount: 2,
                    angle: leftBlobAngle
                });
            }
        }
    }

    //READ
    if (targetInitStep != 0 && !targetWantsNewA) {
        //Request New A
        if (nextTargetIndexBs[targetPartion]() == NULL_BLOB_INDEX) {
            // console.log("READ -> NEW A");
            //Request New A (we must request because we have to wait for last B to finish processing)
            _("targetWantsNewA <= 1");

            //Nullify B0|1
            _(`targetIndexBs[${targetPartion}] <= `, NULL_BLOB_INDEX);
        }

        //READ New B0|1
        else {
            // console.log("READ -> New B" + targetPartion);
            //READ New B0|1
            _(`blobBRAMPorts[${targetPartion}].addr <= `, nextTargetIndexBs[targetPartion]());

            //Save New B0|1 Index
            _(`targetIndexBs[${targetPartion}] <= `, nextTargetIndexBs[targetPartion]());
        }
    }

    //Reset for New A OR Finish
    if (targetWantsNewA && targetIndexBs[invertReg1(targetPartion)] == NULL_BLOB_INDEX) {
        //Reset Target Partion
        _("targetPartion <= 0");

        //Finish
        if (nextTargetIndexA() === NULL_BLOB_INDEX) {
            // console.log("\n\n\nNEW A -> DONE");
            //transfer best target to target
            _("target <= ", targetCurrent);

            //flag
            _("targetSelectorDone <= 1");
        }

        //READ New A & B0|1 (if not end frame AND valid New B for DUAL mode)
        else if (initTargetIndexB() !== NULL_BLOB_INDEX) {
            // console.log("\n\n\nNEW A -> GOOD");
            //READ New A on 1
            _("blobBRAMPorts[1].addr <= ", nextTargetIndexA());

            //Update State
            _("targetWantsNewA <= 0");
            _("targetPartion <= 1");
            _("targetInitStep <= 1");
        }
        
        //No Valid Bs for this A => Go get new A
        else {
            // console.log("\n\n\nNEW A -> SKIP");
            _("targetInitStep <= 0");
        }

        //Set New A
        _("targetIndexA <= ", nextTargetIndexA());
    }

    // console.log("");
}
function updateTargetSelectorSingle(): void {
    /* SINGLE Breakdown (A = index, B = unused, 0|1 = BRAM ports)
    Note: @ PROCESS 0|1 & !doesBlobMatchCriteria() -> Skip & Flag GARBAGE (technically unnessary)
    ------------------------------------------------------
    0 -           READ New 0 (0 is invalid @ start)
    1 +           READ New 1 (1 is invalid @ start)
    2 - PROCESS 0 READ New 0 (0 is valid @ start)
    3 + PROCESS 1 READ New 1 (1 is valid @ start)
    4 - PROCESS 0 READ New 0 ...
    5 + PROCESS 1 READ New 1
    6 - PROCESS 0 READ New 0
    ---- till nextIndex == NULL_BLOB_INDEX */

    //Finish
    if (targetSingleAlmostDone) {
        //transfer best target to target
        _("target <= ", targetCurrent);

        //flag
        _("targetSelectorDone <= 1");
    }

    //PROCESS
    if (targetInitStep > 1) {
        const blob: BlobData = blobBRAMPorts[targetPartion].dout;

        // console.log("\n\n", blobBRAMPorts[targetPartion].addr, doesBlobMatchCriteria(blob), blob, "\n\n");

        //PROCESS
        if (doesBlobMatchCriteria(blob)) {
            //Convert Blob A Bounding Box from TopLeft/BottomRight => Center/Width/Height
            const center: Vector2d10 = {
                x: (blob.boundBottomRight.x + blob.boundTopLeft.x) >> 1,
                y: (blob.boundBottomRight.y + blob.boundTopLeft.y) >> 1
            };
            const width:  reg10 = blob.boundBottomRight.x - blob.boundTopLeft.x + 1;
            const height: reg10 = blob.boundBottomRight.y - blob.boundTopLeft.y + 1;

            //aspect ratio valid
            const aspectRatioValid: reg1 = inRangeInclusive(width, //TODO fixed point mult
                virtexConfig.targetAspectRatioMin*height, virtexConfig.targetAspectRatioMax*height);

            //bound area valid
            const boundAreaValid: reg1 = inRangeInclusive((width * height) >> 1,
                virtexConfig.targetBoundAreaMin, virtexConfig.targetBoundAreaMax);

            //if this target is valid AND this target is better OR we dont have a target yet
            if (aspectRatioValid && boundAreaValid &&
                (isTargetNull(targetCurrent) || distSqToTargetCenter(center) < distSqToTargetCenter(targetCurrent.center))) {
                _("targetCurrent <= ", {
                    center, width, height,
                    blobCount: 1,
                    angle: calcBlobAngle(blob)
                });
            }
        }

        //Skip & Flag Garbage
        else {
            _(`blobGarbageList[${blobBRAMPorts[targetPartion].addr}] <= 1`);
        }
    }

    //READ
    if (!targetSingleAlmostDone) {
        //Finish
        if (nextTargetIndexA() == NULL_BLOB_INDEX) {
            //flag almost done so we can come back last loop and process ~targetPartion
            _("targetSingleAlmostDone <= 1");
        }

        //READ
        else {
            _(`blobBRAMPorts[${targetPartion}].addr <= `, nextTargetIndexA());
            _("targetIndexA <= ", nextTargetIndexA());
        }
    }
}
function distSqToTargetCenter(v: Vector2d10): reg24 {
    //Distance^2 Between Vector and Target Center
    return (v.x - virtexConfig.targetCenterX)**2 + (v.y - virtexConfig.targetCenterY)**2;
}
function doesBlobMatchCriteria(blob: BlobData): reg1 {
    const boundWidth: reg10 = blob.boundBottomRight.x - blob.boundTopLeft.x;
    const boundHeight: reg10 = blob.boundBottomRight.y - blob.boundTopLeft.y;

    //TODO fixed point mult
    const inAspectRatioRange: reg1 = inRangeInclusive(boundWidth,
        virtexConfig.blobAspectRatioMin*boundHeight, virtexConfig.blobAspectRatioMax*boundHeight);

    const boundAreaUnshifted: reg24 = boundWidth * boundHeight;
    const inBoundAreaRange: reg1 = inRangeInclusive(boundAreaUnshifted >> 1,
        virtexConfig.blobBoundAreaMin, virtexConfig.blobBoundAreaMax);

    //TODO fixed point mult
    const inFullnessRange: reg1 = inRangeInclusive(blob.area,
        virtexConfig.blobFullnessMin*boundAreaUnshifted, virtexConfig.blobFullnessMax*boundAreaUnshifted);

    const isValidAngle: reg1 = boolToReg1(virtexConfig.blobAnglesEnabled[(Object.keys(virtexConfig.blobAnglesEnabled) as Array<keyof BlobAnglesEnabled>)[calcBlobAngle(blob)]]);

    return inAspectRatioRange && inBoundAreaRange && inFullnessRange && isValidAngle;
}
function getNextValidTargetIndex(startIndex: BlobIndex): BlobIndex {
    //find next valid blob >= startIndex (and < blobIndex because anything above that is invalid)
    for (let i = 0; i < MAX_BLOBS; i++) {
        if (i >= startIndex && i < blobIndex && !blobGarbageList[i]) {
            return i;
        }
    }
    return NULL_BLOB_INDEX;
}

//Combinational Logic
function always_comb(): void {
    if (blobIndex >= NULL_BLOB_INDEX) {
        faults.OUT_OF_BLOB_MEM_FAULT = 1;
    }
    if (currentLineBuffer.count >= MAX_RUNS_PER_LINE) {
        faults.OUT_OF_RLE_MEM_FAULT = 1;
    }
}

//Global Reset for New Frame
function frameReset(): void {
    console.log(" --- FRAME RESET --- ")

    //TODO BLOB_PROCESSOR_TOO_SLOW_FAULT

    //Flag Reset
    _("justResetFrame <= 1");

    //Blob Maker Reset (everything else is reset in on New Line* updateBlobMaker())
    _("blobIndex <= 0");
    _("blobSkipCycle <= 0");
    _("blobMakerState <= BlobMakerState.NONE");

    //Target Selector Reset
    _("target <= ", makeZeroTarget());
    _("targetCurrent <= ", makeZeroTarget());
    _("targetChain <= ", makeZeroTarget());
    _("targetChainValid <= ", makeZeroTarget());
    _("targetIndexA <= ", NULL_BLOB_INDEX);
    _("targetWantsNewA <= 1");
    _("targetIndexBs <= ", [NULL_BLOB_INDEX, NULL_BLOB_INDEX]);
    _("targetInitStep <= 0");
    _("targetPartion <= 0");
    _("targetSingleAlmostDone <= 0");
    _("targetSelectorDone <= 0");
}

//(scripting only)
let nonblockingQueue: {name: string, val: string}[] = [];
function _(ass: string, val?: any) {
    if (ass.indexOf(" <= ") == -1) console.error(`ERROR "${ass}" DOES NOT CONTAIN ASSIGNMENT PATTERN: " <= "`);
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
        catch (e) { console.error(`ERROR EVALUATING "${assignment.name}" TO "${assignment.val}"`); }
    }
    nonblockingQueue = [];
}
let isDone = () => Boolean(targetSelectorDone);
let getBlobIndex = () => blobIndex;
let getTarget = () => target;
let getBlobColorBuffer = () => blobColorBuffer;
let getFaults = () => faults;
let getBlobGarbageList = () => blobGarbageList;
let clearFaults = () => faults = {
    PYTHON_300_PLL_FAULT: 0,
    IR_LED_FAULT: 0,
    OUT_OF_BLOB_MEM_FAULT: 0,
    OUT_OF_RLE_MEM_FAULT: 0,
    BLOB_POINTER_DEPTH_FAULT: 0,
    BLOB_PROCESSOR_TOO_SLOW_FAULT: 0
};
clearFaults();
export { always_ff, isDone, getBlobIndex, getBlobGarbageList, getTarget, getBlobColorBuffer, getFaults, clearFaults };