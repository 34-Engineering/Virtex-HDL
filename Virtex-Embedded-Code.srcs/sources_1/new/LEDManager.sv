`timescale 1ns / 1ps

/* LEDManager - Manages the 8 LED_IR LEDs & 4 RGB Signal LEDs */
module LEDManager(
    input wire CLK,
    output wire LED_IR,
    output wire [2:0] LED_PWR, //0 = red, 1 = green, 2 = blue
    output wire [2:0] LED_EN,
    output wire [2:0] LED_TAR,
    output wire [2:0] LED_COM,
    output bit LED_USER,
    input wire LED_FAULT, //active low, from MAX16834
    input wire USB_ON,
    input wire PWR_12V_EN,
    input wire enabled,
    input wire targetBlobValid,
    input wire hasComms
    );

    //LED_USER: blink at 1hz
    bit [31:0] counter = 0;
    initial begin
        LED_USER <= 0;
    end
    always @ (posedge CLK) begin
        counter <= counter + 1;
        if (counter > 50000000) begin
            LED_USER <= !LED_USER;
            counter <= 0;
        end
    end

    //LED_IR: on when enabled, no fault, and 12V power
    assign LED_IR = enabled & LED_FAULT & PWR_12V_EN;

    //PWR: green for 12V power & yellow for USB power
    assign LED_PWR[1] = 1;
    assign LED_PWR[0] = USB_ON;

    //TAR: blue when target valid
    assign LED_TAR[2] = targetBlobValid; 

    //COM: green when has coms
    assign LED_COM[1] = hasComms;

    //EN: flashes orange rgb(255, 165, 0) when enabled
    bit [26:0] enabledToggleCounter;
    bit [7:0] enabledGreenCounter;
    wire enabledToggle = enabled && enabledToggleCounter > 50000000;
    assign LED_EN[2] = enabledToggle;
    assign LED_EN[1] = enabledToggle && enabledGreenCounter > 165;
    always @(posedge CLK) begin
        enabledToggleCounter = enabledToggleCounter + 1;
        enabledGreenCounter = enabledGreenCounter + 1;
    end
endmodule
