`timescale 1ns / 1ps

/* FrameBufferUtil - 

    */
`ifndef FRAME_BUFFER_UTIL_DONE
`define FRAME_BUFFER_UTIL_DONE

`include "../util/Util.sv"

package FrameBufferUtil;
    `include "../util/Util.sv"
    
    //Frame Buffer
    //FIXME
    typedef struct packed {
        Kernel kernel;
        logic valid; //active high
    } FrameBufferWriteRequest;

endpackage

import FrameBufferUtil::*;
`endif
