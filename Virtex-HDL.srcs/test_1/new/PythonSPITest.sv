`timescale 1ns / 1ps

`define SIM 1

`include "../../sources_1/new/config/VirtexConfig.sv"

/* PythonSPITest

    */
module PythonSPITest;
    

    reg CLK100 = 0;
    always #5 CLK100 <= ~CLK100;

    wire SPI_CS, SPI_MOSI, SPI_CLK;
    reg SPI_MISO = 0;

    PythonSPIManager uut (
        .CLK100(CLK100),
        .SPI_CS(SPI_CS),
        .SPI_MOSI(SPI_MOSI),
        .SPI_MISO(SPI_MISO),
        .SPI_CLK(SPI_CLK),
        .TRIGGER(),
        .MONITOR(2'b0),
        .sequencerEnabled(1'b1),
        .PYTHON_300_PLL_FAULT(),
        .debug()
    );

endmodule