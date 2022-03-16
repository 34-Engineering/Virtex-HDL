`timescale 1ns / 1ps
`include "../python/PythonUtil.sv"
`include "BlobUtil.sv"

/* BlobProcessor - Processes incoming pixels into blobs and selects the target blob based on config
   
   */
module BlobProcessor(
    input wire CLK200,
    input wire Kernel kernel, //top left coord of the kernel
    output Target target,
    output reg OUT_OF_BLOB_MEM_FAULT,
    output reg OUT_OF_RLE_MEM_FAULT,
    output reg BLOB_POINTER_DEPTH_FAULT,
    output reg BLOB_PROCESSOR_SLOW_FAULT
    );
    
    //blk_mem_blobs
    initial begin
        
    end
    
endmodule