`timescale 1ns / 1ps

`define SIM 1

`include "../../sources_1/new/blob/BlobUtil.sv"
`include "./Image.sv"

/* BlobTest

    */
module BlobTest;

    reg CLK200 = 0, CLK72 = 0;
    always #(500/200) CLK200 <= ~CLK200;
    always #(500/72) CLK72 <= ~CLK72;

    Vector pos = 0;
    reg end1 = 0;
    Kernel blobKernel = 0;
    reg writeBlobKernel = 0;
    Target target;
    reg [10:0] endCounter = 0;
    always_ff @(negedge CLK72) begin
        if (pos.y < 480) begin
            endCounter <= 0;

            if (~writeBlobKernel) begin
                blobKernel <= '{ value: image[pos.y * 80 + pos.x], pos: pos };

                if (pos.x == 79) begin
                    pos <= '{ x: 0, y: pos.y + 1 };
                end
                else pos.x <= pos.x + 1;
            end

            writeBlobKernel <= ~writeBlobKernel;
        end
        else begin
            end1 <= 1;
            writeBlobKernel <= 0;

            // //new frame
            // if (endCounter == 2047) begin
            //     pos <= 0;
            // end
            // endCounter <= endCounter + 1;
        end
    end

    BlobProcessor BlobProcessor(
        .CLK200(CLK200),
        .CLK72(CLK72),
        .kernelInput(blobKernel),
        .kernelInputWrite(writeBlobKernel),
        .target(target),
        .virtexConfig(DefaultVirtexConfig),
        .OUT_OF_BLOB_MEM_FAULT(),
        .OUT_OF_RLE_MEM_FAULT(),
        .BLOB_POINTER_DEPTH_FAULT(),
        .BLOB_PROCESSOR_SLOW_FAULT(),
        .test(end1)
    );

endmodule