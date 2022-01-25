`timescale 1ns / 1ps
import Util::*;

/* RoboRIOSimTest

    */
module RoboRIOSimTest;

    reg CLK = 0;
    always #5 CLK <= !CLK;

    RoboRIOSim RoboRIOSim(

    );

endmodule