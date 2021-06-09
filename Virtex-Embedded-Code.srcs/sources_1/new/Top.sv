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

    inout [7:0] USB_BDBUS,
    inout [7:0] USB_BCBUS,

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

    reg enabled = 0;
    reg hasTarget = 0;
    reg [1:0] streamMode = 2'b00; //0: 2b 60fps, 1: 4b 30fps, 2: 8b 15fps

    //Vision Config
    reg dualObjectMode = 0;
    reg [3:0] wantedData = 4'b0000; //1: bounding rect xywh, 2: bounding vertexes, 3: inner rect xywhs, 4: inner vertexes
    reg [1:0] orientation = 2'b00; //0: normal, 1: 90 clock, 2: 180, 3: 270 clock
    reg [6:0] exposure = 0; //????
    reg [7:0] threshold = 8'b00001111;
    reg [9:0] minBlobBoundingWidth = 0;
    reg [9:0] maxBlobBoundingWidth = 10'b1111111111;
    reg [9:0] minBlobBoundingHeight = 0;
    reg [9:0] maxBlobBoundingHeight = 10'b1111111111;
    reg [6:0] minFullness = 0;
    reg [6:0] maxFullness = 7'b1111111;
    reg [8:0] minAngle = 0;
    reg [8:0] maxAngle = 8'b11111111;
    reg [8:0] minAngleDiff = 0;
    reg [8:0] maxAngleDiff = 8'b11111111;
    reg [9:0] finalSelectionCoordX = 10'b100011000;
    reg [9:0] finalSelectionCoordY = 10'b100011000;
    
    USBManager USBManager(
        .CLK(CLK),
        .BDBUS(BDBUS),
        .BCBUS(BCBUS)
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
endmodule
