`timescale 1ns / 1ps

`define SIM 1

`include "../../sources_1/new/util/Math.sv"
`include "../../sources_1/new/vision/VisionUtil.sv"
`include "./Image.sv"

/* VisionTest

    */
module VisionTest;

    initial $display(" ###### STARTING VISION TEST ###### ");

    reg CLK288 = '0, CLK200 = '0;
    always #(500/288) CLK288 <= ~CLK288;
    always #(500/200) CLK200 <= ~CLK200;

    Run rleCurrentRun = '0;
    Math::Vector2d10 rleKernelPos = '0;
    wire [7:0] rleKernel = image[rleKernelPos.y * 80 + rleKernelPos.x];
    reg [2:0] rleKernelX = '0;

    Run runFIFOIn = '0;
    reg runFIFOWrite = '0;

    Target target;
    reg [10:0] endCounter = '0;
    
    always_ff @(negedge CLK288) begin
        if (rleKernelPos.y < 480) begin
            //New Run @ Color Change
            if (rleKernel[7-rleKernelX] != rleCurrentRun.black) begin
                //end old run
                if (rleCurrentRun.length != 0) begin
                    runFIFOIn <= rleCurrentRun;
                    runFIFOWrite <= 1;
                end

                //start new run
                rleCurrentRun <= '{
                    length: 1,
                    line: rleKernelPos.y,
                    black: rleKernel[7-rleKernelX]
                };
            end

            //Extend Run
            else begin
                rleCurrentRun.length <= rleCurrentRun.length + 1;
            end

            //New Kernel
            if (rleKernelX == 7) begin
                //New Line
                if (rleKernelPos.x == 79) begin
                    //end old run
                    if (rleCurrentRun.length != 0) begin
                        runFIFOIn <= rleCurrentRun;
                        runFIFOWrite <= 1;
                    end

                    //start run
                    rleCurrentRun <= '{
                        length: 0,
                        line: rleKernelPos.y,
                        black: ~image[(rleKernelPos.y + 1) * 80][7]
                    };

                    rleKernelPos <= '{ x: 0, y: rleKernelPos.y + 1 };
                end
                else rleKernelPos.x <= rleKernelPos.x + 1;
            end
            
            rleKernelX <= rleKernelX + 1;
            endCounter <= 0;
        end
        else begin
            $display(" ###### VISION TEST DONE ###### ");
            $finish();
            // //new frame
            // if (endCounter == 2047) begin
            //     rleKernelPos <= 0;
            // end
            // endCounter <= endCounter + 1;
        end
    end

    VisionProcessor VisionProcessor(
        .CLK288(CLK288),
        .CLK200(CLK200),
        .runFIFOIn(runFIFOIn),
        .runFIFOWrite(runFIFOWrite),
        .target(target),
        .virtexConfig(DefaultVirtexConfig),
        .OUT_OF_BLOB_MEM_FAULT(),
        .OUT_OF_RLE_MEM_FAULT(),
        .BLOB_PROCESSOR_SLOW_FAULT(),
        .RUN_FIFO_FULL_FAULT()
    );

endmodule