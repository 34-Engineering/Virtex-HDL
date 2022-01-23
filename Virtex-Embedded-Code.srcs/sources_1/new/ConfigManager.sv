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
    output VirtexConfig virtexConfig,
    input VirtexConfigWriteRequest virtexConfigWriteRequests [1:0]
    );

    initial begin
        virtexConfig = DefaultVirtexConfig;
    end

    //TODO Read from EEPROM at boot
    initial begin
        SPI_CS <= 1;
        SPI_WP <= 0;
        SPI_HOLD <= 0;
        SPI_CLK <= 0;
        SPI_MOSI <= 0;
    end

    //TODO implement SPI master
    //TODO 2MHz SPI_CLK
    // SPIMaster SPI();

    // task onData(reg [15:0] data);
    
    // endtask

    // task write();
    //     //TODO
    // endtask

    //Write Requests
    genvar i;
    generate
        for (i=0; i < $size(virtexConfigWriteRequests); i++) begin
            always @(posedge virtexConfigWriteRequests[i].valid) begin
                virtexConfig[virtexConfigWriteRequests[i].address] <= virtexConfigWriteRequests[i].data;
            end
        end
    endgenerate
endmodule