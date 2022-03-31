import { BlobAnglesEnabled, TargetMode } from "../BlobUtil";
import { IMAGE_HEIGHT, IMAGE_WIDTH } from "./Constants";

export interface VirtexConfig {
    threshold: number,

    //target params
    //Note:in group mode: gap & area diff are using for making the group, while
    //aspect ratio, bound area, & blob count are ONLY used for validity of the group (as target) once finished
    targetMode: TargetMode,
    targetBlobXGapMin: number, //distance between blobs in target
    targetBlobXGapMax: number, //16-bit integer
    targetBlobYGapMin: number, //distance between blobs in target
    targetBlobYGapMax: number, //16-bit integer
    targetBoundAreaRatioMin: number, //ratio between bound area of original blob & new blob
    targetBoundAreaRatioMax: number, //16-bit integer
    targetBoundAreaMin: number, //boundArea = boundWidth * boundHeight >> 3
    targetBoundAreaMax: number, //16-bit integer
    targetAspectRatioMin: number, //aspectRatio = boundWidth / boundHeight
    targetAspectRatioMax: number, //Q9.7 floating point
    targetBlobCountMin: number, //(group mode only) # of blobs in target
    targetBlobCountMax: number, //63 max
    targetCenterX: number, //final target selection parameter //TODO better name
    targetCenterY: number, //choose target thats closet to this point

    //blob params
    blobAspectRatioMin: number, //aspectRatio = boundWidth / boundHeight
    blobAspectRatioMax: number, //Q9.7 floating point
    blobBoundAreaMin: number, //boundArea = boundWidth * boundHeight >> 3
    blobBoundAreaMax: number, //16-bit integer
    blobFullnessMin: number, //fullness = blob.area (true area) / boundArea
    blobFullnessMax: number, //Q1.15 floating point
    blobAnglesEnabled: BlobAnglesEnabled
};

export let virtexConfig: VirtexConfig = {
    threshold: 128,

    //target params
    targetMode: TargetMode.DUAL_UP,
    targetBlobXGapMin: 0,
    targetBlobXGapMax: 0xFFFF,//30,
    targetBlobYGapMin: 0,
    targetBlobYGapMax: 0xFFFF,//30,
    targetBoundAreaRatioMin: 0.25,
    targetBoundAreaRatioMax: 1.75,//100,
    targetBoundAreaMin: 12,
    targetBoundAreaMax: 0xFFFF,//0xFFFF,
    targetAspectRatioMin: 0,//2,
    targetAspectRatioMax: 4,//4,
    targetBlobCountMin: 3,
    targetBlobCountMax: 5,
    targetCenterX: IMAGE_WIDTH / 2,
    targetCenterY: IMAGE_HEIGHT / 2,

    //blob params
    blobAspectRatioMin: 0,
    blobAspectRatioMax: 0xFFFF,
    blobBoundAreaMin: 12,
    blobBoundAreaMax: 0xFFFF,
    blobFullnessMin: 0,
    blobFullnessMax: 0xFFFF,
    blobAnglesEnabled: { horizontal: true, vertical: true, forward: true, backward: true }
};