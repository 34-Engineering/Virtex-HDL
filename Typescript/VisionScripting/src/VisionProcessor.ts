/* BlobProcessor V3.5
The Blob Processor is a multi-functional module that takes in an pipelined
run length encoded images (through a run FIFO) and outputs a single target
per image frame: Runs => Blobs => Target

Nomenclature:
 Blob: an isolated white region in the image
  - Bounding Box: the minimum non-rotated rectangle that covers all pixels in the blob
  - Quad: a quadrilateral made from the four most extreme points in the blob (used for angle calculations)
 Target: a blob or group of blobs

Blob making is a process where blobs are "grown" to cover an entire isolated
white region of the image. Isolated regions are first spotted by runs that
are not touching any another run in the line above them, then following
runs that are touching it are joined onto its blob and the blob
is expanded to cover the entire region.
The Blob making process is also required to merge blobs in certain region
shapes like U, V, W, etc. This is because the regions are initially
seen as two separate blobs but later found to be part of the same region.

Stages:
 1) Blob Maker: process runs from FIFO into blobs in "growing" BRAM
 2) Blob Train: tranfers unorganized blobs from "growing" BRAM to organized "finished" BRAM
     -> TargetMode.SINGLE:
         - chooses the best target based off center distance
 3) Target Selector: make a target from "finished" BRAM
     -> TargetMode.DUAL:
        //FIXME
         - loop through every valid blob (A)
         - for each A, loop through every valid blob with indexes > A (B)
         - make a target from every A & B
         - choose the best target based off center distance
     -> TargetMode.GROUP:
         - continously loop through every valid blob (A) until there is 0|1 left
         - for each A, loop through every other valid blob (B)
         - group all B's within gap & area ratio range to A, join them to A
            (using Blob BRAM to represent a "Group Target" instead of a blob),
            & flag B as garbage
         - when no B's join an A, convert A from a "Group Target" to a Target,
            & become the targetCurrent if it is better than the existing one

Note: The Artix-7/Vivado BRAM IP has a 2 clock cycle read delay
(cycle 1 (request): old data, cycle 2: old data, cycle 3: new data)

Future Note: if target selector is too slow we can double the speed by doing double processing (but also doubles area)
*/

import { Faults } from "./Fault";
import { MAX_RUNS_PER_LINE, NULL_LINE_NUMBER, NULL_BLOB_INDEX, NULL_RUN_BUFFER_PARTION, NULL_TIMESTAMP, MAX_TARGET_GROUP_SIZE } from "./VisionConstants";
import { BlobData, mergeBlobs, RunBuffer, runsOverlap, runToBlob, calcBlobAngle, BlobAngle, Target, TargetMode, BlobAnglesEnabled, Run, isTargetNull, inAspectRatioRange, inFullnessRange, inBoundAreaRatioRange, inBoundAreaRange, isGroupTarget, asGroupTarget, makeGroupTarget, GroupTarget, mergeGroupTargets, asBlob, groupTargetToTarget } from "./VisionUtil";
import { Math_diff, Math_inRangeInclusive, Math_max, Math_min, Math_overflow, Vector2d10 } from "./Math";
import { virtexConfig } from "./VirtexConfig";
import { reg1, reg10, BlobIndex, BlobArea, processRunFIFO, growingBlobsBRAM, finishedBlobsBRAM, addToRunFIFO, RunBufferIndex, makeZeroBlobData, boolToReg1, makeZeroTarget, reg2, invertReg1, reg20, reg6 } from "./VerilogUtil";
import { deepCopy } from "./DrawUtil";
import { IMAGE_HEIGHT, IMAGE_WIDTH } from "./Constants";

//(scripting only)
let blobColorBuffer: RunBuffer[] = [];
let faults: Faults;

//Run FIFO
let runFIFOEmpty: reg1 = 1, runFIFORead: reg1;
let runFIFOOut: Run = {length:0, line:0, black:0};
let lastLine: reg10 = 340;
let justResetFrame: reg1 = 0;

//Blob BRAM
interface BlobBRAMPort { addr: BlobIndex, din: BlobData, dout: BlobData, we: reg1 };
let growingBlobs: BlobBRAMPort[] = [{addr:0, din:makeZeroBlobData(), dout:makeZeroBlobData(), we:0}, {addr:0, din:makeZeroBlobData(), dout:makeZeroBlobData(), we:0}];
let finishedBlobs: BlobBRAMPort[] = [{addr:0, din:makeZeroBlobData(), dout:makeZeroBlobData(), we:0}, {addr:0, din:makeZeroBlobData(), dout:makeZeroBlobData(), we:0}];

