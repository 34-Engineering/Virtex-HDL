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

typedef struct packed { //64 x 16
    //camera params & python config
    /*00*/CameraOrientation cameraOrientation;
    /*01*/LEDSafety ledSafety;
    /*02*/logic [15:0] threshold;
    /*03*/PythonBlackOffsetConfig blackOffset;
    /*04*/PythonAnalogGainConfig analogGain;
    /*05*/logic [15:0] digitalGain;
    /*06*/logic [15:0] exposure;
    /*07*/logic [15:0] multTimer;
    /*08*/logic [15:0] frameLength;

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
    logic [15:0] reserved29;
    logic [15:0] reserved30;
    logic [15:0] reserved31;
    logic [15:0] reserved32;
    logic [15:0] reserved33;
    logic [15:0] reserved34;
    logic [15:0] reserved35;
    logic [15:0] reserved36;
    logic [15:0] reserved37;
    logic [15:0] reserved38;
    logic [15:0] reserved39;
    logic [15:0] reserved40;
    logic [15:0] reserved41;
    logic [15:0] reserved42;
    logic [15:0] reserved43;
    logic [15:0] reserved44;
    logic [15:0] reserved45;
    logic [15:0] reserved46;
    logic [15:0] reserved47;
    logic [15:0] reserved48;
    logic [15:0] reserved49;
    logic [15:0] reserved50;
    logic [15:0] reserved51;
    logic [15:0] reserved52;
    logic [15:0] reserved53;
    logic [15:0] reserved54;
    logic [15:0] reserved55;
    logic [15:0] reserved56;
    logic [15:0] reserved57;
    logic [15:0] reserved58;
    logic [15:0] reserved59;
    logic [15:0] reserved60;
    logic [15:0] reserved61;
    logic [15:0] reserved62;
    logic [15:0] memValid; //63
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
    multTimer: 20,
    frameLength: 41500,

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
    reserved29: 16'h0,
    reserved30: 16'h0,
    reserved31: 16'h0,
    reserved32: 16'h0,
    reserved33: 16'h0,
    reserved34: 16'h0,
    reserved35: 16'h0,
    reserved36: 16'h0,
    reserved37: 16'h0,
    reserved38: 16'h0,
    reserved39: 16'h0,
    reserved40: 16'h0,
    reserved41: 16'h0,
    reserved42: 16'h0,
    reserved43: 16'h0,
    reserved44: 16'h0,
    reserved45: 16'h0,
    reserved46: 16'h0,
    reserved47: 16'h0,
    reserved48: 16'h0,
    reserved49: 16'h0,
    reserved50: 16'h0,
    reserved51: 16'h0,
    reserved52: 16'h0,
    reserved53: 16'h0,
    reserved54: 16'h0,
    reserved55: 16'h0,
    reserved56: 16'h0,
    reserved57: 16'h0,
    reserved58: 16'h0,
    reserved59: 16'h0,
    reserved60: 16'h0,
    reserved61: 16'h0,
    reserved62: 16'h0,
    memValid: 16'h0034
};

function logic [9:0] getConfigAddrIndex(logic [5:0] addr);
    return 1023 - (addr << 4);
endfunction

typedef struct packed { //23-bit
    logic [5:0] addr;
    logic [15:0] data;
    logic valid; //active high
} VirtexConfigWriteRequest;

`endif