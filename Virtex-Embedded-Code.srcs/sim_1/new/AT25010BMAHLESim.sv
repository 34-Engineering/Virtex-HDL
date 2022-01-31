`timescale 1ns / 1ps
`include "../../sources_1/new/Util.sv"

/* AT25010BMAHLESim - simulates the EEPROM Memory for the ConfigManager

    Docs: https://ww1.microchip.com/downloads/en/DeviceDoc/20006251A.pdf

    */
module AT25010BMAHLESim(
    input wire SPI_CS,
    input wire SPI_WP,
    input wire SPI_HOLD,
    input wire SPI_CLK,
    input wire SPI_MOSI,
    output reg SPI_MISO
    );


endmodule