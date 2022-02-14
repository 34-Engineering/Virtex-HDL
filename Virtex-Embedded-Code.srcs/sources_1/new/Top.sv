`timescale 1ns / 1ps
`include "./blob/BlobUtil.sv"
`include "./config/VirtexConfig.sv"
`include "./python/PythonUtil.sv"
`include "./util/Fault.sv"

/* Top - top (main) module for the FPGA source code

    Only this module and it's submodules will get synthesizes and implemented into the bit file.

    All the inputs either come from TopSim.sv or the Virtex.xdc contraints file.
    
    */
module Top(
    input CLK,

    //USB
    input wire USB_FSDO, USB_FSCTS,
    output wire USB_FSDI, USB_FSCLK,
    input wire USB_ON, USB_PWREN, USB_SUS,

    //RoboRIO
    input wire RIO_CLK, RIO_MOSI, RIO_CS,
    output wire RIO_MISO,

    //Config EEPROM
    output wire CONF_CS, CONF_WP, CONF_HOLD, CONF_CLK, CONF_MOSI,
    input wire CONF_MISO,

    //Flash Memory
    output wire FLASH_CS, FLASH_WP, FLASH_HOLD, FLASH_CLK, FLASH_MOSI,
    input wire FLASH_MISO,

    //LEDs
    output wire LED_IR, LED_USER,
    output wire [2:0] LED_PWR, LED_EN, LED_TAR, LED_COM,
    input wire LED_FAULT,
    
    //Power
    input wire PWR_12V_EN,

    //Python/Image Sensor LVDS
    input wire PYTHON_CLK_P, PYTHON_CLK_N,
    input wire PYTHON_SYNC_P, PYTHON_SYNC_N,
    input wire [3:0] PYTHON_DOUT_P, PYTHON_DOUT_N,

    //Python/Image Sensor IO
    output wire PYTHON_SPI_CLK, PYTHON_SPI_MOSI, PYTHON_SPI_CS, 
    input wire PYTHON_SPI_MISO,
    output wire [2:0] PYTHON_TRIG,
    input wire [1:0] PYTHON_MON,
    output wire PYTHON_RESET
    );

    wire enabled;
    wire bootDone;
    wire Fault faults [1:0];

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

    //PythonManager
    wire Blob targetBlob;
    wire Kernel frameBufferWriteRequest;
    PythonManager PythonManager(
        .CLK(CLK),
        .LVDS_CLK_P(PYTHON_CLK_P),
        .LVDS_CLK_N(PYTHON_CLK_N),
        .LVDS_SYNC_P(PYTHON_SYNC_P),
        .LVDS_SYNC_N(PYTHON_SYNC_N),
        .LVDS_DOUT_P(PYTHON_DOUT_P),
        .LVDS_DOUT_N(PYTHON_DOUT_N),
        .SPI_CS(PYTHON_SPI_CS),
        .SPI_MOSI(PYTHON_SPI_MOSI),
        .SPI_MISO(PYTHON_SPI_MISO),
        .SPI_CLK(PYTHON_SPI_CLK),
        .TRIGGER(PYTHON_TRIG),
        .MONITOR(PYTHON_MON),
        .RESET_SENSOR(PYTHON_RESET),
        .enabled(enabled),
        .virtexConfig(virtexConfig),
        .frameBufferWriteRequest(frameBufferWriteRequest),
        .targetBlob(targetBlob),
        .fault(faults[0])
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
        .frameBufferWriteRequest(frameBufferWriteRequest)
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
        .SPI_CS(FLASH_CS),
        .SPI_WP(FLASH_WP),
        .SPI_HOLD(FLASH_HOLD),
        .SPI_CLK(FLASH_CLK),
        .SPI_MOSI(FLASH_MOSI),
        .SPI_MISO(FLASH_MISO)
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
        .hasCommunication(hasCommunication),
        .fault(faults[1])
    );
endmodule