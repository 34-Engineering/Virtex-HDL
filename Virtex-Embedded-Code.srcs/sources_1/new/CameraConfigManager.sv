`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 34 Engineering
// Engineer: Liam Snow
// 
// Create Date: 06/28/2021
// Module Name: CameraConfigManager
// Project Name: Virtex
// 
//////////////////////////////////////////////////////////////////////////////////

/* CameraConfigManager - manages boot & config; SPI master to python 300
    Python 300 Notes: https://docs.google.com/document/d/1I_gz72WDF619c93o520tFeQNC_jHlEsQBOqtdv9CuxE/edit?usp=sharing */
module CameraConfigManager(
    input wire CLK,
    output wire SPI_CS, //active low
    output wire SPI_MOSI,
    input wire SPI_MISO,
    output wire SPI_CLK,
    output wire TRIGGER,
    input wire MONITOR,
    output wire RESET //active low
    );

    assign RESET = 1;
    assign SPI_CS = 1;

endmodule
