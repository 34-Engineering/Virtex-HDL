`timescale 1ns / 1ps

`include "../../sources_1/new/config/VirtexConfig.sv"

/* PythonSPITest

    */
module PythonSPITest;

    reg CLK100 = 0, CLK10 = 0;
    always #5 CLK100 <= ~CLK100; //100MHz = 10ns period
    always #50 CLK10 <= ~CLK10; //10MHz = 100ns period

    reg CONF_MISO = 0;

    ConfigManager ConfigManager(
        .CLK100(CLK100),
        .CLK10(CLK10),
        // .SPI_CS(CONF_CS),
        .SPI_WP(),
        .SPI_HOLD(),
        .SPI_CLK(),
        .SPI_MOSI(),
        .SPI_MISO(CONF_MISO),
        // .virtexConfig(),
        .virtexConfigWriteRequests('{0, 0}),
        // .bootDone(),
        .debug()
    );

    // reg CLK100 = 0;
    // always #5 CLK100 <= ~CLK100;

    // wire SPI_CS, SPI_MOSI, SPI_CLK;
    // reg SPI_MISO = 0;

    // PythonSPIManager uut (
    //     .CLK100(CLK100),
    //     .SPI_CS(SPI_CS),
    //     .SPI_MOSI(SPI_MOSI),
    //     .SPI_MISO(SPI_MISO),
    //     .SPI_CLK(SPI_CLK),
    //     .TRIGGER(),
    //     .MONITOR(2'b0),
    //     .sequencerEnabled(1'b1),
    //     .PYTHON_300_PLL_FAULT(),
    //     .debug()
    // );

endmodule