//Blob Maker
enum MakerState { NONE, SEARCH, MERGE, JOIN, JOIN_END, MAKE, DONE };
let makerState: MakerState = MakerState.NONE;
let makerSkipCycle: reg1 = 0;
let makerJustResetLine: reg1 = 0;
let makerGrowingIndex: BlobIndex = 0;

let currentLineBuffer: RunBuffer = {
    runs: [...Array(MAX_RUNS_PER_LINE)].map(_=>({ start:0, stop:0, blobIndex:0 })),
    count:0,
    line:0
}; //we are loading read in runs into this (never read from), then it is transfered to lastLineBuffer
let currentLineBufferX: reg10 = 0;
let lastLineBuffer: RunBuffer = {
    runs: [...Array(MAX_RUNS_PER_LINE)].map(_=>({ start:0, stop:0, blobIndex:0 })),
    count:0,
    line:0
};
let currentRunAsBlob = (): BlobData => runToBlob(currentLineBufferX, runFIFOOut.length, runFIFOOut.line);
let currentRunHasJoinedBlob = (): reg1 => boolToReg1(currentLineBuffer.runs[currentLineBuffer.count]?.blobIndex != NULL_BLOB_INDEX);

//Blob Train
let trainFinishedIndex: BlobIndex = 0;
let trainGrowingIndex: BlobIndex = 0;
let trainAlmostDone = (): reg1 => boolToReg1(trainGrowingIndex == makerGrowingIndex);
let trainDone = (): reg1 => boolToReg1(trainGrowingIndex == (makerGrowingIndex+1)); //+1 because the train needs to finish the last index
let trainPartion: reg1 = 0;
let trainInitDone: reg1 = 0;

//Target Selector
let target: Target = makeZeroTarget(); //"best" target for the last frame
let targetCurrent: Target = makeZeroTarget(); //"best" target for the current frame
let targetBlobA: BlobData = makeZeroBlobData();
let targetBlobAAngle: BlobAngle;
let targetInitStep: reg2 = 0; //0-2: init, 3: done
let targetPartion: reg1 = 0; //alterates every cycle
let targetIndexA: BlobIndex = NULL_BLOB_INDEX;
let targetIndexBs: BlobIndex[] = [NULL_BLOB_INDEX, NULL_BLOB_INDEX]; //B0|1 (alternates, so one is waiting for read delay & the other is proc)
let targetWantsNewA: reg1 = 1; //wants to get a new A (takes 2 cycles)
let targetWillGetNewA = (): reg1 => boolToReg1(Boolean(targetWantsNewA) && targetIndexBs[0] == NULL_BLOB_INDEX && targetIndexBs[1] == NULL_BLOB_INDEX); //we have wanted a new A, but now we are ready
let targetGroupBJoined: reg1 = 0;
let targetSingleAlmostDone: reg1 = 0; //will be done next loop (single mode only)
let targetSelectorDone: reg1 = 0;

let nextTargetIndexA = (): BlobIndex => (targetIndexA == NULL_BLOB_INDEX) ? 0 : targetIndexA + 1;
let fixTargetIndex = (index: BlobIndex): BlobIndex => (index < trainFinishedIndex) ? index : NULL_BLOB_INDEX; //return null for blob index that is above bound
let initTargetIndexB = (): BlobIndex => (virtexConfig.targetMode == TargetMode.GROUP) ? //first B index (with overlap protection)
    fixTargetIndex(targetIndexA == 0 ? 1 : 0) :
    fixTargetIndex(targetIndexA + 1);
let nextInitTargetIndexB = (): BlobIndex => (virtexConfig.targetMode == TargetMode.GROUP) ? //calculate next init index B so we know if the next A should be skipped
    fixTargetIndex(nextTargetIndexA() == 0 ? 1 : 0) :
    fixTargetIndex(nextTargetIndexA() + 1);
