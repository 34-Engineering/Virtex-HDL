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

    //Config Parameters
    reg [15:0] configVars [15:0];
    initial begin
        configVars[ 0] <= 0;
        configVars[ 1] <= 0;
        configVars[ 2] <= 0;
        configVars[ 3] <= 16'hffff;
        configVars[ 4] <= 0;
        configVars[ 5] <= 16'hffff;
        configVars[ 6] <= 0;
        configVars[ 7] <= 16'hffff;
        configVars[ 8] <= 0;
        configVars[ 9] <= 16'hffff;
        configVars[10] <= 0;
        configVars[11] <= 16'hffff;
        configVars[12] <= 16'd280;
        configVars[13] <= 16'd280;
        configVars[14] <= 8'h0f;
        configVars[15] <= 8'h0f;
    end

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
