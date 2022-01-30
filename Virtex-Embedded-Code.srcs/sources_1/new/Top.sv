`timescale 1ns / 1ps
`include "Util.sv"
`include "CameraManagerParams.sv"

/* Top - top (main) module for the FPGA source code

    Only this module and it's submodules will get synthesizes and implemented into the bit file.

    All the inputs either come from TopSim.sv or the Virtex.xdc contraints file.
    
    */
module Top(
    input CLK,

    //USB
    input wire USB_FSDI, USB_FSCLK, USB_FSDO, USB_FSCTS,
    input wire USB_ON, USB_PWREN, USB_SUS,

    //RoboRIO
    input wire RIO_CLK, RIO_MOSI, RIO_CS,
    output wire RIO_MISO,

    //Config EEPROM
    output wire CONF_CS, CONF_WP, CONF_HOLD, CONF_CLK, CONF_MOSI,
    input wire CONF_MISO,

    //Flash Memory
    output wire FLASH_CLK, FLASH_CS,
    output wire [3:0] FLASH_SIO,

    //JTAG
    input wire USB_TMS, USB_TCK, USB_TDI,
    output wire USB_TDO,

    //LEDs
    output wire LED_IR, LED_USER,
    output wire [2:0] LED_PWR, LED_EN, LED_TAR, LED_COM,
    input wire LED_FAULT,
    
    //Power
    input wire PWR_12V_EN,

    //Camera/Image Sensor LVDS
    input wire CAM_CLK_P, CAM_CLK_N,
    input wire CAM_SYNC_P, CAM_SYNC_N,
    input wire [3:0] CAM_DOUT_P, CAM_DOUT_N,

    //Camera/Image Sensor IO
    output wire CAM_SPI_CLK, CAM_SPI_MOSI, CAM_SPI_CS, 
    input wire CAM_SPI_MISO,
    output wire [2:0] CAM_TRIG,
    input wire [1:0] CAM_MON,
    output wire CAM_RESET
    );

    wire enabled;
    wire bootDone;

    //ConfigManager
    wire VirtexConfig virtexConfig;
    wire VirtexConfigWriteRequest virtexConfigWriteRequests [1:0];
    ConfigManager ConfigManager(
        .CLK(CLK),
        .SPI_CS(CONF_CS),
        .SPI_WP(CONF_WP),
        .SPI_HOLD(CONF_HOLD),
        .SPI_CLK(CONF_CLK),
        .SPI_MOSI(CONF_MOSI),
        .SPI_MISO(CONF_MISO),
        .virtexConfig(virtexConfig),
        .virtexConfigWriteRequests(virtexConfigWriteRequests),
        .bootDone(bootDone)
    );

    //CameraManager
    wire Blob targetBlob;
    wire ImageFrame imageFrame;
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
        .reset(CAM_RESET),
        .enabled(enabled),
        .virtexConfig(virtexConfig),
        .imageFrame(imageFrame),
        .targetBlob(targetBlob)
    );

    //AppManager
    AppManager AppManager(
        .CLK(CLK),
        .FSDI(USB_FSDI),
        .FSCLK(USB_FSCLK),
        .FSDO(USB_FSDO),
        .FSCTS(USB_FSCTS),
        .USB_ON(USB_ON),
        .USB_PWREN(USB_PWREN),
        .USB_SUS(USB_SUS),
        .virtexConfig(virtexConfig),
        .virtexConfigWriteRequest(virtexConfigWriteRequests[0]),
        .imageFrame(imageFrame)
    );

    //RoboRIOManager
    wire hasCommunication;
    RoboRIOManager RoboRIOManager(
        .CLK(CLK),
        .SPI_CLK(RIO_CLK),
        .SPI_MOSI(RIO_MOSI),
        .SPI_MISO(RIO_MISO),
        .SPI_CS(RIO_CS),
        .virtexConfig(virtexConfig),
        .virtexConfigWriteRequest(virtexConfigWriteRequests[1]),
        .hasCommunication(hasCommunication),
        .enabled(enabled),
        .targetBlob(targetBlob)
    );

    //FlashManager
    FlashManager FlashManager(
        .CLK(CLK),
        .SPI_CLK(FLASH_CLK),
        .SPI_CS(FLASH_CS),
        .SPI_Q(FLASH_SIO),
        .TMS(USB_TMS),
        .TCK(USB_TCK),
        .TDO(USB_TDO),
        .TDI(USB_TDI)
    );

    //LEDManager
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
        .targetBlob(targetBlob),
        .hasCommunication(hasCommunication)
    );
endmodule