let nextTargetIndexBsUnaccounted = [ //unaccounted for possible overlap with targetIndexA
    (): BlobIndex => fixTargetIndex(targetIndexBs[1] + 1), //opposite so they will skip ahead of eachother (AKA: (0,1), (2,3) ...)
    (): BlobIndex => fixTargetIndex(targetIndexBs[0] + 1)
];
let nextTargetIndexBs = [
    (): BlobIndex => (nextTargetIndexBsUnaccounted[0]() == targetIndexA) ? (nextTargetIndexBsUnaccounted[0]()+1) : nextTargetIndexBsUnaccounted[0](), //prevent A index overlap
    (): BlobIndex => (targetInitStep == 1) ? initTargetIndexB() : //init B index @ value
    (nextTargetIndexBsUnaccounted[1]() == targetIndexA) ? (nextTargetIndexBsUnaccounted[1]()+1) : nextTargetIndexBsUnaccounted[1]()
];

//200MHz Clocked Loop
function always_ff(): void {
    //defaults & counters
    _("growingBlobs[0].we <= 0");
    _("growingBlobs[1].we <= 0");
    _("finishedBlobs[0].we <= 0");
    _("finishedBlobs[1].we <= 0");
    _("lastLine <= ", runFIFOOut.line);
    _("justResetFrame <= 0");
    _("runFIFORead <= 0");
    _("makerSkipCycle <= 0");
    _("makerJustResetLine <= 0");

    //Reset @ New Frame
    if (runFIFOOut.line == 0 && lastLine != 0) {
        frameReset();
    }

    else {
        //Update Blob Maker (Stage 1)
        if (makerState !== MakerState.DONE) {
            updateBlobMaker();
        }
        
        //Read from FIFO @ Reset for New Frame
        else if (!runFIFOEmpty) {
            _("runFIFORead <= 1");
            if (!targetSelectorDone) {
                faults.BLOB_PROCESSOR_TOO_SLOW_FAULT = 1;
            }
        }

        //Update Blob Train (Stage 2)
        else if (!trainDone()) {
            updateBlobTrain();
        }

        //Update Target Selector (Stage 3)
        else if (!targetSelectorDone) {
            if (virtexConfig.targetMode == TargetMode.SINGLE) {
                _("targetSelectorDone <= 1");
            }
            else updateTargetSelectorDualGroup();
        }
    }

    //(scripting only)
    processNonblocking();
    always_comb();
    [ runFIFOEmpty, runFIFOOut ] = processRunFIFO({ read: runFIFORead });
    [ growingBlobs[0].dout, growingBlobs[1].dout ] = growingBlobsBRAM.update({
        addra: growingBlobs[0].addr, dina: growingBlobs[0].din, wea: growingBlobs[0].we, 
        addrb: growingBlobs[1].addr, dinb: growingBlobs[1].din, web: growingBlobs[1].we
    });
    [ finishedBlobs[0].dout, finishedBlobs[1].dout ] = finishedBlobsBRAM.update({
        addra: finishedBlobs[0].addr, dina: finishedBlobs[0].din, wea: finishedBlobs[0].we, 
        addrb: finishedBlobs[1].addr, dinb: finishedBlobs[1].din, web: finishedBlobs[1].we
    });
}

