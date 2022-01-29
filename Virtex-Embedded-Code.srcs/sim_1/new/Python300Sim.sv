`timescale 1ns / 1ps
`include "../../sources_1/new/Util.sv"

/* Python300Sim

    */
module Python300Sim(
    output wire LVDS_CLK_P,
    output wire LVDS_CLK_N,
    output wire LVDS_SYNC_P,
    output wire LVDS_SYNC_N,
    output wire [3:0] LVDS_DOUT_P,
    output wire [3:0] LVDS_DOUT_N,
    input wire SPI_CS,
    input wire SPI_MOSI,
    output reg SPI_MISO,
    input wire SPI_CLK,
    output wire [2:0] TRIGGER,
    output wire [1:0] MONITOR,
    input wire reset
    );

    OSERDESSim();

    Python300SPISim();

endmodule