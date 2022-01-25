`timescale 1ns / 1ps
import Util::*;

/* FastSerialSimTest

    */
module FastSerialSimTest;

    reg CLK = 0;
    always #5 CLK <= !CLK;

    FastSerialSim (

    );

endmodule