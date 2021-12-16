`timescale 1ns / 1ps

/* CameraConfigManager - manages boot & config; SPI master to python 300
    Python 300 Docs: https://www.onsemi.com/pdf/datasheet/noip1sn1300a-d.pdf
    Python 300 Notes: https://docs.google.com/document/d/1I_gz72WDF619c93o520tFeQNC_jHlEsQBOqtdv9CuxE/edit?usp=sharing */
module CameraConfigManager(
    input wire CLK,
    output wire SPI_CS, //active low
    output wire SPI_MOSI,
    input wire SPI_MISO,
    output wire SPI_CLK,
    output wire TRIGGER,
    input wire MONITOR,
    output wire RESET //active low
    );

    assign RESET = 1;
    assign SPI_CS = 1;

    //TODO SPI MASTER
    SPIMaster SPI();

    task write();
        begin
            
        end
    endtask
endmodule
