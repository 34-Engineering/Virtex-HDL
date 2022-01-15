`timescale 1ns / 1ps
import Util::*;

/* RoboRIOManager - I2C Slave to the RoboRIO
    Sets config on request
    Sends config or processed data on request */
module RoboRIOManager(
    input wire CLK,
    input wire I2C_SCL,
    inout wire I2C_SDA,
    input wire VirtexConfig virtexConfig,
    output VirtexConfigWriteRequest virtexConfigWriteRequest,
    output reg hasCommunication
    );

    //I2C
    parameter ADDR = 'h34;
    wire [7:0] readData;
    wire readDataValid;
    I2CSlave#(ADDR) I2C (
        .SCL(I2C_SCL),
        .SDA(I2C_SDA),
        .readData(readData),
        .readDataValid(readDataValid)
    );

    //On Data
    always @(posedge readDataValid) begin
        $display ("read %b", readData);
    end
endmodule