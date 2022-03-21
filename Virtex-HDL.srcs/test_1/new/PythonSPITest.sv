`timescale 1ns / 1ps

`define SIM 1

`include "../../sources_1/new/config/VirtexConfig.sv"

/* PythonSPITest

    */
module PythonSPITest;

    reg CLK200 = 0, CLK72 = 0;
    always #(500/200) CLK200 <= ~CLK200;
    always #(500/72) CLK72 <= ~CLK72;

    reg [7:0] blobKernel = 0;
    reg writeBlobKernel = 0;
    Target target;
    always_ff @(posedge CLK72) begin
        writeBlobKernel <= ~writeBlobKernel;
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
        .BLOB_PROCESSOR_SLOW_FAULT()
    );

    // reg CLK100 = 0, CLK10 = 0;
    // always #(500/100) CLK100 <= ~CLK100; //100MHz = 10ns period
    // always #(500/10) CLK10 <= ~CLK10; //10MHz = 100ns period

    // reg CONF_MISO = 0;
    // always_ff @(negedge CLK10) CONF_MISO = ~CONF_MISO;

    // ConfigManager ConfigManager(
    //     .CLK100(CLK100),
    //     .CLK10(CLK10),
    //     .SPI_CS(),
    //     .SPI_WP(),
    //     .SPI_HOLD(),
    //     .SPI_CLK(),
    //     .SPI_MOSI(),
    //     .SPI_MISO(CONF_MISO),
    //     // .virtexConfig(),
    //     .virtexConfigWriteRequests('{0, 0}),
    //     .isBooted(),
    //     .debug()
    // );

    // reg CLK100 = 0;
    // always #5 CLK100 <= ~CLK100;

    // wire SPI_CS, SPI_MOSI, SPI_CLK;
    // reg SPI_MISO = 0;

    // PythonSPIManager uut (
    //     .CLK100(CLK100),
    //     .SPI_CS(SPI_CS),
    //     .SPI_MOSI(SPI_MOSI),
    //     .SPI_MISO(SPI_MISO),
    //     .SPI_CLK(SPI_CLK),
    //     .TRIGGER(),
    //     .MONITOR(2'b0),
    //     .sequencerEnabled(1'b1),
    //     .PYTHON_300_PLL_FAULT(),
    //     .debug()
    // );

endmodule