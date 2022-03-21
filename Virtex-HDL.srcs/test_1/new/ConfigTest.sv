`timescale 1ns / 1ps

`define SIM 1

`include "../../sources_1/new/config/VirtexConfig.sv"

/* ConfigManagerTest

    */
module ConfigManagerTest;

    reg CLK100 = 0, CLK10 = 0;
    always #(500/100) CLK100 <= ~CLK100; //100MHz = 10ns period
    always #(500/10) CLK10 <= ~CLK10; //10MHz = 100ns period

    reg CONF_MISO = 0;
    always_ff @(negedge CLK10) CONF_MISO = ~CONF_MISO;

    ConfigManager ConfigManager(
        .CLK100(CLK100),
        .CLK10(CLK10),
        .SPI_CS(),
        .SPI_WP(),
        .SPI_HOLD(),
        .SPI_CLK(),
        .SPI_MOSI(),
        .SPI_MISO(CONF_MISO),
        // .virtexConfig(),
        .virtexConfigWriteRequests('{0, 0}),
        .isBooted(),
        .debug()
    );

    //TODO ensure virtexConfig is 64 x 16

endmodule