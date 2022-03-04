`timescale 1ns / 1ps
`include "../python/PythonUtil.sv"
`include "BlobUtil.sv"

/* BlobProcessor - Processes incoming pixels into blobs and selects the target blob based on config
   
   */
//TODO invalidate blob w/ disable
//TODO invalidate blob w/ delayed frame?
module BlobProcessor(
    input wire CLK180,
    input wire Kernel kernel, //top left coord of the kernel
    output Target target
    );
    
    //blk_mem_blobs
    
endmodule