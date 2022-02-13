



localparam MAX_BLOBS = 4000; //FIXME
localparam MAX_BLOB_POINTER_DEPTH = 5; //under normal cond: max needed ~3
localparam MAX_RUNS_PER_LINE = 40; //under normal cond: max needed ~26
localparam KERNEL_MAX_X = IMAGE_WIDTH / 8 - 1;
localparam NULL_RUN_START = IMAGE_WIDTH;
localparam NULL_LINE_NUMBER = IMAGE_HEIGHT;
localparam NULL_BLOB_ID = MAX_BLOBS;
localparam NULL_RUN_BUFFER_PARTION = 3;