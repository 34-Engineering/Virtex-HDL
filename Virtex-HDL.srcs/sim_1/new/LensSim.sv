`timescale 1ns / 1ps
`include "../../sources_1/new/Util.sv"

/* LensSim - simulates images of what the Python 300 would see

    */
module LensSim(
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
    input wire SENSOR_RESET
    );

    Python300Sim Python300Sim(
        .LVDS_CLK_P(LVDS_CLK_P),
        .LVDS_CLK_N(LVDS_CLK_N),
        .LVDS_SYNC_P(LVDS_SYNC_P),
        .LVDS_SYNC_N(LVDS_SYNC_N),
        .LVDS_DOUT_P(LVDS_DOUT_P),
        .LVDS_DOUT_N(LVDS_DOUT_N),
        .SPI_CS(SPI_CS),
        .SPI_MOSI(SPI_MOSI),
        .SPI_MISO(SPI_MISO),
        .SPI_CLK(SPI_CLK),
        .TRIGGER(TRIGGER),
        .MONITOR(MONITOR),
        .SENSOR_RESET(SENSOR_RESET)
        //TODO
    );

    //TODO

endmodule