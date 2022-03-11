`timescale 1ns / 1ps
`include "../../../sources_1/new/Util.sv"

/* ISERDESTest

    */
module ISERDESTest;

    reg CLK = 0;
    always #5 CLK <= ~CLK;

    // ISERDES (

    // );

endmodule