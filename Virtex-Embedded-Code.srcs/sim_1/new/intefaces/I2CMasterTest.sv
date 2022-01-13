`timescale 1ns / 1ps

/* I2CMasterTest - Simulates the RoboRIO Fast I2C

    */
module I2CMasterTest#(parameter ADDR = 'h34) (
    output bit SCL,
    inout wire SDA,
    input bit [15:0] writeData, //addr + r/w + data byte
    input bit writeDataValid,
    output bit [7:0] readData,
    output bit readDataValid,
    input bit reset //active low
    );

    //400kHz clock
    always #1250 SCL <= !SCL;

    always @(posedge SCL) begin
    end

endmodule