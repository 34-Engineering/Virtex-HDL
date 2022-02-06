`timescale 1ns / 1ps
`include "../../sources_1/new/Util.sv"

/* FT2232HSim - simulates the FT2232H's fast serial & JTAG interfaces
    */
module FT2232HSim(
    input wire FSDI, FSCLK,
    output wire FSDO, FSCTS,
    input wire TDO,
    output wire TMS, TCK, TDI,
    output reg USB_ON, USB_PWREN, USB_SUS
    );

    AppSim(
        .FSDI(FSDI),
        .FSCLK(FSCLK),
        .FSDO(FSDO),
        .FSCTS(FSCTS)
    );

    initial begin
        //TODO add functionality?
        USB_ON <= 1;
        USB_PWREN <= 0;
        USB_SUS <= 0;
    end
    
endmodule