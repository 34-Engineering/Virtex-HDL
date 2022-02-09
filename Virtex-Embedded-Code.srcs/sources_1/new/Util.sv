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
    } PythonOrientation;

    typedef struct packed { //32 x 16
        //python config
        /*00*/PythonOrientation pythonOrientation;
        /*01*/logic [15:0] threshold; //max: 255
        /*02*/logic [15:0] blackOffset; //'{128, 1, 16'h4008} black_offset
        /*03*/logic [15:0] analog_gain; //'{204, 1, 16'h01e1} analog_gain ([12:5]: AFE_gain, [4:0]: MUX_gain)
        /*04*/logic [15:0] digital_gain; //'{205, 1, 16'h0080} digital_gain
        /*05*/logic [15:0] exposure; //'{201, 1, 16'd41746} max: 41746
                                     // integration_time_ms = exposure * mult_timer (2) * clk_period (0.000013889ms)

        //target params
        /*06*/logic [15:0] targetBlobCountMin; //amount of blobs in target
        logic [15:0] targetBlobCountMax;
        logic [15:0] targetBlobGapMin; //distance between blobs
        logic [15:0] targetBlobGapMax;
        logic [15:0] targetBlobSlopeDiffMin; //difference in slope between each blob next to eachother //TODO how does the work if blobs are not in a clear line?
        logic [15:0] targetBlobSlopeDiffMax;
        logic [15:0] targetCenterX; //choose blob thats closet to this point
        logic [15:0] targetCenterY;

        //blob params
        logic [15:0] blobBoundAspectRatioMin; //boundWidth / boundHeight
        logic [15:0] blobBoundAspectRatioMax;
        logic [15:0] blobBoundAreaMin; //boundWidth * boundHeight
        logic [15:0] blobBoundAreaMax;
        logic [15:0] blobBoundFullnessMin; //blob.area / (boundWidth * boundHeight)
        logic [15:0] blobBoundFullnessMax;
        logic [15:0] blobQuadSlopeMin; //avg slope between left and right sides
        logic [15:0] blobQuadSlopeMax;
        
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
        //python config
        pythonOrientation: NORMAL,
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
    typedef logic [639:0] FrameBuffer [479:0];

    typedef struct packed {
        Vector kernelPos;
        logic [7:0] kernel;
        logic valid; //active high
    } FrameBufferWriteRequest;

    //Fault
    typedef enum logic [7:0] {
        NO_FAULT = 0,
        PYTHON_300_PLL_FAULT = 1,
        IR_LED_FAULT = 2,
        OUT_OF_BLOB_MEM_FAULT = 3
    } Fault;
endpackage

import Util::*;
`endif