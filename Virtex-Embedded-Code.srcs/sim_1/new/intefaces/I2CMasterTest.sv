`timescale 1ns / 1ps

/* I2CMasterTest - Simulates the RoboRIO Fast I2C

    */
module I2CMasterTest#(parameter ADDR = 'h34) (
    output reg SCL,
    inout wire SDA,
    input reg [15:0] writeData, //addr + r/w + data byte
    input reg writeDataValid,
    output reg [7:0] readData,
    output reg readDataValid,
    input reg reset //active low
    );

    //400kHz clock
    always #1250 SCL <= !SCL;

    always @(posedge SCL) begin
    end

endmodule