`timescale 1ns / 1ps

/* I2CMasterTest - Simulates the RoboRIO Fast I2C

    */
module I2CMasterTest#(parameter ADDR = 'h34) (
    output bit SCL,
    inout reg SDA,
    output bit [7:0] readData,
    output bit readDataValid
    );

    //400kHz clock
    always #1250 SCL <= !SCL;

    

endmodule