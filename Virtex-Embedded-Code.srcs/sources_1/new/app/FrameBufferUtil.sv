`timescale 1ns / 1ps

/* FrameBufferUtil - */
`ifndef FRAME_BUFFER_UTIL_DONE
`define FRAME_BUFFER_UTIL_DONE

`include "../python/PythonUtil.sv"
    
//Frame Buffer
typedef struct packed {
    Kernel kernel;
    logic valid; //active high
} FrameBufferWriteRequest;

`endif
