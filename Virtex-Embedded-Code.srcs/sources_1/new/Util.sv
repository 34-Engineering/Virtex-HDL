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

    //?-bit Blob
    typedef struct packed {
        Vector boundTopLeft, boundBottomRight; //square bounding box
        // Vector cornerTopLeft, cornerTopRight, cornerBottomRight, cornerBottomLeft; //corners of quad
        logic valid;
        // logic [2:0] reserved; //to make it 64-bit
    } Blob;

    //Virtex Config
    typedef enum logic [15:0] {
       NORMAL=0, COUNTER_CLOCKWISE_90=1, UPSIDE_DOWN=2, CLOCKWISE_90=3
    } CameraOrientation;

    typedef struct packed { //32 x 16
        //camera config
        /*00*/CameraOrientation cameraOrientation;
        /*01*/logic [15:0] threshold;
        logic [15:0] blackOffset; //128 [7:0]; def h4008
        logic [15:0] gain;
        /*
        '{204, 1, 16'h01e1},	// ZROT - Analog_gain_0 ([12:5]: AFE_gain, [4:0]: MUX_gain},
        '{235, 1, 16'h01e1},	// ZROT - Analog_gain_1 ([12:5]: AFE_gain, [4:0]: MUX_gain},
        '{205, 1, 16'h0080},	// Digital_gain_0
        '{236, 1, 16'h0080},	// Digital_gain_1
        */
        logic [15:0] integrationTime;
        // 

        //target params
        logic [15:0] targetBlobCountMin; //amount of blobs in target
        logic [15:0] targetBlobCountMax;
        logic [15:0] targetBlobGapMin; //distance between blobs
        logic [15:0] targetBlobGapMax;
        logic [15:0] targetBlobSlopeDiffMin; //difference in slope between each blob next to eachother //TODO how does the work if blobs are not in a clear line?
        logic [15:0] targetBlobSlopeDiffMax;
        logic [15:0] targetCenterX; //choose blob thats closet to this point
        logic [15:0] targetCenterY;

        //blob params
        logic [15:0] blobBoundingAspectRatioMin;
        logic [15:0] blobBoundingAspectRatioMax;
        logic [15:0] blobBoundingHeightMin;
        logic [15:0] blobBoundingHeightMax;
        logic [15:0] blobBoundingAreaMin;
        logic [15:0] blobBoundingAreaMax;
        logic [15:0] blobSlopeMin; //slope of each blob
        logic [15:0] blobSlopeMax;
        logic [15:0] blobFullnessMin;
        logic [15:0] blobFullnessMax;
        
        //reserved for future use
        logic [15:0] reserved1;
        logic [15:0] reserved2;
        logic [15:0] reserved3;
        logic [15:0] reserved4;
        logic [15:0] reserved5;
        logic [15:0] reserved6;
        logic [15:0] reserved7;
        logic [15:0] reserved8;
        logic [15:0] reserved9;
        logic [15:0] reserved10;
        logic [15:0] reserved11;
    } VirtexConfig;

    localparam VirtexConfig DefaultVirtexConfig = '{
        //camera config
        cameraOrientation: NORMAL,
        threshold: 8'h0f,
        exposure: 8'h0f,

        //target params
        targetBlobCountMin: 1,
        targetBlobCountMax: 1,
        targetBlobGapMin: 0,
        targetBlobGapMax: 16'hffff,
        targetBlobSlopeDiffMin: 0,
        targetBlobSlopeDiffMax: 16'hffff,
        targetBlobSlopeMin: 0,
        targetBlobSlopeMax: 16'hffff,
        targetCenterX: 16'd320,
        targetCenterY: 16'd240,

        //blob params
        blobBoundingWidthMin: 0,
        blobBoundingWidthMax: 16'hffff,
        blobBoundingHeightMin: 0,
        blobBoundingHeightMax: 16'hffff,
        blobBoundingAreaMin: 100,
        blobBoundingAreaMax: 16'hffff,
        blobFullnessMin: 0,
        blobFullnessMax: 16'hffff,
        
        //reserved for future use
        reserved1: 16'd0,
        reserved2: 16'd0,
        reserved3: 16'd0,
        reserved4: 16'd0,
        reserved5: 16'd0,
        reserved6: 16'd0,
        reserved7: 16'd0,
        reserved8: 16'd0,
        reserved9: 16'd0,
        reserved10: 16'd0,
        reserved11: 16'd0
    };

    typedef struct packed {
        logic [4:0] address;
        logic [15:0] data;
        logic valid; //active high
    } VirtexConfigWriteRequest;

    //Frame Buffer
    typedef logic [7:0] FrameBuffer [79:0][479:0];

    typedef struct packed {
        Vector kernelPos;
        logic [7:0] kernel;
        logic valid; //active high
    } FrameBufferWriteRequest;

    //Fault
    typedef enum logic [7:0] {
        NO_FAULT = 0,
        PYTHON_300_PLL_FAULT = 1,
        IR_LED_FAULT = 2
    } Fault;
endpackage

import Util::*;
`endif