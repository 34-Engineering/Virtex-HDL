import { IMAGE_HEIGHT, IMAGE_WIDTH } from "./Constants";

export interface VirtexConfig { //32 x 16
    //camera params & python config
    // /*00*/CameraOrientation cameraOrientation;
    // /*01*/LEDSafety ledSafety;
    threshold: number;
    // blackOffset;
    // PythonAnalogGainConfig analogGain;
    // digitalGain;
    // exposure; // integration_time_ms = exposure * mult_timer (2) * clk_period (0.000013889ms), max 41746 wo/ lowering fps

    //target params
    targetBlobCountMin: number; //amount of blobs in target
    targetBlobCountMax: number;
    targetBlobGapMin: number; //distance between blobs in target
    targetBlobGapMax: number;
    targetBlobAreaDiffMin: number; //difference between areas of blobs in target
    targetBlobAreaDiffMax: number;
    targetBlobSlopeDiffMin: number; //difference in slope between each blob next to eachother
    targetBlobSlopeDiffMax: number; //TODO how does the work if blobs are not in a clear line?
    targetAspectRatioMin: number;
    targetAspectRatioMax: number;
    targetCenterX: number; //final target selection parameter
    targetCenterY: number; //choose target thats closet to this point

    //blob params
    blobAspectRatioMin: number; //aspectRatio = boundWidth / boundHeight
    blobAspectRatioMax: number;
    blobSizeMin: number; //size = boundWidth * boundHeight
    blobSizeMax: number;
    blobFullnessMin: number; //fullness = blob.area (true area) / boundArea
    blobFullnessMax: number;
    blobSlopeMin: number; //slope = avg slope between left and right sides
    blobSlopeMax: number;
    
    //reserved for future use
    // /*27*/reserved27;
    // /*28*/reserved28;
    // /*29*/reserved29;
    // /*30*/reserved30;
    // /*31*/reserved31;
};
export const DefaultVirtexConfig: VirtexConfig = {
    //camera params & python config
    // cameraOrientation: NORMAL,
    // ledSafety: '{1, 1000},
    threshold: 128,
    // blackOffset: 8,
    // analogGain: '{0, 0, 15, 1},
    // digitalGain: 128,
    // exposure: 30000,

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
    blobAspectRatioMin: 0,
    blobAspectRatioMax: 0xffff,
    blobSizeMin: 16,
    blobSizeMax: 0xffff,
    blobFullnessMin: 0,
    blobFullnessMax: 0xffff,
    blobSlopeMin: 0,
    blobSlopeMax: 0xffff,
    
    //reserved for future use
    // reserved27: 16'd0,
    // reserved28: 16'd0,
    // reserved29: 16'd0,
    // reserved30: 16'd0,
    // reserved31: 16'd0
};