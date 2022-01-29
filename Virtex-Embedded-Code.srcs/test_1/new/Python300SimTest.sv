`timescale 1ns / 1ps
`include "../../sources_1/new/Util.sv"

/* Python300SimTest

    */
module Python300SimTest;

    reg CLK = 0;
    always #5 CLK <= !CLK;

    Python300Sim (

    );

endmodule