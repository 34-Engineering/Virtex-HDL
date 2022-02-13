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
    /*02*/logic [15:0] threshold;
    /*03*/logic [15:0] blackOffset;
    /*04*/PythonAnalogGainConfig analogGain;
    /*05*/logic [15:0] digitalGain;
    /*06*/logic [15:0] exposure; // integration_time_ms = exposure * mult_timer (2) * clk_period (0.000013889ms), max 41746 wo/ lowering fps

    //target params
    /*07*/logic [15:0] targetBlobCountMin; //amount of blobs in target
    /*08*/logic [15:0] targetBlobCountMax;
    /*09*/logic [15:0] targetBlobGapMin; //distance between blobs
    /*10*/logic [15:0] targetBlobGapMax;
    /*11*/logic [15:0] targetBlobSlopeDiffMin; //difference in slope between each blob next to eachother //TODO how does the work if blobs are not in a clear line?
    /*12*/logic [15:0] targetBlobSlopeDiffMax;
    /*13*/logic [15:0] targetCenterX; //choose blob thats closet to this point
    /*14*/logic [15:0] targetCenterY;

    //blob params
    /*15*/logic [15:0] blobBoundAspectRatioMin; //boundWidth / boundHeight
    /*16*/logic [15:0] blobBoundAspectRatioMax;
    /*17*/logic [15:0] blobBoundAreaMin; //boundWidth * boundHeight
    /*18*/logic [15:0] blobBoundAreaMax;
    /*19*/logic [15:0] blobBoundFullnessMin; //blob.area / (boundWidth * boundHeight)
    /*20*/logic [15:0] blobBoundFullnessMax;
    /*21*/logic [15:0] blobQuadSlopeMin; //avg slope between left and right sides
    /*22*/logic [15:0] blobQuadSlopeMax;
    
    //reserved for future use
    /*23*/logic [15:0] reserved23;
    /*24*/logic [15:0] reserved24;
    /*25*/logic [15:0] reserved25;
    /*26*/logic [15:0] reserved26;
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
    exposure: 41746,

    //target params
    targetBlobCountMin: 1,
    targetBlobCountMax: 1,
    targetBlobGapMin: 0,
    targetBlobGapMax: 16'hffff,
    targetBlobSlopeDiffMin: 0,
    targetBlobSlopeDiffMax: 16'hffff,
    targetCenterX: IMAGE_WIDTH / 2,
    targetCenterY: IMAGE_HEIGHT / 2,

    //blob params
    blobBoundAspectRatioMin: 0,
    blobBoundAspectRatioMax: 16'hffff,
    blobBoundAreaMin: 0,
    blobBoundAreaMax: 16'hffff,
    blobBoundFullnessMin: 0,
    blobBoundFullnessMax: 16'hffff,
    blobQuadSlopeMin: 0,
    blobQuadSlopeMax: 16'hffff,
    
    //reserved for future use
    reserved23: 16'd0,
    reserved24: 16'd0,
    reserved25: 16'd0,
    reserved26: 16'd0,
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