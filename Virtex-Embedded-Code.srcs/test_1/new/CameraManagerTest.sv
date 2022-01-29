`timescale 1ns / 1ps
`include "../../sources_1/new/Util.sv"

/* CameraManagerTest

    */
module CameraManagerTest;

    reg CLK = 0;
    always #5 CLK <= !CLK;

    CameraManager (

    );

endmodule