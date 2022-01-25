`timescale 1ns / 1ps
import Util::*;

/* FT2232HSimTest

    */
module FT2232HSimTest;

    reg CLK = 0;
    always #5 CLK <= !CLK;

    FT2232HSim (

    );

endmodule