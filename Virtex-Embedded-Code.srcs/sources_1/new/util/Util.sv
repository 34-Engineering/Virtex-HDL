`timescale 1ns / 1ps

localparam IMAGE_WIDTH = 640;
localparam IMAGE_HEIGHT = 480;

/* Util - 

    */
`ifndef UTIL_DONE
`define UTIL_DONE

package Util;

    //Fault
    typedef enum logic [7:0] {
        NO_FAULT = 0,
        PYTHON_300_PLL_FAULT = 1, //python 300 PLL could not stabalize
        IR_LED_FAULT = 2, //from MAX chip
        OUT_OF_BLOB_MEM_FAULT = 3, //tried to create more blobs than available in mem => image is too noisy
        OUT_OF_RLE_MEM_FAULT = 4, //out of runs => image is too noisy
        BLOB_POINTER_DEPTH_FAULT = 5, //tried recursively following blob pointer, but it was too deep
        BLOB_PROCESSOR_TOO_SLOW_FAULT = 6 //blob processor took too long on line(s)
    } Fault;

    //20-bit Vector
    typedef struct packed {
        logic [9:0] x, y;
    } Vector;

    //10-bit Range Functions
    function automatic logic [9:0] min(logic [9:0] num1, num2);
        //pick the lesser of num1 & num2
        return num1 < num2 ? num1 : num2;
    endfunction

    function automatic logic [9:0] max(logic [9:0] num1, num2);
        //pick the greater of num1 & num2
        return num1 > num2 ? num1 : num2;
    endfunction

    function automatic logic [9:0] overflow1(logic [9:0] num, max);
        //overflow number between 0 & max by 1 increment max
        return num > max ? 0 : (num < 0 ? max : num);
    endfunction
    
endpackage

import Util::*;
`endif