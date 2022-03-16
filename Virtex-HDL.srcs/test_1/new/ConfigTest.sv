`timescale 1ns / 1ps

/* ConfigManagerTest

    */
module ConfigManagerTest;

    reg CLK = 0;
    always #5 CLK <= ~CLK;

    ConfigManager uut (

    );

endmodule