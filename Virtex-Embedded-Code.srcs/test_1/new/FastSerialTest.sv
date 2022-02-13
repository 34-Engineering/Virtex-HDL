`timescale 1ns / 1ps
`include "../../../sources_1/new/Util.sv"

/* FastSerialTest

    */
module FastSerialTest;

    reg CLK = 0;
    always #5 CLK <= !CLK;

    FastSerial (

    );

endmodule