//Blob Maker (runs => blobs)
function updateBlobMaker(): reg1 {
    //New Line*
    if (runFIFOOut.line != lastLine) {
        //flag reset
        _("makerJustResetLine <= 1");

        //transfer current line buffer => last line buffer
        if (runFIFOOut.line != 0) {
            _("lastLineBuffer <= ", currentLineBuffer);
            //(scripting only)
            blobColorBuffer[lastLineBuffer.line] = deepCopy(lastLineBuffer);
        }

        //reset current line buffer
        _("currentLineBufferX <= 0");
        _("currentLineBuffer.count <= 0");
        _(`currentLineBuffer.runs[0] <= `, {start:0, stop:0, blobIndex:NULL_BLOB_INDEX});
        _("currentLineBuffer.line <= ", (runFIFOOut.line));
    }

    else if (!makerSkipCycle) {
        //New Run*
        if (makerState == MakerState.NONE) {
            //Process FIFO Read
            if (runFIFORead || makerJustResetLine || justResetFrame) {
                //Run is Black => Continue
                if (runFIFOOut.black) {
                    _(`currentLineBuffer.runs[${currentLineBuffer.count}] <= `, {
                        start: currentLineBufferX,
                        stop: currentLineBufferX + runFIFOOut.length - 1,
                        blobIndex: NULL_BLOB_INDEX
                    });
                    
                    blobFinishRun();
                }
                
                //Run is White => Search & Join OR Make new Blob
                else if (runFIFOOut.line > 0) {
                    _("makerState <= MakerState.SEARCH");
                    return updateOnMakerState(MakerState.SEARCH);
                }

                //Run is White (and no line above) => Make new Blob
                else {
                    _("makerState <= MakerState.MAKE");
                    return updateOnMakerState(MakerState.MAKE);
                }
            }

            //Read from FIFO
            else if (!runFIFOEmpty) {
                _("runFIFORead <= 1");
            }
        }

        //Working on Run
        else return updateOnMakerState(makerState);
    }

    return 0;
}
function updateOnMakerState(ustate: MakerState): reg1 {
    //Search through runs from last line & Check if this run is touching them
    if (ustate == MakerState.SEARCH) {
        //defaults
        if (currentRunHasJoinedBlob()) {
            _("makerState <= MakerState.JOIN_END");
        }
        else _("makerState <= MakerState.MAKE");

        //Search
        for (let i = 0; i < MAX_RUNS_PER_LINE; i++) {
            if (i < lastLineBuffer.count && lastLineBuffer.runs[i].blobIndex != NULL_BLOB_INDEX && //if valid index in lastLineBuffer
                runsOverlap(currentLineBufferX, currentLineBufferX + runFIFOOut.length - 1, //if this run is touching it
                    lastLineBuffer.runs[i].start, lastLineBuffer.runs[i].stop))
            {
                const iBlobIndex: BlobIndex = lastLineBuffer.runs[i].blobIndex;

                //First touching run => Join it's blob
                if (!currentRunHasJoinedBlob()) {
                    //set new state
                    _("makerState <= MakerState.JOIN");

                    //read Blob from BRAM
                    _("growingBlobs[0].addr <= ", iBlobIndex);
                    _("makerSkipCycle <= 1");
                }

                //2nd+ touching run => Merge this blob with master blob
                else if (iBlobIndex != currentLineBuffer.runs[currentLineBuffer.count].blobIndex) {
                    // set new state
                    _("makerState <= MakerState.MERGE");

                    // read Blobs from BRAM
                    _("growingBlobs[0].addr <= ", currentLineBuffer.runs[currentLineBuffer.count].blobIndex);
                    _("growingBlobs[1].addr <= ", iBlobIndex);
                    _("makerSkipCycle <= 1");
                    return 1;
                }
            }
        }
    }
    
    //Join Blob
    else if (ustate == MakerState.JOIN) {
        //write back to BRAM
        _("growingBlobs[0].din <= ", mergeBlobs(currentRunAsBlob(), growingBlobs[0].dout));
        _("growingBlobs[0].we <= 1");

        //save to current line run buffer
        _(`currentLineBuffer.runs[${currentLineBuffer.count}] <= `, {
            start: currentLineBufferX,
            stop: currentLineBufferX + runFIFOOut.length - 1,
            blobIndex: growingBlobs[0].addr
        });

        //go back to searching
        _("makerState <= MakerState.SEARCH");
    }

    //Merge two intersecting Blobs (U/V/W Case)
    else if (ustate == MakerState.MERGE) {
        //update all pointers to slave
        for (let i = 0; i < MAX_RUNS_PER_LINE; i++) {
            if (lastLineBuffer.runs[i].blobIndex == growingBlobs[1].addr) {
                _(`lastLineBuffer.runs[${i}].blobIndex <= `, growingBlobs[0].addr);
            }
        }

        //write back merged blob to master in BRAM
        _("growingBlobs[0].din <= ", mergeBlobs(growingBlobs[1].dout, growingBlobs[0].dout));
        _("growingBlobs[0].we <= 1");

        //write back null blob to slave in BRAM
        _("growingBlobs[1].din <= ", makeZeroBlobData());
        _("growingBlobs[1].we <= 1");

        //go back to searching
        _("makerState <= MakerState.SEARCH");
    }

    //Join End (had joined a blob & is done now)
    else if (ustate == MakerState.JOIN_END) {
        blobFinishRun();
    }

    //Make new Blob
    else if (ustate == MakerState.MAKE) {
        //write to BRAM
        _("growingBlobs[0].din <= ", currentRunAsBlob());
        _("growingBlobs[0].addr <= ", makerGrowingIndex);
        _("growingBlobs[0].we <= 1");

        //save to current line run buffer
        _(`currentLineBuffer.runs[${currentLineBuffer.count}] <= `, {
            start: currentLineBufferX,
            stop: currentLineBufferX + runFIFOOut.length - 1,
            blobIndex: makerGrowingIndex
        });

        //increment blob counter
        _("makerGrowingIndex <= ", (makerGrowingIndex + 1));

        //prepare for new run
        blobFinishRun();
    }

    return 0;
}
function blobFinishRun(): void {
    //prepare for new run
    _("currentLineBufferX <= ", (currentLineBufferX + runFIFOOut.length));
    _("currentLineBuffer.count <= ", (currentLineBuffer.count + 1));
    _(`currentLineBuffer.runs[${currentLineBuffer.count+1}] <= `, {start:0, stop:0, blobIndex:NULL_BLOB_INDEX});

    //reset state
    _("makerState <= MakerState.NONE");

    //finish
    if ((currentLineBufferX + runFIFOOut.length - 1) == (IMAGE_WIDTH-1) && runFIFOOut.line == IMAGE_HEIGHT-1) {
        console.log(" > Blob Processor Done < ");
        _("makerState <= MakerState.DONE");
    }
    
    //read new run
    else if (!runFIFOEmpty) {
        _("runFIFORead <= 1");
    }
}

