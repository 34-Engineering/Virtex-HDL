`timescale 1ns / 1ps
`include "../../sources_1/new/Util.sv"

/* CameraSPIManagerTest

    */
module CameraSPIManagerTest;

    reg CLK = 0;
    always #5 CLK <= !CLK;

    CameraSPIManager(

    );

endmodule