`timescale 1ns / 1ps
import Util::*;

/* OSERDESSimTest

    */
module OSERDESSimTest;

    reg CLK = 0;
    always #5 CLK <= !CLK;

    OSERDES (

    );

endmodule