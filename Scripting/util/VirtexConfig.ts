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
    targetBlobAngleRadsDiffMin: number; //difference in slope between each blob next to eachother
    targetBlobAngleRadsDiffMax: number; //TODO how does the work if blobs are not in a clear line?
    targetAspectRatioMin: number;
    targetAspectRatioMax: number;
    targetCenterX: number; //final target selection parameter
    targetCenterY: number; //choose target thats closet to this point

    //blob params
    blobAspectRatioMin: number; //aspectRatio = boundWidth / boundHeight
    blobAspectRatioMax: number;
    blobSizeMin: number; //size = boundWidth * boundHeight
    blobSizeMax: number;
    blobFullnessMin: number; //fullness = blob.area (true area) / size
    blobFullnessMax: number;
    blobAngleRadsMin: number; //angle of polygon (-PI to PI)
    blobAngleRadsMax: number; //avg line between two longest sides of quad
    
    //reserved for future use
    // /*27*/reserved27;
    // /*28*/reserved28;
    // /*29*/reserved29;
    // /*30*/reserved30;
    // /*31*/reserved31;
};