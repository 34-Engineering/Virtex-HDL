`timescale 1ns / 1ps
import Util::*;

/* ConfigManager - SPI Master to the EEPROM
    Reads in config at boot
    Saves config on event trigger
    Max 32 configurations */
module ConfigManager(
    input wire CLK,
    output reg SPI_CS,
    output reg SPI_WP,
    output reg SPI_HOLD,
    output reg SPI_CLK,
    output reg SPI_MOSI,
    input wire SPI_MISO,
    inout Configuration configuration,
    input wire save
    );

    //Read from EEPROM at boot
    initial begin
        SPI_CS <= 1;
        SPI_WP <= 0;
        SPI_HOLD <= 0;
        SPI_CLK <= 0;
        SPI_MOSI <= 0;
        //TODO Read Tasks
    end

    //TODO SPI MASTER
    SPIMaster SPI();
    task onData(bit [15:0] data);
    
    endtask

    //Save Config to EEPROM
    always @(posedge save) begin
        
    end
endmodule