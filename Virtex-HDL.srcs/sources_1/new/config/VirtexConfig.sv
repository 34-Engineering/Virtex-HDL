`timescale 1ns / 1ps

/* VirtexConfig -  */
`ifndef VIRTEX_CONFIG_DONE
`define VIRTEX_CONFIG_DONE

`include "../util/Constants.sv"
`include "../blob/BlobUtil.sv"

typedef enum logic [15:0] {
    NORMAL=0, COUNTER_CLOCKWISE_90=1, UPSIDE_DOWN=2, CLOCKWISE_90=3
} CameraOrientation;

typedef struct packed {
    logic enabled;
    logic [14:0] timeoutMs;
} LEDSafety;

typedef struct packed {
    logic crcSeed;
    logic [3:0] reserved;
    logic [2:0] blackSamples;
    logic [7:0] blackOffset;
} PythonBlackOffsetConfig;

typedef struct packed {
    logic [1:0] reserved;
    logic gainLatComp;
    logic [7:0] afeGain;
    logic [4:0] muxGainsw;
} PythonAnalogGainConfig;

typedef struct packed { //32 x 16
    //camera params & python config
    /*00*/CameraOrientation cameraOrientation;
    /*01*/LEDSafety ledSafety;
    logic [15:0] threshold;
    PythonBlackOffsetConfig blackOffset;
    PythonAnalogGainConfig analogGain;
    logic [15:0] digitalGain;
    logic [15:0] exposure; // integration_time_ms = exposure * mult_timer (2) * clk_period (0.000013889ms), max 41746 wo/ lowering fps

    //target params
    TargetMode targetMode;
    logic [15:0] targetBlobXGapMin; //distance between blobs in target
    logic [15:0] targetBlobXGapMax; //16-bit integer
    logic [15:0] targetBlobYGapMin; //distance between blobs in target
    logic [15:0] targetBlobYGapMax; //16-bit integer
    logic [15:0] targetAspectRatioMin; //aspectRatio = boundWidth / boundHeight
    logic [15:0] targetAspectRatioMax; //Q9.7 floating point
    logic [15:0] targetBoundAreaMin; //boundArea = boundWidth * boundHeight >> 1
    logic [15:0] targetBoundAreaMax; //16-bit integer
    logic [15:0] targetBlobAreaDiffMin; //difference between areas of blobs in target
    logic [15:0] targetBlobAreaDiffMax; //16-bit integer
    logic [15:0] targetCenterX; //final target selection parameter //TODO better name
    logic [15:0] targetCenterY; //choose target thats closet to this point

    //blob params
    logic [15:0] blobAspectRatioMin; //aspectRatio = boundWidth / boundHeight
    logic [15:0] blobAspectRatioMax; //Q9.7 floating point
    logic [15:0] blobBoundAreaMin; //boundArea = boundWidth * boundHeight >> 1
    logic [15:0] blobBoundAreaMax; //16-bit integer
    logic [15:0] blobFullnessMin; //fullness = blob.area (true area) / boundArea
    logic [15:0] blobFullnessMax; //Q1.15 floating point
    BlobAnglesEnabled blobAnglesEnabled;
    
    //reserved for future use
    /*27*/logic [15:0] reserved27;
    /*28*/logic [15:0] reserved28;
    /*29*/logic [15:0] reserved29;
    /*30*/logic [15:0] reserved30;
    /*31*/logic [15:0] reserved31;
} VirtexConfig;
localparam VirtexConfig DefaultVirtexConfig = '{
    //camera params & python config
    cameraOrientation: NORMAL,
    ledSafety: '{1, 1000},
    threshold: 128,
    blackOffset: '{0, 6, 6, 8},
    analogGain: '{0, 0, 15, 8},
    digitalGain: 16'h0080,
    exposure: 4000,

    //target params
    targetMode: GROUP,
    targetBlobXGapMin: 0,
    targetBlobXGapMax: 16'hFFFF,//30,
    targetBlobYGapMin: 0,
    targetBlobYGapMax: 16'hFFFF,//30,
    targetAspectRatioMin: 0,//2,
    targetAspectRatioMax: 16'hFFFF,//4,
    targetBoundAreaMin: 0,
    targetBoundAreaMax: 16'hFFFF,//0xffff,
    targetBlobAreaDiffMin: 0,
    targetBlobAreaDiffMax: 100,//100,
    targetCenterX: IMAGE_WIDTH / 2,
    targetCenterY: IMAGE_HEIGHT / 2,

    //blob params
    blobAspectRatioMin: 0,
    blobAspectRatioMax: 16'hFFFF,
    blobBoundAreaMin: 50,
    blobBoundAreaMax: 16'hFFFF,
    blobFullnessMin: 0,
    blobFullnessMax: 16'hFFFF,
    blobAnglesEnabled: '{ horizontal: 1, vertical: 1, forward: 1, backward: 1, reserved: 0 },
    
    //reserved for future use
    reserved27: 16'd0,
    reserved28: 16'd0,
    reserved29: 16'd0,
    reserved30: 16'd0,
    reserved31: 16'd0
};
typedef struct packed {
    logic [4:0] address;
    logic [15:0] data;
    logic valid; //active high
} VirtexConfigWriteRequest;

`endif