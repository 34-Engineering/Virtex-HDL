`timescale 1ns / 1ps
`include "../../sources_1/new/Util.sv"

/* RoboRIOManagerTest

    */
module RoboRIOManagerTest;

    reg CLK = 0;
    always #5 CLK <= !CLK;

    RoboRIOManager (

    );

endmodule