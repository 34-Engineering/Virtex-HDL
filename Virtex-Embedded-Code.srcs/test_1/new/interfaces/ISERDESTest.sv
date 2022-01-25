`timescale 1ns / 1ps
import Util::*;

/* ISERDESTest

    */
module ISERDESTest;

    reg CLK = 0;
    always #5 CLK <= !CLK;

    ISERDES (

    );

endmodule