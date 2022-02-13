`timescale 1ns / 1ps



/* Fault - */
`ifndef FAULT_DONE
`define FAULT_DONE

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

`endif