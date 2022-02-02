`timescale 1ns / 1ps
`include "../Util.sv"

/* JTAG - 

    */
module JTAG(
    input wire TMS, TCK, TDI,
    output reg TDO
    );

    initial begin
        TDO <= 0;
    end

endmodule