`timescale 1ns / 1ps



/* Fault - */
`ifndef FAULT_DONE
`define FAULT_DONE

typedef struct packed {
    logic PYTHON_300_PLL;      //python 300 PLL could not stabalize (electrical issue?)
    logic IR_LED;              //fault flag from MAX chip (electrical issue like LED burn out)
    logic OUT_OF_BLOB_MEM;     //tried to create more blobs than available in mem (probably too noisy)
    logic OUT_OF_RLE_MEM;      //out of runs (probably too noisy)
    logic BLOB_POINTER_DEPTH;  //tried recursively following blob pointer, but it was too deep
    logic BLOB_PROCESSOR_SLOW; //blob processor took too long on line(s) (probably too noisy)
    logic KERNEL_FIFO_FULL;    //blob run length encoder wasn't reading kernels fast enough
} Faults;

`endif