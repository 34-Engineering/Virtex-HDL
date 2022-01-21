`timescale 1ns / 1ps

/* Util -  

    */
package Util;
    //Types
    typedef struct packed {
        logic [9:0] x, y;
    } Vector;

    typedef struct {
        Vector boundTopLeft, boundBottomRight;
        Vector cornerTopLeft, cornerTopRight, cornerBottomRight, cornerBottomLeft;
        logic valid = 0;
    } Blob;

    typedef enum {
       OFF=0, ON_VERTICAL=1, ON_HORIZONTAL=2, ON_DIAGONAL=3
    } DualObjectMode; //TODO support more than 2 targets

    typedef enum {
       NORMAL=0, COUNTER_CLOCKWISE_90=1, UPSIDE_DOWN=2, CLOCKWISE_90=3
    } Orientation;
    
    typedef struct packed {
        logic [15:0] test;
        logic [15:0] dualObjectMode;
        logic [15:0] orientation;
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
        dualObjectMode: 0,
        orientation: 0,
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

    typedef logic [7:0] ImageFrame [79:0] [479:0];

    //Range
    function logic [9:0] min(input logic [9:0] num1, num2);
        return num1 < num2 ? num1 : num2;
    endfunction

    function logic [9:0] max(input logic [9:0] num1, num2);
        return num1 > num2 ? num1 : num2;
    endfunction
endpackage