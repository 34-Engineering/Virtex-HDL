`timescale 1ns / 1ps

`include "../../sources_1/new/config/VirtexConfig.sv"

/* PythonSPITest

    */
module PythonSPITest;

    VirtexConfig virtexConfig;
    reg [5:0] configAddress = 1;

    initial begin
        virtexConfig = DefaultVirtexConfig;
        $display("######################################## BALLS ######################################");
        for (int i = 0; i < 32; i++) begin
            $display("%d, %b %b", i, virtexConfig[(i << 4) + 15 -: 8], virtexConfig[(i << 4) + 7 -: 8]);
        end
        $display("######################################## BALLS ######################################");
    end

    // reg CLK = 0;
    // always #5 CLK <= ~CLK;

    // wire SPI_CS, SPI_MOSI, SPI_CLK;
    // reg SPI_MISO = 0;

    // PythonSPIManager uut (
    //     .CLK(CLK),
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