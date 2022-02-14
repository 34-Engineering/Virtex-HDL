`timescale 1ns / 1ps
`include "../../sources_1/new/blob/BlobUtil.sv"

/* TopSim - top simulation file for executing a global test of the entire FPGA

    Includes the Top module to simulate the FPGA & all sim modules to simulate the hardware the FPGA interacts.

    */
module TopSim;

    //100MHz clock
    reg CLK = 0;
    always #5 CLK <= !CLK;

    reg PWR_12V_EN = 0;

    //AT25010BMAHLESim for ConfigManager
    wire CONF_CS, CONF_WP, CONF_HOLD, CONF_CLK, CONF_MOSI, CONF_MISO;
    AT25010BMAHLESim(
        .SPI_CS(CONF_CS),
        .SPI_WP(CONF_WP),
        .SPI_HOLD(CONF_HOLD),
        .SPI_CLK(CONF_CLK),
        .SPI_MOSI(CONF_MOSI),
        .SPI_MISO(CONF_MISO)
    );

    //LensSim for PythonManager
    wire Blob targetBlob;
    wire PYTHON_CLK_P, PYTHON_CLK_N, PYTHON_SYNC_P, PYTHON_SYNC_N, PYTHON_DOUT_P, PYTHON_DOUT_N;
    wire PYTHON_SPI_CS, PYTHON_SPI_MOSI, PYTHON_SPI_MISO, PYTHON_SPI_CLK;
    wire PYTHON_TRIG, PYTHON_MON, PYTHON_RESET;
    LensSim(
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
        .SENSOR_RESET(PYTHON_RESET)
    );

    //FT2232HSim for AppManager
    wire USB_FSDI, USB_FSCLK, USB_FSDO, USB_FSCTS;
    wire USB_ON, USB_PWREN, USB_SUS;
    FT2232HSim(
        .FSDI(USB_FSDI),
        .FSCLK(USB_FSCLK),
        .FSDO(USB_FSDO),
        .FSCTS(USB_FSCTS),
        .USB_ON(USB_ON),
        .USB_PWREN(USB_PWREN),
        .USB_SUS(USB_SUS)
    );

    //RobotCodeSim for RoboRIOManager
    wire RIO_CLK, RIO_MOSI, RIO_MISO, RIO_CS;
    RobotCodeSim(
        .SPI_CLK(RIO_CLK),
        .SPI_MOSI(RIO_MOSI),
        .SPI_MISO(RIO_MISO),
        .SPI_CS(RIO_CS)
    );

    //No Sim for FlashManager
    wire FLASH_CLK, FLASH_CS;
    wire [3:0] FLASH_SIO;

    //No Sim for LEDManager
    reg LED_FAULT = 1;
    wire LED_IR, LED_USER;
    wire [2:0] LED_PWR, LED_EN, LED_TAR, LED_COM;

    //Top
    Top(
        .CLK(CLK),

        //USB
        .USB_FSDI(USB_FSDI),
        .USB_FSCLK(USB_FSCLK),
        .USB_FSDO(USB_FSDO),
        .USB_FSCTS(USB_FSCTS),
        .USB_ON(USB_ON),
        .USB_PWREN(USB_PWREN),
        .USB_SUS(USB_SUS),

        //RoboRIO
        .RIO_CLK(RIO_CLK),
        .RIO_MOSI(RIO_MOSI),
        .RIO_MISO(RIO_MISO),
        .RIO_CS(RIO_CS),

        //Config EEPROM
        .CONF_CS(CONF_CS),
        .CONF_WP(CONF_WP),
        .CONF_HOLD(CONF_HOLD),
        .CONF_CLK(CONF_CLK),
        .CONF_MOSI(CONF_MOSI),
        .CONF_MISO(CONF_MISO),

        //Flash Memory
        .FLASH_CLK(FLASH_CLK),
        .FLASH_CS(FLASH_CS),
        .FLASH_SIO(FLASH_SIO),

        //LEDs
        .LED_IR(LED_IR),
        .LED_PWR(LED_PWR),
        .LED_EN(LED_EN),
        .LED_TAR(LED_TAR),
        .LED_COM(LED_COM),
        .LED_USER(LED_USER),
        .LED_FAULT(LED_FAULT),
        
        //Power
        .PWR_12V_EN(PWR_12V_EN),

        //Python/Image Sensor LVDS
        .PYTHON_CLK_P(PYTHON_CLK_P),
        .PYTHON_CLK_N(PYTHON_CLK_N),
        .PYTHON_SYNC_P(PYTHON_SYNC_P),
        .PYTHON_SYNC_N(PYTHON_SYNC_N),
        .PYTHON_DOUT_P(PYTHON_DOUT_P),
        .PYTHON_DOUT_N(PYTHON_DOUT_N),

        //Python/Image Sensor IO
        .PYTHON_SPI_CS(PYTHON_SPI_CS),
        .PYTHON_SPI_MOSI(PYTHON_SPI_MOSI),
        .PYTHON_SPI_MISO(PYTHON_SPI_MISO),
        .PYTHON_SPI_CLK(PYTHON_SPI_CLK),
        .PYTHON_TRIG(PYTHON_TRIG),
        .PYTHON_MON(PYTHON_MON),
        .PYTHON_RESET(PYTHON_RESET)
    );
    
endmodule