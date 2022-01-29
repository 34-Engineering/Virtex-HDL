`timescale 1ns / 1ps
`include "../../sources_1/new/Util.sv"

/* AppSim

    */
module AppSim(
    input wire FSDI,
    input wire FSCLK,
    output reg FSDO,
    output reg FSCTS,
    output reg USB_ON,
    output reg USB_PWREN,
    output reg USB_SUS
    );

    FastSerialSim();

endmodule