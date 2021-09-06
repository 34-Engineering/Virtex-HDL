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

/* LEDManager - Manages the 3x LS_IR LEDs & 4x RGB Signal LEDs */
module LEDManager(
    input CLK,
    
    output LS_IR,
    output [2:0] LS_PWR,
    output [2:0] LS_EN,
    output [2:0] LS_TAR,
    output [2:0] LS_COM,
    input PWR_V2ON,
    input PWR_V2UV,
    input PWR_V1UV
    );

    //LS_IR: on when enabled
    assign LS_IR = Top.enabled;

    //PWR: green for 12V power & yellow for USB power
    assign LS_PWR[2] = PWR_V2ON;
    assign LS_PWR[1] = 1;

    //TAR: blue when target valid
    assign LS_TAR[0] = Top.targetBlobValid; 

    //COM: green when has coms
    assign LS_COM[1] = Top.RoboRIOManager.hasComs;

    //EN: flashes orange (255,165,0) when enabled
    reg [26:0] enabledToggleCounter;
    reg [7:0] enabledGreenCounter;
    always @(posedge CLK) begin
        enabledToggleCounter = enabledToggleCounter + 1;
        enabledGreenCounter = enabledGreenCounter + 1;
    end
    assign LS_EN[2] = Top.enabled && enabledToggleCounter > 50000000;
    assign LS_EN[1] = Top.enabled && enabledToggleCounter > 50000000 && enabledGreenCounter > 165;

endmodule
