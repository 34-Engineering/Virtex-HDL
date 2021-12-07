`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 34 Engineering
// Engineer: Liam Snow
// 
// Create Date: 06/08/2021
// Module Name: LEDManager
// Project Name: Virtex
// 
//////////////////////////////////////////////////////////////////////////////////

/* LEDManager - Manages the 3x LS_IR LEDs & 4x RGB Signal LEDs */
module LEDManager(
    input wire CLK,
    
    output wire LS_IR,
    output wire [2:0] LS_PWR,
    output wire [2:0] LS_EN,
    output wire [2:0] LS_TAR,
    output wire [2:0] LS_COM,
    input wire LED_FAULT,
    input wire USB_ON,
    input wire PWR_12V_EN,
    input wire targetBlobValid,
    input wire hasComms
    );

    //LS_IR: on when enabled
    assign LS_IR = Top.enabled;

    //PWR: green for 12V power & yellow for USB power
    assign LS_PWR[2] = USB_ON;
    assign LS_PWR[1] = 1;

    //TAR: blue when target valid
    assign LS_TAR[0] = targetBlobValid; 

    //COM: green when has coms
    assign LS_COM[1] = hasComms;

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
