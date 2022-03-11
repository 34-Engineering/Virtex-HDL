"use strict";
exports.__esModule = true;
exports.virtexConfig = void 0;
var Constants_1 = require("./Constants");
;
exports.virtexConfig = {
    threshold: 128,
    //target params
    targetMode: 4 /* GROUP */,
    targetBlobXGapMin: 0,
    targetBlobXGapMax: 0xffff,
    targetBlobYGapMin: 0,
    targetBlobYGapMax: 0xffff,
    targetAspectRatioMin: 0,
    targetAspectRatioMax: 0xffff,
    targetBoundAreaMin: 0,
    targetBoundAreaMax: 0xffff,
    targetBlobAreaDiffMin: 0,
    targetBlobAreaDiffMax: 100,
    targetCenterX: Constants_1.IMAGE_WIDTH / 2,
    targetCenterY: Constants_1.IMAGE_HEIGHT / 2,
    //blob params
    blobAspectRatioMin: 0,
    blobAspectRatioMax: 0xffff,
    blobBoundAreaMin: 50,
    blobBoundAreaMax: 0xffff,
    blobFullnessMin: 0,
    blobFullnessMax: 0xffff,
    blobAnglesEnabled: { horizontal: true, vertical: true, forward: true, backward: true }
};
