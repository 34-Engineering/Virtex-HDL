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

    inout [3:0] USB_BD,
    output USB_PWRSAV,
    output USB_PWREN,
    output USB_SUS,

    input RIO_SCL,
    inout RIO_SDA,

    output CONF_CS,
    output CONF_WP,
    output CONF_HOLD,
    output CONF_CLK,
    output CONF_MOSI,
    input CONF_MISO,

    output LED_IR,
    output [2:0] LED_PWR,
    output [2:0] LED_EN,
    output [2:0] LED_TAR,
    output [2:0] LED_COM,
    
    input PWR_V1_UV,
    input PWR_V2UV,
    input PWR_V2ON,

    input CAM_MC_LPP,
    input CAM_MC_LPN,
    input CAM_MC_HSP,
    input CAM_MC_HSN,
    input [1:0] CAM_MD_LPP,
    input [1:0] CAM_MD_LPN,
    input [1:0] CAM_MD_HSP,
    input [1:0] CAM_MD_HSN,
    inout [3:0] CAM_GPIO,
    output CAM_SHDN,
    output CAM_SCL,
    inout CAM_SDA
    );

    //Process Vars
    reg enabled = 0; /* synthesis keep */
    reg targetBlobValid = 0; /* synthesis keep */
    reg [9:0] targetBlob [12:0]; /* synthesis keep */

    //Sub-Components
    USBManager USBManager(
        .CLK(CLK),
        .FSDI(USB_BD[0]),
        .FSCLK(USB_BD[1]),
        .FSDO(USB_BD[2]),
        .FSCTS(USB_BD[3]),
        .PWRSAV(USB_PWRSAV),
        .PWREN(USB_PWREN),
        .SUS(USB_SUS)
    ); /* synthesis keep */

    RoboRIOManager RoboRIOManager(
        .CLK(CLK),
        .SCL(RIO_SCL),
        .SDA(RIO_SDA)
    ); /* synthesis keep */

    ConfigManager ConfigManager(
        .CLK(CLK),
        .CS(CONF_CS),
        .WP(CONF_WP),
        .HOLD(CONF_HOLD),
        .OCLK(CONF_CLK),
        .MOSI(CONF_MOSI),
        .MISO(CONF_MISO)
    ); /* synthesis keep */

    LEDManager LEDManager(
        .CLK(CLK),
        .IR(LED_IR),
        .PWR(LED_PWR),
        .EN(LED_EN),
        .TAR(LED_TAR),
        .COM(LED_COM),
        .PWR_V2ON(PWR_V2ON)
    ); /* synthesis keep */

    CameraManager CameraManager(
        .CLK(CLK),
        .MC_LPP(CAM_MC_LPP),
        .MC_LPN(CAM_MC_LPN),
        .MC_HSP(CAM_MC_HSP),
        .MC_HSN(CAM_MC_HSN),
        .MD_LPP(CAM_MD_LPP),
        .MD_LPN(CAM_MD_LPN),
        .MD_HSP(CAM_MD_HSP),
        .MD_HSN(CAM_MD_HSN),
        .GPIO(CAM_GPIO),
        .SHDN(CAM_SHDN),
        .SCL(CAM_SCL),
        .SDA(CAM_SDA)
    ); /* synthesis keep */

endmodule
