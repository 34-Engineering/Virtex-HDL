`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 34 Engineering
// Engineer: Liam Snow
// 
// Create Date: 06/08/2021
// Module Name: FlashManager
// Project Name: Virtex
// 
//////////////////////////////////////////////////////////////////////////////////

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

endmodule