`timescale 1ns / 1ps
`include "Util.sv"

/* LEDManager - Manages the 8 LED_IR LEDs & 4 RGB Signal LEDs

    Signal LEDs: 3-bit registers where 0 = red, 1 = blue, 2 = green (RGB)
*/
module LEDManager(
    input wire CLK,
    output wire LED_IR, LED_USER,
    output wire [2:0] LED_PWR, LED_EN, LED_TAR, LED_COM,
    input wire LED_FAULT, //active low, from MAX16834
    input wire USB_ON, PWR_12V_EN,
    input wire enabled, hasCommunication,
    input wire Blob targetBlob,
    output wire Fault fault
    );

    //LED_IR: on when enabled, no fault, and 12V power
    assign LED_IR = enabled & LED_FAULT & PWR_12V_EN;
    assign fault = LED_FAULT ? IR_LED_FAULT : NO_FAULT;

    //PWR: green for 12V power & yellow for USB power
    assign LED_PWR[1] = 1;
    assign LED_PWR[0] = USB_ON;

    //TAR: blue when target valid
    assign LED_TAR[2] = targetBlob.valid; 

    //COM: green when has coms
    assign LED_COM[1] = hasCommunication;

    //EN: flashes orange rgb(255, 165, 0) at 2.5hz (100MHz / 40MHz) when enabled
    reg [25:0] enabledToggleCounter;
    reg [7:0] enabledGreenCounter;
    wire enabledToggle = enabled & enabledToggleCounter > 25'd20000000;
    assign LED_EN[2] = enabledToggle;
    assign LED_EN[1] = enabledToggle & enabledGreenCounter > 165;
    always @(posedge CLK) begin
        enabledGreenCounter <= enabledGreenCounter + 1;
        enabledToggleCounter <= enabledToggleCounter < 26'd40000000 ? enabledToggleCounter + 1 : 0;
    end

    //LED_USER: blink at 2.5hz 
    assign LED_USER = enabledToggleCounter > 25'd20000000;
endmodule