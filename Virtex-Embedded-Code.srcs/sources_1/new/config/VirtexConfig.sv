`timescale 1ns / 1ps

/* VirtexConfig -  */
`ifndef VIRTEX_CONFIG_DONE
`define VIRTEX_CONFIG_DONE

`include "../util/Constants.sv"

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
function PythonBlackOffsetConfig makePythonBlackOffsetConfig(logic [15:0] blackOffset);
    return '{0, 8, 0, blackOffset}; //duplicated in PythonUtil
endfunction

typedef struct packed {
    logic [1:0] reserved;
    logic gainLatComp;
    logic [7:0] afeGain0;
    logic [4:0] muxGainsw0;
} PythonAnalogGainConfig;

typedef struct packed { //32 x 16
    //camera params & python config
    /*00*/CameraOrientation cameraOrientation;
    /*01*/LEDSafety ledSafety;
    logic [15:0] threshold;
    logic [15:0] blackOffset;
    PythonAnalogGainConfig analogGain;
    logic [15:0] digitalGain;
    logic [15:0] exposure; // integration_time_ms = exposure * mult_timer (2) * clk_period (0.000013889ms), max 41746 wo/ lowering fps

    //target params
    logic [15:0] targetBlobCountMin; //amount of blobs in target
    logic [15:0] targetBlobCountMax;
    logic [15:0] targetBlobGapMin; //distance between blobs in target
    logic [15:0] targetBlobGapMax;
    logic [15:0] targetBlobAreaDiffMin; //difference between areas of blobs in target
    logic [15:0] targetBlobAreaDiffMax;
    logic [15:0] targetBlobSlopeDiffMin; //difference in slope between each blob next to eachother
    logic [15:0] targetBlobSlopeDiffMax; //TODO how does the work if blobs are not in a clear line?
    logic [15:0] targetAspectRatioMin;
    logic [15:0] targetAspectRatioMax;
    logic [15:0] targetCenterX; //final target selection parameter
    logic [15:0] targetCenterY; //choose target thats closet to this point

    //blob params
    logic [15:0] blobAspectRatioMin; //aspectRatio = boundWidth / boundHeight
    logic [15:0] blobAspectRatioMax;
    logic [15:0] blobSizeMin; //size = boundWidth * boundHeight
    logic [15:0] blobSizeMax;
    logic [15:0] blobFullnessMin; //fullness = blob.area (true area) / boundArea
    logic [15:0] blobFullnessMax;
    logic [15:0] blobSlopeMin; //slope = avg slope between left and right sides
    logic [15:0] blobSlopeMax;
    
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
    blackOffset: 8,
    analogGain: '{0, 0, 15, 1},
    digitalGain: 128,
    exposure: 30000,

    //target params
    targetBlobCountMin: 1,
    targetBlobCountMax: 1,
    targetBlobGapMin: 0,
    targetBlobGapMax: 16'hffff,
    targetBlobAreaDiffMin: 0,
    targetBlobAreaDiffMax: 16'hffff,
    targetBlobSlopeDiffMin: 0,
    targetBlobSlopeDiffMax: 16'hffff,
    targetAspectRatioMin: 0,
    targetAspectRatioMax: 16'hffff,
    targetCenterX: IMAGE_WIDTH / 2,
    targetCenterY: IMAGE_HEIGHT / 2,

    //blob params
    blobAspectRatioMin: 0,
    blobAspectRatioMax: 16'hffff,
    blobSizeMin: 16'd16,
    blobSizeMax: 16'hffff,
    blobFullnessMin: 0,
    blobFullnessMax: 16'hffff,
    blobSlopeMin: 0,
    blobSlopeMax: 16'hffff,
    
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