`include "../util/Constants.sv"

/* BlobConstants -  */
`ifndef BLOB_CONSTANTS_DONE
`define BLOB_CONSTANTS_DONE

//max amount of blobs that can be stored in BRAM (duplicated in blk_mem_blobs)
localparam MAX_BLOBS = 400;

//max runs RLE can create per line (under normal cond: max needed ~40)
localparam MAX_RUNS_PER_LINE = 60;

//size of run fifo (python -> blob processor)
localparam RUN_FIFO_LENGTH = 512;

//max amount of blobs in target group (tied to Target.blobCount register size)
localparam MAX_TARGET_GROUP_SIZE = (2 << (10-1)) - 1;

//group target area const : added to the BlobData.area to distinguish between a blob & a group target
localparam GROUP_TARGET_AREA_CONST = (640*480)+1; // >(640*480)

//null values
localparam NULL_LINE_NUMBER = IMAGE_HEIGHT;
localparam NULL_BLOB_INDEX = MAX_BLOBS;
localparam NULL_RUN_BUFFER_PARTION = 3;
localparam NULL_TIMESTAMP = 0;

`endif