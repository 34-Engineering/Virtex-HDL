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

    //USB
    inout [3:0] USB_BD,
    output USB_PWRSAV,
    output USB_PWREN,
    output USB_SUS,

    //RoboRIO
    input RIO_SCL,
    inout RIO_SDA,

    //Config EEPROM
    output CONF_CS,
    output CONF_WP,
    output CONF_HOLD,
    output CONF_CLK,
    output CONF_MOSI,
    input CONF_MISO,

    //Flash Memory
    output FLASH_CLK,
    output FLASH_CS,
    output [3:0] FLASH_SIO,

    //JTAG
    input TMS,
    input TCK,
    output TDO,
    input TDI,

    //LEDs
    output LED_IR,
    output [2:0] LED_PWR,
    output [2:0] LED_EN,
    output [2:0] LED_TAR,
    output [2:0] LED_COM,
    
    //Power Data
    input PWR_V1UV,
    input PWR_V2UV,
    input PWR_V2ON,

    //Camera/Image Sensor LVDS
    input CAM_CLK_P,
    input CAM_CLK_N,
    input CAM_SYNC_P,
    input CAM_SYNC_N,
    input [3:0] CAM_DOUT_P,
    input [3:0] CAM_DOUT_N,

    //Camera/Image Sensor IO
    output CAM_SPI_CS,
    output CAM_SPI_MOSI,
    input CAM_SPI_MISO,
    output CAM_SPI_CLK,
    output [2:0] CAM_TRIG,
    input [1:0] CAM_MON,
    output CAM_RESET
    );

    //Process Vars
    reg enabled = 0; /* synthesis keep */
    reg targetBlobValid = 0; /* synthesis keep */
    reg [9:0] targetBlob [12:0]; /* synthesis keep */

    //Sub-Components
    AppManager AppManager(
        .CLK(CLK),
        .FS_DI(USB_BD[0]),
        .FS_CLK(USB_BD[1]),
        .FS_DO(USB_BD[2]),
        .FS_CTS(USB_BD[3]),
        .USB_PWRSAV(USB_PWRSAV),
        .USB_PWREN(USB_PWREN),
        .USB_SUS(USB_SUS)
    ); /* synthesis keep */

    RoboRIOManager RoboRIOManager(
        .CLK(CLK),
        .I2C_SCL(RIO_SCL),
        .I2C_SDA(RIO_SDA)
    ); /* synthesis keep */

    ConfigManager ConfigManager(
        .CLK(CLK),
        .SPI_CS(CONF_CS),
        .SPI_WP(CONF_WP),
        .SPI_HOLD(CONF_HOLD),
        .SPI_CLK(CONF_CLK),
        .SPI_MOSI(CONF_MOSI),
        .SPI_MISO(CONF_MISO)
    ); /* synthesis keep */

    FlashManager FlashManager(
        .CLK(CLK),
        .SPI_CLK(FLASH_CLK),
        .SPI_CS(FLASH_CS),
        .SPI_Q(FLASH_SIO),
        .TMS(TMS),
        .TCK(TCK),
        .TDO(TDO),
        .TDI(TDI)
    ); /* synthesis keep */

    LEDManager LEDManager(
        .CLK(CLK),
        .LS_IR(LED_IR),
        .LS_PWR(LED_PWR),
        .LS_EN(LED_EN),
        .LS_TAR(LED_TAR),
        .LS_COM(LED_COM),
        .PWR_V2ON(PWR_V2ON),
        .PWR_V2UV(PWR_V2UV),
        .PWR_V1UV(PWR_V1UV)
    ); /* synthesis keep */

    CameraManager CameraManager(
        .CLK(CLK),
        .LVDS_CLK_P(CAM_CLK_P),
        .LVDS_CLK_N(CAM_CLK_N),
        .LVDS_SYNC_P(CAM_SYNC_P),
        .LVDS_SYNC_N(CAM_SYNC_N),
        .LVDS_DOUT_P(CAM_DOUT_P),
        .LVDS_DOUT_N(CAM_DOUT_N),
        .SPI_CS(CAM_SPI_CS),
        .SPI_MOSI(CAM_SPI_MOSI),
        .SPI_MISO(CAM_SPI_MISO),
        .SPI_CLK(CAM_SPI_CLK),
        .TRIGGER(CAM_TRIG),
        .MONITOR(CAM_MON),
        .RESET(CAM_RESET)
    ); /* synthesis keep */

endmodule
