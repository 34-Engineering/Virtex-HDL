// BlobProcessor.ts

import { IMAGE_HEIGHT } from "./util/Constants";
import { Fault } from "./util/Fault";
import { Kernel, KERNEL_MAX_X } from "./util/PythonUtil";
import { BlobBRAMPort, BLOB_BRAM_PORT_DEFAULT, EMPTY_BLOB  } from "./util/OtherUtil";
import { MAX_BLOBS, MAX_BLOB_POINTER_DEPTH, MAX_RUNS_PER_LINE, NULL_LINE_NUMBER, NULL_BLOB_ID, NULL_RUN_BUFFER_PARTION, NULL_BLACK_RUN_BLOB_ID, NULL_TIMESTAMP } from "./BlobConstants";
import { BlobData, BlobMetadata, BlobStatus, mergeBlobs, Run, RunBuffer, runsOverlap, runToBlob, calcBlobAngle, BlobAngle, Target, TargetMode, BlobAnglesEnabled } from "./BlobUtil";
import { inRangeInclusive, overflow, Vector } from "./util/Math";
import { virtexConfig } from "./util/VirtexConfig";

