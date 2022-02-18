import { IMAGE_WIDTH, IMAGE_HEIGHT } from './util/Constants';
import { VirtexConfig } from './util/VirtexConfig';

//Config
export const IMAGES_INPUT_PATH = 'images';
export const IMAGES_OUTPUT_PATH = 'output';
export const IMAGE_INPUT_PATH = 'images/Angles.png';
export const IMAGE_OUTPUT_PATH = 'out.png';
export const DRAW_BLOB_COLOR = false;
export const DRAW_BOUND = false;
export const DRAW_QUAD = true;
export const DRAW_QUAD_CENTER_LINES = true;
export const DRAW_QUAD_CORNERS = false;
export const DRAW_ELLIPSE = false;

export const virtexConfig: VirtexConfig = {
    threshold: 128,

    //target params
    targetBlobCountMin: 1,
    targetBlobCountMax: 1,
    targetBlobGapMin: 0,
    targetBlobGapMax: 0xffff,
    targetBlobAreaDiffMin: 0,
    targetBlobAreaDiffMax: 0xffff,
    targetBlobAngleRadsDiffMin: 0,
    targetBlobAngleRadsDiffMax: 0xffff,
    targetAspectRatioMin: 0,
    targetAspectRatioMax: 0xffff,
    targetCenterX: IMAGE_WIDTH / 2,
    targetCenterY: IMAGE_HEIGHT / 2,

    //blob params
    blobAspectRatioMin: Number.MIN_SAFE_INTEGER,
    blobAspectRatioMax: Number.MAX_SAFE_INTEGER,
    blobSizeMin: 100,
    blobSizeMax: Number.MAX_SAFE_INTEGER,
    blobFullnessMin: Number.MIN_SAFE_INTEGER,
    blobFullnessMax: Number.MAX_SAFE_INTEGER,
    blobAngleRadsMin: Number.MIN_SAFE_INTEGER,
    blobAngleRadsMax: Number.MAX_SAFE_INTEGER
};