`timescale 1ns / 1ps

/* Util -  

    */
`ifndef UTIL_DONE
`define UTIL_DONE
package Util;
    //10-bit Vector
    typedef struct packed {
        logic [9:0] x, y;
    } Vector;

    //96-bit Blob
    typedef struct packed {
        Vector boundTopLeft, boundBottomRight;
        Vector quadTopLeft, quadTopRight, quadBottomRight, quadBottomLeft;
        logic [18:0] area;
        logic [9:0] pointer;
        logic valid;
        logic [5:0] reserved;
    } Blob;

    //Virtex Config
    typedef enum logic [15:0] {
       NORMAL=0, COUNTER_CLOCKWISE_90=1, UPSIDE_DOWN=2, CLOCKWISE_90=3
    } CameraOrientation;

    typedef struct packed {
        logic crcSeed;
        logic [3:0] reserved;
        logic [2:0] blackSamples;
        logic [7:0] blackOffset;
    } PythonBlackOffsetConfig;
    function PythonBlackOffsetConfig makePythonBlackOffsetConfig(logic [15:0] blackOffset);
        return '{0, 8, 0, blackOffset};
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
        /*01*/logic [15:0] threshold;
        /*02*/logic [15:0] blackOffset;
        /*03*/PythonAnalogGainConfig analogGain;
        /*04*/logic [15:0] digitalGain;
        /*05*/logic [15:0] exposure; // integration_time_ms = exposure * mult_timer (2) * clk_period (0.000013889ms), max 41746 wo/ lowering fps

        //target params
        /*06*/logic [15:0] targetBlobCountMin; //amount of blobs in target
        /*07*/logic [15:0] targetBlobCountMax;
        /*08*/logic [15:0] targetBlobGapMin; //distance between blobs
        /*09*/logic [15:0] targetBlobGapMax;
        /*10*/logic [15:0] targetBlobSlopeDiffMin; //difference in slope between each blob next to eachother //TODO how does the work if blobs are not in a clear line?
        /*11*/logic [15:0] targetBlobSlopeDiffMax;
        /*12*/logic [15:0] targetCenterX; //choose blob thats closet to this point
        /*13*/logic [15:0] targetCenterY;

        //blob params
        /*14*/logic [15:0] blobBoundAspectRatioMin; //boundWidth / boundHeight
        /*15*/logic [15:0] blobBoundAspectRatioMax;
        /*16*/logic [15:0] blobBoundAreaMin; //boundWidth * boundHeight
        /*17*/logic [15:0] blobBoundAreaMax;
        /*18*/logic [15:0] blobBoundFullnessMin; //blob.area / (boundWidth * boundHeight)
        /*19*/logic [15:0] blobBoundFullnessMax;
        /*20*/logic [15:0] blobQuadSlopeMin; //avg slope between left and right sides
        /*21*/logic [15:0] blobQuadSlopeMax;
        
        //reserved for future use
        /*22*/logic [15:0] reserved22;
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
        threshold: 128,
        blackOffset: DefaultPythonBlackOffsetConfig.blackOffset,
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
        targetCenterX: 16'd320,
        targetCenterY: 16'd240,

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
        reserved22: 16'd0,
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

    //Frame Buffer
    typedef logic [639:0] FrameBuffer [479:0];

    typedef struct packed {
        Vector kernelPos;
        logic [7:0] kernel;
        logic valid; //active high
    } FrameBufferWriteRequest;

    //Fault
    typedef enum logic [7:0] {
        NO_FAULT = 0,
        PYTHON_300_PLL_FAULT = 1, //python 300 PLL could not stabalize
        IR_LED_FAULT = 2, //from MAX chip
        OUT_OF_BLOB_MEM_FAULT = 3, //tried to create more blobs than available in mem => image is too noisy
        BLOB_POINTER_DEPTH_FAULT = 4 //tried recursively following blob pointer, but it was too deep
    } Fault;
endpackage

import Util::*;
`endif