import { IMAGE_HEIGHT, IMAGE_WIDTH } from "./Constants";

export const virtexConfig = {
    threshold: 128,

    //target params
    targetBlobCountMin: 1, //amount of blobs in target
    targetBlobCountMax: 1, //16-bit integer
    targetBlobXGapMin: 0, //distance between blobs in target
    targetBlobXGapMax: 0xffff, //16-bit integer
    targetBlobYGapMin: 0, //distance between blobs in target
    targetBlobYGapMax: 0xffff, //16-bit integer
    targetBlobAreaDiffMin: 0, //difference between areas of blobs in target //TODO what?? shouldn't this scale on blob size?
    targetBlobAreaDiffMax: 0xffff, //16-bit integer
    targetBlobAngleMin: 0, //difference in slope between each blob next to eachother //TODO how does the work if blobs are not in a clear line?
    targetBlobAngleMax: 0xffff, //signed 15-bit integer [-32767, 32767] where 32767 = 360°
    targetCenterX: IMAGE_WIDTH / 2, //final target selection parameter
    targetCenterY: IMAGE_HEIGHT / 2, //choose target thats closet to this point

    //blob params
    blobAspectRatioMin: Number.MIN_SAFE_INTEGER, //aspectRatio = boundWidth / boundHeight
    blobAspectRatioMax: Number.MAX_SAFE_INTEGER, //Q9.7 floating point
    blobSizeMin: 100, //size = boundWidth * boundHeight
    blobSizeMax: Number.MAX_SAFE_INTEGER, //16-bit integer
    blobFullnessMin: Number.MIN_SAFE_INTEGER, //fullness = blob.area (true area) / size
    blobFullnessMax: Number.MAX_SAFE_INTEGER, //Q1.15 floating point
    blobAngleMin: Number.MIN_SAFE_INTEGER, //angle of quad
    blobAngleMax: Number.MAX_SAFE_INTEGER, //signed 15-bit integer [-32767, 32767] where 32767 = 360°
};