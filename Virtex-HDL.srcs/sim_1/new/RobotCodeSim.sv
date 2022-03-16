`timescale 1ns / 1ps
`include "../../sources_1/new/Util.sv"

/* RobotCodeSim - simulates the users robot code

    */
module RobotCodeSim(
    output wire SPI_CLK,
    output reg SPI_MOSI,
    input wire SPI_MISO,
    output reg SPI_CS
    //TODO
    );

    RoboRIOSim RoboRIOSim(
        .SPI_CLK(SPI_CLK),
        .SPI_MOSI(SPI_MOSI),
        .SPI_MISO(SPI_MISO),
        .SPI_CS(SPI_CS)
    );

    //TODO

endmodule