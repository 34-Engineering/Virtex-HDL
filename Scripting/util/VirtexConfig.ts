import { BlobAnglesEnabled, BlobIntersection } from "../BlobUtil";
import { IMAGE_HEIGHT, IMAGE_WIDTH } from "./Constants";

export interface VirtexConfig {
    threshold: number,

    //target params
    targetBlobCountMin: number, //amount of blobs in target
    targetBlobCountMax: number, //16-bit integer
    targetBlobXGapMin: number, //distance between blobs in target
    targetBlobXGapMax: number, //16-bit integer
    targetBlobYGapMin: number, //distance between blobs in target
    targetBlobYGapMax: number, //16-bit integer
    targetBlobAreaDiffMin: number, //difference between areas of blobs in target
    targetBlobAreaDiffMax: number, //16-bit integer
    targetBlobIntersection: BlobIntersection, //only works for 2 horizontal blobs //TODO more functionality
    targetCenterX: number, //final target selection parameter
    targetCenterY: number, //choose target thats closet to this point

    //blob params
    blobAspectRatioMin: number, //aspectRatio = boundWidth / boundHeight
    blobAspectRatioMax: number, //Q9.7 floating point
    blobBoundAreaMin: number, //size = boundWidth * boundHeight
    blobBoundAreaMax: number, //16-bit integer
    blobFullnessMin: number, //fullness = blob.area (true area) / boundArea
    blobFullnessMax: number, //Q1.15 floating point
    blobAnglesEnabled: BlobAnglesEnabled
};

export const virtexConfig: VirtexConfig = {
    threshold: 128,

    //target params
    targetBlobCountMin: 1,
    targetBlobCountMax: 1,
    targetBlobXGapMin: 0,
    targetBlobXGapMax: 0xffff,
    targetBlobYGapMin: 0,
    targetBlobYGapMax: 0xffff,
    targetBlobAreaDiffMin: 0,
    targetBlobAreaDiffMax: 0xffff,
    targetBlobIntersection: BlobIntersection.ANY,
    targetCenterX: IMAGE_WIDTH / 2,
    targetCenterY: IMAGE_HEIGHT / 2,

    //blob params
    blobAspectRatioMin: 0,
    blobAspectRatioMax: 0xffff,
    blobBoundAreaMin: 100,
    blobBoundAreaMax: 0xffff,
    blobFullnessMin: 0,
    blobFullnessMax: 0xffff,
    blobAnglesEnabled: { horizontal: true, vertical: true, forward: true, backward: true }
};