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
    input wire CLK_F, CLK_P,
    input Run runFIFOIn,
    input wire runFIFOWrite,
    output Target target,
    input VirtexConfig virtexConfig,
    output reg OUT_OF_BLOB_MEM_FAULT,
    output reg OUT_OF_RLE_MEM_FAULT, //TODO add to faults
    output reg BLOB_PROCESSOR_SLOW_FAULT,
    output reg RUN_FIFO_FULL_FAULT,
    output reg [7:0] debug
    );

    reg [9:0] lastLine = 10'd340; //init >0 so we know to reset on first frame
    reg justResetFrame = '0;

    //Run FIFO
    wire runFIFOEmpty, runFIFOFull;
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
    
    RunBuffer makerLastLineBuffer = '0;
    RunBuffer makerCurrentLineBuffer = '0;
    reg [9:0] makerCurrentLineBufferX = '0;
    reg [9:0] makerCurrentRunEnd = makerCurrentLineBufferX + runFIFOOut.length - 1;
    wire BlobData makerCurrentRunAsBlob = runToBlob(makerCurrentLineBufferX, runFIFOOut.length, runFIFOOut.line);
    wire makerIsLastRun = (makerCurrentRunEnd) == (IMAGE_WIDTH-1) & runFIFOOut.line == (IMAGE_HEIGHT-1);

    wire BlobIndex makerTouchingIndex = getMakerTouchingIndex(); //the run from the last line buffer in which the current run is touching
    function BlobIndex getMakerTouchingIndex();
        for (int i = 0; i < MAX_RUNS_PER_LINE; i++) begin
            if (i < makerLastLineBuffer.count &
                makerLastLineBuffer.runs[i].blobIndex != NULL_BLOB_INDEX & //if valid index in makerLastLineBuffer
                runsOverlap(
                    makerCurrentLineBufferX, makerCurrentRunEnd, //if this run is touching it
                    makerLastLineBuffer.runs[i].start, makerLastLineBuffer.runs[i].stop
                )
            ) begin
                return i;
            end
        end
    endfunction
    
    wire BlobIndex makerTouchingBlobIndex = makerLastLineBuffer.runs[makerTouchingIndex].blobIndex;
    wire BlobIndex makerCurrentBlobIndex = makerCurrentLineBuffer.runs[makerCurrentLineBuffer.count].blobIndex;
    wire makerCurrentRunHasJoinedBlob = makerCurrentBlobIndex != NULL_BLOB_INDEX;

    wire BlobData makerNewJoinedBlob = mergeBlobs(makerCurrentRunAsBlob, bramPorts[0].dout);
    wire BlobData makerNewMergedBlob = mergeBlobs(bramPorts[0].dout, bramPorts[1].dout);

    //Blob Train
    BlobIndex trainFinishedIndex = '0;
    BlobIndex trainGrowingIndex = '0;
    wire trainAlmostDone = trainGrowingIndex == (makerGrowingIndex+1);
    wire trainDone = trainGrowingIndex == (makerGrowingIndex+2); //+2 because the train needs to finish the last index
    reg trainPartion = '0;
    reg trainInitDone = '0;
    
    wire BlobData trainBlob = bramPorts[trainPartion].dout;
    wire trainBlobGood = 1;//FIXME doesBlobMatchCriteria(trainBlob);

    //Target Selector
    initial target = '0; //"best" target for the last frame
    Target targetCurrentSingle = '0, targetCurrentDual = '0, targetCurrentGroup = '0; //"best" target for the current frame
    reg [1:0] targetInitStep = 0; //0-2: init, 3: done
    reg targetPartion = 0; //alterates every cycle
    wire isTargetSingleMode = virtexConfig.targetMode == SINGLE;
    wire isTargetGroupMode = virtexConfig.targetMode == GROUP;

    //Target Selector - Single
    wire Math::Vector2d10 targetSingleCenter = '{ //Convert Blob A Bounding Box from TopLeft/BottomRight => Center/Width/Height
        x: (trainBlob.boundBottomRight.x + trainBlob.boundTopLeft.x) >> 1,
        y: (trainBlob.boundBottomRight.y + trainBlob.boundTopLeft.y) >> 1
    };
    wire [9:0] targetSingleWidth  = trainBlob.boundBottomRight.x - trainBlob.boundTopLeft.x + 1;
    wire [9:0] targetSingleHeight = trainBlob.boundBottomRight.y - trainBlob.boundTopLeft.y + 1;
    wire Target targetSingleNewTarget = '{
        center: targetSingleCenter,
        width: targetSingleWidth,
        height: targetSingleHeight,
        blobCount: 1,
        angle: calcBlobAngle(trainBlob)
    };
    wire targetSingleIsBetterTarget = ( //if this target is valid AND this target is better OR we dont have a target yet
        trainBlobGood &&
        // inAspectRatioRange(targetSingleWidth, targetSingleHeight, virtexConfig.targetAspectRatioMin, virtexConfig.targetAspectRatioMax) &&
        // inBoundAreaRange(targetSingleWidth * targetSingleHeight, virtexConfig.targetBoundAreaMin, virtexConfig.targetBoundAreaMax) && //FIXME
        (isTargetNull(targetCurrentSingle) || distSqToTargetCenter(targetSingleCenter) < distSqToTargetCenter(targetCurrentSingle.center))
    );

    //Target Selector - Dual & Group
    reg targetBRAMNumber = 0; //which BRAM to use (0=growing, 1=finished)
    BlobIndex [0:1] targetBRAMEnds = '{0, 0}; //max index we can go to +1 (5 -> [0:4])
    wire [1:0] targetBRAMOffset      = targetBRAMNumber ? 2 : 0;
    wire [1:0] targetBRAMOffsetOther = targetBRAMNumber ? 0 : 2;

    BlobIndex [0:1] targetIndexBs = '{NULL_BLOB_INDEX, NULL_BLOB_INDEX}; //B0|1 (alternates, so one is waiting for read delay & the other is proc)
    `define fixTargetIndex(index, bramNum) (index < targetBRAMEnds[bramNum]) ? index : NULL_BLOB_INDEX
    wire BlobIndex initTargetIndexB = `fixTargetIndex(1, targetBRAMNumber);
    wire BlobIndex [0:1] nextTargetIndexBs = '{
        `fixTargetIndex(targetIndexBs[1] + 1, targetBRAMNumber), //targetIndexBs opposite so they will skip ahead of eachother (0,1),(2,3)...
        (targetInitStep == 1) ? initTargetIndexB : `fixTargetIndex(targetIndexBs[0] + 1, targetBRAMNumber)
    };
    wire [1:0] nextTargetInitStep = targetInitStep+1;

    reg targetWantsNewA = 1; //wants to get a new A (takes 2 cycles)
    wire targetWillGetNewA = targetWantsNewA && targetIndexBs[0] == NULL_BLOB_INDEX && targetIndexBs[1] == NULL_BLOB_INDEX && targetInitStep != 2; //we have wanted a new A, but now we are ready
    wire targetWillProcess = targetInitStep == 3 && targetIndexBs[targetPartion] != NULL_BLOB_INDEX;
    wire targetWillIncrementInitStep = targetInitStep != 3;
    wire targetWillRead = targetInitStep != 0 && !targetWantsNewA;
    wire targetWillRequestNewA = nextTargetIndexBs[targetPartion] == NULL_BLOB_INDEX;
    reg targetGroupBJoined = 0; //whether any Bs joined cur targetA
    reg targetSelectorDone = 0;

    BlobData targetBlobA = '0; //cached blob A
    BlobAngle targetBlobAAngle = HORIZONTAL;
    wire BlobData targetReadBlob = bramPorts[targetBRAMOffset+targetPartion].dout;
    wire BlobAngle targetReadBlobAngle = calcBlobAngle(targetReadBlob);
    wire BlobData targetBlobB = targetReadBlob;
    wire BlobAngle targetBlobBAngle = targetReadBlobAngle;

    //Target Selector - Dual
    wire targetDualBlobALeftOfBlobB = (targetBlobA.boundTopLeft.x + targetBlobA.boundBottomRight.x) < (targetBlobB.boundTopLeft.x + targetBlobB.boundBottomRight.x);
    wire targetDualBlobAAboveOfBlobB = (targetBlobA.boundTopLeft.y + targetBlobA.boundBottomRight.y) < (targetBlobB.boundTopLeft.y + targetBlobB.boundBottomRight.y);
    wire BlobAngle targetDualLeftBlobAngle = targetDualBlobALeftOfBlobB ? targetBlobAAngle : targetBlobBAngle;
    wire BlobAngle targetDualRightBlobAngle = targetDualBlobALeftOfBlobB ? targetBlobBAngle : targetBlobAAngle;
    wire Math::Vector2d10 targetDualTopLeft = '{
        x: `Math_min(targetBlobA.boundTopLeft.x, targetBlobB.boundTopLeft.x),
        y: `Math_min(targetBlobA.boundTopLeft.y, targetBlobB.boundTopLeft.y)
    };
    wire Math::Vector2d10 targetDualBottomRight = '{
        x: `Math_max(targetBlobA.boundBottomRight.x, targetBlobB.boundBottomRight.x),
        y: `Math_max(targetBlobA.boundBottomRight.y, targetBlobB.boundBottomRight.y)
    };
    wire Math::Vector2d10 targetDualCenter = '{
        x: (targetDualTopLeft.x + targetDualBottomRight.x) >> 1,
        y: (targetDualTopLeft.y + targetDualBottomRight.y) >> 1
    };
    wire [9:0] targetDualWidth  = targetDualBottomRight.x - targetDualTopLeft.x + 1;
    wire [9:0] targetDualHeight = targetDualBottomRight.y - targetDualTopLeft.y + 1;
    wire targetDualIsBetterTarget = ( //is new target (blobA & blobB) valid & better than targetCurrent
        (virtexConfig.targetMode != DUAL_UP   || (targetDualLeftBlobAngle == FORWARD  && targetDualRightBlobAngle == BACKWARD)) && //validate angles of blobs
        (virtexConfig.targetMode != DUAL_DOWN || (targetDualLeftBlobAngle == BACKWARD && targetDualRightBlobAngle == FORWARD )) &&
        `Math_inRangeInclusive(`Math_diff(
            targetDualBlobALeftOfBlobB ? targetBlobB.boundTopLeft.x : targetBlobA.boundTopLeft.x,
            targetDualBlobALeftOfBlobB ? targetBlobA.boundBottomRight.x : targetBlobB.boundBottomRight.x), //validate x-gap between blobs
            virtexConfig.targetBlobXGapMin, virtexConfig.targetBlobXGapMax) &&
        `Math_inRangeInclusive(`Math_diff( //validate y-gap between blobs
            targetDualBlobAAboveOfBlobB ? targetBlobB.boundTopLeft.y : targetBlobA.boundTopLeft.y, //find the blob on Top, then compare bottom.y of Top blob to top.y of the Bottom blob
            targetDualBlobAAboveOfBlobB ? targetBlobA.boundBottomRight.y : targetBlobB.boundBottomRight.y),
            virtexConfig.targetBlobYGapMin, virtexConfig.targetBlobYGapMax) &&
        inBoundAreaRatioRange( //validate the ratio of the area between the two blobs
            (targetBlobA.boundBottomRight.x - targetBlobA.boundTopLeft.x + 1) * (targetBlobA.boundBottomRight.y - targetBlobA.boundTopLeft.y + 1),
            (targetBlobB.boundBottomRight.x - targetBlobB.boundTopLeft.x + 1) * (targetBlobB.boundBottomRight.y - targetBlobB.boundTopLeft.y + 1),
            virtexConfig.targetBoundAreaRatioMin, virtexConfig.targetBoundAreaRatioMax
        ) &&
        inBoundAreaRange(targetDualWidth * targetDualHeight, virtexConfig.targetBoundAreaMin, virtexConfig.targetBoundAreaMax) && //validate area of target
        inAspectRatioRange(targetDualWidth, targetDualHeight, virtexConfig.targetAspectRatioMin, virtexConfig.targetAspectRatioMax) && //validate aspect ratio of target
        (isTargetNull(targetCurrentDual) || distSqToTargetCenter(targetDualCenter) < distSqToTargetCenter(targetCurrentDual.center))
    );

    //Target Selector - Group
    wire GroupTarget groupTargetA = isGroupTarget(targetBlobA) ? asGroupTarget(targetBlobA) : makeGroupTarget(targetBlobA);
    wire GroupTarget groupTargetB = isGroupTarget(targetBlobB) ? asGroupTarget(targetBlobB) : makeGroupTarget(targetBlobB);
    wire Target targetA = groupTargetToTarget(groupTargetA);
    wire [9:0] groupTargetABoundWidth = (groupTargetA.boundBottomRight.x - groupTargetA.boundTopLeft.x + 1); 
    wire [9:0] groupTargetABoundHeight = (groupTargetA.boundBottomRight.y - groupTargetA.boundTopLeft.y + 1);
    wire targetGroupWillJoin = (
        inBoundAreaRatioRange( //area ratio valid
            groupTargetA.blobBoundArea, groupTargetB.blobBoundArea,
            virtexConfig.targetBoundAreaRatioMin, virtexConfig.targetBoundAreaRatioMax
        ) &&
        `Math_inRangeInclusive( //gap x valid
            `Math_diff(targetBlobA.boundTopLeft.x, targetBlobB.boundBottomRight.x),
            virtexConfig.targetBlobXGapMin, virtexConfig.targetBlobXGapMax
        ) &&
        `Math_inRangeInclusive( //gap y valid
            `Math_diff(targetBlobA.boundTopLeft.y, targetBlobB.boundBottomRight.y),
            virtexConfig.targetBlobYGapMin, virtexConfig.targetBlobYGapMax
        )
    );
    wire targetGroupIsBetterTarget = (
        inBoundAreaRange(groupTargetABoundWidth * groupTargetABoundHeight, virtexConfig.targetBoundAreaMin, virtexConfig.targetBoundAreaMax) &&
        inAspectRatioRange(groupTargetABoundWidth, groupTargetABoundHeight, virtexConfig.targetAspectRatioMin, virtexConfig.targetAspectRatioMax) &&
        `Math_inRangeInclusive(groupTargetA.blobCount, virtexConfig.targetBlobCountMin, virtexConfig.targetBlobCountMax) &&
        (isTargetNull(targetCurrentGroup) || distSqToTargetCenter(targetA.center) < distSqToTargetCenter(targetCurrentGroup.center))
    );
    wire Target targetGroupNewTargetA = asBlob(mergeGroupTargets(groupTargetA, groupTargetB));
    wire targetIsGroupEnd = isTargetGroupMode && targetBlobA.area != 0;

    //(sim only)
    int fd;
    bit fd_closed;
    task openFile();
        fd = $fopen("../../../../Typescript/VisionDebugger/output.txt", "w");
        if (!fd) begin $display(" <===> ERROR OPENING FILE <===>"); fd_closed = 1; end
        else fd_closed = 0;
    endtask
    initial openFile();

    //FIXME
    assign debug = target.width >> 2;

    //200MHz Clocked Loop
    always_ff @(negedge CLK_P) begin
        bramPorts[0].we <= 0;
        bramPorts[1].we <= 0;
        bramPorts[2].we <= 0;
        bramPorts[3].we <= 0;
        lastLine <= runFIFOOut.line;
        justResetFrame <= 0;
        runFIFORead <= 0;
        makerSkipCycle <= 0;
        makerJustResetLine <= 0;

        //FIXME
        // if (runFIFOFull) debug[7] <= 1;
        
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
            debug[0] <= 1;
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
            if (isTargetSingleMode) begin
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
                makerLastLineBuffer <= makerCurrentLineBuffer;
            end

            //reset current line buffer
            makerCurrentLineBufferX <= 0;
            makerCurrentLineBuffer.count <= 0;
            makerCurrentLineBuffer.runs[0] <= '{start:0, stop:0, blobIndex:NULL_BLOB_INDEX};
            makerCurrentLineBuffer.line <= runFIFOOut.line;
        end

        else if (~makerSkipCycle) begin
            //New Run*
            if (makerState == NONE) begin
                //Process FIFO Read
                if (runFIFORead | makerJustResetLine | justResetFrame) begin
                    //Run is Black => Continue
                    if (runFIFOOut.black) begin
                        makerCurrentLineBuffer.runs[makerCurrentLineBuffer.count] <= '{
                            start: makerCurrentLineBufferX,
                            stop: makerCurrentRunEnd,
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
            if (makerCurrentRunHasJoinedBlob) begin
                makerState <= JOIN_END;
            end
            else makerState <= MAKE;

            //Touching
            begin
                //First touching run => Join it's blob
                if (~makerCurrentRunHasJoinedBlob) begin
                    //set new state
                    makerState <= JOIN;

                    //read Blob from BRAM
                    bramPorts[0].addr <= makerTouchingBlobIndex;
                    makerSkipCycle <= 1;
                end

                //2nd+ touching run => Merge this blob with master blob
                else if (makerTouchingBlobIndex != makerCurrentBlobIndex) begin
                    // set new state
                    makerState <= MERGE;

                    // read Blobs from BRAM
                    bramPorts[0].addr <= makerTouchingBlobIndex;
                    bramPorts[1].addr <= makerCurrentBlobIndex;
                    makerSkipCycle <= 1;
                end
            end
        end
        
        //Join Blob
        else if (ustate == JOIN) begin
            //write back to BRAM
            bramPorts[0].din <= makerNewJoinedBlob;
            bramPorts[0].we <= 1;

            //save to current line run buffer
            makerCurrentLineBuffer.runs[makerCurrentLineBuffer.count] <= '{
                start: makerCurrentLineBufferX,
                stop: makerCurrentRunEnd,
                blobIndex: bramPorts[0].addr
            };

            //go back to searching
            makerState <= SEARCH;
        end

        //Merge two intersecting Blobs (U/V/W Case)
        else if (ustate == MERGE) begin
            //update all pointers to slave
            for (int i = 0; i < MAX_RUNS_PER_LINE; i++) begin
                if (makerLastLineBuffer.runs[i].blobIndex == bramPorts[0].addr) begin
                    makerLastLineBuffer.runs[i].blobIndex <= bramPorts[1].addr;
                end
            end

            //write back merged blob to master in BRAM
            bramPorts[1].din <= makerNewMergedBlob;
            bramPorts[1].we <= 1;

            //write back null blob to slave in BRAM
            bramPorts[0].din <= '0;
            bramPorts[0].we <= 1;

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
            bramPorts[0].din <= makerCurrentRunAsBlob;
            bramPorts[0].addr <= makerGrowingIndex;
            bramPorts[0].we <= 1;

            //save to current line run buffer
            makerCurrentLineBuffer.runs[makerCurrentLineBuffer.count] <= '{
                start: makerCurrentLineBufferX,
                stop: makerCurrentRunEnd,
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
        makerCurrentLineBufferX <= makerCurrentRunEnd + 1;
        makerCurrentLineBuffer.count <= makerCurrentLineBuffer.count + 1;
        makerCurrentLineBuffer.runs[makerCurrentLineBuffer.count+1] <= '{start:0, stop:0, blobIndex:NULL_BLOB_INDEX};

        // debug[0] <= 1;

        //reset state
        makerState <= NONE;

        //finish
        if (makerIsLastRun) begin
            makerState <= DONE;
        end

        //read new run
        else if (~runFIFOEmpty) begin
            runFIFORead <= 1;
        end
    endtask

    //Blob Train ("Growing" BRAM -> "Finished" BRAM) (Note: automatically does target selection for single target mode)
    task updateBlobTrain();
        trainPartion <= ~trainPartion;

        if (trainInitDone) begin
            //(sim only)
            begin
                automatic BlobData blob = trainBlob;
                $fwrite(fd, "{blob:1, topLeft:{x:%d, y:%d}, bottomRight:{x:%d, y:%d}, quad:{topLeft:{x:%d,y:%d},topRight:{x:%d,y:%d},bottomRight:{x:%d,y:%d},bottomLeft:{x:%d,y:%d}}}\n",
                    blob.boundTopLeft.x, blob.boundTopLeft.y,
                    blob.boundBottomRight.x, blob.boundBottomRight.y,
                    blob.quad.topLeft.x, blob.quad.topLeft.y,
                    blob.quad.topRight.x, blob.quad.topRight.y,
                    blob.quad.bottomRight.x, blob.quad.bottomRight.y,
                    blob.quad.bottomLeft.x, blob.quad.bottomLeft.y
                );
                $display("blob: {topLeft:{x:%d, y:%d}, bottomRight:{x:%d, y:%d}} @ %d - GOOD:%d",
                    blob.boundTopLeft.x, blob.boundTopLeft.y, blob.boundBottomRight.x, blob.boundBottomRight.y,
                    bramPorts[trainPartion].addr, trainBlobGood
                );
            end

            //Transfer Good Blobs to "Finished" BRAM
            if (trainBlobGood) begin
                bramPorts[2].addr <= trainFinishedIndex;
                bramPorts[2].din <= trainBlob;
                bramPorts[2].we <= 1;
                trainFinishedIndex <= trainFinishedIndex + 1;
                targetBRAMEnds[1] <= trainFinishedIndex + 1;
            end
            
            //Update Single Mode Target Selector
            if (isTargetSingleMode) begin
                updateTargetSelectorSingle();
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
            $display(" > Blob Train Done < %d", trainFinishedIndex + (trainInitDone && trainBlobGood ? 1 : 0));
        end
    endtask
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

    //Target Selector (blobs => target)
    task updateTargetSelectorSingle();
        if (targetSingleIsBetterTarget) begin
            targetCurrentSingle <= targetSingleNewTarget;
        end
        
        if (trainAlmostDone) begin
            target <= targetSingleIsBetterTarget ? targetSingleNewTarget : targetCurrentSingle;

            //(sim only)
            begin automatic Target newTarget = targetSingleIsBetterTarget ? targetSingleNewTarget : targetCurrentSingle;
            $fwrite(fd, "{target:1, center:{x:%d, y:%d}, width:%d, height:%d, blobCount:%d, angle:%d}\n", newTarget.center.x, newTarget.center.y, newTarget.width, newTarget.height, newTarget.blobCount, newTarget.angle); end
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
        if (targetWillIncrementInitStep) begin
            targetInitStep <= nextTargetInitStep;
        end

        //Swap Partion
        targetPartion <= ~targetPartion;

        //SAVE A from 0
        if (targetInitStep == 2) begin
            targetBlobA <= targetReadBlob;
            targetBlobAAngle <= targetReadBlobAngle;

            //(sim only)
            $write(" SAVE A0 FROM 0");
        end

        //PROCESS
        if (targetWillProcess) begin
            //(sim only)
            $write(" PROCESS B%d FROM %d", targetIndexBs[targetPartion], targetPartion);

            //GROUP: chain other blobs together starting a Blob A
            if (isTargetGroupMode) begin
                //join B to A
                if (targetGroupWillJoin) begin
                    //make new group target & save
                    targetBlobA <= targetGroupNewTargetA;

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
                //(sim only)
                // $write(" -[targetDualLeftBlobAngle:%d, targetDualRightBlobAngle:%d]-", targetDualLeftBlobAngle, targetDualRightBlobAngle);
                // $write("(*angV:%b,gapV:%b,aspV:%b,bndV:%b,rtiV:%b,nil:%b*)", angleValid, gapValid, aspectRatioValid, boundAreaValid, boundAreaRatioValid, isTargetNull(targetCurrentDual));

                //if this target is valid AND this target is better OR we dont have a target yet
                if (targetDualIsBetterTarget) begin
                    //(sim only)
                    // $write("=>{TC{cx:%d,cy:%d,w:%d,h:%d,a:%d}}", center.x, center.y, width, height, targetDualLeftBlobAngle);
                    
                    targetCurrentDual <= '{
                        center: targetDualCenter,
                        width: targetDualWidth,
                        height: targetDualHeight,
                        blobCount: 2,
                        angle: HORIZONTAL //FIXME targetDualLeftBlobAngle
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
        if (targetWillRead) begin
            //Request New A
            if (targetWillRequestNewA) begin
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
            automatic reg justSetTargetCurrent = 0;
            automatic BlobIndex newInvertTargetBRAMEnd = targetBRAMEnds[~targetBRAMNumber];

            //Reset
            targetPartion <= 0;
            targetInitStep <= 0;
            targetGroupBJoined <= 0;

            //Wrap up Group Mode
            if (targetIsGroupEnd) begin
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
                else if (targetGroupIsBetterTarget) begin
                    //make Best Target
                    targetCurrentGroup <= targetA;
        
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
                target <= justSetTargetCurrent ? targetA : isTargetGroupMode ? targetCurrentGroup : targetCurrentDual;

                //(sim only)
                begin
                    automatic Target newTarget = justSetTargetCurrent ? targetA : isTargetGroupMode ? targetCurrentGroup : targetCurrentDual;
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

    //Global Reset for New Frame
    task frameReset();
        //(sim only)
        $display(" --- FRAME RESET --- ");
        openFile();

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
        targetCurrentSingle <= '0;
        targetCurrentDual <= '0;
        targetCurrentGroup <= '0;
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
        .clka(CLK_P),
        .dina(bramPorts[0].din),
        .douta(bramPorts[0].dout),
        .wea(bramPorts[0].we),
        .addrb(bramPorts[1].addr),
        .clkb(CLK_P),
        .dinb(bramPorts[1].din),
        .doutb(bramPorts[1].dout),
        .web(bramPorts[1].we)
    );
    blk_mem_blobs_2 blk_mem_blobs_2 (
        .addra(bramPorts[2].addr),
        .clka(CLK_P),
        .dina(bramPorts[2].din),
        .douta(bramPorts[2].dout),
        .wea(bramPorts[2].we),
        .addrb(bramPorts[3].addr),
        .clkb(CLK_P),
        .dinb(bramPorts[3].din),
        .doutb(bramPorts[3].dout),
        .web(bramPorts[3].we)
    );
    fifo_python_to_blob fifo_python_to_blob (
        .full(runFIFOFull),
        .din(runFIFOIn),
        .wr_en(runFIFOWrite),
        .wr_clk(CLK_F),
        .empty(runFIFOEmpty),
        .dout(runFIFOOut),
        .rd_en(runFIFORead),
        .rd_clk(CLK_P),
        .rst(1'b0)
    );

    //Fault Logic
    always_comb begin
        if (makerGrowingIndex >= NULL_BLOB_INDEX) OUT_OF_BLOB_MEM_FAULT = 1;
        if (makerCurrentLineBuffer.count >= MAX_RUNS_PER_LINE)  OUT_OF_RLE_MEM_FAULT = 1;
        if (runFIFOFull) RUN_FIFO_FULL_FAULT = 1;
    end
endmodule