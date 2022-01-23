`timescale 1ns / 1ps

/* Util -  

    */
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
        logic [2:0] empty; //to make it 64-bit
    } Blob;

    typedef logic [7:0] ImageFrame [79:0] [479:0];

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
        //all must be 16-bit
        logic [15:0] test;
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
    } VirtexConfig;

    parameter VirtexConfig DefaultVirtexConfig = '{
        test: 16'h0f0f,
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
        exposure: 8'h0f
    };

    typedef struct packed {
        logic [4:0] address;
        logic [15:0] data;
        logic valid; 
    } VirtexConfigWriteRequest;

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