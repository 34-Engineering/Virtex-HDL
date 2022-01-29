`timescale 1ns / 1ps
`include "../../../sources_1/new/Util.sv"

/* JTAGTest

    */
module JTAGTest;

    reg CLK = 0;
    always #5 CLK <= !CLK;

    JTAG (
        
    );

endmodule