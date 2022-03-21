`timescale 1ns / 1ps
`include "../python/PythonUtil.sv"
`include "BlobUtil.sv"
`include "../config/VirtexConfig.sv"

/* BlobProcessor - Processes incoming pixels into blobs and selects the target blob based on config
   
   */
module BlobProcessor(
    input wire CLK200, CLK72,
    input Kernel kernelInput,
    input wire kernelInputWrite,
    output Target target,
    input VirtexConfig virtexConfig,
    output reg OUT_OF_BLOB_MEM_FAULT,
    output reg OUT_OF_RLE_MEM_FAULT,
    output reg BLOB_POINTER_DEPTH_FAULT,
    output reg BLOB_PROCESSOR_SLOW_FAULT,
    output reg KERNEL_FIFO_FULL_FAULT,
    output reg TARGET_SELECTOR_TOO_SLOW_FAULT //TODO pull down?
    );

    //FIFO Kernel Input
    wire kernelFIFOFull, kernelFIFOEmpty;
    wire hasNewKernel = ~kernelFIFOEmpty;
    Kernel kernel;
    reg readNewKernel = 0;
    reg resetKernelFIFO = 1;
    fifo_python_to_blob fifo_python_to_blob (
        .full(kernelFIFOFull),
        .din(kernelInput),
        .wr_en(kernelInputWrite),
        .wr_clk(CLK72),
        .empty(kernelFIFOEmpty),
        .dout(kernel),
        .rd_en(readNewKernel),
        .rd_clk(CLK200),
        .rst(resetKernelFIFO)
    );
    always_comb if (kernelFIFOFull & ~resetKernelFIFO) KERNEL_FIFO_FULL_FAULT = 1;

    //Blob BRAM
    typedef struct packed {
        logic [10:0] addr;
        BlobData din, dout;
        logic we;
    } BlobBRAMPort;
    BlobBRAMPort blobBRAMPorts [1:0] = '{0, 0};
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

    //Run Length Encoder (registers + wires)
    RunBuffer runBuffers [2:0];
    initial for (int i = 0; i < 3; i++) runBuffers[i] = '{ runs: 0, count: 0, line: NULL_LINE_NUMBER };
    RunBufferPartion rleRunBuffersPartion;
    wire isLastKernel = kernel.pos.y == IMAGE_HEIGHT-1 & kernel.pos.x == KERNEL_MAX_X;
    wire rlePartionValid = rleRunBuffersPartion != NULL_RUN_BUFFER_PARTION;
    reg lastKernelZero = 0, isFirstFrame = 1;

    //Blob Processor (registers + wires)
    enum logic [2:0] { IDLE=0, LAST_LINE=1, MERGE_READ=2, MERGE_WRITE_1=3, MERGE_WRITE_2=4, JOIN_1=5, JOIN_2=6, WRITE=7 } blobRunState = IDLE;
    BlobMetadata blobMetadatas [MAX_BLOBS];
    initial for (int i = 0; i < MAX_BLOBS; i++) blobMetadatas[i] = '{ status: UNSCANED, pointer: NULL_BLOB_INDEX };
    BlobIndex blobIndex;
    RunBufferPartion blobRunBuffersPartionCurrent; //partion of run buffer (0-2)
    RunBufferPartion blobRunBuffersPartionLast;
    RunBufferIndex blobRunBufferIndexCurrent; //index in run buffer
    RunBufferIndex blobRunBufferIndexLast;
    reg [9:0] blobRunBufferXCurrent; // counter for RLE x position
    reg [9:0] blobRunBufferXLast;
    BlobIndex blobMasterIndex; //master blob for run to join into (following joining runs are slaves)
    reg blobUsingPort1; //whether blobProcessor is using port1 (so garbage collector won't)
    wire blobProcessorDoneWithLine = blobRunBuffersPartionCurrent == NULL_RUN_BUFFER_PARTION |
        blobRunBufferIndexCurrent >= runBuffers[blobRunBuffersPartionCurrent].count; //done with line @ on NULL line OR all runs processed
    wire blobPartionCurrentValid = blobRunBuffersPartionCurrent != NULL_RUN_BUFFER_PARTION;
    wire RunBufferPartion blobNextPartionCurrent = overflow2(blobRunBuffersPartionCurrent + 1, 2); //note: overflow2(NULL+1)=0
    wire blobNextLineAvailable = rleRunBuffersPartion != blobNextPartionCurrent &
        runBuffers[blobNextPartionCurrent].line != NULL_LINE_NUMBER; //can move next line @ rle is done with it & its a valid location
    wire blobProcessorTooSlow = rlePartionValid & rleRunBuffersPartion == blobRunBuffersPartionLast;
    wire blobProcessorReallyTooSlow = rlePartionValid & rleRunBuffersPartion == blobRunBuffersPartionCurrent;
    wire Run blobLastLineRun = runBuffers[blobRunBuffersPartionLast].runs[blobRunBufferIndexLast];
    wire BlobIndex blobLastLineRunBlobPointerIndex = getBlobPointerIndex(blobLastLineRun.blobIndex);
    wire Run blobCurrentRun = runBuffers[blobRunBuffersPartionCurrent].runs[blobRunBufferIndexCurrent];
    wire [9:0] blobCurrentLine = runBuffers[blobRunBuffersPartionCurrent].line;
    wire blobProcessorOnLastLine = blobCurrentLine == IMAGE_HEIGHT-1;
    wire isWorkingOnFrame = ~isLastKernel | ~blobProcessorDoneWithLine | ~blobProcessorOnLastLine;
    reg lastIsWorkingOnFrame;

    //Target Selector (registers + wires)
    reg targetSelectorDone = 1;
    Target targetCurrent; //current best target for the frame
    BlobIndex targetIndexA; //keeping track of A for DUAL/GROUP; also tracking frame start when == NULL
    BlobIndex targetIndexBs [1:0];  //B0|1
    reg targetIndexBsValid [1:0];
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
    BlobIndex lastGarbageIndex [1:0] = '{0, 0}; 
    reg garbageCollectorWasUsingPorts [1:0] = '{0, 0}; //BRAM ports
    wire garbageCollectorCanUsePorts [1:0] = '{~isWorkingOnFrame, ~blobUsingPort1};
    wire garbageCollectorUsingPorts [1:0] = '{garbageCollectorWasUsingPorts[0] & garbageCollectorCanUsePorts[0], garbageCollectorWasUsingPorts[1] & garbageCollectorCanUsePorts[1]}; //if read from Port A & can still use it
    wire BlobIndex nextValidGarbageIndex = getNextValidGarbageIndex(garbageIndex + 1);
    wire BlobIndex firstValidGarbageIndex = getNextValidGarbageIndex(0);
    reg garbageCollectorLastLoop;
    wire garbageCollectorDone = garbageCollectorLastLoop & garbageCollectorUsingPorts == '{0, 0};

    //Main Process Loop
    always_ff @(negedge CLK200) begin
        resetKernelFIFO <= 0;

        //Reset All @ Frame Start
        if (kernel.pos == 0 & ~lastKernelZero) begin
            reset();
            isFirstFrame <= 0;
        end
        lastKernelZero <= kernel.pos == 0;

        //Reset Garbage Collector @ Frame End
        if (~isWorkingOnFrame & lastIsWorkingOnFrame) begin
            //reset garbage collector @ frame end because garbageIndex
            //may have passed blobs that were still being worked on
            resetGarbageCollector();
        end
        lastIsWorkingOnFrame <= isWorkingOnFrame;

        //Garbage Collection Loop
        if (~garbageCollectorDone) begin
            updateGarbageCollector();
        end
        
        //Working on Frame
        readNewKernel <= hasNewKernel;
        if (isWorkingOnFrame) begin
            //Process New Kernel
            if (readNewKernel) begin
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
                target = targetCurrent;
            end
            else begin
                //DUAL/GROUP Target Selection Loop
                updateTargetSelectorDualGroup();
            end
        end
    end

    //Run Length Encoding Loop
    function automatic void updateRunLengthEncoder(Kernel kernel);
        //start of line
        if (kernel.pos.x == 0) begin
            //FORK
            //set line number of our RunBuffer
            runBuffers[rleRunBuffersPartion].line = kernel.pos.y;

            //zero count of our RunBuffer
            runBuffers[rleRunBuffersPartion].count = 0;
            //JOIN
        end
        
        //encode every pixel in kernel
        for (int x = 0; x < 8; x++) begin
            //FORK
            //new run @ start of line OR color transition
            if ((kernel.pos.x == 0 & x == 0) |
                kernel.value[x] != (runBuffers[rleRunBuffersPartion].runs[runBuffers[rleRunBuffersPartion].count-1].blobIndex != NULL_BLACK_RUN_BLOB_INDEX)) begin

                //push run to buffer
                runBuffers[rleRunBuffersPartion].runs[runBuffers[rleRunBuffersPartion].count] = '{
                    length: 1,
                    blobIndex: kernel.value[x] ? NULL_BLOB_INDEX : NULL_BLACK_RUN_BLOB_INDEX
                };

                //increment our buffer count for next run
                if (runBuffers[rleRunBuffersPartion].count == MAX_RUNS_PER_LINE) begin
                    OUT_OF_RLE_MEM_FAULT = 1;
                end
                else begin
                    runBuffers[rleRunBuffersPartion].count = runBuffers[rleRunBuffersPartion].count + 1;
                end
            end

            //extend length of last run
            else begin
                runBuffers[rleRunBuffersPartion].runs[runBuffers[rleRunBuffersPartion].count-1].length = 
                runBuffers[rleRunBuffersPartion].runs[runBuffers[rleRunBuffersPartion].count-1].length + 1;
            end
            //JOIN
        end

        //end line
        if (kernel.pos.x == KERNEL_MAX_X) begin
            //FORK
            if (runBuffers[rleRunBuffersPartion].line == IMAGE_HEIGHT-1) begin
                //done with frame => null
                rleRunBuffersPartion = NULL_RUN_BUFFER_PARTION;
            end
            else begin
                //increment buffer partion for next line
                rleRunBuffersPartion = overflow2(rleRunBuffersPartion + 1, 2);
            end
            //JOIN
        end
    endfunction

    //Blob Processor Loop
    function automatic void updateBlobProcessor();
        blobBRAMPorts[0].we <= 0;

        //Next Line
        if ((blobProcessorDoneWithLine & blobNextLineAvailable) | blobProcessorTooSlow | blobProcessorReallyTooSlow) begin
            //Fault
            if ((blobProcessorReallyTooSlow | blobProcessorTooSlow) & ~(blobProcessorDoneWithLine & blobNextLineAvailable)) begin
                BLOB_PROCESSOR_SLOW_FAULT <= 1;
            end

            //FORK
            //Get partions for new line
            if (blobProcessorReallyTooSlow) begin
                //blob processor is so slow that we it caught up to our current position
                // => skip 2 lines so we can still use the last line wo/ RLE overwriting it
                //this can happen on the first line of the image, where blobRunBuffersPartionLast is NULL
                //get partions for new line
                logic [1:0] nextPartionLast = blobNextPartionCurrent;
                blobRunBuffersPartionLast = 
                    (nextPartionLast != overflow2(blobNextPartionCurrent + 1, 2) & runBuffers[nextPartionLast].line != NULL_LINE_NUMBER) ?
                    nextPartionLast : NULL_RUN_BUFFER_PARTION;
                blobRunBuffersPartionCurrent = overflow2(blobNextPartionCurrent + 1, 2);
            end
            else begin
                logic [1:0] nextPartionLast = overflow2(blobRunBuffersPartionCurrent, 2);
                blobRunBuffersPartionLast = 
                    (nextPartionLast != blobNextPartionCurrent & runBuffers[nextPartionLast].line != NULL_LINE_NUMBER) ?
                    nextPartionLast : NULL_RUN_BUFFER_PARTION;
                blobRunBuffersPartionCurrent = blobNextPartionCurrent;
           end

            //Reset Intra-Buffer Indexes
            blobRunBufferIndexCurrent = 0;
            blobRunBufferXCurrent = 0;
            blobRunState = IDLE;
            //JOIN
        end

        //Handle Run (if we are on a valid partion of the RunBuffer & there are more Runs to handle)
        if (blobPartionCurrentValid & blobRunBufferIndexCurrent < runBuffers[blobRunBuffersPartionCurrent].count) begin
            //run is black => continue to next run
            if (blobCurrentRun.blobIndex == NULL_BLACK_RUN_BLOB_INDEX) begin
                //continue to next run
                blobRunBufferXCurrent = blobRunBufferXCurrent + runBuffers[blobRunBuffersPartionCurrent].runs[blobRunBufferIndexCurrent].length;
                blobRunBufferIndexCurrent = blobRunBufferIndexCurrent + 1;
            end

            //run is white => process
            else begin
                //start run (if done with last one, or last one timed out)
                if (blobRunState == IDLE) begin
                    //FORK
                    //mark this run as doesn't have another run to join
                    blobMasterIndex = NULL_BLOB_INDEX;

                    //reset last run buffer indexes
                    blobRunBufferIndexLast = 0;
                    blobRunBufferXLast = 0;

                    //proceed to look for runs to join OR go straight to writing if on the first line of image
                    blobRunState = (blobRunBuffersPartionLast == NULL_RUN_BUFFER_PARTION) ? WRITE : LAST_LINE;
                    //JOIN
                end
 
                //loop through all runs that were filled up in the last run buffer (line above)
                if (blobRunState == LAST_LINE) begin
                    //FORK
                    for (int i = 0; i < MAX_RUNS_PER_LINE; i++) begin
                        if (i >= blobRunBufferIndexLast & blobRunBufferIndexLast < runBuffers[blobRunBuffersPartionLast].count) begin
                            //FORK
                            if (blobLastLineRun.blobIndex != NULL_BLACK_RUN_BLOB_INDEX) begin
                                if (runsOverlap(blobCurrentRun, blobRunBufferXCurrent, blobLastLineRun, blobRunBufferXLast)) begin
                                    //pointer fault
                                    if (blobLastLineRunBlobPointerIndex == NULL_BLOB_INDEX) begin
                                        BLOB_POINTER_DEPTH_FAULT = 1;
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
                            //JOIN
                            
                            blobRunBufferXLast = blobRunBufferXLast + runBuffers[blobRunBuffersPartionLast].runs[blobRunBufferIndexLast].length; //BLOCKING
                            blobRunBufferIndexLast = blobRunBufferIndexLast + 1;
                        end
                    end
                    //JOIN

                    //done looping last line => write blob
                    if (blobRunState == LAST_LINE) begin
                        //FORK
                        blobRunState = blobMasterIndex == NULL_BLOB_INDEX ? WRITE : JOIN_1;
                        //JOIN
                    end
                end

                else if (blobRunState == MERGE_WRITE_1) begin
                    //account for read delay
                    //FORK
                    blobRunState = MERGE_WRITE_2;
                    //JOIN
                end

                else if (blobRunState == MERGE_WRITE_2) begin
                    //FORK
                    blobBRAMPorts[0].din <= mergeBlobs(blobBRAMPorts[1].dout, blobBRAMPorts[0].dout);
                    blobBRAMPorts[0].we <= 1;
                    blobUsingPort1 = 0;
                    blobRunState = LAST_LINE;
                    //JOIN
                end

                if (blobRunState == JOIN_1) begin
                    //FORK
                    //account for read delay
                    blobBRAMPorts[0].addr <= blobMasterIndex;
                    blobRunState = JOIN_2;
                    //JOIN
                end

                else if (blobRunState == JOIN_2) begin
                    //FORK
                    blobRunState = WRITE;
                    //JOIN
                end

                else if (blobRunState == WRITE) begin
                    //FORK
                    //add this pixel to blob if we have a valid blob to join
                    if (blobMasterIndex != NULL_BLOB_INDEX) begin
                        blobBRAMPorts[0].din <= mergeBlobs(runToBlob(blobCurrentRun, blobRunBufferXCurrent, blobCurrentLine), blobBRAMPorts[0].dout);
                        blobBRAMPorts[0].we <= 1;

                        //set index of the blob we joined
                        runBuffers[blobRunBuffersPartionCurrent].runs[blobRunBufferIndexCurrent].blobIndex = blobMasterIndex;
                    end
                    
                    //not touching a blob => make new blob
                    else begin
                        //create blob at next available index
                        blobBRAMPorts[0].addr <= blobIndex;
                        blobBRAMPorts[0].din <= runToBlob(blobCurrentRun, blobRunBufferXCurrent, blobCurrentLine);
                        blobBRAMPorts[0].we <= 1;
                        blobMetadatas[blobIndex].status = UNSCANED; //tell garbage collector to check this once it is done

                        //set index of the blob we made in runBuffer
                        runBuffers[blobRunBuffersPartionCurrent].runs[blobRunBufferIndexCurrent].blobIndex = blobIndex;

                        
                        if (blobIndex == MAX_BLOBS-1) begin
                            //fault
                            OUT_OF_BLOB_MEM_FAULT = 1;
                            blobIndex = 0;
                        end
                        else begin
                            //increment index for next blob
                            blobIndex = blobIndex + 1;
                        end  
                    end
                    //JOIN

                    //FORK
                    //continue to next run
                    blobRunBufferXCurrent = blobRunBufferXCurrent + runBuffers[blobRunBuffersPartionCurrent].runs[blobRunBufferIndexCurrent].length;
                    blobRunBufferIndexCurrent = blobRunBufferIndexCurrent + 1;
                    blobRunState = IDLE;
                    //JOIN
                end
            end
        end
    endfunction

    //Garbage Collector Loop
    function automatic void updateGarbageCollector();
        //Process Port 0|1 (if read from)
        if (garbageCollectorUsingPorts[garbagePort]) begin
            BlobData blob = blobBRAMPorts[garbagePort].dout;
            $display("111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111");
            $display("--- %b %b %b ---", ~isWorkingOnFrame, blobPartionCurrentValid, blob.boundBottomRight.y + 2 < blobCurrentLine);

            //if blob is finished adding to
            if (~isWorkingOnFrame | (blobPartionCurrentValid & blob.boundBottomRight.y + 2 < blobCurrentLine)) begin
                reg valid = doesBlobMatchCriteria(blob);

                $display("222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222");

                //Mark blob as Valid or Garbage
                blobMetadatas[lastGarbageIndex[1]].status = valid ? VALID : GARBAGE;

                //Single Mode Target Selector
                $display("DISPLAY MOMA %b", valid);
                if (virtexConfig.targetMode == SINGLE & valid) begin
                    updateTargetSelectorSingle(blob);
                end
            end
        end

        //Read Port 0|1 (if available & not writing angle)
        garbageCollectorWasUsingPorts[garbagePort] <= 0;
        if (garbageCollectorCanUsePorts[garbagePort] & ~garbageCollectorLastLoop) begin
            //Go To Next Garbage Index
            setNextGarbageIndex();

            //Read Port X
            if (garbageIndex != NULL_BLOB_INDEX & ~garbageCollectorDone) begin
                blobBRAMPorts[garbagePort].addr <= garbageIndex;
                blobBRAMPorts[garbagePort].we <= 0;
                garbageCollectorWasUsingPorts[garbagePort] <= 1;
            end
        end

        lastGarbageIndex[1] <= lastGarbageIndex[0];
        lastGarbageIndex[0] <= garbageIndex;
        garbagePort <= ~garbagePort;
    endfunction
    function automatic void resetGarbageCollector();
        garbagePort = 0;
        garbageIndex = 0;
        lastGarbageIndex = '{0, 0};
        garbageCollectorWasUsingPorts = '{0, 0};
        garbageCollectorLastLoop = 0;
    endfunction
    function automatic void setNextGarbageIndex();
        //FORK
        if (garbageIndex == NULL_BLOB_INDEX | nextValidGarbageIndex == NULL_BLOB_INDEX) begin
            //still on frame => keep doing garbage duty
            if (isWorkingOnFrame) begin
                garbageIndex = firstValidGarbageIndex;
            end

            //done with frame => all done
            else begin
                garbageCollectorLastLoop = 1;
            end
        end
        else begin
            garbageIndex = nextValidGarbageIndex;
        end
        //JOIN
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
        //FIXME
        // logic [9:0] boundWidth = blob.boundBottomRight.x - blob.boundTopLeft.x;
        // logic [9:0] boundHeight = blob.boundBottomRight.y - blob.boundTopLeft.y;

        // logic inAspectRatioRange = isAspectRatioInRange(boundWidth, boundHeight, virtexConfig.targetAspectRatioMin, virtexConfig.targetAspectRatioMax);

        // logic [23:0] boundAreaUnshifted = boundWidth * boundHeight;
        // logic inBoundAreaRange = inRangeInclusive16(boundAreaUnshifted >> 1, virtexConfig.blobBoundAreaMin, virtexConfig.blobBoundAreaMax);

        // logic inFullnessRange = isFullnessInRange(blob.area, boundAreaUnshifted, virtexConfig.blobFullnessMin, virtexConfig.blobFullnessMax);

        // logic isValidAngle = virtexConfig.blobAnglesEnabled[calcBlobAngle(blob)];

        return 1;//inAspectRatioRange & inBoundAreaRange & inFullnessRange & isValidAngle;
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
                Vector chainTopLeft = '{
                    x: targetChain.center.x - (targetChain.width >> 1),
                    y: targetChain.center.y - (targetChain.height >> 1)
                };
                Vector chainBottomRight = '{
                    x: targetChain.center.x + (targetChain.width >> 1),
                    y: targetChain.center.y + (targetChain.height >> 1)
                };
                Vector newTopLeft = '{
                    x: min10(targetBlobB.boundTopLeft.x, chainTopLeft.x),
                    y: min10(targetBlobB.boundTopLeft.y, chainTopLeft.y)
                };
                Vector newBottomRight = '{
                    x: max10(targetBlobB.boundBottomRight.x, chainBottomRight.x),
                    y: max10(targetBlobB.boundBottomRight.y, chainBottomRight.y)
                };
                Vector newCenter = '{
                    x: (newTopLeft.x + newBottomRight.x) >> 1,
                    y: (newTopLeft.y + newBottomRight.y) >> 1
                };
                logic [9:0] newWidth = newBottomRight.x - newTopLeft.x + 1;
                logic [9:0] newHeight = newBottomRight.y - newTopLeft.y + 1;

                //gap valid between Blob B & target
                logic [9:0] gapX = min10(
                    diff10(targetBlobB.boundTopLeft.x, chainBottomRight.x),
                    diff10(targetBlobB.boundBottomRight.x, chainTopLeft.x)
                );
                logic [9:0] gapY = min10(
                    diff10(targetBlobB.boundTopLeft.y, chainBottomRight.y),
                    diff10(targetBlobB.boundBottomRight.y, chainTopLeft.y)
                );
                logic gapValid = inRangeInclusive16(gapX, virtexConfig.targetBlobXGapMin, virtexConfig.targetBlobXGapMax) &
                    inRangeInclusive16(gapY, virtexConfig.targetBlobYGapMin, virtexConfig.targetBlobYGapMax);

                //area diff between Blob A & B
                logic [23:0] areaBlobA = (targetBlobA.boundBottomRight.x - targetBlobA.boundTopLeft.x + 1) * (targetBlobA.boundBottomRight.y - targetBlobA.boundTopLeft.y + 1);
                logic [23:0] areaBlobB = (targetBlobB.boundBottomRight.x - targetBlobB.boundTopLeft.x + 1) * (targetBlobB.boundBottomRight.y - targetBlobB.boundTopLeft.y + 1);
                logic areaDiffValid = inRangeInclusive24(diff24(areaBlobA, areaBlobB), virtexConfig.targetBlobAreaDiffMin, virtexConfig.targetBlobAreaDiffMax);

                if (gapValid & areaDiffValid) begin
                    //aspect ratio of new currentTarget valid
                    logic newAspectRatioValid = isAspectRatioInRange(newWidth, newHeight, virtexConfig.targetAspectRatioMin, virtexConfig.targetAspectRatioMax);

                    //bound area of new currentTarget valid
                    logic newBoundAreaValid = inRangeInclusive16(
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
                Vector topLeft = '{
                    x: min10(leftBlob.boundTopLeft.x, rightBlob.boundTopLeft.x),
                    y: min10(leftBlob.boundTopLeft.y, rightBlob.boundTopLeft.y)
                };
                Vector bottomRight = '{
                    x: max10(leftBlob.boundBottomRight.x, rightBlob.boundBottomRight.x),
                    y: max10(leftBlob.boundBottomRight.y, rightBlob.boundBottomRight.y)
                };
                Vector center = '{
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
                logic [9:0] gapX = diff10(rightBlob.boundTopLeft.x, leftBlob.boundBottomRight.x);
                logic [9:0] gapY = diff10(rightBlob.boundTopLeft.y, leftBlob.boundBottomRight.y);
                logic gapValid = inRangeInclusive16(gapX, virtexConfig.targetBlobXGapMin, virtexConfig.targetBlobXGapMax) &
                    inRangeInclusive16(gapY, virtexConfig.targetBlobYGapMin, virtexConfig.targetBlobYGapMax);

                //aspect ratio valid
                logic aspectRatioValid = isAspectRatioInRange(width, height, virtexConfig.targetAspectRatioMin, virtexConfig.targetAspectRatioMax);

                //bound area valid
                logic boundAreaValid = inRangeInclusive16((width * height) >> 1,
                    virtexConfig.targetBoundAreaMin, virtexConfig.targetBoundAreaMax);

                //area diff valid
                logic [23:0] areaLeft = (leftBlob.boundBottomRight.x - leftBlob.boundTopLeft.x + 1) * (leftBlob.boundBottomRight.y - leftBlob.boundTopLeft.y + 1);
                logic [23:0] areaRight = (rightBlob.boundBottomRight.x - rightBlob.boundTopLeft.x + 1) * (rightBlob.boundBottomRight.y - rightBlob.boundTopLeft.y + 1);
                logic areaDiffValid = inRangeInclusive24(diff24(areaRight, areaLeft),
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
        Vector center = '{
            x: (blob.boundBottomRight.x + blob.boundTopLeft.x) >> 1,
            y: (blob.boundBottomRight.y + blob.boundTopLeft.y) >> 1
        };
        logic [9:0] width  = blob.boundBottomRight.x - blob.boundTopLeft.x + 1;
        logic [9:0] height = blob.boundBottomRight.y - blob.boundTopLeft.y + 1;

        //aspect ratio valid
        logic aspectRatioValid = isAspectRatioInRange(width, height, virtexConfig.targetAspectRatioMin, virtexConfig.targetAspectRatioMax);

        //bound area valid
        logic boundAreaValid = inRangeInclusive16((width * height) >> 1,
            virtexConfig.targetBoundAreaMin, virtexConfig.targetBoundAreaMax);

        $display("TARGET: {x:%d, y:%d}, width:%d, height:%d, angle:%d, %b %b", center.x, center.y, width, height, calcBlobAngle(blob), aspectRatioValid, boundAreaValid);

        //if this target is valid AND this target is better OR we dont have a target yet
        if (//aspectRatioValid & boundAreaValid &
            (isTargetNull(targetCurrent) | distSqToTargetCenter(center) < distSqToTargetCenter(targetCurrent.center))) begin
            targetCurrent = '{
                center: center,
                width: width,
                height: height,
                blobCount: 1,
                angle: calcBlobAngle(blob)
            };
            $display("GOOD TARGET: {x:%d, y:%d}, width:%d, height:%d, angle:%d", targetCurrent.center.x, targetCurrent.center.y, targetCurrent.width, targetCurrent.height, targetCurrent.angle);
        end
    endfunction
    function automatic void targetReadIndex(logic partion);
        blobBRAMPorts[partion].addr <= targetIndexBs[partion];
        blobBRAMPorts[partion].we <= 0;
        targetIndexBsValid[partion] = 1;
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
    function automatic logic [18:0] distSqToTargetCenter(Vector v);
        //Distance^2 Between Vector and Target Center
        return (v.x - virtexConfig.targetCenterX)**2 + (v.y - virtexConfig.targetCenterY)**2;
    endfunction

    //Resetting for New Frame
    initial reset();
    function automatic void reset();
        $display("RESET/RESET/RESET/RESET/RESET/RESET/RESET/RESET/RESET/RESET/RESET/RESET/RESET/RESET/RESET/RESET/RESET/RESET/RESET/RESET/RESET/");
        
        //FORK
        blobIndex = 0;
        blobRunBuffersPartionCurrent = NULL_RUN_BUFFER_PARTION;
        blobRunBuffersPartionLast = NULL_RUN_BUFFER_PARTION;
        blobUsingPort1 = 0;
        
        rleRunBuffersPartion = 0;
        for (int i = 0; i < 3; i++) begin
            runBuffers[i].count = 0;
            runBuffers[i].line = NULL_LINE_NUMBER;
        end
        lastIsWorkingOnFrame = 0;

        resetGarbageCollector();

        //we got a new frame when we weren't done with the last => throw fault
        if (~targetSelectorDone & ~isFirstFrame) begin
            TARGET_SELECTOR_TOO_SLOW_FAULT <= 1;
        end
        else targetSelectorDone = 0;

        targetCurrent = NULL_TARGET;
        targetIndexA = NULL_BLOB_INDEX;
        targetIndexBs = '{0, 0};
        targetIndexBsValid = '{0, 0};
        targetChain = NULL_TARGET;
        targetChainValid = NULL_TARGET;
        targetPartion = 0;
        targetHasNewA = 0;
        targetWantsNewA = 0;

        resetKernelFIFO = 1;
        //JOIN
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
endmodule