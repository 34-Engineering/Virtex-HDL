`timescale 1ns / 1ps

/* LEDManager - Manages the 8 LS_IR LEDs & 4 RGB Signal LEDs */
module LEDManager(
    input wire CLK,
    output wire LS_IR,
    output wire [2:0] LS_PWR, //0 = red, 1 = green, 2 = blue
    output wire [2:0] LS_EN,
    output wire [2:0] LS_TAR,
    output wire [2:0] LS_COM,
    input wire LED_FAULT, //active low, from MAX16834
    input wire USB_ON,
    input wire PWR_12V_EN,
    input wire enabled,
    input wire targetBlobValid,
    input wire hasComms
    );

    //LS_IR: on when enabled, no fault, and 12V power
    assign LS_IR = enabled & LED_FAULT & PWR_12V_EN;

    //PWR: green for 12V power & yellow for USB power
    assign LS_PWR[1] = 1;
    assign LS_PWR[0] = USB_ON;

    //TAR: blue when target valid
    assign LS_TAR[2] = targetBlobValid; 

    //COM: green when has coms
    assign LS_COM[1] = hasComms;

    //EN: flashes orange rgb(255, 165, 0) when enabled
    reg [26:0] enabledToggleCounter;
    reg [7:0] enabledGreenCounter;
    wire enabledToggle = enabled && enabledToggleCounter > 50000000;
    assign LS_EN[2] = enabledToggle;
    assign LS_EN[1] = enabledToggle && enabledGreenCounter > 165;
    always @(posedge CLK) begin
        enabledToggleCounter = enabledToggleCounter + 1;
        enabledGreenCounter = enabledGreenCounter + 1;
    end
endmodule
