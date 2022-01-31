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

    //64-bit Blob
    typedef struct packed {
        Vector boundTopLeft, boundBottomRight; //square bounding box
        Vector cornerTopLeft, cornerTopRight, cornerBottomRight, cornerBottomLeft; //corners of quad
        logic valid;
        logic [2:0] reserved; //to make it 64-bit
    } Blob;

    //Config
    typedef enum logic [7:0] {
       ANY=0, HORIZONTAL=1, VERTICAL=2, DIAGONAL=3,
       DIAGONAL_FORWARD=4, DIAGONAL_BACKWARD=5 //TODO new names for diagonals?
    } TargetOrientation;

    typedef struct packed {
        logic [7:0] count;
        TargetOrientation targetOrientation;
    } TargetMode;

    typedef enum logic [15:0] {
       NORMAL=0, COUNTER_CLOCKWISE_90=1, UPSIDE_DOWN=2, CLOCKWISE_90=3
    } Orientation;
    
    typedef struct packed {
        TargetMode targetMode;
        Orientation orientation;
        logic [15:0] boundingWidthMin;
        logic [15:0] boundingWidthMax;
        logic [15:0] boundingHeightMin;
        logic [15:0] boundingHeightMax;
        logic [15:0] fullnessMin;
        logic [15:0] fullnessMax;
        logic [15:0] slopeDiffMin;
        logic [15:0] slopeDiffMax;
        logic [15:0] slopeMin;
        logic [15:0] slopeMax;
        logic [15:0] centerX;
        logic [15:0] centerY;
        logic [15:0] threshold;
        logic [15:0] exposure;
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
        logic [15:0] reserved13;
        logic [15:0] reserved14;
        logic [15:0] reserved15;
        logic [15:0] reserved16;
    } VirtexConfig;

    parameter VirtexConfig DefaultVirtexConfig = '{
        targetMode: '{1, ANY},
        orientation: NORMAL,
        boundingWidthMin: 0,
        boundingWidthMax: 16'hffff,
        boundingHeightMin: 0,
        boundingHeightMax: 16'hffff,
        fullnessMin: 0,
        fullnessMax: 16'hffff,
        slopeDiffMin: 0,
        slopeDiffMax: 16'hffff,
        slopeMin: 0,
        slopeMax: 16'hffff,
        centerX: 16'd320,
        centerY: 16'd240,
        threshold: 8'h0f,
        exposure: 8'h0f,
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
        reserved12: 16'd0,
        reserved13: 16'd0,
        reserved14: 16'd0,
        reserved15: 16'd0,
        reserved16: 16'd0
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

    //Range Functions
    function logic [9:0] min(input logic [9:0] num1, num2);
        return num1 < num2 ? num1 : num2;
    endfunction

    function logic [9:0] max(input logic [9:0] num1, num2);
        return num1 > num2 ? num1 : num2;
    endfunction

    function logic [9:0] clamp(input logic[9:0] num, min, max);
        return num < min ? min : (num > max ? max : num);
    endfunction
endpackage

import Util::*;
`endif