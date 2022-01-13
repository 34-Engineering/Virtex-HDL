`timescale 1ns / 1ps
`include "Util.sv"
import Util::*;

/* Top - 

    */
module Top(
    input CLK,

    //USB
    inout wire [3:0] USB_BD,
    input wire USB_ON,
    input wire USB_PWREN,
    input wire USB_SUS,

    //RoboRIO
    input wire RIO_SCL,
    inout wire RIO_SDA,

    //Config EEPROM
    output wire CONF_CS,
    output wire CONF_WP,
    output wire CONF_HOLD,
    output wire CONF_CLK,
    output wire CONF_MOSI,
    input wire CONF_MISO,

    //Flash Memory
    output wire FLASH_CLK,
    output wire FLASH_CS,
    output wire [3:0] FLASH_SIO,

    //JTAG
    input wire TMS,
    input wire TCK,
    output wire TDO,
    input wire TDI,

    //LEDs
    output wire LED_IR,
    output wire [2:0] LED_PWR,
    output wire [2:0] LED_EN,
    output wire [2:0] LED_TAR,
    output wire [2:0] LED_COM,
    output wire LED_USER,
    input wire LED_FAULT,
    
    //Power Data
    input wire PWR_12V_EN,

    //Camera/Image Sensor LVDS
    input wire CAM_CLK_P,
    input wire CAM_CLK_N,
    input wire CAM_SYNC_P,
    input wire CAM_SYNC_N,
    input wire [3:0] CAM_DOUT_P,
    input wire [3:0] CAM_DOUT_N,

    //Camera/Image Sensor IO
    output wire CAM_SPI_CS,
    output wire CAM_SPI_MOSI,
    input wire CAM_SPI_MISO,
    output wire CAM_SPI_CLK,
    output wire [2:0] CAM_TRIG,
    input wire [1:0] CAM_MON,
    output wire CAM_RESET
    );

    bit enabled = 0;
    bit targetBlobValid = 0;
    Blob targetBlob;
    bit hasCommunication = 0;
    bit saveConfig = 0;
    OutputFrame outputFrame;

    //Sub-Components
    AppManager AppManager(
        .CLK(CLK),
        .FSDI(USB_BD[0]),
        .FSCLK(USB_BD[1]),
        .FSDO(USB_BD[2]),
        .FSCTS(USB_BD[3]),
        .USB_ON(USB_ON),
        .USB_PWREN(USB_PWREN),
        .USB_SUS(USB_SUS),
        .config(configuration),
        .saveConfig(saveConfig),
        .outputFrame(outputFrame)
    );

    // RoboRIOManager RoboRIOManager(
    //     .CLK(CLK),
    //     .I2C_SCL(RIO_SCL),
    //     .I2C_SDA(RIO_SDA),
    //     .configuration(configuration),
    //     .saveConfig(saveConfig),
    //     .hasCommunication(hasCommunication)
    // );

    // ConfigManager ConfigManager(
    //     .CLK(CLK),
    //     .SPI_CS(CONF_CS),
    //     .SPI_WP(CONF_WP),
    //     .SPI_HOLD(CONF_HOLD),
    //     .SPI_CLK(CONF_CLK),
    //     .SPI_MOSI(CONF_MOSI),
    //     .SPI_MISO(CONF_MISO),
    //     .configuration(configuration),
    //     .save(saveConfig)
    // );

    // FlashManager FlashManager(
    //     .CLK(CLK),
    //     .SPI_CLK(FLASH_CLK),
    //     .SPI_CS(FLASH_CS),
    //     .SPI_Q(FLASH_SIO),
    //     .TMS(TMS),
    //     .TCK(TCK),
    //     .TDO(TDO),
    //     .TDI(TDI)
    // );

    LEDManager LEDManager(
        .CLK(CLK),
        .LED_IR(LED_IR),
        .LED_PWR(LED_PWR),
        .LED_EN(LED_EN),
        .LED_TAR(LED_TAR),
        .LED_COM(LED_COM),
        .LED_USER(LED_USER),
        .LED_FAULT(LED_FAULT),
        .USB_ON(USB_ON),
        .PWR_12V_EN(PWR_12V_EN),
        .enabled(enabled),
        .targetBlobValid(targetBlobValid),
        .hasCommunication(hasCommunication)
    );

    // CameraManager CameraManager(
    //     .CLK(CLK),
    //     .LVDS_CLK_P(CAM_CLK_P),
    //     .LVDS_CLK_N(CAM_CLK_N),
    //     .LVDS_SYNC_P(CAM_SYNC_P),
    //     .LVDS_SYNC_N(CAM_SYNC_N),
    //     .LVDS_DOUT_P(CAM_DOUT_P),
    //     .LVDS_DOUT_N(CAM_DOUT_N),
    //     .SPI_CS(CAM_SPI_CS),
    //     .SPI_MOSI(CAM_SPI_MOSI),
    //     .SPI_MISO(CAM_SPI_MISO),
    //     .SPI_CLK(CAM_SPI_CLK),
    //     .TRIGGER(CAM_TRIG),
    //     .MONITOR(CAM_MON),
    //     .RESET(CAM_RESET),
    //     .outputFrame(outputFrame)
    // );
endmodule