`timescale 1ns / 1ps
`include "../../../sources_1/new/Util.sv"

/* JTAGSimTest

    */
module JTAGSimTest;

    reg CLK = 0;
    always #5 CLK <= !CLK;

    JTAGSim (

    );

endmodule