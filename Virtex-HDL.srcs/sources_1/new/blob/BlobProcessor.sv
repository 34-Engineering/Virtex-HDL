`timescale 1ns / 1ps
`include "../python/PythonUtil.sv"
`include "BlobUtil.sv"
`include "../config/VirtexConfig.sv"

/* BlobProcessor - Processes incoming pixels into blobs and selects the target blob based on config
   
   */
module BlobProcessor(
    input wire CLK200, CLK72,
    input Run runInput,
    input wire runInputWrite,
    output Target target,
    input VirtexConfig virtexConfig,
    output reg OUT_OF_BLOB_MEM_FAULT,
    output reg BLOB_POINTER_DEPTH_FAULT,
    output reg BLOB_PROCESSOR_SLOW_FAULT,
    output reg KERNEL_FIFO_FULL_FAULT,
    output reg TARGET_SELECTOR_TOO_SLOW_FAULT //TODO pull down?
    );

    //Main (registers + wires)
    struct packed { BlobIndex addr; BlobData din, dout; logic we; } blobBRAMPorts [0:1] = '{'0, '0};
    wire runFIFOEmpty;
    reg runFIFORead;
    BlobData runFIFOOut;
    reg [9:0] lastLine = 10'd340; //init >0 so we know to reset on first frame
    reg justResetFrame = '0;
    reg isFirstReset = '1;
    reg isFirstFrame = '1;

    //Blob Processor (registers + wires)
    typedef enum logic [0:2] { NONE=0, SEARCH=1, MERGE=2, JOIN=3, JOIN_END=4, MAKE=5 } BlobMakerState;
    BlobMakerState blobMakerState = NONE;
    wire blobMakerDone = pythonDone & runFIFOEmpty & blobMakerState == NONE;
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
    reg targetSelectorDone;
    Target targetCurrent; //current best target for the frame
    BlobIndex targetIndexA; //keeping track of A for DUAL/GROUP; also tracking frame start when == NULL
    BlobIndex targetIndexBs [0:1];  //B0|1
    reg targetIndexBsValid [0:1];
    BlobData targetBlobA;
    BlobAngle targetBlobAAngle;
    wire BlobIndex firstTargetIndex = getNextValidTargetIndex(0);
    wire BlobIndex nextTargetIndexA = getNextValidTargetIndex(targetIndexA+1);
    wire BlobIndex nextTargetIndex [1:0] = '{getNextValidTargetIndex(targetIndexBs[0]+1), getNextValidTargetIndex(targetIndexBs[1]+1)};
    Target targetChain; //current chain (for GROUP)
    Target targetChainValid; //biggest valid target for current chain
    reg targetPartion; //tells 0: A|B1 or 1: A|B2
    reg targetHasNewA;
    reg targetWantsNewA;

    //Garbage Collector (registers + wires)
    reg garbagePort;
    BlobIndex garbageIndex;
    BlobIndex lastGarbageIndex;
    reg garbageCollectorWasUsingPorts [0:1]; //BRAM ports
    wire garbageCollectorCanUsePorts [0:1] = '{~isWorkingOnFrame, ~blobUsingPort1};
    wire garbageCollectorUsingPorts [0:1] = '{garbageCollectorWasUsingPorts[0] & garbageCollectorCanUsePorts[0], garbageCollectorWasUsingPorts[1] & garbageCollectorCanUsePorts[1]}; //if read from Port A & can still use it
    wire BlobIndex nextValidGarbageIndex = getNextValidGarbageIndex(garbageIndex + 1);
    wire BlobIndex firstValidGarbageIndex = getNextValidGarbageIndex(0);
    reg garbageCollectorLastLoop;
    wire garbageCollectorDone = garbageCollectorLastLoop & garbageCollectorUsingPorts[0] == 0 & garbageCollectorUsingPorts[1] == 0;
    wire garbageIndexAtEnd = garbageIndex == NULL_BLOB_INDEX | nextValidGarbageIndex == NULL_BLOB_INDEX;

    //Main Process Loop
    always_ff @(negedge CLK200) begin
        //Clear Values
        blobBRAMPorts[0].addr <= NULL_BLOB_INDEX;
        blobBRAMPorts[1].addr <= NULL_BLOB_INDEX;
        blobBRAMPorts[0].we <= 0;
        blobBRAMPorts[1].we <= 0;
        justReset <= 0;

        //Reset All @ Frame Start
        if (kernel.pos == 0 & ~lastKernelZero) begin
            reset();
            isFirstFrame <= 0;
        end

        //Reset Garbage Collector @ Frame End
        if (~isWorkingOnFrame & lastIsWorkingOnFrame) begin
            //reset to go run over all blobs (some may have been skipped temp)
            resetGarbageCollector();
        end

        //Garbage Collection Loop
        if (~garbageCollectorDone) begin
            updateGarbageCollector();
        end
        
        //Working on Frame
        if (isWorkingOnFrame) begin
            //Process New Kernel
            if (readNewKernel | justReset) begin
                //Run Length Encoding Loop
                updateRunLengthEncoder(kernel);
            end

            //Blob Processor Loop
            updateBlobProcessor();
        end

        //Done with Frame
        else if (~targetSelectorDone & garbageCollectorDone) begin
            if (virtexConfig.targetMode == SINGLE) begin
                //SINGLE target selection was finished with Garbage Collection
                targetSelectorDone <= 1;

                //Save Best Target into Target Slot
                target <= targetCurrent;
            end
            else begin
                //DUAL/GROUP Target Selection Loop
                updateTargetSelectorDualGroup();
            end
        end

        //Read New Kernel from FIFO
        readNewKernel <= hasNewKernel;

        //Update Last
        lastIsWorkingOnFrame <= isWorkingOnFrame;
        lastKernelZero <= kernel.pos == 0;
    end

    //Run Length Encoding Loop
    function automatic void updateRunLengthEncoder(Kernel kernel);
        //set line number of our RunBuffer
        rleRunBuffer.line <= kernel.pos.y;

        //encode every pixel in kernel
        for (int x = 0; x < 8; x++) begin
            //new run @ start of line
            if (kernel.pos.x == 0 & x == 0) begin
                //push run to buffer
                rleRunBuffer.runs[0] <= '{
                    length: 1,
                    blobIndex: kernel.value[7-x] ? NULL_BLOB_INDEX : NULL_BLACK_RUN_BLOB_INDEX
                };

                //set next buffer count
                rleRunBuffer.count <= 1;
            end

            //new run @ color transition
            else if (kernel.value[7-x] != (rleRunBuffer.runs[rleRunBuffer.count-1].blobIndex != NULL_BLACK_RUN_BLOB_INDEX)) begin
                //push run to buffer
                rleRunBuffer.runs[rleRunBuffer.count] <= '{
                    length: 1,
                    blobIndex: kernel.value[7-x] ? NULL_BLOB_INDEX : NULL_BLACK_RUN_BLOB_INDEX
                };

                //fault
                if (rleRunBuffer.count == MAX_RUNS_PER_LINE) begin
                    OUT_OF_RLE_MEM_FAULT <= 1;
                end

                //increment our buffer count for next run
                rleRunBuffer.count <= rleRunBuffer.count + 1;
            end

            //extend length of last run
            else begin
                rleRunBuffer.runs[rleRunBuffer.count-1].length <= 
                rleRunBuffer.runs[rleRunBuffer.count-1].length + 1;
            end
        end

        //end line
        if (kernel.pos.x == KERNEL_MAX_X) begin
            blobRunBufferNext <= rleRunBuffer;
            rleRunBuffer <= NULL_RUN_BUFFER;
        end
    endfunction

    //Blob Processor Loop
    function automatic void updateBlobProcessor();
        //Next Line
        if ((blobProcessorDoneWithLine & blobNextLineAvailable) | blobProcessorTooSlow) begin
            //Fault
            if (blobProcessorTooSlow & ~(blobProcessorDoneWithLine & blobNextLineAvailable)) begin
                BLOB_PROCESSOR_SLOW_FAULT <= 1;
            end

            //Transfer Run Buffers
            blobRunBufferLast = blobRunBufferCurrent;
            blobRunBufferCurrent = blobRunBufferNext;

            //Reset Intra-Buffer Indexes
            blobRunBufferIndexCurrent = 0;
            blobRunBufferXCurrent = 0;
            blobRunState = IDLE;
        end

        //Handle Run (if we are on a valid partion of the RunBuffer & there are more Runs to handle)
        if (blobRunBufferCurrent.line != NULL_LINE_NUMBER & blobRunBufferIndexCurrent < blobRunBufferCurrent.count) begin
            //run is black => continue to next run
            if (blobRunBufferCurrent.runs[blobRunBufferIndexCurrent].blobIndex == NULL_BLACK_RUN_BLOB_INDEX) begin
                //continue to next run
                blobRunBufferXCurrent = blobRunBufferXCurrent + blobRunBufferCurrent.runs[blobRunBufferIndexCurrent].length;
                blobRunBufferIndexCurrent = blobRunBufferIndexCurrent + 1;
            end

            //run is white => process
            else begin
                //start run (if done with last one, or last one timed out)
                if (blobRunState == IDLE) begin
                    //mark this run as doesn't have another run to join
                    blobMasterIndex = NULL_BLOB_INDEX;

                    //reset last run buffer indexes
                    blobRunBufferIndexLast = 0;
                    blobRunBufferXLast = 0;

                    //proceed to look for runs to join OR go straight to writing if on the first line of image
                    blobRunState = (blobRunBufferLast.line == NULL_LINE_NUMBER) ? WRITE : LAST_LINE;
                end
 
                //loop through all runs that were filled up in the last run buffer (line above)
                if (blobRunState == LAST_LINE) begin
                    for (int i = 0; i < MAX_RUNS_PER_LINE; i++) begin
                        if (i >= blobRunBufferIndexLast & blobRunBufferIndexLast < blobRunBufferLast.count) begin
                            if (blobLastLineRun.blobIndex != NULL_BLACK_RUN_BLOB_INDEX) begin
                                if (runsOverlap(blobRunBufferCurrent.runs[blobRunBufferIndexCurrent], blobRunBufferXCurrent, blobLastLineRun, blobRunBufferXLast)) begin
                                    //pointer fault
                                    if (blobLastLineRunBlobPointerIndex == NULL_BLOB_INDEX) begin
                                        BLOB_POINTER_DEPTH_FAULT <= 1;
                                    end

                                    //found master (1st valid blob)
                                    else if (blobMasterIndex == NULL_BLOB_INDEX) begin
                                        blobMasterIndex = blobLastLineRunBlobPointerIndex;
                                    end

                                    //found another valid blob => merge with master
                                    else if (blobLastLineRunBlobPointerIndex != blobMasterIndex) begin
                                        //read slave & master blobs
                                        blobBRAMPorts[0].addr <= blobMasterIndex;
                                        blobBRAMPorts[1].addr <= blobLastLineRunBlobPointerIndex;
                                        blobUsingPort1 = 1;

                                        //mark slave as pointer to master
                                        blobMetadatas[blobLastLineRunBlobPointerIndex] = '{
                                            status: POINTER,
                                            pointer: blobMasterIndex
                                        };

                                        //go merge blobs & write once we read them
                                        blobRunState = MERGE_WRITE_1;
                                    end
                                end
                            end
                            
                            blobRunBufferXLast = blobRunBufferXLast + blobRunBufferLast.runs[blobRunBufferIndexLast].length; //BLOCKING
                            blobRunBufferIndexLast = blobRunBufferIndexLast + 1;
                        end
                    end

                    //done looping last line => write blob
                    if (blobRunState == LAST_LINE) begin
                        blobRunState = blobMasterIndex == NULL_BLOB_INDEX ? WRITE : JOIN_1;
                    end
                end

                else if (blobRunState == MERGE_WRITE_1) begin
                    //account for read delay
                    blobRunState = MERGE_WRITE_2;
                end

                else if (blobRunState == MERGE_WRITE_2) begin
                    blobBRAMPorts[0].addr <= blobMasterIndex;
                    blobBRAMPorts[0].din <= mergeBlobs(blobBRAMPorts[1].dout, blobBRAMPorts[0].dout);
                    blobBRAMPorts[0].we <= 1;
                    blobUsingPort1 = 0;
                    blobRunState = LAST_LINE;
                end

                if (blobRunState == JOIN_1) begin
                    //account for read delay
                    blobBRAMPorts[0].addr <= blobMasterIndex;
                    blobRunState = JOIN_2;
                end

                else if (blobRunState == JOIN_2) begin
                    blobRunState = WRITE;
                end

                else if (blobRunState == WRITE) begin
                    //add this pixel to blob if we have a valid blob to join
                    if (blobMasterIndex != NULL_BLOB_INDEX) begin
                        blobBRAMPorts[0].addr <= blobMasterIndex;
                        blobBRAMPorts[0].din <= mergeBlobs(runToBlob(blobRunBufferCurrent.runs[blobRunBufferIndexCurrent], blobRunBufferXCurrent, blobRunBufferCurrent.line), blobBRAMPorts[0].dout);
                        blobBRAMPorts[0].we <= 1;

                        //set index of the blob we joined
                        blobRunBufferCurrent.runs[blobRunBufferIndexCurrent].blobIndex = blobMasterIndex;
                    end
                    
                    //not touching a blob => make new blob
                    else begin
                        //create blob at next available index
                        blobBRAMPorts[0].addr <= blobIndex;
                        blobBRAMPorts[0].din <= runToBlob(blobRunBufferCurrent.runs[blobRunBufferIndexCurrent], blobRunBufferXCurrent, blobRunBufferCurrent.line);
                        blobBRAMPorts[0].we <= 1;
                        blobMetadatas[blobIndex].status = UNSCANED; //tell garbage collector to check this once it is done

                        //set index of the blob we made in runBuffer
                        blobRunBufferCurrent.runs[blobRunBufferIndexCurrent].blobIndex = blobIndex;

                        
                        if (blobIndex == MAX_BLOBS-1) begin
                            //fault
                            OUT_OF_BLOB_MEM_FAULT <= 1;
                            blobIndex = 0;
                        end
                        else begin
                            //increment index for next blob
                            blobIndex = blobIndex + 1;
                        end  
                    end

                    //continue to next run
                    blobRunBufferXCurrent = blobRunBufferXCurrent + blobRunBufferCurrent.runs[blobRunBufferIndexCurrent].length;
                    blobRunBufferIndexCurrent = blobRunBufferIndexCurrent + 1;
                    blobRunState = IDLE;
                end
            end
        end
    endfunction

    //Garbage Collector Loop
    function automatic void updateGarbageCollector();
        //Process Port 0|1 (if read from)
        if (garbageCollectorUsingPorts[garbagePort]) begin
            BlobData blob = blobBRAMPorts[garbagePort].dout;

            //if blob is finished adding to
            if (~isWorkingOnFrame | (blobRunBufferCurrent.line != NULL_LINE_NUMBER & blob.boundBottomRight.y + 2 < blobRunBufferCurrent.line)) begin
                reg valid = doesBlobMatchCriteria(blob);

                //FIXME SIM
                int fd = $fopen("../../../../Typescript/BlobDebugger/output.txt", "w");
                if (!fd) $display(" <===> ERROR OPENING FILE <===>");
                else $display(" <---> WROTE FILE <--->");
                $fwrite(fd, "{topLeft:{x:%d, y:%d}, bottomRight:{x:%d, y:%d}}\n", blob.boundTopLeft.x, blob.boundTopLeft.y, blob.boundBottomRight.x, blob.boundBottomRight.y);
                $fclose(fd);
                $display("{topLeft:{x:%d, y:%d}, bottomRight:{x:%d, y:%d}}", blob.boundTopLeft.x, blob.boundTopLeft.y, blob.boundBottomRight.x, blob.boundBottomRight.y);

                //Mark blob as Valid or Garbage
                blobMetadatas[lastGarbageIndex].status = valid ? VALID : GARBAGE;

                //Single Mode Target Selector
                if (virtexConfig.targetMode == SINGLE & valid) begin
                    updateTargetSelectorSingle(blob);
                end
            end
        end

        //Read Port 0|1 (if available & not writing angle)
        garbageCollectorWasUsingPorts[garbagePort] <= 0;
        if (garbageCollectorCanUsePorts[garbagePort] & ~garbageCollectorLastLoop) begin
            //Go To Next Garbage Index
            if (~garbageIndexAtEnd | isWorkingOnFrame) begin
                //Read Port X
                if (~garbageIndexAtEnd | firstValidGarbageIndex != NULL_BLOB_INDEX) begin
                    garbageIndex <= garbageIndexAtEnd ? firstValidGarbageIndex : nextValidGarbageIndex;
                    blobBRAMPorts[garbagePort].addr <= garbageIndexAtEnd ? firstValidGarbageIndex : nextValidGarbageIndex;
                    blobBRAMPorts[garbagePort].we <= 0;
                    garbageCollectorWasUsingPorts[garbagePort] <= 1;
                end
            end
            //done with frame => all done
            else begin
                garbageCollectorLastLoop <= 1;
            end
        end

        lastGarbageIndex <= garbageIndex;
        garbagePort <= ~garbagePort;
    endfunction
    function automatic void resetGarbageCollector();
        garbagePort <= 0;
        garbageIndex <= 0;
        lastGarbageIndex <= 0;
        garbageCollectorWasUsingPorts <= '{0, 0};
        garbageCollectorLastLoop <= 0;
    endfunction
    function automatic BlobIndex getNextValidGarbageIndex(BlobIndex startIndex);
        //find next unscaned blob >= startIndex
        //(and < blobIndex because anything above that is invalid)
        for (int i = 0; i < MAX_BLOBS; i++) begin
            if (i >= startIndex & i <= blobIndex & blobMetadatas[i].status == UNSCANED) begin
                return i;
            end
        end
        return NULL_BLOB_INDEX;
    endfunction
    function automatic logic doesBlobMatchCriteria(BlobData blob);
        logic [9:0] boundWidth = blob.boundBottomRight.x - blob.boundTopLeft.x;
        logic [9:0] boundHeight = blob.boundBottomRight.y - blob.boundTopLeft.y;

        logic inAspectRatioRange = isAspectRatioInRange(boundWidth, boundHeight, virtexConfig.targetAspectRatioMin, virtexConfig.targetAspectRatioMax);

        logic [23:0] boundAreaUnshifted = boundWidth * boundHeight;
        logic inBoundAreaRange = `Math_inRangeInclusive(boundAreaUnshifted >> 1, virtexConfig.blobBoundAreaMin, virtexConfig.blobBoundAreaMax);

        logic inFullnessRange = isFullnessInRange(blob.area, boundAreaUnshifted, virtexConfig.blobFullnessMin, virtexConfig.blobFullnessMax);

        logic isValidAngle = virtexConfig.blobAnglesEnabled[calcBlobAngle(blob)];

        //FIXME
        return inBoundAreaRange;//inAspectRatioRange & inBoundAreaRange & inFullnessRange & isValidAngle;
    endfunction
    
    //Target Selector Loop
    function automatic void updateTargetSelectorDualGroup();
        /*  DUAL/GROUP
            ------------------------------------------------------
            0 -                 READ New B0 on 0 READ New A on 1       (B0 is invalid @ start)
            1 +                 READ New B1 on 1                       (B1 is invalid @ start)
            2 - PROCESS B0 on 0 READ New B0 on 0 SAVE A from 1 (first) (B0 is valid @ start)
            3 + PROCESS B1 on 1 READ New B1 on 1                       (B1 is valid @ start)
            4 - PROCESS B0 on 0 READ New B0 on 0                        ...
            5 + PROCESS B1 on 1 READ New B1 on 1
            6 - PROCESS B0 on 0 READ New B0 on 0
            ... till B0|B1 == NULL_BLOB_INDEX
            ---- till A == NULL_BLOB_INDEX */

        //SAVE A from 1
        if (targetHasNewA & ~targetPartion) begin
            targetBlobA = blobBRAMPorts[1].dout;
            targetBlobAAngle = calcBlobAngle(targetBlobA);
            targetHasNewA = 0; //BLOCKING

            //Wrap up + Reset for GROUP Mode
            if (virtexConfig.targetMode == GROUP) begin
                //Chain is Done. Make it the target if we made a valid target AND
                //its better than the current one OR we dont have a current one
                if (~isTargetNull(targetChainValid) &
                    (isTargetNull(targetCurrent) | distSqToTargetCenter(targetChainValid.center) < distSqToTargetCenter(targetCurrent.center))) begin
                        targetCurrent = targetChainValid;
                end

                //Reset Group Target Selector
                targetChain = '{
                    center: '{
                        x: (targetBlobA.boundBottomRight.x + targetBlobA.boundTopLeft.x) >> 1,
                        y: (targetBlobA.boundBottomRight.y + targetBlobA.boundTopLeft.y) >> 1
                    },
                    width:  targetBlobA.boundBottomRight.x - targetBlobA.boundTopLeft.x + 1,
                    height: targetBlobA.boundBottomRight.y - targetBlobA.boundTopLeft.y + 1,
                    angle: targetBlobAAngle,
                    blobCount: 1
                };
                targetChainValid = '{ //FIXME ??
                    center: 0,
                    width: 0, height: 0,
                    angle: targetBlobAAngle,
                    blobCount: 0
                };
            end
        end

        //PROCESS
        if (targetIndexBsValid[targetPartion]) begin
            //Get Blob
            BlobData targetBlobB = blobBRAMPorts[targetPartion].dout;
            BlobAngle targetBlobBAngle = calcBlobAngle(targetBlobB);

            //GROUP: chain other blobs together starting a Blob A
            if (virtexConfig.targetMode == GROUP) begin
                //make new enclosing bound that includes currentTarget & blobB
                Math::Vector2d10 chainTopLeft = '{
                    x: targetChain.center.x - (targetChain.width >> 1),
                    y: targetChain.center.y - (targetChain.height >> 1)
                };
                Math::Vector2d10 chainBottomRight = '{
                    x: targetChain.center.x + (targetChain.width >> 1),
                    y: targetChain.center.y + (targetChain.height >> 1)
                };
                Math::Vector2d10 newTopLeft = '{
                    x: `Math_min(targetBlobB.boundTopLeft.x, chainTopLeft.x),
                    y: `Math_min(targetBlobB.boundTopLeft.y, chainTopLeft.y)
                };
                Math::Vector2d10 newBottomRight = '{
                    x: `Math_max(targetBlobB.boundBottomRight.x, chainBottomRight.x),
                    y: `Math_max(targetBlobB.boundBottomRight.y, chainBottomRight.y)
                };
                Math::Vector2d10 newCenter = '{
                    x: (newTopLeft.x + newBottomRight.x) >> 1,
                    y: (newTopLeft.y + newBottomRight.y) >> 1
                };
                logic [9:0] newWidth = newBottomRight.x - newTopLeft.x + 1;
                logic [9:0] newHeight = newBottomRight.y - newTopLeft.y + 1;

                //gap valid between Blob B & target
                logic [9:0] gapX = `Math_min(
                    `Math_diff(targetBlobB.boundTopLeft.x, chainBottomRight.x),
                    `Math_diff(targetBlobB.boundBottomRight.x, chainTopLeft.x)
                );
                logic [9:0] gapY = `Math_min(
                    `Math_diff(targetBlobB.boundTopLeft.y, chainBottomRight.y),
                    `Math_diff(targetBlobB.boundBottomRight.y, chainTopLeft.y)
                );
                logic gapValid = `Math_inRangeInclusive(gapX, virtexConfig.targetBlobXGapMin, virtexConfig.targetBlobXGapMax) &
                    `Math_inRangeInclusive(gapY, virtexConfig.targetBlobYGapMin, virtexConfig.targetBlobYGapMax);

                //area diff between Blob A & B
                logic [23:0] areaBlobA = (targetBlobA.boundBottomRight.x - targetBlobA.boundTopLeft.x + 1) * (targetBlobA.boundBottomRight.y - targetBlobA.boundTopLeft.y + 1);
                logic [23:0] areaBlobB = (targetBlobB.boundBottomRight.x - targetBlobB.boundTopLeft.x + 1) * (targetBlobB.boundBottomRight.y - targetBlobB.boundTopLeft.y + 1);
                logic areaDiffValid = `Math_inRangeInclusive(`Math_diff(areaBlobA, areaBlobB), virtexConfig.targetBlobAreaDiffMin, virtexConfig.targetBlobAreaDiffMax);

                if (gapValid & areaDiffValid) begin
                    //aspect ratio of new currentTarget valid
                    logic newAspectRatioValid = isAspectRatioInRange(newWidth, newHeight, virtexConfig.targetAspectRatioMin, virtexConfig.targetAspectRatioMax);

                    //bound area of new currentTarget valid
                    logic newBoundAreaValid = `Math_inRangeInclusive(
                        (newWidth * newHeight) >> 1,
                        virtexConfig.targetBoundAreaMin,
                        virtexConfig.targetBoundAreaMax);
                    
                    //join current target
                    targetChain = '{
                        center: newCenter,
                        width: newWidth,
                        height: newHeight,
                        blobCount: targetChain.blobCount + 1,
                        angle: targetBlobAAngle
                    };

                    if (newAspectRatioValid & newBoundAreaValid) begin
                        //set current valid target
                        targetChainValid = targetChain;
                    end
                end
            end

            //DUAL: make all combinations of two blobs
            else begin
                //pick left & right
                logic [9:0] targetBlobACenterX = (targetBlobA.boundTopLeft.x + targetBlobA.boundBottomRight.x) >> 1;
                logic [9:0] blobBCenterX       = (targetBlobB.boundTopLeft.x + targetBlobB.boundBottomRight.x) >> 1;
                BlobData leftBlob        = targetBlobACenterX < blobBCenterX ? targetBlobA : targetBlobB;
                BlobAngle leftBlobAngle  = targetBlobACenterX < blobBCenterX ? targetBlobAAngle : targetBlobBAngle;
                BlobData rightBlob       = targetBlobACenterX < blobBCenterX ? targetBlobB : targetBlobA;
                BlobAngle rightBlobAngle = targetBlobACenterX < blobBCenterX ? targetBlobBAngle : targetBlobAAngle;

                //make enclosing bound
                Math::Vector2d10 topLeft = '{
                    x: `Math_min(leftBlob.boundTopLeft.x, rightBlob.boundTopLeft.x),
                    y: `Math_min(leftBlob.boundTopLeft.y, rightBlob.boundTopLeft.y)
                };
                Math::Vector2d10 bottomRight = '{
                    x: `Math_max(leftBlob.boundBottomRight.x, rightBlob.boundBottomRight.x),
                    y: `Math_max(leftBlob.boundBottomRight.y, rightBlob.boundBottomRight.y)
                };
                Math::Vector2d10 center = '{
                    x: (topLeft.x + bottomRight.x) >> 1,
                    y: (topLeft.y + bottomRight.y) >> 1
                };
                logic [9:0] width = bottomRight.x - topLeft.x + 1;
                logic [9:0] height = bottomRight.y - topLeft.y + 1;

                //find if angles are valid
                logic isAngleValid = virtexConfig.targetMode == DUAL_UP ?
                    leftBlobAngle == FORWARD & rightBlobAngle == BACKWARD :
                    virtexConfig.targetMode == DUAL_DOWN ?
                    leftBlobAngle == BACKWARD & rightBlobAngle == FORWARD : 1;

                //gap valid
                logic [9:0] gapX = `Math_diff(rightBlob.boundTopLeft.x, leftBlob.boundBottomRight.x);
                logic [9:0] gapY = `Math_diff(rightBlob.boundTopLeft.y, leftBlob.boundBottomRight.y);
                logic gapValid = `Math_inRangeInclusive(gapX, virtexConfig.targetBlobXGapMin, virtexConfig.targetBlobXGapMax) &
                    `Math_inRangeInclusive(gapY, virtexConfig.targetBlobYGapMin, virtexConfig.targetBlobYGapMax);

                //aspect ratio valid
                logic aspectRatioValid = isAspectRatioInRange(width, height, virtexConfig.targetAspectRatioMin, virtexConfig.targetAspectRatioMax);

                //bound area valid
                logic boundAreaValid = `Math_inRangeInclusive((width * height) >> 1,
                    virtexConfig.targetBoundAreaMin, virtexConfig.targetBoundAreaMax);

                //area diff valid
                logic [23:0] areaLeft = (leftBlob.boundBottomRight.x - leftBlob.boundTopLeft.x + 1) * (leftBlob.boundBottomRight.y - leftBlob.boundTopLeft.y + 1);
                logic [23:0] areaRight = (rightBlob.boundBottomRight.x - rightBlob.boundTopLeft.x + 1) * (rightBlob.boundBottomRight.y - rightBlob.boundTopLeft.y + 1);
                logic areaDiffValid = `Math_inRangeInclusive(`Math_diff(areaRight, areaLeft),
                    virtexConfig.targetBlobAreaDiffMin, virtexConfig.targetBlobAreaDiffMax);
                
                //if this target is valid AND this target is better OR we dont have a target yet
                if (isAngleValid & gapValid & aspectRatioValid & boundAreaValid & areaDiffValid &
                    (isTargetNull(targetCurrent) | distSqToTargetCenter(center) < distSqToTargetCenter(targetCurrent.center))) begin
                    targetCurrent = '{
                        center: center,
                        width: width,
                        height: height,
                        blobCount: 2,
                        angle: leftBlobAngle
                    };
                end
            end

            //Clear Valitity
            targetIndexBsValid[targetPartion] = 0;
        end

        if (~targetWantsNewA) begin
            //Set New B0|1 (our current partion has the oldest index, so our new index one will be the next step ahead of the other partion's index)
            targetIndexBs[targetPartion] = nextTargetIndex[~targetPartion]; //BLOCKING

            //Request New A (IF frame init OR no more Bs left (if new B0|1 is NULL | or new B0|1 is invalid AND new new B is NULL))
            if (targetIndexA == NULL_BLOB_INDEX | targetIndexBs[targetPartion] == NULL_BLOB_INDEX | 
                (targetIndexBs[targetPartion] == targetIndexA & nextTargetIndex[targetPartion] == NULL_BLOB_INDEX)) begin
                //Request New A
                //we need access to both BRAM ports so we may have to wait
                //an entire loop for the last B to finish processing
                targetWantsNewA = 1;
            end

            //READ New B0|1
            else begin
                //increment B0|1 again (because new B0|1 is invalid aka overlaps A in GROUP mode)
                if (targetIndexBs[targetPartion] == targetIndexA) begin
                    targetIndexBs[targetPartion] = nextTargetIndex[targetPartion];
                end

                //READ New B0|1 on 0|1
                targetReadIndex(targetPartion);
            end
        end

        //Reset for New A
        if (targetWantsNewA & ~targetIndexBsValid[0] & ~targetIndexBsValid[1]) begin
            //Set New A (if @ start frame use first valid blob index)
            targetIndexA = targetIndexA == NULL_BLOB_INDEX ? firstTargetIndex : nextTargetIndexA; //BLOCKING

            //Finish Frame
            if (targetIndexA == NULL_BLOB_INDEX) begin
                targetSelectorDone = 1;

                //Save Best Target into Target Slot
                target = targetCurrent;
            end

            //READ New A & B0|1 (if not end frame AND valid New B for DUAL mode)
            else if (nextTargetIndexA != NULL_BLOB_INDEX | virtexConfig.targetMode == GROUP) begin
                //READ New A on 1
                blobBRAMPorts[1].addr <= targetIndexA;
                blobBRAMPorts[1].we <= 0;

                //Set New B0
                targetIndexBs[0] = (virtexConfig.targetMode == GROUP & firstTargetIndex != targetIndexA) ? 
                    firstTargetIndex : nextTargetIndexA;

                //READ New B0 on 0
                targetReadIndex(0);

                //Update State
                targetHasNewA = 1;
                targetWantsNewA = 0;
                targetPartion = 1;
            end
        end

        //Swap Partion (or hold 0 for new A)
        else begin
            targetPartion = ~targetPartion;
        end
    endfunction
    function automatic void updateTargetSelectorSingle(BlobData blob);
        //Convert Blob A Bounding Box from TopLeft/BottomRight => Center/Width/Height
        Math::Vector2d10 center = '{
            x: (blob.boundBottomRight.x + blob.boundTopLeft.x) >> 1,
            y: (blob.boundBottomRight.y + blob.boundTopLeft.y) >> 1
        };
        logic [9:0] width  = blob.boundBottomRight.x - blob.boundTopLeft.x + 1;
        logic [9:0] height = blob.boundBottomRight.y - blob.boundTopLeft.y + 1;

        //aspect ratio valid
        logic aspectRatioValid = isAspectRatioInRange(width, height, virtexConfig.targetAspectRatioMin, virtexConfig.targetAspectRatioMax);

        //bound area valid
        logic boundAreaValid = `Math_inRangeInclusive((width * height) >> 1,
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
            $display("GOOD TARGET: {x:%d, y:%d}, width:%d, height:%d, angle:%d", targetCurrent.center.x, targetCurrent.center.y, targetCurrent.width, targetCurrent.height, targetCurrent.angle);
        end
        else
            $display("BAD TARGET: {x:%d, y:%d}, width:%d, height:%d, angle:%d, %b %b", center.x, center.y, width, height, calcBlobAngle(blob), aspectRatioValid, boundAreaValid);
    endfunction
    function automatic void targetReadIndex(logic partion);
        blobBRAMPorts[partion].addr <= targetIndexBs[partion];
        blobBRAMPorts[partion].we <= 0;
        targetIndexBsValid[partion] <= 1;
    endfunction
    function automatic BlobIndex getNextValidTargetIndex(BlobIndex startIndex);
        //find next valid blob >= startIndex
        //(and < blobIndex because anything above that is invalid)
        for (int i = 0; i < MAX_BLOBS; i++) begin
            if (i >= startIndex & i <= blobIndex & blobMetadatas[i].status == VALID) begin
                return i;
            end
        end
        return NULL_BLOB_INDEX;
    endfunction
    function automatic logic [18:0] distSqToTargetCenter(Math::Vector2d10 v);
        //Distance^2 Between Math::Vector2d10 and Target Center
        return (v.x - virtexConfig.targetCenterX)**2 + (v.y - virtexConfig.targetCenterY)**2;
    endfunction

    //Resetting for New Frame
    initial reset();
    function automatic void reset();
        //RLE
        rleRunBuffer <= NULL_RUN_BUFFER;

        blobRunBufferNext <= NULL_RUN_BUFFER;
        blobRunBufferCurrent <= NULL_RUN_BUFFER;
        blobRunBufferLast <= NULL_RUN_BUFFER;
        blobIndex <= 0;
        blobUsingPort1 <= 0;
        
        //Garbage Collector
        resetGarbageCollector();

        //Target Selector
        if (~targetSelectorDone & ~isFirstFrame) begin
            TARGET_SELECTOR_TOO_SLOW_FAULT <= 1;
        end
        targetSelectorDone <= 0;
        targetCurrent <= NULL_TARGET;
        targetIndexA <= NULL_BLOB_INDEX;
        targetIndexBs <= '{0, 0};
        targetIndexBsValid <= '{0, 0};
        targetChain <= NULL_TARGET;
        targetChainValid <= NULL_TARGET;
        targetPartion <= 0;
        targetHasNewA <= 0;
        targetWantsNewA <= 0;

        justReset <= 1;
    endfunction

    //Get Blob Pointer Index (follow a blob's pointer)
    function automatic BlobIndex getBlobPointerIndex(BlobIndex startIndex);
        BlobIndex index = startIndex;
        for (int i = 0; i < MAX_BLOB_POINTER_DEPTH; i++) begin
            if (blobMetadatas[index].status == POINTER) begin
                index = blobMetadatas[index].pointer; //BLOCKING
            end
            else begin
                return index;
            end
        end
        return NULL_BLOB_INDEX;
    endfunction

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
    fifo_python_to_blob fifo_python_to_blob (
        .full(kernelFIFOFull),
        .din(kernelInput),
        .wr_en(kernelInputWrite),
        .wr_clk(CLK72),
        .empty(kernelFIFOEmpty),
        .dout(kernel),
        .rd_en(readNewKernel),
        .rd_clk(CLK200),
        .rst(1'b0)
    );
    always_comb if (kernelFIFOFull) KERNEL_FIFO_FULL_FAULT = 1;
endmodule