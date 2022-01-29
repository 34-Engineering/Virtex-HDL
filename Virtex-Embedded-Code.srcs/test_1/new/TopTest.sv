`timescale 1ns / 1ps
`include "../../sources_1/new/Util.sv"
`include "../../sources_1/new/CameraManagerParams.sv"

/* TopTest - top test file for executing unit tests on every module

    Every source & sim module should have a test module that tests the functionality
    of the module separate from all other modules. This file runs all of those tests.

    */
module TopTest;

    FT2232HSimTest();
    JTAGTest();
    JTAGSimTest();
    FastSerialTest();
    FastSerialSimTest();
    ISERDESTest();
    OSERDESSimTest();
    AppManagerTest();
    AppSimTest();
    AT25010BMAHLESimTest();
    BlobProcessorTest();
    CameraManagerTest();
    CameraSPIManagerTest();
    ConfigManagerTest();
    FlashManagerTest();
    LEDManagerTest();
    MX25V1635FM2ISimTest();
    Python300SimTest();
    Python300SPISimTest();
    RoboRIOManagerTest();
    RoboRIOSimTest();
    UtilTest();

endmodule