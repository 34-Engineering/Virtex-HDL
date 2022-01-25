`timescale 1ns / 1ps
import Util::*;

/* AppSimTest

    */
module AppSimTest;

    reg CLK = 0;
    always #5 CLK <= !CLK;

    AppSim (

    );

endmodule