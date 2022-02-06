`timescale 1ns / 1ps
`include "../../sources_1/new/Util.sv"

/* RoboRIOSim

    */
module RoboRIOSim(
    output wire SPI_CLK,
    output reg SPI_MOSI,
    input wire SPI_MISO,
    output reg SPI_CS
    //TODO
    );

    reg [3:0] byteNumber = 0; //what byte we are on
    reg [2:0] bytePointer = 0; //where we are in the byte
    reg [7:0] readData = 0;
    reg [7:0] writeData = 0;
    reg [7:0] command = 0; //register addr + r/w
    always @(negedge SPI_CLK) begin
        //TODO
    end

endmodule