`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 34 Engineering
// Engineer: Liam Snow
// 
// Create Date: 06/08/2021 11:14:59 AM
// Module Name: LEDManager
// Project Name: Virtex
// 
//////////////////////////////////////////////////////////////////////////////////

/* LEDManager - Manages the 3x IR LEDs & 4x RGB Signal LEDs */
module LEDManager(
    input CLK,
    output IR,
    output [2:0] PWR,
    output [2:0] EN,
    output [2:0] TAR,
    output [2:0] COM,
    input PWR_V2ON
    );

    //IR: on when enabled
    assign IR = Top.enabled;

    //PWR: green for 12V power & yellow for USB power
    assign PWR[2] = PWR_V2ON;
    assign PWR[1] = 1;

    //TAR: blue when target valid
    assign TAR[0] = Top.targetBlobValid; 

    //COM: green when has coms
    assign COM[1] = Top.RoboRIOManager.hasComs;

    //EN: flashes orange (255,165,0) when enabled
    reg [26:0] enabledToggleCounter;
    reg [7:0] enabledGreenCounter;
    always @(posedge CLK) begin
        enabledToggleCounter = enabledToggleCounter + 1;
        enabledGreenCounter = enabledGreenCounter + 1;
    end
    assign EN[2] = Top.enabled && enabledToggleCounter > 50000000;
    assign EN[1] = Top.enabled && enabledToggleCounter > 50000000 && enabledGreenCounter > 165;

endmodule
