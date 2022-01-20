`timescale 1ns / 1ps

/* RoboRIOManagerTest - 
    
    */
module RoboRIOManagerTest(input wire CLK);

    //I2C
    wire [7:0] readData;
    wire readDataValid;
    // SPIMasterTest SPI (
    //     .SCLK(),
    //     .MOSI(),
    //     .MISO(),
    //     .CS(),
    //     .readData(readData),
    //     .readDataValid(readDataValid)
    // );

    initial begin
        write(8'b11111111);
    end

    always @(posedge readDataValid) begin
        $display ("test read %b", readData);
    end

endmodule
