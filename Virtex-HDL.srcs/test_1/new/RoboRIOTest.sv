`timescale 1ns / 1ps

/* RoboRIOManagerTest

    */
module RoboRIOManagerTest;

    reg CLK = 0;
    always #5 CLK <= ~CLK;

    RoboRIOManager (

    );

endmodule