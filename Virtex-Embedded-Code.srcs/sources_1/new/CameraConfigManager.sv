`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 34 Engineering
// Engineer: Liam Snow
// 
// Create Date: 06/28/2021 07:21:36 PM
// Module Name: CameraConfigManager
// Project Name: Virtex
// 
//////////////////////////////////////////////////////////////////////////////////

/* CameraConfigManager - manages boot & config; SPI master to python 300
    Python 300 Notes: https://docs.google.com/document/d/1I_gz72WDF619c93o520tFeQNC_jHlEsQBOqtdv9CuxE/edit?usp=sharing */
module CameraConfigManager(
    input CLK,
    output SPI_CS, //active low
    output SPI_MOSI,
    input SPI_MISO,
    output SPI_CLK,
    output TRIGGER,
    input MONITOR,
    output RESET //active low
    );

    assign RESET = 1;
    assign SPI_CS = 1;

endmodule
