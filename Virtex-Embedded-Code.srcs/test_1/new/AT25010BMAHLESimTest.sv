`timescale 1ns / 1ps
import Util::*;

/* AT25010BMAHLESimTest

    */
module AT25010BMAHLESimTest;

    reg CLK = 0;
    always #5 CLK <= !CLK;

    AT25010BMAHLESim (

    );

endmodule