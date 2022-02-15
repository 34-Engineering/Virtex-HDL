import { IMAGE_WIDTH, IMAGE_HEIGHT } from "./util/Constants";

//max amount of blobs that can be stored in BRAM (duplicated in blk_mem_blobs)
export const MAX_BLOBS = 2000; //288,000-bits

//max depth getRealBlobID() will follow a pointer (under normal cond: max needed ~3)
export const MAX_BLOB_POINTER_DEPTH = 5;

//max runs RLE can create per line (under normal cond: max needed ~26)
export const MAX_RUNS_PER_LINE = 40;

//null values
export const NULL_BLACK_RUN_BLOB_ID = MAX_BLOBS+1;
export const NULL_LINE_NUMBER = IMAGE_HEIGHT;
export const NULL_BLOB_ID = MAX_BLOBS;
export const NULL_RUN_BUFFER_PARTION = 3;