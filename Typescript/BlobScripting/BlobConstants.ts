import { IMAGE_WIDTH, IMAGE_HEIGHT } from "./util/Constants";

//max amount of blobs that can be stored in BRAM (duplicated in blk_mem_blobs)
export const MAX_BLOBS = 2000; //288,000-bits

//max runs RLE can create per line (under normal cond: max needed ~40)
export const MAX_RUNS_PER_LINE = 60;

//null values
export const NULL_LINE_NUMBER = IMAGE_HEIGHT;
export const NULL_BLOB_INDEX = MAX_BLOBS;
export const NULL_RUN_BUFFER_PARTION = 3;
export const NULL_TIMESTAMP = 0;