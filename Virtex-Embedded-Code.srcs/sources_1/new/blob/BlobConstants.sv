`include "../util/Constants.sv"

/* BlobConstants -  */
`ifndef BLOB_CONSTANTS_DONE
`define BLOB_CONSTANTS_DONE

//max amount of blobs that can be stored in BRAM (duplicated in blk_mem_blobs)
localparam MAX_BLOBS = 4000; //576,000-bits

//max depth getRealBlobID() will follow a pointer (under normal cond: max needed ~3)
localparam MAX_BLOB_POINTER_DEPTH = 5;

//max runs RLE can create per line (under normal cond: max needed ~26)
localparam MAX_RUNS_PER_LINE = 40;

//null values
localparam NULL_RUN_START = IMAGE_WIDTH;
localparam NULL_LINE_NUMBER = IMAGE_HEIGHT;
localparam NULL_BLOB_ID = MAX_BLOBS;
localparam NULL_RUN_BUFFER_PARTION = 3;

//indexes
localparam MAX_BLOB_ID_SIZE = $clog2(MAX_BLOBS) + 1; //13 -> [12:0]

`endif