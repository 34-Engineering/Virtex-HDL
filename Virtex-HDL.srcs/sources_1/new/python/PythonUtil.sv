`timescale 1ns / 1ps

/** PythonUtil -  */
`ifndef PythonUtil_DONE
`define PythonUtil_DONE

`include "../util/Constants.sv"
`include "../util/Math.sv"

//Kernel
typedef struct packed { //28-bit
    logic [7:0] value; //threshold
    Math::Vector2d10 pos; //(0, 0) to (79, 479)
} Kernel;
typedef struct packed { //52-bit
    logic [7:0] [3:0] value;
    Math::Vector2d10 pos; //(0, 0) to (79, 479)
} KernelMono;
localparam KERNEL_MAX_X = IMAGE_WIDTH / 8 - 1;

//Default SYNC Channel Codes (Frame Sync + Data Classification)
localparam PYTHON_SYNC_FRAME_START = 8'hAA;
localparam PYTHON_SYNC_FRAME_END = 8'hCA;
localparam PYTHON_SYNC_LINE_START = 8'h2A;
localparam PYTHON_SYNC_LINE_END = 8'h4A;
localparam PYTHON_SYNC_BLACK = 8'h05; //black pixels
localparam PYTHON_SYNC_IMAGE = 8'h0D; //valid pixels
localparam PYTHON_SYNC_CRC = 8'h16; //checksum
localparam PYTHON_SYNC_MAIN_WINDOW_ID = 8'h00;
localparam PYTHON_TRAINING_PATTERN = 8'hE9; //training pattern for SYNC + DOUT

//SPI Commands
typedef struct packed { //26-bit
    logic [0:8] address;
    logic readWrite; //1 for write
    logic [0:15] value;
} PythonSPICommand;
localparam PythonSPICommandEndIndex = $bits(PythonSPICommand) - 1;

localparam PythonSPICommand disableSequencer = '{192, 1, 16'h0800};
localparam PythonSPICommand enableSequencer = '{192, 1, 16'h080D}; //master pipelined ZROT mode
localparam PythonSPICommand enableDisableSequencer [2] = '{disableSequencer, enableSequencer};

localparam PythonSPICommand checkPLLLockStatus = '{24, 0, 0};

localparam logic [8:0] setBlackOffsetAddress = 128;
localparam logic [8:0] setAnalogGainAddress = 204;
localparam logic [8:0] setDigitalGainAddress = 205;
localparam logic [8:0] setExposureAddress = 201;
localparam logic [8:0] setMultTimerAddress = 199;
localparam logic [8:0] setFrameLengthAddress = 200;
localparam logic [8:0] setSettingAddresses [6] = '{
    setBlackOffsetAddress,
    setAnalogGainAddress,
    setDigitalGainAddress,
    setExposureAddress,
    setMultTimerAddress,
    setFrameLengthAddress
};

`endif