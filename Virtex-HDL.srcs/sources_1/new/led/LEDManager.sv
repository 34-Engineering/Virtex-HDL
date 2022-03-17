`timescale 1ns / 1ps
`include "../blob/BlobUtil.sv"
`include "../util/Fault.sv"

/* LEDManager - Manages the 8 LED_IR LEDs & 4 RGB Signal LEDs

    Signal LEDs: 3-bit registers where 0 = red, 1 = blue, 2 = green (RGB)
*/
module LEDManager(
    input wire CLK100,
    output wire LED_IR, LED_USER,
    output wire [2:0] LED_PWR, LED_EN, LED_TAR, LED_COM,
    input wire LED_FAULT, //active low, from MAX16834
    input wire USB_ON, PWR_12V_EN,
    input wire enabled, hasCommunication,
    input wire Target target,
    input wire [7:0] debug
    );

    localparam brightness = 400;

    //Make RGB
    reg [7:0] counter255 = 0;
    reg [11:0] counter255B = 8'h0F; //4096 (x16, << 4)
    always_ff @(posedge CLK100) begin
        counter255 <= counter255 + 1;
        counter255B <= counter255B + 1; //90° shift
    end
    function automatic logic [2:0] makeRGBA(logic [7:0] r, g, b, a);
        //generated RGB PWM signal from rgba code
        // 255 -> 1111..., 0 -> 0000..., 127 -> 1010...
        return '{
            counter255 < r & counter255B < a,
            counter255 < g & counter255B < a,
            counter255 < b & counter255B < a
        };
    endfunction

    //IR Led Ring (on when enabled, no fault, and 12V power)
    reg fault = 0;
    reg clearedFault = 0;
    reg [26:0] faultTimer = 0;
    reg [7:0] tb = 0;
    assign LED_IR = enabled & tb == 0; //~fault//~PWR_12V_EN;
    always_ff @(posedge CLK100) begin
        tb <= tb + 1;

        faultTimer <= faultTimer + 1;

        //flag fault (delay 10ms if we just cleared it)
        if (~fault & ~LED_FAULT & (~clearedFault | faultTimer > 24'd10000000)) begin
            fault <= 1;
            clearedFault <= 0;
            faultTimer <= 0;
        end

        //clear fault after 100ms //TODO is this bad?? //TODO only if no fault rn/reset timer on fault?
        else if (fault & faultTimer == 27'd100000000) begin
            fault <= 0;
            clearedFault <= 1;
            faultTimer <= 0;
        end

        //clear clear fault after 100ms
        if (clearedFault & faultTimer == 27'd100000000) begin
            clearedFault <= 0;
        end
    end

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