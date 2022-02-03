`timescale 1ns / 1ps
`include "../../sources_1/new/Util.sv"

/* Python300SPISim

    */
module Python300SPISim(
    input wire CLK,
    output wire SPI_CLK, SPI_CS, //active low
    input reg SPI_MOSI,
    output wire SPI_MISO,
    input wire [2:0] TRIGGER,
    output wire [1:0] MONITOR,
    input wire reset, //active low
    output wire sequencerEnabled
    );


endmodule