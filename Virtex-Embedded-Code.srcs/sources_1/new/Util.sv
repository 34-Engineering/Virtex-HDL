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
    typedef enum logic [7:0] {
       HORIZONTAL=1,
       VERTICAL=2 //TODO diagonal support?
    } TargetOrientation;

    typedef struct packed {
        TargetOrientation targetOrientation;
        logic [7:0] count;
    } TargetMode;

    typedef enum logic [15:0] {
       NORMAL=0, COUNTER_CLOCKWISE_90=1, UPSIDE_DOWN=2, CLOCKWISE_90=3
    } CameraOrientation;

    typedef struct packed { //32 x 16
        //camera config
        CameraOrientation cameraOrientation;
        logic [15:0] threshold;
        logic [15:0] exposure;

        //target params
        TargetMode targetMode;
        logic [15:0] gapMin;
        logic [15:0] gapMax;
        logic [15:0] slopeDiffMin; //difference between each blob next to eachother
        logic [15:0] slopeDiffMax;
        logic [15:0] slopeMin;
        logic [15:0] slopeMax;
        logic [15:0] centerX;
        logic [15:0] centerY;

        //blob params
        logic [15:0] boundingWidthMin;
        logic [15:0] boundingWidthMax;
        logic [15:0] boundingHeightMin;
        logic [15:0] boundingHeightMax;
        logic [15:0] boundingAreaMin;
        logic [15:0] boundingAreaMax;
        logic [15:0] fullnessMin;
        logic [15:0] fullnessMax;
        
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
        logic [15:0] reserved12;
    } VirtexConfig;

    localparam VirtexConfig DefaultVirtexConfig = '{
        //camera config
        cameraOrientation: NORMAL,
        threshold: 8'h0f,
        exposure: 8'h0f,

        //target params
        targetMode: '{HORIZONTAL, 1},
        gapMin: 0,
        gapMax: 16'hffff,
        slopeDiffMin: 0,
        slopeDiffMax: 16'hffff,
        slopeMin: 0,
        slopeMax: 16'hffff,
        centerX: 16'd320,
        centerY: 16'd240,

        //blob params
        boundingWidthMin: 0,
        boundingWidthMax: 16'hffff,
        boundingHeightMin: 0,
        boundingHeightMax: 16'hffff,
        boundingAreaMin: 100,
        boundingAreaMax: 16'hffff,
        fullnessMin: 0,
        fullnessMax: 16'hffff,
        
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
        reserved11: 16'd0,
        reserved12: 16'd0
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