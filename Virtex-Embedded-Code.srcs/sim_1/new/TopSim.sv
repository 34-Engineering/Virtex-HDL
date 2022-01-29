`timescale 1ns / 1ps
`include "../../sources_1/new/Util.sv"

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

    //Python300Sim for CameraManager
    wire Blob targetBlob;
    wire ImageFrame imageFrame;
    wire CAM_CLK_P, CAM_CLK_N, CAM_SYNC_P, CAM_SYNC_N, CAM_DOUT_P, CAM_DOUT_N;
    wire CAM_SPI_CS, CAM_SPI_MOSI, CAM_SPI_MISO, CAM_SPI_CLK;
    wire CAM_TRIG, CAM_MON, CAM_RESET;
    Python300Sim(
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
        .reset(CAM_RESET)
    );

    //FT2232HSim for AppManager
    wire USB_FSDI, USB_FSCLK, USB_FSDO, USB_FSCTS;
    wire USB_ON, USB_PWREN, USB_SUS;
    wire USB_TMS, USB_TCK, USB_TDO, USB_TDI;
    FT2232HSim(
        .FSDI(USB_FSDI),
        .FSCLK(USB_FSCLK),
        .FSDO(USB_FSDO),
        .FSCTS(USB_FSCTS),
        .USB_ON(USB_ON),
        .USB_PWREN(USB_PWREN),
        .USB_SUS(USB_SUS)
    );

    //RoboRIOSim for RoboRIOManager
    wire RIO_CLK, RIO_MOSI, RIO_MISO, RIO_CS;
    RoboRIOSim(
        .SPI_CLK(RIO_CLK),
        .SPI_MOSI(RIO_MOSI),
        .SPI_MISO(RIO_MISO),
        .SPI_CS(RIO_CS)
    );

    //MX25V1635FM2ISim for FlashManager
    wire FLASH_CLK, FLASH_CS;
    wire [3:0] FLASH_SIO;
    MX25V1635FM2ISim(
        .SPI_CLK(FLASH_CLK),
        .SPI_CS(FLASH_CS),
        .SPI_Q(FLASH_SIO)
    );

    //LEDSim for LEDManager
    wire LED_IR, LED_USER, LED_FAULT;
    wire [2:0] LED_PWR, LED_EN, LED_TAR, LED_COM;
    LEDSim(
        .LED_IR(LED_IR),
        .LED_PWR(LED_PWR),
        .LED_EN(LED_EN),
        .LED_TAR(LED_TAR),
        .LED_COM(LED_COM),
        .LED_USER(LED_USER),
        .LED_FAULT(LED_FAULT)
    );

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

        //JTAG
        .USB_TMS(USB_TMS),
        .USB_TCK(USB_TCK),
        .USB_TDO(USB_TDO),
        .USB_TDI(USB_TDI),

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

        //Camera/Image Sensor LVDS
        .CAM_CLK_P(CAM_CLK_P),
        .CAM_CLK_N(CAM_CLK_N),
        .CAM_SYNC_P(CAM_SYNC_P),
        .CAM_SYNC_N(CAM_SYNC_N),
        .CAM_DOUT_P(CAM_DOUT_P),
        .CAM_DOUT_N(CAM_DOUT_N),

        //Camera/Image Sensor IO
        .CAM_SPI_CS(CAM_SPI_CS),
        .CAM_SPI_MOSI(CAM_SPI_MOSI),
        .CAM_SPI_MISO(CAM_SPI_MISO),
        .CAM_SPI_CLK(CAM_SPI_CLK),
        .CAM_TRIG(CAM_TRIG),
        .CAM_MON(CAM_MON),
        .CAM_RESET(CAM_RESET)
    );
    
endmodule