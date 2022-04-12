`timescale 1ns / 1ps
`include "../vision/VisionUtil.sv"
`include "../util/Fault.sv"
`include "../config/VirtexConfig.sv"

/* LEDManager - Manages the 3 IR LEDs & RGB LED Bar

    Signal LEDs: 3-bit registers where 0 = red, 1 = blue, 2 = green (RGB)
*/
module LEDManager(
    input wire CLK100,
    output wire LED_IR, LED_USER,
    output wire [2:0] LED_PWR, LED_EN, LED_TAR, LED_COM,
    input wire LED_FAULT, //active low, from MAX16834
    input wire USB_ON, PWR_12V_EN,
    input VirtexConfig virtexConfig,
    input wire enabled, hasCommunication,
    input wire Target target,
    input wire [7:0] debug
    );

    localparam brightness = 12'd400;

    //Make RGB
    reg [7:0] counter255 = 0;
    reg [11:0] counter255B = 8'h0F; //4096 (x16, << 4)
    always_ff @(posedge CLK100) begin
        counter255 <= counter255 + 1;
        counter255B <= counter255B + 1; //90° shift
    end
    function automatic logic [2:0] makeRGBA(logic [7:0] r, g, b, logic [11:0] a);
        //generated RGB PWM signal from rgba code
        // 255 -> 1111..., 0 -> 0000..., 127 -> 1010...
        return '{
            counter255 < r & counter255B < a,
            counter255 < g & counter255B < a,
            counter255 < b & counter255B < a
        };
    endfunction

    //IR Led Ring (on when enabled, no fault, and 12V power)
    reg [13:0] clkdiv1 = 0;
    wire CLK1 = clkdiv1 > 14'd50; //1MHz (from 100MHz)
    always_ff @(posedge CLK100) clkdiv1 <= clkdiv1 < 14'd100 ? (clkdiv1 + 1) : 0;

    reg [3:0] pwmPos = 0; //10kHz PWM with 16-bit precision
    always_ff @(posedge CLK1) pwmPos <= pwmPos + 1;

    assign LED_IR = enabled & virtexConfig.ledBrightness[pwmPos]; //~fault//~PWR_12V_EN;

    //Status LEDs
    assign LED_PWR = ~makeRGBA(debug[7]?255:0, debug[6]?255:0, 0, brightness);
    assign LED_EN  = ~makeRGBA(debug[5]?255:0, debug[4]?255:0, 0, brightness);
    assign LED_TAR = ~makeRGBA(debug[3]?255:0, debug[2]?255:0, 0, brightness);
    assign LED_COM = ~makeRGBA(debug[1]?255:0, debug[0]?255:0, 0, brightness);

    reg [25:0] enabledToggleCounter = 0;
    wire enabledToggle = enabled & enabledToggleCounter > 25'd20000000;
    always_ff @(posedge CLK100) begin
        enabledToggleCounter <= enabledToggleCounter < 26'd40000000 ? (enabledToggleCounter + 1) : 0;
    end

    // assign LED_PWR = PWR_12V_EN ? ~makeRGBA(255, 255, 0, brightness) : ~makeRGBA(255, 0, 0, brightness);
    // assign LED_TAR = 3'b111;
    // assign LED_COM = hasCommunication ? ~makeRGBA(0, 255, 0, brightness) : 3'b111;
    // assign LED_EN = enabledToggle ? ~makeRGBA(255, 165, 0, brightness) : 3'b111;

    // LED_USER: blink at ?hz
    assign LED_USER = enabledToggleCounter > 25'd20000000 & counter255 < 8'd2;

endmodule