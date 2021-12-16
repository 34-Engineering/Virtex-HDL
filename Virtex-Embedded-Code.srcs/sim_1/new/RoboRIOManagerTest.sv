`timescale 1ns / 1ps

/* RoboRIOManagerTest - 
    
    */
module RoboRIOManagerTest(input wire CLK);

    //I2C
    parameter ADDR = 'h34;
    wire [7:0] readData;
    wire readDataValid;
    I2CMasterTest#(ADDR) I2C (
        .SCL(I2C_SCL),
        .SDA(I2C_SDA),
        .readData(readData),
        .readDataValid(readDataValid)
    );

    //On Data
    always @(posedge readDataValid) begin
        $display ("test read %b", readData);
    end

endmodule
