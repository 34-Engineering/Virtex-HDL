`include "../util/Constants.sv"

/* BlobConstants -  */
`ifndef BLOB_CONSTANTS_DONE
`define BLOB_CONSTANTS_DONE

//max amount of blobs that can be stored in BRAM (duplicated in blk_mem_blobs)
localparam MAX_BLOBS = 2000; //288,000-bits

//max depth getRealBlobID() will follow a pointer (under normal cond: max needed ~3)
localparam MAX_BLOB_POINTER_DEPTH = 5;

//max runs RLE can create per line (under normal cond: max needed ~40)
localparam MAX_RUNS_PER_LINE = 60;

//after how many nanoseconds the target will be invalidated (marked NULL/STALE)
// localparam TIMESTAMP_SIZE = 32; //2^32-1ns = ~4295ms
// localparam TARGET_AGE_STALE = 5000000; //5ms

//null values
localparam NULL_BLACK_RUN_BLOB_INDEX = MAX_BLOBS+1;
localparam NULL_LINE_NUMBER = IMAGE_HEIGHT;
localparam NULL_BLOB_INDEX = MAX_BLOBS;
// localparam NULL_TIMESTAMP = 0;

`endif