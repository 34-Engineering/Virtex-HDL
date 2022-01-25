`timescale 1ns / 1ps
import Util::*;

/* FlashManagerTest

    */
module FlashManagerTest;

    reg CLK = 0;
    always #5 CLK <= !CLK;

    FlashManager (

    );

endmodule