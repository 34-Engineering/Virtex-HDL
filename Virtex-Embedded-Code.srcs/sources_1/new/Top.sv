`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 34 Engineering
// Engineer: Liam Snow
// 
// Create Date: 06/08/2021 11:14:59 AM
// Module Name: Top
// Project Name: Virtex
// 
//////////////////////////////////////////////////////////////////////////////////


module Top(
    input CLK,

    inout USB_TX,
    inout USB_RX,

    output UART_TX,
    input UART_RX,

    output LED_IR,
    output LED_PWR,
    output LED_EN,
    output LED_TAR,
    input LED_V12,

    input CAM_MCLK_N,
    input CAM_MCLK_P,
    input CAM_MD1_N,
    input CAM_MD1_P,
    input CAM_MD2_N,
    input CAM_MD2_P,
    inout [3:0] CAM_GPIO,
    output CAM_XSHDN
    );

    //Sub-Components
    USBManager USBManager(
        .CLK(CLK),
        .TX(USB_TX),
        .RX(USB_RX)
    );

    UARTManager UARTManager(
        .CLK(CLK),
        .TX(UART_TX),
        .RX(UART_RX)
    );

    LEDManager LEDManager(
        .CLK(CLK),
        .IR(LED_IR),
        .PWR(LED_PWR),
        .EN(LED_EN),
        .TAR(LED_TAR),
        .V12(LED_V12)
    );

    CameraManager CameraManager(
        .CLK(CLK),
        .MCLK_N(CAM_MCLK_N),
        .MCLK_P(CAM_MCLK_P),
        .MD1_N(CAM_MD1_N),
        .MD1_P(CAM_MD1_P),
        .MD2_N(CAM_MD2_N),
        .MD2_P(CAM_MD2_P),
        .GPIO(CAM_GPIO),
        .XSHDN(CAM_XSHDN)
    );

    //Process Vars
    reg enabled = 0;
    reg hasTarget = 0;

    //Config
    typedef struct { reg [9:0] x; reg [9:0] y; } vertex;
    typedef struct { reg [9:0] min; reg [9:0] max; } rangedConst;
    enum { Fast, Med, Slow } streamMode; //60fps@2bit, 30fps@4bit, 15fps@2bit
    enum { OFF, ON_AIN, ON_AOUT } dualObjectMode;
    enum { C0, C90, C180, C270 } orientation;
    rangedConst boundingWidth = '{0, 10'b1111111111};
    rangedConst boundingHeight = '{0, 10'b1111111111};
    rangedConst fullness = '{0, 10'b1111111111};
    rangedConst angleDiff = '{0, 10'b1111111111};
    rangedConst angle = '{0, 10'b1111111111};
    vertex nearstCoord = '{280, 280};
    reg [7:0] threshold = 8'b00001111;
    reg [7:0] exposure = 8'b00000000; //????
    reg [3:0] wantedData = 4'b0000; //0: bou. xywh, 1: bou. vert., 2: inn. xywha, 3: inn. vert.

endmodule
