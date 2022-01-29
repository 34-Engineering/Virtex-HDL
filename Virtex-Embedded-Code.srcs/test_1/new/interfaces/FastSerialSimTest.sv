`timescale 1ns / 1ps
`include "../../../sources_1/new/Util.sv"

/* FastSerialSimTest

    */
module FastSerialSimTest;

    reg CLK = 0;
    always #5 CLK <= !CLK;

    FastSerialSim (

    );

endmodule