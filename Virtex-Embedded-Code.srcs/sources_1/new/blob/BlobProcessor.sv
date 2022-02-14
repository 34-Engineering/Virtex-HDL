`timescale 1ns / 1ps
`include "../python/PythonUtil.sv"
`include "BlobUtil.sv"

/* BlobProcessor - Processes incoming pixels into blobs and selects the target blob based on config
   
    Naming:
        Kernel: a group of 8 horizontal pixels (native to Python 300)

        White Pixel: a pixel that has a value >  threshold
        Black Pixel: a pixel that has a value <= threshold

        Run: a line of touching white pixels that is encoded (RLE) in a start and stop (and blobID)

        Blob: a group of touching pixels
        - Bounding Box: a non-rotated square that covers all pixels in the blob
        - Quad: a quadrilateral that is drawn inside the bounding box that covers most of the pixels (this is used for rotation/slope calculations)
            - Corner: the four corners of the quad
        
        Target: a (group) of blob(s) that represent the entire physical target

   */
//TODO invalidate blob w/ disable
//TODO invalidate blob w/ delayed frame?
module BlobProcessor(
    input wire CLK180,
    input wire Kernel kernel, //top left coord of the kernel
    output Blob targetBlob
    );
    
    //blk_mem_blobs
    
endmodule