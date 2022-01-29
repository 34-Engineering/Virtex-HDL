`timescale 1ns / 1ps
`include "../../sources_1/new/Util.sv"

/* BlobProcessorTest

    */
module BlobProcessorTest;

    reg CLK = 0;
    always #5 CLK <= !CLK;

    BlobProcessor (

    );

endmodule