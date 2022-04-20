`timescale 1ns / 1ps
`include "../python/PythonUtil.sv"
`include "VisionUtil.sv"
`include "../config/VirtexConfig.sv"

/* VisionProcessor V4
The Vision Processor is a multi-functional module that takes in a run length
encoded image frame (through a FIFO), locates regional blobs, and selects
a target included one of multiple of the blobs.

Nomenclature:
 Blob: an isolated white region in the image
  - Bounding Box: the minimum non-rotated rectangle that covers all pixels in the blob
  - Quad: a quadrilateral made from the four most extreme points in the blob (used for rough angle calculations)
 Target: a blob or group of blobs

Stages:
 1) Blob Maker: process runs from FIFO into blobs in "growing" BRAM
     -> Blob making is a process where blobs are "grown" to cover an entire isolated
        white region of the image. Isolated regions are first spotted by runs that
        are not touching any another run in the line above them, then following
        runs that are touching it are joined onto its blob and the blob
        is expanded to cover the entire region.
        The Blob making process also has to merge blobs in certain region
        shapes like U, V, W, etc. This is because the regions are initially
        seen as two separate blobs but later found to be part of the same region.

 2) Blob Train: tranfers unorganized blobs from "growing" BRAM to organized "finished" BRAM

 3) Target Selector: make a target from "finished" BRAM
     -> SINGLE (occurs in parallel w/ training process):
         - loop through every blob
            - set as targetCurrent if closer to center than targetCurrent
         - save targetCurrent->target
     -> DUAL:
         - loop through every blob (A)
            - loop through every blob with indexes >A (B)
            - make a target from A & B
               - set as targetCurrent if closer to center than targetCurrent
         - set target=targetCurrent
     -> DUAL:
         - swap between BRAMs until there are 0 blobs left in the current BRAM
            - read blob 0 (A)
            - loop through every blob with indexes >0 (B)
               - attempt to join A & set as targetCurrent if closer to center than targetCurrent
               - copy to next slot in other BRAM
     -> GROUP:
         - swap between BRAMs until there are 0 blobs left in the current BRAM
            - read blob 0 (A)
               - convert blob -> "group target" (which can represent multiple blobs but still be saved in blob BRAM)
            - loop through every blob with indexes >0 (B)
               - attempt to join A
                  - if can't -> copy to next slot in other BRAM
            - if no B's joined this A
               - set as targetCurrent if closer to center than targetCurrent
            - else save new "group target" to next slot in other BRAM

Note: The BRAM IP optional registers added which causes a 2 clock cycle read delay
 -> cycle 1 (request): old data
 -> cycle 2: old data
 -> cycle 3: new data

*/
module VisionProcessor(
    input wire CLK288, CLK200,
    input Run runFIFOIn,
    input wire runFIFOWrite,
    output Target target,
    input VirtexConfig virtexConfig,
    output reg OUT_OF_BLOB_MEM_FAULT,
    output reg OUT_OF_RLE_MEM_FAULT, //TODO add to faults
    output reg BLOB_PROCESSOR_SLOW_FAULT,
    output reg RUN_FIFO_FULL_FAULT
    );

    reg [9:0] lastLine = 10'd340; //init >0 so we know to reset on first frame
    reg justResetFrame = '0;

    //Run FIFO
    wire runFIFOEmpty;
    reg runFIFORead;
    Run runFIFOOut;

    //Blob BRAM
    typedef struct packed { BlobIndex addr; BlobData din, dout; logic we; } BlobBRAMPorts;
    BlobBRAMPorts bramPorts [0:3] = '{'0, '0, '0, '0}; //0=growingA,1=growingB,2=finishedA,3=finishedB

    //Blob Maker
    typedef enum { NONE, SEARCH, MERGE, JOIN, JOIN_END, MAKE, DONE } MakerState;
    MakerState makerState = NONE;
    reg makerSkipCycle = '0;
    reg makerJustResetLine = '0;
    BlobIndex makerGrowingIndex = '0;
    
    RunBuffer currentLineBuffer = '0;
    reg [9:0] currentLineBufferX = '0;
    RunBuffer lastLineBuffer = '0;
    wire BlobData currentRunAsBlob = runToBlob(currentLineBufferX, runFIFOOut.length, runFIFOOut.line);
    wire currentRunHasJoinedBlob = currentLineBuffer.runs[currentLineBuffer.count].blobIndex != NULL_BLOB_INDEX;

    //Blob Train
    BlobIndex trainFinishedIndex = '0;
    BlobIndex trainGrowingIndex = '0;
    wire trainAlmostDone = trainGrowingIndex == (makerGrowingIndex+1);
    wire trainDone = trainGrowingIndex == (makerGrowingIndex+2); //+2 because the train needs to finish the last index
    reg trainPartion = '0;
    reg trainInitDone = '0;

    //Target Selector
    initial target = '0; //"best" target for the last frame
    Target targetCurrent = '0; //"best" target for the current frame
    BlobData targetBlobA = '0; //cached blob A
    BlobAngle targetBlobAAngle = HORIZONTAL;
    reg [1:0] targetInitStep = 0; //0-2: init, 3: done
    reg targetPartion = 0; //alterates every cycle
    BlobIndex [0:1] targetIndexBs = '{NULL_BLOB_INDEX, NULL_BLOB_INDEX}; //B0|1 (alternates, so one is waiting for read delay & the other is proc)
    reg targetWantsNewA = 1; //wants to get a new A (takes 2 cycles)
    wire targetWillGetNewA = targetWantsNewA && targetIndexBs[0] == NULL_BLOB_INDEX && targetIndexBs[1] == NULL_BLOB_INDEX && targetInitStep != 2; //we have wanted a new A, but now we are ready
    reg targetGroupBJoined = 0; //whether any Bs joined cur targetA
    reg targetSelectorDone = 0;
    reg targetBRAMNumber = 0; //which BRAM to use (0=growing, 1=finished)
    BlobIndex [0:1] targetBRAMEnds = '{0, 0}; //max index we can go to +1 (5 -> [0:4])
    wire [1:0] targetBRAMOffset      = targetBRAMNumber ? 2 : 0;
    wire [1:0] targetBRAMOffsetOther = targetBRAMNumber ? 0 : 2;
    `define fixTargetIndex(index, bramNum) (index < targetBRAMEnds[bramNum]) ? index : NULL_BLOB_INDEX
    wire BlobIndex initTargetIndexB = `fixTargetIndex(1, targetBRAMNumber);
    wire BlobIndex [0:1] nextTargetIndexBs = '{
        `fixTargetIndex(targetIndexBs[1] + 1, targetBRAMNumber), //targetIndexBs opposite so they will skip ahead of eachother (0,1),(2,3)...
        (targetInitStep == 1) ? initTargetIndexB : `fixTargetIndex(targetIndexBs[0] + 1, targetBRAMNumber)
    };

    //(sim only)
    int fd;
    bit fd_closed = 0;
    initial begin
        fd = $fopen("../../../../Typescript/VisionDebugger/output.txt", "w");
        if (!fd) begin $display(" <===> ERROR OPENING FILE <===>"); end
    end

    //200MHz Clocked Loop
    always_ff @(negedge CLK200) begin
        bramPorts[0].we <= 0;
        bramPorts[1].we <= 0;
        bramPorts[2].we <= 0;
        bramPorts[3].we <= 0;
        lastLine <= runFIFOOut.line;
        justResetFrame <= 0;
        runFIFORead <= 0;
        makerSkipCycle <= 0;
        makerJustResetLine <= 0;

        //Reset @ New Frame
        if (runFIFOOut.line == 0 && lastLine != 0) begin
            frameReset();
        end

        //Update Blob Maker (Stage 1)
        else if (makerState != DONE) begin
            updateBlobMaker();
        end
        
        //Read from FIFO
        else if (~runFIFOEmpty) begin
            runFIFORead <= 1;
            if (~targetSelectorDone) begin
                BLOB_PROCESSOR_SLOW_FAULT <= 1;
            end
        end

        //Update Blob Train (Stage 2)
        else if (~trainDone) begin
            updateBlobTrain();
        end

        //Update Target Selector (Stage 3)
        else if (~targetSelectorDone) begin
            if (virtexConfig.targetMode == SINGLE) begin
                targetSelectorDone <= 1;
            end
            else updateTargetSelectorDualGroup();
        end

        //(sim only)
        else if (~fd_closed) begin $fclose(fd); fd_closed = 1; end
    end

    //Blob Maker (runs => blobs)
    task updateBlobMaker();
        //New Line*
        if (runFIFOOut.line != lastLine) begin
            //flag reset
            makerJustResetLine <= 1;

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

        else if (~makerSkipCycle) begin
            //New Run*
            if (makerState == NONE) begin
                //Process FIFO Read
                if (runFIFORead | makerJustResetLine | justResetFrame) begin
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
                        makerState <= SEARCH;
                        updateOnMakerState(SEARCH);
                    end

                    //Run is White (and no line above) => Make new Blob
                    else begin
                        makerState <= MAKE;
                        updateOnMakerState(MAKE);
                    end
                end

                //Read from FIFO
                else if (~runFIFOEmpty) begin
                    runFIFORead <= 1;
                end
            end

            //Working on Run
            else updateOnMakerState(makerState);
        end
    endtask
    task updateOnMakerState(MakerState ustate);
        //Search through runs from last line & Check if this run is touching them
        if (ustate == SEARCH) begin
            //defaults
            if (currentRunHasJoinedBlob) begin
                makerState <= JOIN_END;
            end
            else makerState <= MAKE;

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
                        makerState <= JOIN;

                        //read Blob from BRAM
                        bramPorts[0].addr <= iBlobIndex;
                        makerSkipCycle <= 1;
                    end

                    //2nd+ touching run => Merge this blob with master blob
                    else if (iBlobIndex != currentLineBuffer.runs[currentLineBuffer.count].blobIndex) begin
                        // set new state
                        makerState <= MERGE;

                        // read Blobs from BRAM
                        bramPorts[0].addr <= currentLineBuffer.runs[currentLineBuffer.count].blobIndex;
                        bramPorts[1].addr <= iBlobIndex;
                        makerSkipCycle <= 1;
                    end
                end
            end
        end
        
        //Join Blob
        else if (ustate == JOIN) begin
            //write back to BRAM
            bramPorts[0].din <= mergeBlobs(currentRunAsBlob, bramPorts[0].dout);
            bramPorts[0].we <= 1;

            //save to current line run buffer
            currentLineBuffer.runs[currentLineBuffer.count] <= '{
                start: currentLineBufferX,
                stop: currentLineBufferX + runFIFOOut.length - 1,
                blobIndex: bramPorts[0].addr
            };

            //go back to searching
            makerState <= SEARCH;
        end

        //Merge two intersecting Blobs (U/V/W Case)
        else if (ustate == MERGE) begin
            //update all pointers to slave
            for (int i = 0; i < MAX_RUNS_PER_LINE; i++) begin
                if (lastLineBuffer.runs[i].blobIndex == bramPorts[1].addr) begin
                    lastLineBuffer.runs[i].blobIndex <= bramPorts[0].addr;
                end
            end

            //write back merged blob to master in BRAM
            bramPorts[0].din <= mergeBlobs(bramPorts[1].dout, bramPorts[0].dout);
            bramPorts[0].we <= 1;

            //write back null blob to slave in BRAM
            bramPorts[1].din <= '0;
            bramPorts[1].we <= 1;

            //go back to searching
            makerState <= SEARCH;
        end

        //Join End (had joined a blob & is done now)
        else if (ustate == JOIN_END) begin
            blobFinishRun();
        end

        //Make new Blob
        else if (ustate == MAKE) begin
            //write to BRAM
            bramPorts[0].din <= currentRunAsBlob;
            bramPorts[0].addr <= makerGrowingIndex;
            bramPorts[0].we <= 1;

            //save to current line run buffer
            currentLineBuffer.runs[currentLineBuffer.count] <= '{
                start: currentLineBufferX,
                stop: currentLineBufferX + runFIFOOut.length - 1,
                blobIndex: makerGrowingIndex
            };

            //increment index
            makerGrowingIndex <= makerGrowingIndex + 1;

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
        makerState <= NONE;

        //finish
        if ((currentLineBufferX + runFIFOOut.length - 1) == (IMAGE_WIDTH-1) & runFIFOOut.line == (IMAGE_HEIGHT-1)) begin
            makerState <= DONE;
        end

        //read new run
        else if (~runFIFOEmpty) begin
            runFIFORead <= 1;
        end
    endtask

    //Blob Train ("Growing" BRAM -> "Finished" BRAM) (Note: automatically does target selection for single target mode)
    task updateBlobTrain();
        automatic reg blobGood = doesBlobMatchCriteria(bramPorts[trainPartion].dout);

        trainPartion <= ~trainPartion;

        if (trainInitDone) begin
            //(sim only)
            begin
                automatic BlobData blob = bramPorts[trainPartion].dout;
                $fwrite(fd, "{blob:1, topLeft:{x:%d, y:%d}, bottomRight:{x:%d, y:%d}}\n",
                    blob.boundTopLeft.x, blob.boundTopLeft.y, blob.boundBottomRight.x, blob.boundBottomRight.y
                );
                $display("blob: {topLeft:{x:%d, y:%d}, bottomRight:{x:%d, y:%d}} @ %d - GOOD:%d",
                    blob.boundTopLeft.x, blob.boundTopLeft.y, blob.boundBottomRight.x, blob.boundBottomRight.y,
                    bramPorts[trainPartion].addr, blobGood
                );
            end

            //Transfer Good Blobs to "Finished" BRAM
            if (blobGood) begin
                bramPorts[2].addr <= trainFinishedIndex;
                bramPorts[2].din <= bramPorts[trainPartion].dout;
                bramPorts[2].we <= 1;
                trainFinishedIndex <= trainFinishedIndex + 1;
                targetBRAMEnds[1] <= trainFinishedIndex + 1;
            end
            
            //Update Single Mode Target Selector
            if (virtexConfig.targetMode == SINGLE) begin
                updateTargetSelectorSingle(blobGood, bramPorts[trainPartion].dout);
            end
        end

        //Finish Init
        else if (trainPartion) begin
            trainInitDone <= 1;
        end

        //Read Blob from "Growing" BRAM
        bramPorts[trainPartion].addr <= trainGrowingIndex;
        trainGrowingIndex <= trainGrowingIndex + 1;

        //(sim only)
        if (trainAlmostDone) begin
            $display(" > Blob Train Done < %d", trainFinishedIndex + (trainInitDone && blobGood ? 1 : 0));
        end
    endtask

    //Target Selector (blobs => target)
    task updateTargetSelectorSingle(reg blobValid, BlobData blob);
        //Convert Blob A Bounding Box from TopLeft/BottomRight => Center/Width/Height
        automatic Math::Vector2d10 center = '{
            x: (blob.boundBottomRight.x + blob.boundTopLeft.x) >> 1,
            y: (blob.boundBottomRight.y + blob.boundTopLeft.y) >> 1
        };
        automatic reg [9:0] width  = blob.boundBottomRight.x - blob.boundTopLeft.x + 1;
        automatic reg [9:0] height = blob.boundBottomRight.y - blob.boundTopLeft.y + 1;

        //aspect ratio valid
        automatic reg aspectRatioValid = inAspectRatioRange(width, height,
            virtexConfig.targetAspectRatioMin, virtexConfig.targetAspectRatioMax);

        //bound area valid
        automatic reg boundAreaValid = inBoundAreaRange(width * height,
            virtexConfig.targetBoundAreaMin, virtexConfig.targetBoundAreaMax);

        //if this target is valid AND this target is better OR we dont have a target yet
        if (blobValid && aspectRatioValid && boundAreaValid &&
            (isTargetNull(targetCurrent) || distSqToTargetCenter(center) < distSqToTargetCenter(targetCurrent.center))) begin
            automatic Target newTarget = '{
                center: center,
                width: width,
                height: height,
                blobCount: 1,
                angle: calcBlobAngle(blob)
            };

            targetCurrent <= newTarget;

            if (trainAlmostDone) begin
                target <= newTarget;

                //(sim only)
                $fwrite(fd, "{target:1, center:{x:%d, y:%d}, width:%d, height:%d, blobCount:%d, angle:%d}\n",
                    newTarget.center.x, newTarget.center.y, newTarget.width, newTarget.height, newTarget.blobCount, newTarget.angle
                );
            end
        end
        else if (trainAlmostDone) begin
            target <= targetCurrent;

            //(sim only)
            $fwrite(fd, "{target:1, center:{x:%d, y:%d}, width:%d, height:%d, blobCount:%d, angle:%d}\n",
                targetCurrent.center.x, targetCurrent.center.y, targetCurrent.width, targetCurrent.height, targetCurrent.blobCount, targetCurrent.angle
            );
        end
    endtask
    task updateTargetSelectorDualGroup();
        /*  TS Dual/Group Breakdown (A = target1/chainStart, B = target2/chainJoiner, 0|1 = BRAM ports)
            targetInitStep, targetPartion, commands
            ------------------------------------------------------
            0 - READ New A on 0
            1 +                                 READ New B1 on 1
            2 - SAVE A from 0                   READ New B0 on 0
            3 +                 PROCESS B1 on 1 READ New B1 on 1
            3 -                 PROCESS B0 on 0 READ New B0 on 0
            3 +                 PROCESS B1 on 1 READ New B1 on 1
            3 -                 PROCESS B0 on 0 READ New B0 on 0
            ... for all Bs
            ---- for all As */

        //(sim only)
        $write("%d %d", targetInitStep, targetPartion);

        //Increment Init Step
        if (targetInitStep != 3) begin
            targetInitStep <= targetInitStep+1;
        end

        //Swap Partion
        targetPartion <= ~targetPartion;

        //SAVE A from 0
        if (targetInitStep == 2) begin
            targetBlobAAngle <= calcBlobAngle(bramPorts[targetBRAMOffset].dout);
            targetBlobA <= bramPorts[targetBRAMOffset].dout;

            //(sim only)
            $write(" SAVE A0 FROM 0");
        end

        //PROCESS
        if (targetInitStep == 3 && targetIndexBs[targetPartion] != NULL_BLOB_INDEX) begin
            //Get Blob
            automatic BlobData targetBlobB = bramPorts[targetBRAMOffset+targetPartion].dout;
            automatic BlobAngle targetBlobBAngle = calcBlobAngle(targetBlobB);

            //(sim only)
            $write(" PROCESS B%d FROM %d", targetIndexBs[targetPartion], targetPartion);

            //GROUP: chain other blobs together starting a Blob A
            if (virtexConfig.targetMode == GROUP) begin
                //gap between
                automatic reg [9:0] gapX = `Math_diff(targetBlobA.boundTopLeft.x, targetBlobB.boundBottomRight.x);
                automatic reg [9:0] gapY = `Math_diff(targetBlobA.boundTopLeft.y, targetBlobB.boundBottomRight.y);
                automatic reg gapValid = `Math_inRangeInclusive(gapX, virtexConfig.targetBlobXGapMin, virtexConfig.targetBlobXGapMax) &&
                    `Math_inRangeInclusive(gapY, virtexConfig.targetBlobYGapMin, virtexConfig.targetBlobYGapMax);
                
                //ratio between the bound area of the two blobs (if either is a group target, then it will used the cashed bound area)
                automatic GroupTarget groupTargetA = isGroupTarget(targetBlobA) ? asGroupTarget(targetBlobA) : makeGroupTarget(targetBlobA);
                automatic GroupTarget groupTargetB = isGroupTarget(targetBlobB) ? asGroupTarget(targetBlobB) : makeGroupTarget(targetBlobB);
                automatic reg blobsBoundAreaRatioValid = inBoundAreaRatioRange(groupTargetA.blobBoundArea, groupTargetB.blobBoundArea,
                    virtexConfig.targetBoundAreaRatioMin, virtexConfig.targetBoundAreaRatioMax);

                //join B to A
                if (gapValid && blobsBoundAreaRatioValid) begin
                    //make new group target & save
                    targetBlobA <= asBlob(mergeGroupTargets(groupTargetA, groupTargetB));

                    //Flag B Joined
                    targetGroupBJoined <= 1;
                end

                //copy B over to other BRAM
                else begin
                    //write to newest slot
                    bramPorts[targetBRAMOffsetOther].din <= targetBlobB;
                    bramPorts[targetBRAMOffsetOther].addr <= targetBRAMEnds[~targetBRAMNumber];
                    bramPorts[targetBRAMOffsetOther].we <= 1;

                    //increment slot counter
                    targetBRAMEnds[~targetBRAMNumber] <= targetBRAMEnds[~targetBRAMNumber] + 1;
                end
            end

            //DUAL: make all combinations of two blobs
            else begin
                //pick left & right
                automatic reg [9:0] targetBlobACenterX = (targetBlobA.boundTopLeft.x + targetBlobA.boundBottomRight.x) >> 1;
                automatic reg [9:0] blobBCenterX       = (targetBlobB.boundTopLeft.x + targetBlobB.boundBottomRight.x) >> 1;
                automatic BlobData leftBlob        = targetBlobACenterX < blobBCenterX ? targetBlobA : targetBlobB;
                automatic BlobAngle leftBlobAngle  = targetBlobACenterX < blobBCenterX ? targetBlobAAngle : targetBlobBAngle;
                automatic BlobData rightBlob       = targetBlobACenterX < blobBCenterX ? targetBlobB : targetBlobA;
                automatic BlobAngle rightBlobAngle = targetBlobACenterX < blobBCenterX ? targetBlobBAngle : targetBlobAAngle;

                //make enclosing bound
                automatic Math::Vector2d10 topLeft = '{
                    x: `Math_min(leftBlob.boundTopLeft.x, rightBlob.boundTopLeft.x),
                    y: `Math_min(leftBlob.boundTopLeft.y, rightBlob.boundTopLeft.y)
                };
                automatic Math::Vector2d10 bottomRight = '{
                    x: `Math_max(leftBlob.boundBottomRight.x, rightBlob.boundBottomRight.x),
                    y: `Math_max(leftBlob.boundBottomRight.y, rightBlob.boundBottomRight.y)
                };
                automatic Math::Vector2d10 center = '{
                    x: (topLeft.x + bottomRight.x) >> 1,
                    y: (topLeft.y + bottomRight.y) >> 1
                };
                automatic reg [9:0] width  = bottomRight.x - topLeft.x + 1;
                automatic reg [9:0] height = bottomRight.y - topLeft.y + 1;

                //if left/right blob angles are valid
                automatic reg angleValid = 1; //FIXME
                // automatic reg angleValid = (virtexConfig.targetMode == DUAL_UP ?
                //     leftBlobAngle == FORWARD && rightBlobAngle == BACKWARD :
                //     virtexConfig.targetMode == DUAL_DOWN ?
                //     leftBlobAngle == BACKWARD && rightBlobAngle == FORWARD : 1);

                //gap between target & blobB
                automatic reg [9:0] gapX = `Math_diff(rightBlob.boundTopLeft.x, leftBlob.boundBottomRight.x);
                automatic reg [9:0] gapY = `Math_diff(rightBlob.boundTopLeft.y, leftBlob.boundBottomRight.y);
                automatic reg gapValid = `Math_inRangeInclusive(gapX, virtexConfig.targetBlobXGapMin, virtexConfig.targetBlobXGapMax) &&
                    `Math_inRangeInclusive(gapY, virtexConfig.targetBlobYGapMin, virtexConfig.targetBlobYGapMax);

                //aspect ratio of new target
                automatic reg aspectRatioValid = inAspectRatioRange(width, height,
                    virtexConfig.targetAspectRatioMin, virtexConfig.targetAspectRatioMax);

                //bound area of new target
                automatic reg boundAreaValid = inBoundAreaRange(width * height,
                    virtexConfig.targetBoundAreaMin, virtexConfig.targetBoundAreaMax);

                //area ratio between two blobs
                automatic BlobArea boundAreaLeft = (leftBlob.boundBottomRight.x - leftBlob.boundTopLeft.x + 1) * (leftBlob.boundBottomRight.y - leftBlob.boundTopLeft.y + 1);
                automatic BlobArea boundAreaRight = (rightBlob.boundBottomRight.x - rightBlob.boundTopLeft.x + 1) * (rightBlob.boundBottomRight.y - rightBlob.boundTopLeft.y + 1);
                automatic reg boundAreaRatioValid = inBoundAreaRatioRange(boundAreaRight, boundAreaLeft,
                    virtexConfig.targetBoundAreaRatioMin, virtexConfig.targetBoundAreaRatioMax);
                
                //(sim only)
                $write("(*angV:%b,gapV:%b,aspV:%b,bndV:%b,rtiV:%b,nil:%b*)", angleValid, gapValid, aspectRatioValid, boundAreaValid, boundAreaRatioValid, isTargetNull(targetCurrent));

                //if this target is valid AND this target is better OR we dont have a target yet
                if (angleValid && gapValid && aspectRatioValid && boundAreaValid && boundAreaRatioValid &&
                    (isTargetNull(targetCurrent) || distSqToTargetCenter(center) < distSqToTargetCenter(targetCurrent.center))) begin
                    //(sim only)
                    $write("=>{TC{cx:%d,cy:%d,w:%d,h:%d,a:%d}}", center.x, center.y, width, height, leftBlobAngle);
                    
                    targetCurrent <= '{
                        center: center,
                        width: width,
                        height: height,
                        blobCount: 2,
                        angle: leftBlobAngle
                    };
                end

                //copy B over to other BRAM
                //write to newest slot
                bramPorts[targetBRAMOffsetOther].din <= targetBlobB;
                bramPorts[targetBRAMOffsetOther].addr <= targetBRAMEnds[~targetBRAMNumber];
                bramPorts[targetBRAMOffsetOther].we <= 1;

                //increment slot counter
                targetBRAMEnds[~targetBRAMNumber] <= targetBRAMEnds[~targetBRAMNumber] + 1;
            end
        end

        //READ
        if (targetInitStep != 0 && !targetWantsNewA) begin
            //Request New A
            if (nextTargetIndexBs[targetPartion] == NULL_BLOB_INDEX) begin
                //(sim only)
                $write(" WANTS NEW A");
                
                //Request New A (we must request because we have to wait for last B to finish processing)
                targetWantsNewA <= 1;

                //Nullify B0|1
                targetIndexBs[targetPartion] <= NULL_BLOB_INDEX;
            end

            //READ New B0|1
            else begin
                //(sim only)
                $write(" READ B%d FROM %D", nextTargetIndexBs[targetPartion], targetPartion);
                
                //READ New B0|1
                bramPorts[targetBRAMOffset+targetPartion].addr <= nextTargetIndexBs[targetPartion];

                //Save New B0|1 Index1
                targetIndexBs[targetPartion] <= nextTargetIndexBs[targetPartion];
            end
        end

        //Reset for New A OR Finish
        if (targetWillGetNewA) begin
            automatic GroupTarget groupTargetA = isGroupTarget(targetBlobA) ? asGroupTarget(targetBlobA) : makeGroupTarget(targetBlobA);
            automatic Target targetA = groupTargetToTarget(groupTargetA);
            automatic reg justSetTargetCurrent = 0;
            automatic BlobIndex newInvertTargetBRAMEnd = targetBRAMEnds[~targetBRAMNumber];

            //Reset
            targetPartion <= 0;
            targetInitStep <= 0;
            targetGroupBJoined <= 0;

            //Wrap up Group Mode
            if (virtexConfig.targetMode == GROUP && targetBlobA.area != 0) begin
                automatic reg [9:0] boundWidth = (groupTargetA.boundBottomRight.x - groupTargetA.boundTopLeft.x + 1); 
                automatic reg [9:0] boundHeight = (groupTargetA.boundBottomRight.y - groupTargetA.boundTopLeft.y + 1);
                automatic BlobArea boundArea = boundWidth * boundHeight; //bound area of entire target
                automatic reg boundAreaValid = inBoundAreaRange(boundArea, virtexConfig.targetBoundAreaMin, virtexConfig.targetBoundAreaMax);
                automatic reg aspectRatioValid = inAspectRatioRange(boundWidth, boundHeight, virtexConfig.targetAspectRatioMin, virtexConfig.targetAspectRatioMax);
                automatic reg blobCountValid = `Math_inRangeInclusive(groupTargetA.blobCount, virtexConfig.targetBlobCountMin, virtexConfig.targetBlobCountMax);

                //More processing needed on this target -> copy over
                if (targetGroupBJoined && newInvertTargetBRAMEnd != 0) begin
                    //write to newest slot
                    bramPorts[targetBRAMOffsetOther+1].din <= targetBlobA;
                    bramPorts[targetBRAMOffsetOther+1].addr <= newInvertTargetBRAMEnd;
                    bramPorts[targetBRAMOffsetOther+1].we <= 1;

                    //(sim only)
                    $write(" CHAIN_NOT_DONE->COPY%b", newInvertTargetBRAMEnd);

                    //increment slot counter
                    newInvertTargetBRAMEnd = newInvertTargetBRAMEnd + 1;
                    targetBRAMEnds[~targetBRAMNumber] <= newInvertTargetBRAMEnd;
                end

                //Done with this target -> attempt to become targetCurrent
                else if (boundAreaValid && aspectRatioValid && blobCountValid &&
                    (isTargetNull(targetCurrent) || distSqToTargetCenter(targetA.center) < distSqToTargetCenter(targetCurrent.center))) begin
                    //make Best Target
                    targetCurrent <= targetA;
        
                    //flag
                    justSetTargetCurrent = 1;

                    //(sim only)
                    $write(" CHAIN_END->BEST_TARGET");
                end

                //(sim only)
                else $write(" CHAIN_END->NOT_BEST_TARGET(boundAreaValid%b, aspectRatioValid%b, blobCountValid%b, nil%b)", boundAreaValid, aspectRatioValid, blobCountValid, isTargetNull(targetCurrent));
            end

            //Reset Slot Counter for Next Opposite BRAM Number
            targetBRAMEnds[targetBRAMNumber] <= 0;

            //Swap BRAM Number
            targetBRAMNumber <= ~targetBRAMNumber;

            //Finish //FIXME finish dual @ 1?
            if (newInvertTargetBRAMEnd == 0) begin
                //transfer best target to target
                target <= justSetTargetCurrent ? targetA : targetCurrent;

                //(sim only)
                begin
                    automatic Target newTarget = justSetTargetCurrent ? targetA : targetCurrent;
                    $fwrite(fd, "{target:1, center:{x:%d, y:%d}, width:%d, height:%d, blobCount:%d, angle:%d}\n",
                        newTarget.center.x,
                        newTarget.center.y,
                        newTarget.width,
                        newTarget.height,
                        newTarget.blobCount,
                        newTarget.angle
                    );
                    $write(" > Target Selector Done < ");
                end

                //flag
                targetSelectorDone <= 1;
            end

            //READ New A on 0
            else begin
                //READ New A on 0
                bramPorts[targetBRAMOffsetOther].addr <= 0;

                //Update State
                targetWantsNewA <= 0;
                targetPartion <= 1;
                targetInitStep <= 1;

                //(sim only)
                $write(" READ NEW A0 FROM 0");
            end
        end

        //Nullify B0|1 (to reset for next loop)
        else if (targetWantsNewA) begin
            targetIndexBs[targetPartion] <= NULL_BLOB_INDEX;
        end

        //(sim only)
        $write("\n");
    endtask
    function automatic logic [19:0] distSqToTargetCenter(Math::Vector2d10 v);
        //Distance^2 Between Vector and Target Center
        return (v.x - virtexConfig.targetCenterX)**2 + (v.y - virtexConfig.targetCenterY)**2;
    endfunction
    function automatic logic doesBlobMatchCriteria(BlobData blob);
        reg nonZero = blob.area != 0;

        reg [9:0] boundWidth  = blob.boundBottomRight.x - blob.boundTopLeft.x;
        reg [9:0] boundHeight = blob.boundBottomRight.y - blob.boundTopLeft.y;

        reg aspectRatioValid = inAspectRatioRange(boundWidth, boundHeight,
            virtexConfig.targetAspectRatioMin, virtexConfig.targetAspectRatioMax);

        BlobArea boundArea = boundWidth * boundHeight;
        reg boundAreaValid = inBoundAreaRange(boundArea,
            virtexConfig.blobBoundAreaMin, virtexConfig.blobBoundAreaMax);

        reg fullnessValid = inFullnessRange(blob.area, boundArea,
            virtexConfig.blobFullnessMin, virtexConfig.blobFullnessMax);

        reg angleValid = virtexConfig.blobAnglesEnabled[15-calcBlobAngle(blob)];

        return nonZero && aspectRatioValid & boundAreaValid & fullnessValid & angleValid;
    endfunction

    //Global Reset for New Frame
    task frameReset();
        //(sim only)
        $display(" --- FRAME RESET --- ");

        //Flag Reset
        justResetFrame <= 1;

        //Blob Maker Reset (everything else is reset in on New Line* updateBlobMaker())
        makerState <= NONE;
        makerSkipCycle <= '0;
        makerJustResetLine <= '0;
        makerGrowingIndex <= '0;

        //Blob Train Reset
        trainFinishedIndex <= '0;
        trainGrowingIndex <= '0;
        trainPartion <= '0;
        trainInitDone <= '0;

        //Target Selector Reset
        targetBlobA <= '0;
        targetCurrent <= '0;
        targetWantsNewA <= 1;
        targetIndexBs <= '{NULL_BLOB_INDEX, NULL_BLOB_INDEX};
        targetInitStep <= '0;
        targetPartion <= '0;
        targetSelectorDone <= '0;
        targetBRAMNumber <= '0;
    endtask

    //FIFO + BRAM IP
    blk_mem_blobs blk_mem_blobs (
        .addra(bramPorts[0].addr),
        .clka(CLK200),
        .dina(bramPorts[0].din),
        .douta(bramPorts[0].dout),
        .wea(bramPorts[0].we),
        .addrb(bramPorts[1].addr),
        .clkb(CLK200),
        .dinb(bramPorts[1].din),
        .doutb(bramPorts[1].dout),
        .web(bramPorts[1].we)
    );
    blk_mem_blobs_2 blk_mem_blobs_2 (
        .addra(bramPorts[2].addr),
        .clka(CLK200),
        .dina(bramPorts[2].din),
        .douta(bramPorts[2].dout),
        .wea(bramPorts[2].we),
        .addrb(bramPorts[3].addr),
        .clkb(CLK200),
        .dinb(bramPorts[3].din),
        .doutb(bramPorts[3].dout),
        .web(bramPorts[3].we)
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

    //Fault Logic
    always_comb begin
        if (makerGrowingIndex >= NULL_BLOB_INDEX) OUT_OF_BLOB_MEM_FAULT = 1;
        if (currentLineBuffer.count >= MAX_RUNS_PER_LINE)  OUT_OF_RLE_MEM_FAULT = 1;
        if (runFIFOFull) RUN_FIFO_FULL_FAULT = 1;
    end
endmodule