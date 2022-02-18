import { IMAGE_WIDTH, IMAGE_HEIGHT } from './util/Constants';
import { VirtexConfig } from './util/VirtexConfig';

//Config
export const IMAGES_INPUT_PATH = 'images';
export const IMAGES_OUTPUT_PATH = 'output';
export const IMAGE_INPUT_PATH = 'images/2019_Noise2.png';
export const IMAGE_OUTPUT_PATH = 'out.png';
export const DRAW_BLOB_COLOR = true;
export const DRAW_BOUND = true;
export const DRAW_POLYGON = true;
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
    targetBlobSlopeDiffMin: 0,
    targetBlobSlopeDiffMax: 0xffff,
    targetAspectRatioMin: 0,
    targetAspectRatioMax: 0xffff,
    targetCenterX: IMAGE_WIDTH / 2,
    targetCenterY: IMAGE_HEIGHT / 2,

    //blob params
    blobAspectRatioMin: 0.25,
    blobAspectRatioMax: 1,
    blobSizeMin: 200,
    blobSizeMax: 0xffff,
    blobFullnessMin: 0.3,
    blobFullnessMax: 0.6,
    blobSlopeMin: 0,
    blobSlopeMax: 0xffff,
};