//Blob Train ("Growing" BRAM -> "Finished" BRAM) (Note: automatically does target selection for single target mode)
function updateBlobTrain(): void {
    _("trainPartion <= ", boolToReg1(!trainPartion));

    const blobGood: reg1 = doesBlobMatchCriteria(growingBlobs[trainPartion].dout);
    if (trainInitDone) {
        //Transfer Good Blobs to "Finished" BRAM
        if (blobGood) {
            _("finishedBlobs[0].addr <= ", trainFinishedIndex);
            _("finishedBlobs[0].din <= ", growingBlobs[trainPartion].dout);
            _("finishedBlobs[0].we <= 1");
            _("trainFinishedIndex <= ", trainFinishedIndex + 1);
        }
        
        //Update Single Mode Target Selector
        if (virtexConfig.targetMode == TargetMode.SINGLE) {
            updateTargetSelectorSingle(blobGood, growingBlobs[trainPartion].dout);
        }
    }

    //Finish Init
    else if (trainPartion) {
        _("trainInitDone <= 1");
    }

    //Read Blob from "Growing" BRAM
    _(`growingBlobs[${trainPartion}].addr <= `, trainGrowingIndex + 1);
    _("trainGrowingIndex <= ", trainGrowingIndex + 1);

    //(scripting only)
    if (trainAlmostDone()) {
        console.log(" > Blob Train Done < ", trainFinishedIndex + (trainInitDone && blobGood ? 1 : 0));
    }
}

