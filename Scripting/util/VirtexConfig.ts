import { BlobAnglesEnabled, TargetMode } from "../BlobUtil";
import { IMAGE_HEIGHT, IMAGE_WIDTH } from "./Constants";

export interface VirtexConfig {
    threshold: number,

    //target params
    targetMode: TargetMode,
    targetBlobXGapMin: number, //distance between blobs in target
    targetBlobXGapMax: number, //16-bit integer
    targetBlobYGapMin: number, //distance between blobs in target
    targetBlobYGapMax: number, //16-bit integer
    targetAspectRatioMin: number, //aspectRatio = boundWidth / boundHeight
    targetAspectRatioMax: number, //Q9.7 floating point
    targetBoundAreaMin: number, //boundArea = boundWidth * boundHeight >> 1
    targetBoundAreaMax: number, //16-bit integer
    targetBlobAreaDiffMin: number, //difference between areas of blobs in target
    targetBlobAreaDiffMax: number, //16-bit integer
    targetCenterX: number, //final target selection parameter //TODO better name
    targetCenterY: number, //choose target thats closet to this point

    //blob params
    blobAspectRatioMin: number, //aspectRatio = boundWidth / boundHeight
    blobAspectRatioMax: number, //Q9.7 floating point
    blobBoundAreaMin: number, //boundArea = boundWidth * boundHeight >> 1
    blobBoundAreaMax: number, //16-bit integer
    blobFullnessMin: number, //fullness = blob.area (true area) / boundArea
    blobFullnessMax: number, //Q1.15 floating point
    blobAnglesEnabled: BlobAnglesEnabled
};

export let virtexConfig: VirtexConfig = {
    threshold: 128,

    //target params
    targetMode: TargetMode.DUAL,
    targetBlobXGapMin: 0,
    targetBlobXGapMax: 0xffff,//30,
    targetBlobYGapMin: 0,
    targetBlobYGapMax: 0xffff,//30,
    targetAspectRatioMin: 0,//2,
    targetAspectRatioMax: 0xffff,//4,
    targetBoundAreaMin: 0,
    targetBoundAreaMax: 0xffff,//0xffff,
    targetBlobAreaDiffMin: 0,
    targetBlobAreaDiffMax: 0xffff,//100,
    targetCenterX: IMAGE_WIDTH / 2,
    targetCenterY: IMAGE_HEIGHT / 2,

    //blob params
    blobAspectRatioMin: 0,
    blobAspectRatioMax: 0xffff,
    blobBoundAreaMin: 50,
    blobBoundAreaMax: 0xffff,
    blobFullnessMin: 0,
    blobFullnessMax: 0xffff,
    blobAnglesEnabled: { horizontal: true, vertical: true, forward: true, backward: true }
};