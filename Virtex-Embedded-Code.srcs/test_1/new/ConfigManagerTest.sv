`timescale 1ns / 1ps
`include "../../sources_1/new/Util.sv"

/* ConfigManagerTest

    */
module ConfigManagerTest;

    reg CLK = 0;
    always #5 CLK <= !CLK;

    ConfigManager (

    );

endmodule