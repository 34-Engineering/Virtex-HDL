`timescale 1ns / 1ps
import Util::*;

/* LEDManager - Manages the 8 LED_IR LEDs & 4 RGB Signal LEDs */
module LEDManager(
    input wire CLK,
    output wire LED_IR,
    output wire [2:0] LED_PWR, //0 = red, 1 = green, 2 = blue
    output wire [2:0] LED_EN,
    output wire [2:0] LED_TAR,
    output wire [2:0] LED_COM,
    output wire LED_USER,
    input wire LED_FAULT, //active low, from MAX16834
    input wire USB_ON,
    input wire PWR_12V_EN,
    input wire enabled,
    input wire Blob targetBlob,
    input wire hasCommunication
    );

    //LED_USER: blink at 1.5hz
    reg [25:0] counter = 0;
    assign LED_USER = counter > 25'b1111111111111111111111111;
    always @ (posedge CLK) begin
        counter <= counter + 1;
    end

    //LED_IR: on when enabled, no fault, and 12V power
    assign LED_IR = enabled & LED_FAULT & PWR_12V_EN;

    //PWR: green for 12V power & yellow for USB power
    assign LED_PWR[1] = 1;
    assign LED_PWR[0] = USB_ON;

    //TAR: blue when target valid
    assign LED_TAR[2] = targetBlob.valid; 

    //COM: green when has coms
    assign LED_COM[1] = hasCommunication;

    //EN: flashes orange rgb(255, 165, 0) at 1.5hz when enabled
    reg [25:0] enabledToggleCounter;
    reg [7:0] enabledGreenCounter;
    wire enabledToggle = enabled && enabledToggleCounter > 25'b1111111111111111111111111;
    assign LED_EN[2] = enabledToggle;
    assign LED_EN[1] = enabledToggle && enabledGreenCounter > 165;
    always @(posedge CLK) begin
        enabledToggleCounter <= enabledToggleCounter + 1;
        enabledGreenCounter <= enabledGreenCounter + 1;
    end
endmodule
