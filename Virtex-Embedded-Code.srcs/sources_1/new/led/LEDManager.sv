`timescale 1ns / 1ps
`include "../blob/BlobUtil.sv"
`include "../util/Fault.sv"

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
    input wire Target target,
    input wire [7:0] debug
    );

    localparam brightness = 20;

    //IR Led Ring (on when enabled, no fault, and 12V power)
    assign LED_IR = enabled & LED_FAULT & PWR_12V_EN;

    //Make RGB
    reg [7:0] counter255 = 0, counter255B = 8'h0f;
    always_ff @(posedge CLK) begin
        counter255 <= counter255 + 1;
        counter255B <= counter255B + 1; //90° shift
    end
    function automatic logic [2:0] makeRGB(logic [7:0] r, g, b, a);
        // 255 -> 1111, 0 -> 0000, 127 -> 1010...
        return '{
            counter255 < r & counter255B < a,
            counter255 < g & counter255B < a,
            counter255 < b & counter255B < a
        };
    endfunction

    //Status LEDs
    assign LED_PWR = ~makeRGB(debug[7], debug[6], 0, brightness);
    assign LED_EN  = ~makeRGB(debug[5], debug[4], 0, brightness);
    assign LED_TAR = ~makeRGB(debug[3], debug[2], 0, brightness);
    assign LED_COM = ~makeRGB(debug[1], debug[0], 0, brightness);

    // assign LED_PWR = PWR_12V_EN ? ~makeRGB(255, 255, 0, brightness) : ~makeRGB(255, 0, 0, brightness);
    // assign LED_TAR = 3'b111;
    // assign LED_COM = hasCommunication ? ~makeRGB(0, 255, 0, brightness) : 3'b111;
    // assign LED_EN = enabledToggle ? ~makeRGB(255, 165, 0, brightness) : 3'b111;

    reg [25:0] enabledToggleCounter = 0;
    wire enabledToggle = enabled & enabledToggleCounter > 25'd20000000;
    always_ff @(posedge CLK) begin
        enabledToggleCounter <= enabledToggleCounter < 26'd40000000 ? (enabledToggleCounter + 1) : 0;
    end

    // LED_USER: blink at ?hz
    assign LED_USER = 0;

endmodule