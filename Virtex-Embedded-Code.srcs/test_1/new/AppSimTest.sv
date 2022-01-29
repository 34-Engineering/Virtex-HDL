`timescale 1ns / 1ps
`include "../../sources_1/new/Util.sv"

/* AppSimTest

    */
module AppSimTest;

    reg CLK = 0;
    always #5 CLK <= !CLK;

    AppSim (

    );

endmodule