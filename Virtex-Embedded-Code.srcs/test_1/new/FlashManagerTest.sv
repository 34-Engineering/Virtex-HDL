`timescale 1ns / 1ps
`include "../../sources_1/new/Util.sv"

/* FlashManagerTest

    */
module FlashManagerTest;

    reg CLK = 0;
    always #5 CLK <= !CLK;

    FlashManager (

    );

endmodule