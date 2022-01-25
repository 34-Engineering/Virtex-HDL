`timescale 1ns / 1ps
import Util::*;

/* Python300SPISimTest

    */
module Python300SPISimTest;

    reg CLK = 0;
    always #5 CLK <= !CLK;

    Python300SPISim (

    );

endmodule