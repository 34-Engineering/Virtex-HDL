//max amount of blobs that can be stored in BRAM (duplicated in blk_mem_blobs)
export const MAX_BLOBS = 400;

//max runs RLE can create per line (under normal cond: max needed ~40)
export const MAX_RUNS_PER_LINE = 60;

//size of run fifo (python -> blob processor)
export const RUN_FIFO_LENGTH = 512;

//group target area const : added to the area to designate a blob as a group target
export const GROUP_TARGET_AREA_CONST = (640*480)+1; // >(640*480)

//null values
export const NULL_BLOB_INDEX = MAX_BLOBS;