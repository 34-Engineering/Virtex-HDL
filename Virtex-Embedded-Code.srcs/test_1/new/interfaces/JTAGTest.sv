`timescale 1ns / 1ps
import Util::*;

/* JTAGTest

    */
module JTAGTest;

    reg CLK = 0;
    always #5 CLK <= !CLK;

    JTAG (
        
    );

endmodule