//Target Selector (blobs => target)
function updateTargetSelectorSingle(blobValid: reg1, blob: BlobData): void {
    //Convert Blob A Bounding Box from TopLeft/BottomRight => Center/Width/Height
    const center: Vector2d10 = {
        x: (blob.boundBottomRight.x + blob.boundTopLeft.x) >> 1,
        y: (blob.boundBottomRight.y + blob.boundTopLeft.y) >> 1
    };
    const width:  reg10 = blob.boundBottomRight.x - blob.boundTopLeft.x + 1;
    const height: reg10 = blob.boundBottomRight.y - blob.boundTopLeft.y + 1;

    //aspect ratio valid
    const aspectRatioValid: reg1 = inAspectRatioRange(width, height,
        virtexConfig.targetAspectRatioMin, virtexConfig.targetAspectRatioMax);

    //bound area valid
    const boundAreaValid: reg1 = inBoundAreaRange(width * height,
        virtexConfig.targetBoundAreaMin, virtexConfig.targetBoundAreaMax);

    //if this target is valid AND this target is better OR we dont have a target yet
    if (blobValid && aspectRatioValid && boundAreaValid &&
        (isTargetNull(targetCurrent) || distSqToTargetCenter(center) < distSqToTargetCenter(targetCurrent.center))) {
        const newTarget: Target = {
            center, width, height,
            blobCount: 1,
            angle: calcBlobAngle(blob)
        };

        _("targetCurrent <= ", newTarget);

        if (trainAlmostDone()) _("target <= ", newTarget);
    }
    else if (trainAlmostDone()) _("target <= ", targetCurrent);
}
function updateTargetSelectorDualGroup(): void {
    console.log(targetInitStep, targetIndexA, targetIndexBs[targetPartion], nextTargetIndexA(), nextTargetIndexBs[0](), nextTargetIndexBs[1]());

    //Increment Init Step
    if (targetInitStep != 3) {
        _("targetInitStep <= ", targetInitStep+1);
    }

    //Swap Partion
    _("targetPartion <= ", boolToReg1(!targetPartion));

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
          ... till B0|1 == NULL_BLOB_INDEX
        ---- till A == NULL_BLOB_INDEX */

    //SAVE A from 1
    if (targetInitStep == 2) {
        _("targetBlobAAngle <= ", calcBlobAngle(finishedBlobs[1].dout));
        _("targetBlobA <= ", finishedBlobs[1].dout);
    }

    //PROCESS
    if (targetInitStep == 3 && targetIndexBs[targetPartion] !== NULL_BLOB_INDEX) {
        //Get Blob
        const targetBlobB: BlobData = finishedBlobs[targetPartion].dout;
        const targetBlobBAngle: BlobAngle = calcBlobAngle(targetBlobB);

        //GROUP: chain other blobs together starting a Blob A
        if (virtexConfig.targetMode == TargetMode.GROUP) {
            //gap between
            const gapX: reg10 = Math_diff(targetBlobA.boundTopLeft.x, targetBlobB.boundBottomRight.x);
            const gapY: reg10 = Math_diff(targetBlobA.boundTopLeft.y, targetBlobB.boundBottomRight.y);
            const gapValid: reg1 = Math_inRangeInclusive(gapX, virtexConfig.targetBlobXGapMin, virtexConfig.targetBlobXGapMax) &&
                Math_inRangeInclusive(gapY, virtexConfig.targetBlobYGapMin, virtexConfig.targetBlobYGapMax);
            
            //ratio between the bound area of the two blobs (if either is a group target, then it will used the cashed bound area)
            const groupTargetA: GroupTarget = isGroupTarget(targetBlobA) ? asGroupTarget(targetBlobA) : makeGroupTarget(targetBlobA);
            const groupTargetB: GroupTarget = isGroupTarget(targetBlobB) ? asGroupTarget(targetBlobB) : makeGroupTarget(targetBlobB);
            const blobsBoundAreaRatioValid: reg1 = inBoundAreaRatioRange(groupTargetA.blobBoundArea, groupTargetB.blobBoundArea,
                virtexConfig.targetBoundAreaRatioMin, virtexConfig.targetBoundAreaRatioMax);

            //join A & B
            if (gapValid && blobsBoundAreaRatioValid) {
                //make new group target
                const newGroupTarget: GroupTarget = mergeGroupTargets(groupTargetA, groupTargetB);

                //write back to A BRAM & cache
                const newTargetBlobA: BlobData = asBlob(newGroupTarget);
                _("targetBlobA <= ", newTargetBlobA);
                _(`finishedBlobs[${boolToReg1(!targetPartion)}].din <= `, newTargetBlobA);
                _(`finishedBlobs[${boolToReg1(!targetPartion)}].addr <= `, targetIndexA);
                _(`finishedBlobs[${boolToReg1(!targetPartion)}].we <= `, 1);

                //Flag B Joined
                _("targetGroupBJoined <= 1");
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
                x: Math_min(leftBlob.boundTopLeft.x, rightBlob.boundTopLeft.x),
                y: Math_min(leftBlob.boundTopLeft.y, rightBlob.boundTopLeft.y)
            };
            const bottomRight: Vector2d10 = {
                x: Math_max(leftBlob.boundBottomRight.x, rightBlob.boundBottomRight.x),
                y: Math_max(leftBlob.boundBottomRight.y, rightBlob.boundBottomRight.y)
            };
            const center: Vector2d10 = {
                x: (topLeft.x + bottomRight.x) >> 1,
                y: (topLeft.y + bottomRight.y) >> 1
            };
            const width: reg10 = bottomRight.x - topLeft.x + 1;
            const height: reg10 = bottomRight.y - topLeft.y + 1;

            //if left/right blob angles are valid
            const angleValid: reg1 = boolToReg1(virtexConfig.targetMode === TargetMode.DUAL_UP ?
                leftBlobAngle == BlobAngle.FORWARD && rightBlobAngle == BlobAngle.BACKWARD :
                virtexConfig.targetMode === TargetMode.DUAL_DOWN ?
                leftBlobAngle == BlobAngle.BACKWARD && rightBlobAngle == BlobAngle.FORWARD : true);

            //gap between target & blobB
            const gapX: reg10 = Math_diff(rightBlob.boundTopLeft.x, leftBlob.boundBottomRight.x);
            const gapY: reg10 = Math_diff(rightBlob.boundTopLeft.y, leftBlob.boundBottomRight.y);
            const gapValid: reg1 = Math_inRangeInclusive(gapX, virtexConfig.targetBlobXGapMin, virtexConfig.targetBlobXGapMax) &&
                Math_inRangeInclusive(gapY, virtexConfig.targetBlobYGapMin, virtexConfig.targetBlobYGapMax);

            //aspect ratio of new target
            const aspectRatioValid: reg1 = inAspectRatioRange(width, height,
                virtexConfig.targetAspectRatioMin, virtexConfig.targetAspectRatioMax);

            //bound area of new target
            const boundAreaValid: reg1 = inBoundAreaRange(width * height,
                virtexConfig.targetBoundAreaMin, virtexConfig.targetBoundAreaMax);

            //area ratio between two blobs
            const boundAreaLeft = (leftBlob.boundBottomRight.x - leftBlob.boundTopLeft.x + 1) * (leftBlob.boundBottomRight.y - leftBlob.boundTopLeft.y + 1);
            const boundAreaRight = (rightBlob.boundBottomRight.x - rightBlob.boundTopLeft.x + 1) * (rightBlob.boundBottomRight.y - rightBlob.boundTopLeft.y + 1);
            const boundAreaRatioValid: reg1 = inBoundAreaRatioRange(boundAreaRight, boundAreaLeft,
                virtexConfig.targetBoundAreaRatioMin, virtexConfig.targetBoundAreaRatioMax);
            
            //if this target is valid AND this target is better OR we dont have a target yet
            if (angleValid && gapValid && aspectRatioValid && boundAreaValid && boundAreaRatioValid &&
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
            //Request New A (we must request because we have to wait for last B to finish processing)
            _("targetWantsNewA <= 1");

            //Nullify B0|1
            _(`targetIndexBs[${targetPartion}] <= `, NULL_BLOB_INDEX);
        }

        //READ New B0|1
        else {
            //READ New B0|1
            _(`finishedBlobs[${targetPartion}].addr <= `, nextTargetIndexBs[targetPartion]());

            //Save New B0|1 Index1
            _(`targetIndexBs[${targetPartion}] <= `, nextTargetIndexBs[targetPartion]());
        }
    }

    //Reset for New A OR Finish
    if (targetWillGetNewA()) {
        //Reset
        _("targetPartion <= 0");
        _("targetInitStep <= 0");
        _("targetGroupBJoined <= 0");

        //No B's Joined this A => Make Group Target into Target
        const groupTargetA: GroupTarget = isGroupTarget(targetBlobA) ? asGroupTarget(targetBlobA) : makeGroupTarget(targetBlobA);
        const targetA: Target = groupTargetToTarget(groupTargetA);
        const boundWidth: reg10 = (groupTargetA.boundBottomRight.x - groupTargetA.boundTopLeft.x + 1);
        const boundHeight: reg10 = (groupTargetA.boundBottomRight.y - groupTargetA.boundTopLeft.y + 1);
        const boundArea: BlobArea = boundWidth * boundHeight; //bound area of entire target
        const boundAreaValid: reg1 = inBoundAreaRange(boundArea, virtexConfig.targetBoundAreaMin, virtexConfig.targetBoundAreaMax);
        const aspectRatioValid: reg1 = inAspectRatioRange(boundWidth, boundHeight, virtexConfig.targetAspectRatioMin, virtexConfig.targetAspectRatioMax);
        const blobCountValid: reg1 = Math_inRangeInclusive(groupTargetA.blobCount, virtexConfig.targetBlobCountMin, virtexConfig.targetBlobCountMax);
        let justSetTargetCurrent: reg1 = 0;
        if (virtexConfig.targetMode == TargetMode.GROUP && !targetGroupBJoined && targetIndexA !== NULL_BLOB_INDEX) {
            if (boundAreaValid && aspectRatioValid && blobCountValid &&
                (isTargetNull(targetCurrent) || distSqToTargetCenter(targetA.center) < distSqToTargetCenter(targetCurrent.center))) {
                //Make Best Target
                _("targetCurrent <= ", targetA);
    
                //Flag Just Set
                justSetTargetCurrent = 1;
            }
        }

        //Finish
        if (nextTargetIndexA() >= trainFinishedIndex) {
            console.log(" > Target Selector Done < ");

            //transfer best target to target
            _("target <= ", targetCurrent);

            //flag
            _("targetSelectorDone <= 1");
        }

        //READ New A & B0|1 (if not end frame AND valid New B for DUAL mode)
        else if (nextInitTargetIndexB() !== NULL_BLOB_INDEX) {
            //READ New A on 1
            _("finishedBlobs[1].addr <= ", nextTargetIndexA());

            //Update State
            _("targetWantsNewA <= 0");
            _("targetPartion <= 1");
            _("targetInitStep <= 1");
        }
        
        //Set New A
        _("targetIndexA <= ", nextTargetIndexA());
    }

    //Nullify B0|1 (to reset for next loop)
    else if (targetWantsNewA) {
        _(`targetIndexBs[${targetPartion}] <= `, NULL_BLOB_INDEX);
    }
}
function distSqToTargetCenter(v: Vector2d10): reg20 {
    //Distance^2 Between Vector and Target Center
    return (v.x - virtexConfig.targetCenterX)**2 + (v.y - virtexConfig.targetCenterY)**2;
}
function doesBlobMatchCriteria(blob: BlobData): reg1 {
    const nonZero: reg1 = boolToReg1(blob.area !== 0);

    const boundWidth: reg10 = blob.boundBottomRight.x - blob.boundTopLeft.x;
    const boundHeight: reg10 = blob.boundBottomRight.y - blob.boundTopLeft.y;

    const aspectRatioValid: reg1 = inAspectRatioRange(boundWidth, boundHeight,
        virtexConfig.targetAspectRatioMin, virtexConfig.targetAspectRatioMax);

    const boundArea: BlobArea = boundWidth * boundHeight;
    const boundAreaValid: reg1 = inBoundAreaRange(boundArea,
        virtexConfig.blobBoundAreaMin, virtexConfig.blobBoundAreaMax);

    const fullnessValid: reg1 = inFullnessRange(blob.area, boundArea,
        virtexConfig.blobFullnessMin, virtexConfig.blobFullnessMax);

    const angleValid: reg1 = boolToReg1(virtexConfig.blobAnglesEnabled[(Object.keys(virtexConfig.blobAnglesEnabled) as Array<keyof BlobAnglesEnabled>)[calcBlobAngle(blob)]]);

    return nonZero && aspectRatioValid && boundAreaValid && fullnessValid && angleValid;
}

//Combinational Logic
function always_comb(): void {
    if (currentLineBuffer.count >= MAX_RUNS_PER_LINE) {
        faults.OUT_OF_RLE_MEM_FAULT = 1;
    }
}

//Global Reset for New Frame
function frameReset(): void {
    console.log(" --- FRAME RESET --- ");

    //Flag Reset
    _("justResetFrame <= 1");

    //Blob Maker Reset (everything else is reset in on New Line* updateBlobMaker())
    _("makerState <= MakerState.NONE");
    _("makerSkipCycle <= 0");
    _("makerJustResetLine <= 0");
    _("makerGrowingIndex <= 0");

    //Blob Train Reset
    _("trainFinishedIndex <= 0");
    _("trainGrowingIndex <= 0");
    _("trainPartion <= 0");
    _("trainInitDone <= 0");

    //Target Selector Reset
    _("targetCurrent <= ", makeZeroTarget());
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
        //TODO overflow on register size
        try { eval(`${assignment.name} = ${assignment.val};`); }
        catch (e) { console.error(`ERROR EVALUATING "${assignment.name}" TO "${assignment.val}"`); }
    }
    nonblockingQueue = [];
}
let isDone = () => Boolean(targetSelectorDone);
let getMakerGrowingIndex = () => makerGrowingIndex;
let getTrainFinishedIndex = () => trainFinishedIndex;
let getTarget = () => target;
let getBlobColorBuffer = () => blobColorBuffer;
let getFaults = () => faults;
let clearFaults = () => faults = {
    PYTHON_300_PLL_FAULT: 0,
    IR_LED_FAULT: 0,
    OUT_OF_BLOB_MEM_FAULT: 0,
    OUT_OF_RLE_MEM_FAULT: 0,
    BLOB_POINTER_DEPTH_FAULT: 0,
    BLOB_PROCESSOR_TOO_SLOW_FAULT: 0,
    MAX_TARGET_GROUP_SIZE_FAULT: 0
};
clearFaults();
export { always_ff, isDone, getMakerGrowingIndex, getTrainFinishedIndex, getTarget, getBlobColorBuffer, getFaults, clearFaults };