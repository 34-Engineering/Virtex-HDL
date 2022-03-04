`include "../util/Constants.sv"

/* BlobConstants -  */
`ifndef BLOB_CONSTANTS_DONE
`define BLOB_CONSTANTS_DONE

//max amount of blobs that can be stored in BRAM (duplicated in blk_mem_blobs)
localparam MAX_BLOBS = 2000; //288,000-bits
localparam MAX_BLOB_ID_SIZE = $clog2(MAX_BLOBS) + 1; //ex: 13 -> [12:0]

//max depth getRealBlobID() will follow a pointer (under normal cond: max needed ~3)
localparam MAX_BLOB_POINTER_DEPTH = 5;

//max runs RLE can create per line (under normal cond: max needed ~40)
localparam MAX_RUNS_PER_LINE = 60;
localparam MAX_RUNS_PER_LINE_POINTER_SIZE = $clog2(MAX_RUNS_PER_LINE) + 1; //ex: 13 -> [12:0]

//null values
localparam NULL_BLACK_RUN_BLOB_ID = MAX_BLOBS+1;
localparam NULL_LINE_NUMBER = IMAGE_HEIGHT;
localparam NULL_BLOB_ID = MAX_BLOBS;
localparam NULL_RUN_BUFFER_PARTION = 3;
localparam NULL_TIMESTAMP = 0;

`endif