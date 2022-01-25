`timescale 1ns / 1ps
import Util::*;

/* JTAGSimTest

    */
module JTAGSimTest;

    reg CLK = 0;
    always #5 CLK <= !CLK;

    JTAGSim (

    );

endmodule