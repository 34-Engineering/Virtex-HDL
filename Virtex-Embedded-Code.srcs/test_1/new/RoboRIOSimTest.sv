`timescale 1ns / 1ps
`include "../../sources_1/new/Util.sv"

/* RoboRIOSimTest

    */
module RoboRIOSimTest;

    reg CLK = 0;
    always #5 CLK <= !CLK;

    RoboRIOSim RoboRIOSim(

    );

endmodule