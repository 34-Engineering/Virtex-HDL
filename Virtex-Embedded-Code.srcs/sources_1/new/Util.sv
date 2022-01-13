`timescale 1ns / 1ps

/* Util -  

    */
package Util;
    //Types
    typedef struct {
        bit [9:0] x, y;
    } Vector;

    typedef struct {
        Vector boundingTopLeft, boundingBottomRight;
        Vector cornerTopLeft, cornerTopRight, cornerBottomRight, cornerBottomLeft;
        bit valid = 0;
    } Blob;

    typedef enum {
       OFF=0, ON_VERTICAL=1, ON_HORIZONTAL=2, ON_DIAGONAL=3
    } DualObjectMode;

    typedef enum {
       NORMAL=0, COUNTER_CLOCKWISE_90=1, UPSIDE_DOWN=2, CLOCKWISE_90=3
    } Orientation;
    
    typedef struct packed {
        reg [1:0] dualObjectMode;
        reg [1:0] orientation;
        reg [15:0] boundingWidthMin;
        reg [15:0] boundingWidthMax;
        reg [15:0] boundingHeightMin;
        reg [15:0] boundingHeightMax;
        reg [15:0] fullnessMin;
        reg [15:0] fullnessMax;
        reg [15:0] slopeDiffMin;
        reg [15:0] slopeDiffMax;
        reg [15:0] slopeMin;
        reg [15:0] slopeMax;
        reg [15:0] centerX;
        reg [15:0] centerY;
        reg [9:0] threshold;
        reg [7:0] exposure;
    } VirtexConfig;

    typedef bit [639:0] [479:0] OutputFrame;

    //Range
    function bit [9:0] min(input bit [9:0] num1, num2);
        return num1 < num2 ? num1 : num2;
    endfunction

    function bit [9:0] max(input bit [9:0] num1, num2);
        return num1 > num2 ? num1 : num2;
    endfunction

    //Other
    parameter VirtexConfig DefaultVirtexConfig = '{
        dualObjectMode: DualObjectMode'(0),
        orientation: Orientation'(0),
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
endpackage