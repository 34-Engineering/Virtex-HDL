`timescale 1ns / 1ps

/* FlashManager - 

    */
module FlashManager(
    input wire CLK,
    output wire SPI_CLK,
    output wire SPI_CS,
    output wire [3:0] SPI_Q,
    input wire TMS,
    input wire TCK,
    output wire TDO,
    input wire TDI
    );

    assign SPI_CS = 1;

    //TODO SPI MASTER
    SPIMaster SPI();
endmodule