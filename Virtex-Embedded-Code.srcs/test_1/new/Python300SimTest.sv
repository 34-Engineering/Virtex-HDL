`timescale 1ns / 1ps
import Util::*;

/* Python300SimTest

    */
module Python300SimTest;

    reg CLK = 0;
    always #5 CLK <= !CLK;

    Python300Sim (

    );

endmodule