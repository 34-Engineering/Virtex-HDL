`timescale 1ns / 1ps
import Util::*;

/* RoboRIOManager - I2C Slave to the RoboRIO
    Sets config on request
    Sends config or processed data on request */
module RoboRIOManager(
    input wire CLK,
    input wire RIO_SCLK,
    input wire RIO_MOSI,
    output wire RIO_MISO,
    input wire RIO_CS,
    input wire VirtexConfig virtexConfig,
    output VirtexConfigWriteRequest virtexConfigWriteRequest,
    output reg hasCommunication,
    output reg enabled
    );

    //I2C
    wire [7:0] readData;
    wire readDataValid;
    SPISlave SPI(
        .SCLK(SCLK),
        .MOSI(MOSI),
        .MISO(MISO),
        .CS(CS),
        .readData(readData),
        .readDataValid(readDataValid)
    );

    //On Data
    always @(posedge readDataValid) begin
        $display ("read %b", readData);
    end
endmodule