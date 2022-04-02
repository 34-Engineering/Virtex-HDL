`timescale 1ns / 1ps
`include "../python/PythonUtil.sv"
`include "BlobUtil.sv"
`include "../config/VirtexConfig.sv"

/* BlobProcessor V3
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
module BlobProcessor(
    input wire CLK288, CLK200,
    input Run runFIFOIn,
    input wire runFIFOWrite,
    output Target target,
    input VirtexConfig virtexConfig,
    output reg OUT_OF_BLOB_MEM_FAULT,
    output reg BLOB_POINTER_DEPTH_FAULT,
    output reg BLOB_PROCESSOR_SLOW_FAULT,
    output reg RUN_FIFO_FULL_FAULT
    );

    //Main (registers + wires)
    struct packed { BlobIndex addr; BlobData din, dout; logic we; } blobBRAMPorts [0:1] = '{'0, '0};
    wire runFIFOEmpty;
    reg runFIFORead;
    BlobData runFIFOOut;
    reg [9:0] lastLine = 10'd340; //init >0 so we know to reset on first frame
    reg justResetFrame = '0;

    //Blob Processor (registers + wires)
    typedef enum { NONE, SEARCH, MERGE, JOIN, JOIN_END, MAKE, DONE } BlobMakerState;
    BlobMakerState blobMakerState = NONE;
    reg blobSkipCycle = '0;
    reg blobJustResetLine = '0;
    BlobIndex blobIndex = '0;
    reg [MAX_BLOBS-1:0] blobGarbageList = '0;
    RunBuffer currentLineBuffer = '0;
    reg [9:0] currentLineBufferX = '0;
    RunBuffer lastLineBuffer = '0;
    wire BlobData currentRunAsBlob = runToBlob(currentLineBufferX, runFIFOOut.length, runFIFOOut.line);
    wire currentRunHasJoinedBlob = currentLineBuffer.runs[currentLineBuffer.count].blobIndex != NULL_BLOB_INDEX;

    //Target Selector (registers + wires)
    Target targetCurrent = '0;
    BlobData targetBlobA = '0;
    BlobAngle targetBlobAAngle = HORIZONTAL;
    wire GroupTarget groupTargetA = isGroupTarget(targetBlobA) ? asGroupTarget(targetBlobA) : makeGroupTarget(targetBlobA);
    wire Target targetA = groupTargetToTarget(groupTargetA);
    reg [1:0] targetInitStep = '0; //0-2: init, 3: done
    reg targetPartion = '0; //alterates every cycle
    BlobIndex targetIndexA = NULL_BLOB_INDEX;
    BlobIndex [0:1] targetIndexBs = '{NULL_BLOB_INDEX, NULL_BLOB_INDEX}; //B0|1 (alternates, so one is waiting for read delay & the other is proc)
    reg targetWantsNewA = 1; //wants to get a new A (takes 2 cycles)
    wire targetWillGetNewA = targetWantsNewA & targetIndexBs[0] == NULL_BLOB_INDEX & targetIndexBs[1] == NULL_BLOB_INDEX; //we have wanted a new A, but now we are ready
    wire BlobIndex firstTargetIndex = getNextValidTargetIndex(0);
    wire BlobIndex nextTargetIndexAUnaccounted = getNextValidTargetIndex(targetIndexA+1);
    wire BlobIndex nextTargetIndexA = (targetIndexA == NULL_BLOB_INDEX |
        (virtexConfig.targetMode == GROUP & nextTargetIndexAUnaccounted == NULL_BLOB_INDEX)) ?
        firstTargetIndex : nextTargetIndexAUnaccounted; //@ start frame => first, @ group end => overflow (if > 1 valid blobs left), else => next index
    wire BlobIndex initTargetIndexB = (virtexConfig.targetMode == GROUP & firstTargetIndex != targetIndexA) ? firstTargetIndex : nextTargetIndexA; //first B index (with overlap protection)
    wire BlobIndex nextInitTargetIndexB = (virtexConfig.targetMode == GROUP & firstTargetIndex != nextTargetIndexA & firstTargetIndex != targetIndexA) ?
        firstTargetIndex : getNextValidTargetIndex(nextTargetIndexA+1); //calculate next init index B so we know if the next A should be skipped
    wire BlobIndex [0:1] nextTargetIndexBsUnaccounted = '{ //unaccounted for possible overlap with targetIndexA
        getNextValidTargetIndex(targetIndexBs[1]+1), //opposite so they will skip ahead of eachother (AKA: (0,1), (2,3) ...)
        getNextValidTargetIndex(targetIndexBs[0]+1)
    };
    wire BlobIndex [0:1] nextTargetIndexBs = '{
        (nextTargetIndexBsUnaccounted[0] == targetIndexA) ? getNextValidTargetIndex(nextTargetIndexBsUnaccounted[0]+1) : nextTargetIndexBsUnaccounted[0], //prevent A index overlap
        (targetInitStep == 1) ? initTargetIndexB : //init B index @ value
        (nextTargetIndexBsUnaccounted[1] == targetIndexA) ? getNextValidTargetIndex(nextTargetIndexBsUnaccounted[1]+1) : nextTargetIndexBsUnaccounted[1]
    };
    reg targetGroupBJoined = '0;
    wire noTargetIndexAsLeft = nextTargetIndexA == NULL_BLOB_INDEX;
    reg targetSingleAlmostDone = '0; //will be done next loop (single mode only)
    reg targetSelectorDone = '0;

    //200MHz Clocked Loop
    always_ff @(negedge CLK200) begin
        //defaults & counters
        blobBRAMPorts[0].we <= 0;
        blobBRAMPorts[1].we <= 0;
        lastLine <= runFIFOOut.line;
        justResetFrame <= 0;
        runFIFORead <= 0;
        blobSkipCycle <= 0;
        blobJustResetLine <= 0;

        //Reset @ New Frame
        if (runFIFOOut.line == 0 && lastLine != 0) begin
            frameReset();
        end

        //Update Blob Maker
        else if (blobMakerState != DONE) begin
            updateBlobMaker();
        end
        
        else begin
            //Read from FIFO
            if (~runFIFOEmpty) begin
                runFIFORead <= 1;
                if (~targetSelectorDone) begin
                    faults.BLOB_PROCESSOR_TOO_SLOW_FAULT = 1;
                end
            end

            //Update Target Selector
            else if (~targetSelectorDone) begin
                updateTargetSelector();
            end
        end
    end

    //Blob Maker (runs => blobs)
    task updateBlobMaker();
        //New Line*
        if (runFIFOOut.line != lastLine) begin
            //flag reset
            blobJustResetLine <= 1;

            //transfer current line buffer => last line buffer
            if (runFIFOOut.line != 0) begin
                lastLineBuffer <= currentLineBuffer;
            end

            //reset current line buffer
            currentLineBufferX <= 0;
            currentLineBuffer.count <= 0;
            currentLineBuffer.runs[0] <= '{start:0, stop:0, blobIndex:NULL_BLOB_INDEX};
            currentLineBuffer.line <= runFIFOOut.line;
        end

        else if (~blobSkipCycle) begin
            //New Run*
            if (blobMakerState == NONE) begin
                //Process FIFO Read
                if (runFIFORead | blobJustResetLine | justResetFrame) begin
                    //Run is Black => Continue
                    if (runFIFOOut.black) begin
                        currentLineBuffer.runs[currentLineBuffer.count] <= '{
                            start: currentLineBufferX,
                            stop: currentLineBufferX + runFIFOOut.length - 1,
                            blobIndex: NULL_BLOB_INDEX
                        };
                        
                        blobFinishRun();
                    end
                    
                    //Run is White => Search & Join OR Make new Blob
                    else if (runFIFOOut.line > 0) begin
                        blobMakerState <= SEARCH;
                        updateOnBlobMakerState(SEARCH);
                    end

                    //Run is White (and no line above) => Make new Blob
                    else begin
                        blobMakerState <= MAKE;
                        updateOnBlobMakerState(MAKE);
                    end
                end

                //Read from FIFO
                else if (~runFIFOEmpty) begin
                    runFIFORead <= 1;
                end
            end

            //Working on Run
            else updateOnBlobMakerState(blobMakerState);
        end
    endtask
    task updateOnBlobMakerState(BlobMakerState ustate);
        //Search through runs from last line & Check if this run is touching them
        if (ustate == SEARCH) begin
            //defaults
            if (currentRunHasJoinedBlob) begin
                blobMakerState <= JOIN_END;
            end
            else blobMakerState <= MAKE;

            //Search
            for (int i = 0; i < MAX_RUNS_PER_LINE; i++) begin
                if (i < lastLineBuffer.count & lastLineBuffer.runs[i].blobIndex != NULL_BLOB_INDEX & //if valid index in lastLineBuffer
                    runsOverlap(currentLineBufferX, currentLineBufferX + runFIFOOut.length - 1, //if this run is touching it
                        lastLineBuffer.runs[i].start, lastLineBuffer.runs[i].stop))
                begin
                    static BlobIndex iBlobIndex = lastLineBuffer.runs[i].blobIndex;

                    //First touching run => Join it's blob
                    if (~currentRunHasJoinedBlob) begin
                        //set new state
                        blobMakerState <= JOIN;

                        //read Blob from BRAM
                        blobBRAMPorts[0].addr <= iBlobIndex;
                        blobSkipCycle <= 1;
                    end

                    //2nd+ touching run => Merge this blob with master blob
                    else if (iBlobIndex != currentLineBuffer.runs[currentLineBuffer.count].blobIndex) begin
                        // set new state
                        blobMakerState <= MERGE;

                        // read Blobs from BRAM
                        blobBRAMPorts[0].addr <= currentLineBuffer.runs[currentLineBuffer.count].blobIndex;
                        blobBRAMPorts[1].addr <= iBlobIndex;
                        blobSkipCycle <= 1;
                    end
                end
            end
        end
        
        //Join Blob
        else if (ustate == JOIN) begin
            //write back to BRAM
            blobBRAMPorts[0].din <= mergeBlobs(currentRunAsBlob, blobBRAMPorts[0].dout);
            blobBRAMPorts[0].we <= 1;

            //save to current line run buffer
            currentLineBuffer.runs[currentLineBuffer.count] <= '{
                start: currentLineBufferX,
                stop: currentLineBufferX + runFIFOOut.length - 1,
                blobIndex: blobBRAMPorts[0].addr
            };

            //go back to searching
            blobMakerState <= SEARCH;
        end

        //Merge two intersecting Blobs (U/V/W Case)
        else if (ustate == MERGE) begin
            //flag slave as garbage
            blobGarbageList[blobBRAMPorts[1].addr] <= 1;

            //update all pointers to slave
            for (int i = 0; i < MAX_RUNS_PER_LINE; i++) begin
                if (lastLineBuffer.runs[i].blobIndex == blobBRAMPorts[1].addr) begin
                    lastLineBuffer.runs[i].blobIndex <= blobBRAMPorts[0].addr;
                end
            end

            //write back master to BRAM
            blobBRAMPorts[0].din <= mergeBlobs(blobBRAMPorts[1].dout, blobBRAMPorts[0].dout);
            blobBRAMPorts[0].we <= 1;

            //go back to searching
            blobMakerState <= SEARCH;
        end

        //Join End (had joined a blob & is done now)
        else if (ustate == JOIN_END) begin
            blobFinishRun();
        end

        //Make new Blob
        else if (ustate == MAKE) begin
            //write to BRAM
            blobBRAMPorts[0].din <= currentRunAsBlob;
            blobBRAMPorts[0].addr <= blobIndex;
            blobBRAMPorts[0].we <= 1;

            //flag not garbage
            blobGarbageList[blobIndex] <= 0;

            //save to current line run buffer
            currentLineBuffer.runs[currentLineBuffer.count] <= '{
                start: currentLineBufferX,
                stop: currentLineBufferX + runFIFOOut.length - 1,
                blobIndex: blobIndex
            };

            //increment blob counter
            blobIndex <= blobIndex + 1;

            //prepare for new run
            blobFinishRun();
        end
    endtask
    task blobFinishRun();
        //prepare for new run
        currentLineBufferX <= currentLineBufferX + runFIFOOut.length;
        currentLineBuffer.count <= currentLineBuffer.count + 1;
        currentLineBuffer.runs[currentLineBuffer.count+1] <= '{start:0, stop:0, blobIndex:NULL_BLOB_INDEX};

        //reset state
        blobMakerState <= NONE;

        //finish
        if ((currentLineBufferX + runFIFOOut.length - 1) == (IMAGE_WIDTH-1) & runFIFOOut.line == IMAGE_HEIGHT-1) begin
            blobMakerState <= DONE;
        end
        
        //read new run
        else if (~runFIFOEmpty) begin
            runFIFORead <= 1;
        end
    endtask

    //Target Selector (blobs => target)
    task updateTargetSelector();
        //Increment Init Step
        if (targetInitStep != 3) begin
            targetInitStep <= targetInitStep+1;
        end

        //Swap Partion
        targetPartion <= ~targetPartion;

        //Update Respective Modes
        if (virtexConfig.targetMode == SINGLE) begin
            updateTargetSelectorSingle();
        end
        else begin
            updateTargetSelectorDualGroup();
        end
    endtask
    task updateTargetSelectorDualGroup();
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
        if (targetInitStep == 2) begin
            static BlobData newTargetBlobA = blobBRAMPorts[1].dout;
            static BlobAngle newTargetBlobAAngle = calcBlobAngle(newTargetBlobA);

            //Garbage A => Skip & Flag Garbage
            if (~doesBlobMatchCriteria(newTargetBlobA)) begin
                //Flag Garbage
                blobGarbageList[targetIndexA] <= 1;
        
                //Request New A
                targetWantsNewA <= 1;
        
                //Nullify B0&1
                targetIndexBs[0] <= NULL_BLOB_INDEX;
                targetIndexBs[1] <= NULL_BLOB_INDEX;
            end

            targetBlobAAngle <= newTargetBlobAAngle;
            targetBlobA <= newTargetBlobA;
        end

        //PROCESS
        if (targetInitStep == 3 & ~blobGarbageList[targetIndexA] & targetIndexBs[targetPartion] != NULL_BLOB_INDEX) begin
            //Get Blob
            static BlobData targetBlobB = blobBRAMPorts[targetPartion].dout;
            static BlobAngle targetBlobBAngle = calcBlobAngle(targetBlobB);

            //Skip & Flag Garbage
            if (~doesBlobMatchCriteria(targetBlobB)) begin
                blobGarbageList[blobBRAMPorts[targetPartion].addr] <= 1;
            end

            //GROUP: chain other blobs together starting a Blob A
            else if (virtexConfig.targetMode == GROUP) begin
                //gap between
                static reg [9:0] gapX = Math_diff(targetBlobA.boundTopLeft.x, targetBlobB.boundBottomRight.x);
                static reg [9:0] gapY = Math_diff(targetBlobA.boundTopLeft.y, targetBlobB.boundBottomRight.y);
                static reg gapValid = Math_inRangeInclusive(gapX, virtexConfig.targetBlobXGapMin, virtexConfig.targetBlobXGapMax) &
                    Math_inRangeInclusive(gapY, virtexConfig.targetBlobYGapMin, virtexConfig.targetBlobYGapMax);
                
                //ratio between the bound area of the two blobs (if either is a group target, then it will used the cashed bound area)
                static GroupTarget groupTargetB = isGroupTarget(targetBlobB) ? asGroupTarget(targetBlobB) : makeGroupTarget(targetBlobB);
                static reg blobsBoundAreaRatioValid = inBoundAreaRatioRange(groupTargetA.blobBoundArea, groupTargetB.blobBoundArea,
                    virtexConfig.targetBoundAreaRatioMin, virtexConfig.targetBoundAreaRatioMax);

                //join A & B
                if (gapValid & blobsBoundAreaRatioValid) begin
                    //make new group target
                    static GroupTarget newGroupTarget = mergeGroupTargets(groupTargetA, groupTargetB);

                    //write back to A BRAM & cache
                    static BlobData newTargetBlobA = asBlob(newGroupTarget);
                    targetBlobA <= newTargetBlobA;
                    blobBRAMPorts[~targetPartion].din <= newTargetBlobA;
                    blobBRAMPorts[~targetPartion].addr <= targetIndexA;
                    blobBRAMPorts[~targetPartion].we <= 1;

                    //garbage B
                    blobGarbageList[targetIndexBs[targetPartion]] <= 1;

                    //Flag B Joined
                    targetGroupBJoined <= 1;
                end
            end

            //DUAL: make all combinations of two blobs
            else begin
                //pick left & right
                static reg [9:0] targetBlobACenterX = (targetBlobA.boundTopLeft.x + targetBlobA.boundBottomRight.x) >> 1;
                static reg [9:0] blobBCenterX       = (targetBlobB.boundTopLeft.x + targetBlobB.boundBottomRight.x) >> 1;
                static BlobData leftBlob        = targetBlobACenterX < blobBCenterX ? targetBlobA : targetBlobB;
                static BlobAngle leftBlobAngle  = targetBlobACenterX < blobBCenterX ? targetBlobAAngle : targetBlobBAngle;
                static BlobData rightBlob       = targetBlobACenterX < blobBCenterX ? targetBlobB : targetBlobA;
                static BlobAngle rightBlobAngle = targetBlobACenterX < blobBCenterX ? targetBlobBAngle : targetBlobAAngle;

                //make enclosing bound
                static Math::Vector2d10 topLeft = '{
                    x: Math_min(leftBlob.boundTopLeft.x, rightBlob.boundTopLeft.x),
                    y: Math_min(leftBlob.boundTopLeft.y, rightBlob.boundTopLeft.y)
                };
                static Math::Vector2d10 bottomRight = '{
                    x: Math_max(leftBlob.boundBottomRight.x, rightBlob.boundBottomRight.x),
                    y: Math_max(leftBlob.boundBottomRight.y, rightBlob.boundBottomRight.y)
                };
                static Math::Vector2d10 center = '{
                    x: (topLeft.x + bottomRight.x) >> 1,
                    y: (topLeft.y + bottomRight.y) >> 1
                };
                static reg [9:0] width  = bottomRight.x - topLeft.x + 1;
                static reg [9:0] height = bottomRight.y - topLeft.y + 1;

                //if left/right blob angles are valid
                static reg angleValid = virtexConfig.targetMode == DUAL_UP ?
                    leftBlobAngle == FORWARD & rightBlobAngle == BACKWARD :
                    virtexConfig.targetMode == DUAL_DOWN ?
                    leftBlobAngle == BACKWARD & rightBlobAngle == FORWARD : 1;

                //gap between target & blobB
                static reg [9:0] gapX = Math_diff(rightBlob.boundTopLeft.x, leftBlob.boundBottomRight.x);
                static reg [9:0] gapY = Math_diff(rightBlob.boundTopLeft.y, leftBlob.boundBottomRight.y);
                static reg gapValid = Math_inRangeInclusive(gapX, virtexConfig.targetBlobXGapMin, virtexConfig.targetBlobXGapMax) &
                    Math_inRangeInclusive(gapY, virtexConfig.targetBlobYGapMin, virtexConfig.targetBlobYGapMax);

                //aspect ratio of new target
                static reg aspectRatioValid = inAspectRatioRange(width, height,
                    virtexConfig.targetAspectRatioMin, virtexConfig.targetAspectRatioMax);

                //bound area of new target
                static reg boundAreaValid = inBoundAreaRange(width * height,
                    virtexConfig.targetBoundAreaMin, virtexConfig.targetBoundAreaMax);

                //area ratio between two blobs
                static BlobArea boundAreaLeft = (leftBlob.boundBottomRight.x - leftBlob.boundTopLeft.x + 1) * (leftBlob.boundBottomRight.y - leftBlob.boundTopLeft.y + 1);
                static BlobArea boundAreaRight = (rightBlob.boundBottomRight.x - rightBlob.boundTopLeft.x + 1) * (rightBlob.boundBottomRight.y - rightBlob.boundTopLeft.y + 1);
                static reg boundAreaRatioValid = inBoundAreaRatioRange(boundAreaRight, boundAreaLeft,
                    virtexConfig.targetBoundAreaRatioMin, virtexConfig.targetBoundAreaRatioMax);
                
                //if this target is valid AND this target is better OR we dont have a target yet
                if (angleValid & gapValid & aspectRatioValid & boundAreaValid & boundAreaRatioValid &
                    (isTargetNull(targetCurrent) | distSqToTargetCenter(center) < distSqToTargetCenter(targetCurrent.center))) begin
                    targetCurrent <= '{
                        center: center,
                        width: width,
                        height: height,
                        blobCount: 2,
                        angle: leftBlobAngle
                    };
                end
            end
        end

        //READ
        if (targetInitStep != 0 & ~targetWantsNewA) begin
            //Request New A
            if (nextTargetIndexBs[targetPartion] == NULL_BLOB_INDEX) begin
                //Request New A (we must request because we have to wait for last B to finish processing)
                targetWantsNewA <= 1;

                //Nullify B0|1
                targetIndexBs[targetPartion] <= NULL_BLOB_INDEX;
            end

            //READ New B0|1
            else begin
                //READ New B0|1
                blobBRAMPorts[targetPartion].addr <= nextTargetIndexBs[targetPartion];

                //Save New B0|1 Index1
                targetIndexBs[targetPartion] <= nextTargetIndexBs[targetPartion];
            end
        end

        //Reset for New A OR Finish
        if (targetWillGetNewA) begin
            //No B's Joined this A => Make Group Target into Target
            static reg [9:0] boundWidth = (groupTargetA.boundBottomRight.x - groupTargetA.boundTopLeft.x + 1);
            static reg [9:0] boundHeight = (groupTargetA.boundBottomRight.y - groupTargetA.boundTopLeft.y + 1);
            static BlobArea boundArea = boundWidth * boundHeight; //bound area of entire target
            static reg boundAreaValid = inBoundAreaRange(boundArea, virtexConfig.targetBoundAreaMin, virtexConfig.targetBoundAreaMax);
            static reg aspectRatioValid = inAspectRatioRange(boundWidth, boundHeight, virtexConfig.targetAspectRatioMin, virtexConfig.targetAspectRatioMax);
            static reg blobCountValid = Math_inRangeInclusive(groupTargetA.blobCount, virtexConfig.targetBlobCountMin, virtexConfig.targetBlobCountMax);
            static reg justSetTargetCurrent = 0;
            if (virtexConfig.targetMode == GROUP & ~targetGroupBJoined & targetIndexA != NULL_BLOB_INDEX) begin
                if (boundAreaValid & aspectRatioValid & blobCountValid &
                    (isTargetNull(targetCurrent) | distSqToTargetCenter(targetA.center) < distSqToTargetCenter(targetCurrent.center))) begin
                    //Make Best Target
                    targetCurrent <= targetA;
        
                    //Flag Just Set
                    justSetTargetCurrent = 1;
                end

                //Flag A as Garbage (so it doesn't come back)
                blobGarbageList[targetIndexA] <= 1;
            end

            //Reset
            targetPartion <= 0;
            targetInitStep <= 0;
            targetGroupBJoined <= 0;

            //Finish
            if (noTargetIndexAsLeft) begin
                //transfer best target to target
                target <= targetCurrent;

                //flag
                targetSelectorDone <= 1;
            end

            //READ New A & B0|1 (if not end frame AND valid New B for DUAL mode)
            else if (nextInitTargetIndexB != NULL_BLOB_INDEX) begin
                //READ New A on 1
                blobBRAMPorts[1].addr <= nextTargetIndexA;

                //Update State
                targetWantsNewA <= 0;
                targetPartion <= 1;
                targetInitStep <= 1;
            end
            
            //Set New A
            targetIndexA <= nextTargetIndexA;
        end

        //Nullify B0|1 (to reset for next loop)
        else if (targetWantsNewA) begin
            targetIndexBs[targetPartion] <= NULL_BLOB_INDEX;
        end
    endtask
    task updateTargetSelectorSingle();
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
        if (targetSingleAlmostDone) begin
            //transfer best target to target
            target <= targetCurrent;

            //flag
            targetSelectorDone <= 1;
        end

        //PROCESS
        if (targetInitStep > 1) begin
            static BlobData blob = blobBRAMPorts[targetPartion].dout;

            //PROCESS
            if (doesBlobMatchCriteria(blob)) begin
                //Convert Blob A Bounding Box from TopLeft/BottomRight => Center/Width/Height
                static Math::Vector2d10 center = '{
                    x: (blob.boundBottomRight.x + blob.boundTopLeft.x) >> 1,
                    y: (blob.boundBottomRight.y + blob.boundTopLeft.y) >> 1
                };
                static reg [9:0] width  = blob.boundBottomRight.x - blob.boundTopLeft.x + 1;
                static reg [9:0] height = blob.boundBottomRight.y - blob.boundTopLeft.y + 1;

                //aspect ratio valid
                static reg aspectRatioValid = inAspectRatioRange(width, height,
                    virtexConfig.targetAspectRatioMin, virtexConfig.targetAspectRatioMax);

                //bound area valid
                static reg boundAreaValid = inBoundAreaRange(width * height,
                    virtexConfig.targetBoundAreaMin, virtexConfig.targetBoundAreaMax);

                //if this target is valid AND this target is better OR we dont have a target yet
                if (aspectRatioValid & boundAreaValid &
                    (isTargetNull(targetCurrent) | distSqToTargetCenter(center) < distSqToTargetCenter(targetCurrent.center))) begin
                    targetCurrent <= '{
                        center: center,
                        width: width,
                        height: height,
                        blobCount: 1,
                        angle: calcBlobAngle(blob)
                    };
                end
            end

            //Skip & Flag Garbage
            else begin
                blobGarbageList[blobBRAMPorts[targetPartion].addr] <= 1;
            end
        end

        //READ
        if (~targetSingleAlmostDone) begin
            //Finish
            if (nextTargetIndexA == NULL_BLOB_INDEX) begin
                //flag almost done so we can come back last loop and process ~targetPartion
                targetSingleAlmostDone <= 1;
            end

            //READ
            else begin
                blobBRAMPorts[targetPartion].addr <= nextTargetIndexA;
                targetIndexA <= nextTargetIndexA;
            end
        end
    endtask
    function automatic logic [19:0] distSqToTargetCenter(Math::Vector2d10 v);
        //Distance^2 Between Vector and Target Center
        return (v.x - virtexConfig.targetCenterX)**2 + (v.y - virtexConfig.targetCenterY)**2;
    endfunction
    function automatic logic doesBlobMatchCriteria(BlobData blob);
        reg [9:0] boundWidth  = blob.boundBottomRight.x - blob.boundTopLeft.x;
        reg [9:0] boundHeight = blob.boundBottomRight.y - blob.boundTopLeft.y;

        reg aspectRatioValid = inAspectRatioRange(boundWidth, boundHeight,
            virtexConfig.targetAspectRatioMin, virtexConfig.targetAspectRatioMax);

        BlobArea boundArea = boundWidth * boundHeight;
        reg boundAreaValid = inBoundAreaRange(boundArea,
            virtexConfig.blobBoundAreaMin, virtexConfig.blobBoundAreaMax);

        reg fullnessValid = inFullnessRange(blob.area, boundArea,
            virtexConfig.blobFullnessMin, virtexConfig.blobFullnessMax);

        reg angleValid = virtexConfig.blobAnglesEnabled[calcBlobAngle(blob)];

        return aspectRatioValid & boundAreaValid & fullnessValid & angleValid;
    endfunction
    function automatic BlobIndex getNextValidTargetIndex(BlobIndex startIndex);
        //find next valid blob >= startIndex (and < blobIndex because anything above that is invalid)
        for (int i = 0; i < MAX_BLOBS; i++) begin
            if (i >= startIndex & i < blobIndex & ~blobGarbageList[i]) begin
                return i;
            end
        end
        return NULL_BLOB_INDEX;
    endfunction

    //Fault Logic
    always_comb begin
        if (blobIndex >= NULL_BLOB_INDEX) begin
            faults.OUT_OF_BLOB_MEM_FAULT = 1;
        end
        if (currentLineBuffer.count >= MAX_RUNS_PER_LINE) begin
            faults.OUT_OF_RLE_MEM_FAULT = 1;
        end
    end

    //Global Reset for New Frame
    task frameReset();
        //Flag Reset
        justResetFrame <= 1;

        //Blob Maker Reset (everything else is reset in on New Line* updateBlobMaker())
        blobIndex <= 0;
        blobSkipCycle <= 0;
        blobMakerState <= NONE;

        //Target Selector Reset
        targetCurrent <= '0;
        targetIndexA <= NULL_BLOB_INDEX;
        targetWantsNewA <= 1;
        targetIndexBs <= '{NULL_BLOB_INDEX, NULL_BLOB_INDEX};
        targetInitStep <= 0;
        targetPartion <= 0;
        targetSingleAlmostDone <= 0;
        targetSelectorDone <= 0;
    endtask

    //FIFO + BRAM IP
    blk_mem_blobs blk_mem_blobs (
        .addra(blobBRAMPorts[0].addr),
        .clka(CLK200),
        .dina(blobBRAMPorts[0].din),
        .douta(blobBRAMPorts[0].dout),
        .wea(blobBRAMPorts[0].we),
        .addrb(blobBRAMPorts[1].addr),
        .clkb(CLK200),
        .dinb(blobBRAMPorts[1].din),
        .doutb(blobBRAMPorts[1].dout),
        .web(blobBRAMPorts[1].we)
    );
    wire runFIFOFull;
    fifo_python_to_blob fifo_python_to_blob (
        .full(runFIFOFull),
        .din(runFIFOIn),
        .wr_en(runFIFOWrite),
        .wr_clk(CLK288),
        .empty(runFIFOEmpty),
        .dout(runFIFOOut),
        .rd_en(runFIFORead),
        .rd_clk(CLK200),
        .rst(1'b0)
    );
    always_comb if (runFIFOFull) RUN_FIFO_FULL_FAULT = 1;
endmodule