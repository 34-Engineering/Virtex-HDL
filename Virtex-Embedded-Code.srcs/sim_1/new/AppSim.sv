`timescale 1ns / 1ps
`include "../../sources_1/new/Util.sv"

/* AppSim

    */
module AppSim(
    input wire FSDI,
    input wire FSCLK,
    output reg FSDO,
    output reg FSCTS
    );

    enum {IDLE, GET_FRAME, SET_CONFIG} state = IDLE;

    FastSerialSim();

endmodule