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
    input wire SPI_MISO
    );

    //Config Parameters (init with default config)
    bit [15:0] configVars [15:0] = {
        0,
        0,
        0,
        16'hffff,
        0,
        16'hffff,
        0,
        16'hffff,
        0,
        16'hffff,
        0,
        16'hffff,
        16'd320,
        16'd240,
        8'h0f,
        8'h0f
    };

    //Config Wires
    wire [1:0] dualObjectMode = DualObjectMode'(configVars[0][1:0]);
    wire [1:0] orientation = Orientation'(configVars[1][1:0]);
    wire [15:0] boundingWidthMin  = configVars[2];
    wire [15:0] boundingWidthMax  = configVars[3];
    wire [15:0] boundingHeightMin = configVars[4];
    wire [15:0] boundingHeightMax = configVars[5];
    wire [15:0] fullnessMin       = configVars[6];
    wire [15:0] fullnessMax       = configVars[7];
    wire [15:0] slopeDiffMin      = configVars[8]; //tanΘ
    wire [15:0] slopeDiffMax      = configVars[9]; //tanΘ
    wire [15:0] slopeMin          = configVars[10]; //tanΘ
    wire [15:0] slopeMax          = configVars[11]; //tanΘ
    wire [15:0] nearestCoordX     = configVars[12];
    wire [15:0] nearestCoordY     = configVars[13];
    wire [9:0] threshold          = configVars[14][9:0];
    wire [7:0] exposure           = configVars[15][7:0];

    //Set Config over Fast Serial
    task setConfig(bit [4:0] addr, bit [15:0] value);
    endtask

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
    task write (bit [15:0] data);

    endtask
endmodule