`timescale 1ns / 1ps

`include "../../sources_1/new/config/VirtexConfig.sv"
`include "../../sources_1/new/python/PythonUtil.sv"
`include "../../sources_1/new/vision/VisionUtil.sv"
`include "../../sources_1/new/util/Math.sv"
`include "./Image.sv"

/* PythonTest

    */
module PythonTest;

    reg CLK10 = '0, CLK72 = '0, CLK100 = '0, CLK288 = '0;
    always #(500/10) CLK10  <= ~CLK10;
    always #(500/72) CLK72  <= ~CLK72;
    always #(500/100) CLK100 <= ~CLK100;
    always #(500/288) CLK288 <= ~CLK288;

    //Kernel Readout Simulation
    reg kernelDone = '0;
    Math::Vector2d10 kernelPos = '0;
    wire [15:0] blab = kernelPos.y * 80 + kernelPos.x;
    wire [7:0] kernelThreshold = image[kernelPos.y * 80 + kernelPos.x];
    reg frameDone = '0;
    always_ff @(posedge CLK72) begin
        kernelDone <= ~kernelDone & ~frameDone;

        //read out
        if (~frameDone) begin
            //increment kernelPos
            if (~kernelDone) begin
                //end line
                if (kernelPos.x == 79) begin
                    //end frame
                    if (kernelPos.y == 479) begin
                        frameDone <= 1;
                        kernelDone <= 0;
                    end

                    //go to next line
                    else kernelPos <= '{ x: 0, y: kernelPos.y + 1 };
                end

                //move across line
                else kernelPos.x <= kernelPos.x + 1;
            end
        end
    end

    //RLE FIFO Simulation
    Run runFIFOIn;
    reg runFIFOWrite = '0;
    always_ff @(posedge CLK288) begin
        if (runFIFOWrite) begin
            $write("{length:%d, line:%d, black:%d}\n", runFIFOIn.length, runFIFOIn.line, runFIFOIn.black);
        end
    end

    // -------- COPY FROM PythonManager.sv --------
    //Run Length Encoding (Kernels -> Runs)
    Run rleCurrentRun = '0;
    reg [7:0] rleKernel;
    Math::Vector2d10 rleKernelPos = '0;
    reg [2:0] rleKernelX;
    reg rleInKernel = '0;
    reg lastKernelDone = '0;
    wire rleAtColorChange = ~rleKernel[7-rleKernelX] != rleCurrentRun.black;
    wire rleAtKernelEnd = rleKernelX == 7;
    wire rleAtLineEnd = rleAtKernelEnd & rleKernelPos.x == 79;
    wire rleCurrentRunExists = rleCurrentRun.length != 0;
    wire rleWillFinishRun = (rleAtColorChange || rleAtLineEnd) & rleCurrentRunExists;
    wire rleHasNewKernel = kernelDone & ~lastKernelDone;
    wire rleHasNewLine = kernelPos.y != rleKernelPos.y;
    wire Run rleExtendedRun = '{ length: rleCurrentRun.length + !rleAtColorChange, line: rleCurrentRun.line, black: rleCurrentRun.black };
    wire Run rleNextRun = '{ length: 1, line: rleKernelPos.y, black: ~rleKernel[7-rleKernelX] };
    wire Run rleNextLineRun = '{ length: 0, line: kernelPos.y, black: ~kernelThreshold[7] };
    wire Run rleEmptyRun = '{ length: 0, line: 0, black: 0 };

    always_ff @(negedge CLK288) begin //kernels are output @ 36MHz so we can process each pixel @ (36*8)MHz
        runFIFOWrite <= 0;
        
        //Process each Pixel in Kernel
        if (rleInKernel) begin
            //Extend Current Run OR Start New Run (@ Color Change)
            rleCurrentRun <= rleAtColorChange ? rleNextRun : (rleAtLineEnd ? rleEmptyRun : rleExtendedRun);

            //End Run @ End Line OR Color Change
            if (rleWillFinishRun) begin
                runFIFOIn <= rleExtendedRun;
                runFIFOWrite <= 1;
            end

            //End Kernel
            if (rleAtKernelEnd) rleInKernel <= 0;

            //Move to Next Pixel
            rleKernelX <= rleKernelX + 1;
        end

        //New Kernel
        if (rleHasNewKernel) begin
            rleKernel <= kernelThreshold;
            rleKernelPos <= kernelPos;
            rleKernelX <= 0;
            rleInKernel <= 1;

            //New Line
            if (rleHasNewLine) begin
                //end run (only in the case of color change happening at end line, in which case the old run was sent, a new 1-pixel run was started, and we end it here)
                if (rleCurrentRunExists) begin
                    runFIFOIn <= rleCurrentRun;
                    runFIFOWrite <= 1;
                end

                //start run
                rleCurrentRun <= rleNextLineRun;
            end
        end
        lastKernelDone <= kernelDone;
    end
    // -------- END COPY --------



    //-------------------------------------------- FULL SIMULATION (WIP) -----------------------------------------------\\

    // Target target;

    // wire CLK;
    // wire [7:0] SYNC;
    // wire [7:0] [3:0] DOUT;

    // wire SYNC_SER;
    // wire [3:0] DOUT_SER;

    // wire LVDS_CLK_P, LVDS_CLK_N;
    // wire LVDS_SYNC_P, LVDS_SYNC_N;
    // wire [3:0] LVDS_DOUT_P, LVDS_DOUT_N;
    // IBUFGDS #(.DIFF_TERM("TRUE"),.IBUF_LOW_PWR("FALSE"),.IOSTANDARD("LVDS_25"))
    // LVDS_CLK_IBUF   (.O(CLK288_DIRTY  ),.I(LVDS_CLK_P    ),.IB(LVDS_CLK_N     ));
    // OBUFDS  #(.DIFF_TERM("TRUE"),.IBUF_LOW_PWR("FALSE"),.IOSTANDARD("LVDS_25"))
    // LVDS_SYNC_IBUF  (.O(SYNC_SERIAL   ),.I(LVDS_SYNC_P   ),.IB(LVDS_SYNC_N    ));
    // OBUFDS  #(.DIFF_TERM("TRUE"),.IBUF_LOW_PWR("FALSE"),.IOSTANDARD("LVDS_25"))
    // LVDS_DOUT0_IBUF (.O(DOUT_SERIAL[0]),.I(LVDS_DOUT_P[0]),.IB(LVDS_DOUT_N[0]));
    // OBUFDS  #(.DIFF_TERM("TRUE"),.IBUF_LOW_PWR("FALSE"),.IOSTANDARD("LVDS_25"))
    // LVDS_DOUT1_IBUF (.O(DOUT_SERIAL[1]),.I(LVDS_DOUT_P[1]),.IB(LVDS_DOUT_N[1]));
    // OBUFDS  #(.DIFF_TERM("TRUE"),.IBUF_LOW_PWR("FALSE"),.IOSTANDARD("LVDS_25"))
    // LVDS_DOUT2_IBUF (.O(DOUT_SERIAL[2]),.I(LVDS_DOUT_P[2]),.IB(LVDS_DOUT_N[2]));
    // OBUFDS  #(.DIFF_TERM("TRUE"),.IBUF_LOW_PWR("FALSE"),.IOSTANDARD("LVDS_25"))
    // LVDS_DOUT3_IBUF (.O(DOUT_SERIAL[3]),.I(LVDS_DOUT_P[3]),.IB(LVDS_DOUT_N[3]));

    // PythonManager uut (
    //     .CLK100(CLK100),
    //     .CLK10(CLK10),
    //     .LVDS_CLK_P(LVDS_CLK_P),
    //     .LVDS_CLK_N(LVDS_CLK_N),
    //     .LVDS_SYNC_P(LVDS_SYNC_P),
    //     .LVDS_SYNC_N(LVDS_SYNC_N),
    //     .LVDS_DOUT_P(LVDS_DOUT_P),
    //     .LVDS_DOUT_N(LVDS_DOUT_N),
    //     .SPI_CS(),
    //     .SPI_MOSI(),
    //     .SPI_MISO(),
    //     .SPI_CLK(),
    //     .TRIGGER(),
    //     .MONITOR(),
    //     .RESET_SENSOR(),
    //     .sequencerEnabled(),
    //     .virtexConfig(DefaultVirtexConfig),
    //     .frameBufferWriteAddr(),
    //     .frameBufferWriteIn(),
    //     .frameBufferWriteEnable(),
    //     .target(target),
    //     .PYTHON_300_PLL_FAULT(),
    //     .OUT_OF_BLOB_MEM_FAULT(),
    //     .OUT_OF_RLE_MEM_FAULT(),
    //     .BLOB_PROCESSOR_SLOW_FAULT(),
    //     .RUN_FIFO_FULL_FAULT(),
    //     .debug(debug)
    // );

endmodule