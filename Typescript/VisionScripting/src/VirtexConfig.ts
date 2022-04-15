import { BlobAnglesEnabled, TargetMode } from "./VisionUtil";
import { IMAGE_HEIGHT, IMAGE_WIDTH } from "./Constants";
import { reg16 } from "./VerilogUtil";

export interface VirtexConfig {
    threshold: number,

    //target params
    //Note:in group mode: gap & area diff are using for making the group, while
    //aspect ratio, bound area, & blob count are ONLY used for validity of the group (as target) once finished
    targetMode: TargetMode,
    targetBlobXGapMin: reg16, //distance between blobs in target
    targetBlobXGapMax: reg16, //16-bit integer
    targetBlobYGapMin: reg16, //distance between blobs in target
    targetBlobYGapMax: reg16, //16-bit integer
    targetBoundAreaRatioMin: reg16, //ratio between bound area of original blob & new blob
    targetBoundAreaRatioMax: reg16, //Q8.8 fixed point
    targetBoundAreaMin: reg16, //boundArea = boundWidth * boundHeight >> 3
    targetBoundAreaMax: reg16, //16-bit integer
    targetAspectRatioMin: reg16, //aspectRatio = boundWidth / boundHeight
    targetAspectRatioMax: reg16, //Q9.7 fixed point
    targetBlobCountMin: reg16, //(group mode only) # of blobs in target
    targetBlobCountMax: reg16, //63 max
    targetCenterX: reg16, //final target selection parameter //TODO better name
    targetCenterY: reg16, //choose target thats closet to this point

    //blob params
    blobAspectRatioMin: reg16, //aspectRatio = boundWidth / boundHeight
    blobAspectRatioMax: reg16, //Q9.7 fixed point
    blobBoundAreaMin: reg16, //boundArea = boundWidth * boundHeight >> 3
    blobBoundAreaMax: reg16, //16-bit integer
    blobFullnessMin: reg16, //fullness = blob.area (true area) / boundArea
    blobFullnessMax: reg16, //Q1.15 fixed point
    blobAnglesEnabled: BlobAnglesEnabled
};

export let virtexConfig: VirtexConfig = {
    threshold: 128,
 
    //target params
    targetMode: TargetMode.GROUP,
    targetBlobXGapMin: 0,
    targetBlobXGapMax: 0xFFFF,//30,
    targetBlobYGapMin: 0,
    targetBlobYGapMax: 0xFFFF,//30,
    targetBoundAreaRatioMin: 0.25,
    targetBoundAreaRatioMax: 1.75,
    targetBoundAreaMin: 12,
    targetBoundAreaMax: 0xFFFF,//0xFFFF,
    targetAspectRatioMin: 0,//2,
    targetAspectRatioMax: 0xFFFF,//4,
    targetBlobCountMin: 0,
    targetBlobCountMax: 0xFFFF,
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