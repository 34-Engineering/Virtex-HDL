`timescale 1ns / 1ps
`include "../../sources_1/new/Util.sv"

/* Python300SPISimTest

    */
module Python300SPISimTest;

    reg CLK = 0;
    always #5 CLK <= !CLK;

    Python300SPISim (

    );

endmodule