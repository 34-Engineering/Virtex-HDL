`timescale 1ns / 1ps
`include "../../sources_1/new/Util.sv"

/* MX25V1635FM2ISimTest

    */
module MX25V1635FM2ISimTest;

    reg CLK = 0;
    always #5 CLK <= !CLK;

    MX25V1635FM2ISim (

    );

endmodule