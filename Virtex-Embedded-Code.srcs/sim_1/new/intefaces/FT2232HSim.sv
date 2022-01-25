`timescale 1ns / 1ps

/* FT2232HSim - simulates the FT2232H's fast serial & JTAG interfaces
    */
module FT2232HSim(
    input wire FSDI,
    input wire FSCLK,
    output wire FSDO,
    output wire FSCTS,
    input wire enabled
    );

    AppSim();

    JTAGSim();
    
endmodule