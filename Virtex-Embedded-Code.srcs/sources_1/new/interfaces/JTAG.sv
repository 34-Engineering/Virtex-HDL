`timescale 1ns / 1ps
`include "../Util.sv"

/* JTAG - 

    */
module JTAG(
    input wire TMS,
    input wire TCK,
    output reg TDO,
    input wire TDI
    );

    initial begin
        TDO <= 0;    
    end

endmodule