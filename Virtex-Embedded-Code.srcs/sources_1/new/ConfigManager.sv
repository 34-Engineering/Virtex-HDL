`timescale 1ns / 1ps

/* ConfigManager - SPI Master to the EEPROM
    Reads in config at boot
    Saves config on event trigger
    Max 32 configurations */
module ConfigManager(
    input wire CLK,
    output wire SPI_CS,
    output wire SPI_WP,
    output wire SPI_HOLD,
    output wire SPI_CLK,
    output wire SPI_MOSI,
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
    wire dualObjectMode     = configVars[0]; //OFF, ON_AIN, ON_AOUT
    wire orientation        = configVars[1]; //0, 90, 180, 270
    wire boundingWidthMin   = configVars[2];
    wire boundingWidthMax   = configVars[3];
    wire boundingHeightMin  = configVars[4];
    wire boundingHeightMax  = configVars[5];
    wire fullnessMin        = configVars[6];
    wire fullnessMax        = configVars[7];
    wire slopeDiffMin       = configVars[8];
    wire slopeDiffMax       = configVars[9];
    wire slopeMin           = configVars[10];
    wire slopeMax           = configVars[11];
    wire nearestCoordX      = configVars[12];
    wire nearestCoordY      = configVars[13];
    wire threshold          = configVars[14]; //8 bit
    wire exposure           = configVars[15]; //8 bit

    //EEPROM
    assign SPI_CS = 1;

    //TODO SPI MASTER

endmodule
