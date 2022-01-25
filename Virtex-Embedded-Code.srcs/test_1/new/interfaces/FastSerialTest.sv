`timescale 1ns / 1ps
import Util::*;

/* FastSerialTest

    */
module FastSerialTest;

    reg CLK = 0;
    always #5 CLK <= !CLK;

    FastSerial (

    );

endmodule