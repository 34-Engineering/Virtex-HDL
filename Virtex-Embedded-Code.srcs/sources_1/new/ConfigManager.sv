`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 34 Engineering
// Engineer: Liam Snow
// 
// Create Date: 06/28/2021
// Module Name: ConfigManager
// Project Name: Virtex
// 
//////////////////////////////////////////////////////////////////////////////////

/* ConfigManager - SPI Master to the EEPROM
    Reads in config at boot
    Saves config on event trigger */
module ConfigManager(
    input wire CLK,
    output wire SPI_CS,
    output wire SPI_WP,
    output wire SPI_HOLD,
    output wire SPI_CLK,
    output wire SPI_MOSI,
    input wire SPI_MISO
    );

    //Config Parameters
    wire [15:0] configVars [15:0];
    assign configVars[ 0] = 0;
    assign configVars[ 1] = 0;
    assign configVars[ 2] = 0;
    assign configVars[ 3] = 16'hffff;
    assign configVars[ 4] = 0;
    assign configVars[ 5] = 16'hffff;
    assign configVars[ 6] = 0;
    assign configVars[ 7] = 16'hffff;
    assign configVars[ 8] = 0;
    assign configVars[ 9] = 16'hffff;
    assign configVars[10] = 0;
    assign configVars[11] = 16'hffff;
    assign configVars[12] = 16'd280;
    assign configVars[13] = 16'd280;
    assign configVars[14] = 8'h0f;
    assign configVars[15] = 8'h0f;

    //Config Wires
    wire dualObjectMode     = configVars[0]; //OFF, ON_AIN, ON_AOUT
    wire orientation        = configVars[1]; //0, 90, 180, 270
    wire boundingWidthMin   = configVars[2];
    wire boundingWidthMax   = configVars[3];
    wire boundingHeightMin  = configVars[4];
    wire boundingHeightMax  = configVars[5];
    wire fullnessMin        = configVars[6];
    wire fullnessMax        = configVars[7];
    wire angleDiffMin       = configVars[8];
    wire angleDiffMax       = configVars[9];
    wire angleMin           = configVars[10];
    wire angleMax           = configVars[11];
    wire nearestCoordX      = configVars[12];
    wire nearestCoordY      = configVars[13];
    wire threshold          = configVars[14]; //8 bit
    wire exposure           = configVars[15]; //8 bit

    //EEPROM
    assign SPI_CS = 1;

endmodule
