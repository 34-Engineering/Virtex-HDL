"use strict";
exports.__esModule = true;
exports.distSqToTargetCenter = exports.runToBlob = exports.runsOverlap = exports.calcBlobAngle = exports.mergeBlobs = exports.doesBlobMatchCriteria = exports.BlobAngle = exports.BlobStatus = void 0;
var VirtexConfig_1 = require("./util/VirtexConfig");
var Math_1 = require("./util/Math");
var OtherUtil_1 = require("./util/OtherUtil");
//Blob Metadata
var BlobStatus;
(function (BlobStatus) {
    BlobStatus[BlobStatus["UNSCANED"] = 0] = "UNSCANED";
    BlobStatus[BlobStatus["VALID"] = 1] = "VALID";
    BlobStatus[BlobStatus["POINTER"] = 2] = "POINTER";
    BlobStatus[BlobStatus["GARBAGE"] = 3] = "GARBAGE";
})(BlobStatus = exports.BlobStatus || (exports.BlobStatus = {}));
;
;
//Blob Angles
var BlobAngle;
(function (BlobAngle) {
    //calcAngle() has up to 2°? error (norm < 0.5°?)
    //quad calculation can have up to 20°? error (norm < 1°?)
    BlobAngle[BlobAngle["HORIZONTAL"] = 0] = "HORIZONTAL";
    BlobAngle[BlobAngle["VERTICAL"] = 1] = "VERTICAL";
    BlobAngle[BlobAngle["FORWARD"] = 2] = "FORWARD";
    BlobAngle[BlobAngle["BACKWARD"] = 3] = "BACKWARD"; //3 \\
})(BlobAngle = exports.BlobAngle || (exports.BlobAngle = {}));
//Blob Criteria
function doesBlobMatchCriteria(blob) {
    var boundWidth = blob.boundBottomRight.x - blob.boundTopLeft.x;
    var boundHeight = blob.boundBottomRight.y - blob.boundTopLeft.y;
    //TODO fixed point mult
    var inAspectRatioRange = (0, Math_1.inRangeInclusive)(boundWidth, VirtexConfig_1.virtexConfig.blobAspectRatioMin * boundHeight, VirtexConfig_1.virtexConfig.blobAspectRatioMax * boundHeight);
    var boundAreaUnshifted = boundWidth * boundHeight;
    var inBoundAreaRange = (0, Math_1.inRangeInclusive)(boundAreaUnshifted >> 1, VirtexConfig_1.virtexConfig.blobBoundAreaMin, VirtexConfig_1.virtexConfig.blobBoundAreaMax);
    //TODO fixed point mult
    var inFullnessRange = (0, Math_1.inRangeInclusive)(blob.area, VirtexConfig_1.virtexConfig.blobFullnessMin * boundAreaUnshifted, VirtexConfig_1.virtexConfig.blobFullnessMax * boundAreaUnshifted);
    var isValidAngle = VirtexConfig_1.virtexConfig.blobAnglesEnabled[Object.keys(VirtexConfig_1.virtexConfig.blobAnglesEnabled)[calcBlobAngle(blob)]];
    return inAspectRatioRange && inBoundAreaRange && inFullnessRange && isValidAngle;
}
exports.doesBlobMatchCriteria = doesBlobMatchCriteria;
//Merging Blobs
function mergeBlobs(blob1, blob2) {
    return {
        boundTopLeft: {
            x: (0, Math_1.min)(blob1.boundTopLeft.x, blob2.boundTopLeft.x),
            y: (0, Math_1.min)(blob1.boundTopLeft.y, blob2.boundTopLeft.y)
        },
        boundBottomRight: {
            x: (0, Math_1.max)(blob1.boundBottomRight.x, blob2.boundBottomRight.x),
            y: (0, Math_1.max)(blob1.boundBottomRight.y, blob2.boundBottomRight.y)
        },
        quad: mergeQuads(blob1.quad, blob2.quad),
        area: blob1.area + blob2.area
    };
}
exports.mergeBlobs = mergeBlobs;
//Merge Quads
function mergeQuads(quad1, quad2) {
    //this algorithm is not perfect but close enough for choosing rough angle of blob
    return {
        topLeft: quad1.topLeft.x + quad1.topLeft.y < quad2.topLeft.x + quad2.topLeft.y ? quad1.topLeft : quad2.topLeft,
        topRight: quad1.topRight.x - quad1.topRight.y < quad2.topRight.x - quad2.topRight.y ? quad2.topRight : quad1.topRight,
        bottomRight: quad1.bottomRight.x + quad1.bottomRight.y < quad2.bottomRight.x + quad2.bottomRight.y ? quad2.bottomRight : quad1.bottomRight,
        bottomLeft: quad1.bottomLeft.x - quad1.bottomLeft.y < quad2.bottomLeft.x - quad2.bottomLeft.y ? quad1.bottomLeft : quad2.bottomLeft
    };
}
//Calculate Blob Angle
function calcBlobAngle(blob, data) {
    if (data === void 0) { data = false; }
    //make two center lines from quad centers
    var start1 = {
        x: (blob.quad.topLeft.x + blob.quad.topRight.x - 1) >> 1,
        y: (blob.quad.topLeft.y + blob.quad.topRight.y) >> 1
    };
    var end1 = {
        x: (blob.quad.bottomLeft.x + blob.quad.bottomRight.x - 1) >> 1,
        y: (blob.quad.bottomLeft.y - 1 + blob.quad.bottomRight.y - 1) >> 1
    };
    var start2 = {
        x: (blob.quad.topLeft.x + blob.quad.bottomLeft.x) >> 1,
        y: (blob.quad.topLeft.y + blob.quad.bottomLeft.y - 1) >> 1
    };
    var end2 = {
        x: (blob.quad.topRight.x - 1 + blob.quad.bottomRight.x - 1) >> 1,
        y: (blob.quad.topRight.y + blob.quad.bottomRight.y - 1) >> 1
    };
    //calculate delta values of center lines (signed 10-bit??)
    var dx1 = end1.x - start1.x;
    var dy1 = end1.y - start1.y;
    var dx2 = end2.x - start2.x;
    var dy2 = end2.y - start2.y;
    //find angle of center lines
    var angle1 = calcAngle(dx1, dy1);
    var angle2 = calcAngle(dx2, dy2);
    //find length of center lines
    var lengthSq1 = Math.pow(dx1, 2) + Math.pow(dy1, 2);
    var lengthSq2 = Math.pow(dx2, 2) + Math.pow(dy2, 2);
    //draw lines (scripting only)
    if (data) {
        if (lengthSq1 > lengthSq2) {
            var color = angle1 == BlobAngle.HORIZONTAL ? [255, 0, 0, 255] :
                angle1 == BlobAngle.VERTICAL ? [0, 255, 0, 255] :
                    angle1 == BlobAngle.FORWARD ? [255, 255, 0, 255] : [0, 255, 255, 255];
            (0, OtherUtil_1.drawLine)(data, start1, end1, color);
        }
        else {
            var color = angle2 == BlobAngle.HORIZONTAL ? [255, 0, 0, 255] :
                angle2 == BlobAngle.VERTICAL ? [0, 255, 0, 255] :
                    angle2 == BlobAngle.FORWARD ? [255, 255, 0, 255] : [0, 255, 255, 255];
            (0, OtherUtil_1.drawLine)(data, start2, end2, color);
        }
    }
    //return best angle
    return lengthSq1 > lengthSq2 ? angle1 : angle2;
}
exports.calcBlobAngle = calcBlobAngle;
function calcAngle(dx, dy) {
    var t = 896; //best fit for 10° tolerance
    var h = (0, Math_1.quickDivide)(dx, dy); //how horizontal the line is
    var v = (0, Math_1.quickDivide)(dy, dx); //how vertical the line is
    return (h > t && v < t) ? BlobAngle.HORIZONTAL :
        (h < t && v > t) ? BlobAngle.VERTICAL :
            Math.sign(dx) * Math.sign(dy) < 0 ? BlobAngle.FORWARD : BlobAngle.BACKWARD;
}
//Runs Overlap
function runsOverlap(run1, start1, run2, start2) {
    //widen run1 to join diagonals, then check overlap
    var stop1 = run1.length + start1 - 1;
    var stop2 = run2.length + start2 - 1;
    return (start2 >= start1 - (start1 == 0 ? 0 : 1) && start2 <= stop1 + 1) || //start2 inside run1
        (stop2 >= start1 - (start1 == 0 ? 0 : 1) && stop2 <= stop1 + 1) || //stop2 inside run1
        (start2 < start1 - (start1 == 0 ? 0 : 1) && stop2 > stop1 + 1); //run2 covers all of run1
}
exports.runsOverlap = runsOverlap;
//Run to Blob
function runToBlob(run, start, line) {
    var stop = run.length + start - 1;
    return {
        boundTopLeft: { x: start, y: line },
        boundBottomRight: { x: stop + 1, y: line + 1 },
        quad: {
            topLeft: { x: start, y: line },
            topRight: { x: stop + 1, y: line },
            bottomRight: { x: stop + 1, y: line + 1 },
            bottomLeft: { x: start, y: line + 1 }
        },
        area: run.length
    };
}
exports.runToBlob = runToBlob;
//Distance^2 Between Vector and Target Center
function distSqToTargetCenter(v) {
    return Math.pow((v.x - VirtexConfig_1.virtexConfig.targetCenterX), 2) + Math.pow((v.y - VirtexConfig_1.virtexConfig.targetCenterY), 2);
}
exports.distSqToTargetCenter = distSqToTargetCenter;
