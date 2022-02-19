import { IMAGE_HEIGHT, IMAGE_WIDTH } from "./Constants";

export const virtexConfig = {
    threshold: 128,

    //target params
    targetBlobCountMin: 1, //amount of blobs in target
    targetBlobCountMax: 1,
    targetBlobGapMin: 0, //distance between blobs in target
    targetBlobGapMax: 0xffff,
    targetBlobAreaDiffMin: 0, //difference between areas of blobs in target
    targetBlobAreaDiffMax: 0xffff,
    targetBlobAngleRadsDiffMin: 0, //difference in slope between each blob next to eachother
    targetBlobAngleRadsDiffMax: 0xffff, //TODO how does the work if blobs are not in a clear line?
    targetAspectRatioMin: 0,
    targetAspectRatioMax: 0xffff,
    targetCenterX: IMAGE_WIDTH / 2, //final target selection parameter
    targetCenterY: IMAGE_HEIGHT / 2, //choose target thats closet to this point

    //blob params
    blobAspectRatioMin: Number.MIN_SAFE_INTEGER, //aspectRatio = boundWidth / boundHeight
    blobAspectRatioMax: Number.MAX_SAFE_INTEGER,
    blobSizeMin: 100, //size = boundWidth * boundHeight
    blobSizeMax: Number.MAX_SAFE_INTEGER,
    blobFullnessMin: Number.MIN_SAFE_INTEGER, //fullness = blob.area (true area) / size
    blobFullnessMax: Number.MAX_SAFE_INTEGER,
    blobAngleRadsMin: Number.MIN_SAFE_INTEGER, //angle of polygon (-PI to PI)
    blobAngleRadsMax: Number.MAX_SAFE_INTEGER, //avg line between two longest sides of quad
};