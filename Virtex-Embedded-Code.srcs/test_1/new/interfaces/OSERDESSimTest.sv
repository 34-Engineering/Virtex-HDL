`timescale 1ns / 1ps
`include "../../../sources_1/new/Util.sv"

/* OSERDESSimTest

    */
module OSERDESSimTest;

    reg CLK = 0;
    always #5 CLK <= !CLK;

    OSERDES (

    );

endmodule