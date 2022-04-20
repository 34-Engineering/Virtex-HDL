import { Math_inRangeInclusive, Math_max, Math_min, Quad10, quickDivide, Vector2d10 } from "./Math";
import { drawLine } from "./DrawUtil";
import { BlobArea, BlobIndex, boolToReg1, reg1, reg10, reg16, reg6, signed_reg10 } from "./VerilogUtil";
import { GROUP_TARGET_AREA_CONST } from "./VisionConstants";

//Blob Data
export interface BlobData { //144-bit
    /*Note: relative side of pixel
    ex) top left (0, 0) means pixel #(0, 0) whereas
        top right (1, 1) means pixel #(1, 0)
        bottom right (2, 2) means pixel #(1, 1)
    this makes area calculations easier*/
    boundTopLeft: Vector2d10, //20-bit
    boundBottomRight: Vector2d10,
    quad: Quad10, //40-bit
    area: BlobArea
}

//Target
export interface Target { //48-bit (6-byte)
    center: Vector2d10; //20-bit
    width: reg10;
    height: reg10;
    blobCount: reg6;
    angle: BlobAngle; //[1:0] angle of blob A (SINGLE: angle of blob, DUAL: angle of left blob, GROUP: HORIZONTAL)
};

//Blob Angles
export enum BlobAngle { //[1:0]
    //calcAngle() has up to 2°? error (norm < 0.5°?)
    //quad calculation can have up to 20°? error (norm < 1°?)
    HORIZONTAL, //0 -- (90±~10°)
    VERTICAL,   //1 || (0±~10°)
    FORWARD,    //2 //
    BACKWARD    //3 \\
}
export interface BlobAnglesEnabled {
    horizontal: boolean,
    vertical: boolean,
    forward: boolean,
    backward: boolean
}

//Target Mode
export const enum TargetMode {
    SINGLE, //only mode without added latency
    DUAL_ANY, //note: may include other combinations besides DUAL_UP & DUAL_DOWN
    DUAL_UP,   /* // \\ */
    DUAL_DOWN, /* \\ // */
    GROUP //2+ targets chained together
}

//Run
export interface Run { //for Python => Blob Processor
    length: reg10,
    line: reg10,
    black: reg1
}

//Run Buffer
export interface RunBufferRun {
    start: reg10,
    stop: reg10,
    blobIndex: BlobIndex
}
export interface RunBuffer {
    runs: RunBufferRun[],
    count: number, //number of runs filled (valid = [count-1:0])
    line: reg10
}

//Merge Quads
function mergeQuad10s(quad1: Quad10, quad2: Quad10): Quad10 {
    const quad1TopLeftD     = quad1.topLeft.x     + quad1.topLeft.y;
    const quad2TopLeftD     = quad2.topLeft.x     + quad2.topLeft.y;
    const quad1TopRightD    = quad1.topRight.x    - quad1.topRight.y;
    const quad2TopRightD    = quad2.topRight.x    - quad2.topRight.y;
    const quad1BottomRightD = quad1.bottomRight.x + quad1.bottomRight.y;
    const quad2BottomRightD = quad2.bottomRight.x + quad2.bottomRight.y;
    const quad1BottomLeftD  = quad1.bottomLeft.x  - quad1.bottomLeft.y;
    const quad2BottomLeftD  = quad2.bottomLeft.x  - quad2.bottomLeft.y;

    //does not create a perfect quad, but is good enough for rough angle calculations
    return {
        topLeft:     quad1TopLeftD     < quad2TopLeftD     ? quad1.topLeft     : quad2.topLeft,
        topRight:    quad1TopRightD    < quad2TopRightD    ? quad2.topRight    : quad1.topRight,
        bottomRight: quad1BottomRightD < quad2BottomRightD ? quad2.bottomRight : quad1.bottomRight,
        bottomLeft:  quad1BottomLeftD  < quad2BottomLeftD  ? quad1.bottomLeft  : quad2.bottomLeft
    };
}
// function mergeQuad10s(quad1: Quad10, quad2: Quad10): Quad10 {
//     //does not create a perfect quad, but is good enough for rough angle calculations
//     return {
//         topLeft:     quad1.topLeft.x     + quad1.topLeft.y     < quad2.topLeft.x     + quad2.topLeft.y     ? quad1.topLeft     : quad2.topLeft,
//         topRight:    quad1.topRight.x    - quad1.topRight.y    < quad2.topRight.x    - quad2.topRight.y    ? quad2.topRight    : quad1.topRight,
//         bottomRight: quad1.bottomRight.x + quad1.bottomRight.y < quad2.bottomRight.x + quad2.bottomRight.y ? quad2.bottomRight : quad1.bottomRight,
//         bottomLeft:  quad1.bottomLeft.x  - quad1.bottomLeft.y  < quad2.bottomLeft.x  - quad2.bottomLeft.y  ? quad1.bottomLeft  : quad2.bottomLeft
//     }
// }

//Merging Blobs
export function mergeBlobs(blob1: BlobData, blob2: BlobData): BlobData {
    return {
        boundTopLeft: {
            x: Math_min(blob1.boundTopLeft.x, blob2.boundTopLeft.x),
            y: Math_min(blob1.boundTopLeft.y, blob2.boundTopLeft.y)
        },
        boundBottomRight: {
            x: Math_max(blob1.boundBottomRight.x, blob2.boundBottomRight.x),
            y: Math_max(blob1.boundBottomRight.y, blob2.boundBottomRight.y)
        },
        quad: mergeQuad10s(blob1.quad, blob2.quad),
        area: blob1.area + blob2.area
    };
}

//Calculate Blob Angle
function calcAngle(dx: signed_reg10, dy: signed_reg10): BlobAngle {
    const t = 896; //best fit for 10° tolerance
    const h = quickDivide(dx, dy); //how horizontal the line is
    const v = quickDivide(dy, dx); //how vertical the line is
    return (h > t && v < t) ? BlobAngle.HORIZONTAL :
           (h < t && v > t) ? BlobAngle.VERTICAL   :
           boolToReg1(dx>0) ^ boolToReg1(dy>0) ? BlobAngle.FORWARD : BlobAngle.BACKWARD;
}
export function calcBlobAngle(blob: BlobData, data: any = false): BlobAngle {
    //make two center lines from quad centers
    const start1: Vector2d10 = {
        x: (blob.quad.topLeft.x + blob.quad.topRight.x-1) >> 1,
        y: (blob.quad.topLeft.y + blob.quad.topRight.y) >> 1
    };
    const end1: Vector2d10 = {
        x: (blob.quad.bottomLeft.x   + blob.quad.bottomRight.x-1) >> 1,
        y: (blob.quad.bottomLeft.y-1 + blob.quad.bottomRight.y-1) >> 1
    };
    const start2: Vector2d10 = {
        x: (blob.quad.topLeft.x + blob.quad.bottomLeft.x) >> 1,
        y: (blob.quad.topLeft.y + blob.quad.bottomLeft.y-1) >> 1
    };
    const end2: Vector2d10 = {
        x: (blob.quad.topRight.x-1 + blob.quad.bottomRight.x-1) >> 1,
        y: (blob.quad.topRight.y   + blob.quad.bottomRight.y-1) >> 1
    };

    //calculate delta values of center lines (signed 10-bit??)
    const dx1 = end1.x - start1.x;
    const dy1 = end1.y - start1.y;
    const dx2 = end2.x - start2.x;
    const dy2 = end2.y - start2.y;

    //find angle of center lines
    const angle1: BlobAngle = calcAngle(dx1, dy1);
    const angle2: BlobAngle = calcAngle(dx2, dy2);

    //find length of center lines
    const lengthSq1 = dx1**2 + dy1**2;
    const lengthSq2 = dx2**2 + dy2**2;

    //draw lines (scripting only)
    if (data) {
        if (lengthSq1 > lengthSq2) {
            const color = angle1 == BlobAngle.HORIZONTAL ? [255,0,0,255] : 
                angle1 == BlobAngle.VERTICAL ? [0,255,0,255] :
                angle1 == BlobAngle.FORWARD ? [255,255,0,255] : [0,255,255,255];
            drawLine(data, start1, end1, color);
        }
        else {
            const color = angle2 == BlobAngle.HORIZONTAL ? [255,0,0,255] : 
                angle2 == BlobAngle.VERTICAL ? [0,255,0,255] :
                angle2 == BlobAngle.FORWARD ? [255,255,0,255] : [0,255,255,255];
            drawLine(data, start2, end2, color);
        }
    }

    //return best angle
    return lengthSq1 > lengthSq2 ? angle1 : angle2;
}

//Runs Overlap
export function runsOverlap(start1: reg10, stop1: reg10, start2: reg10, stop2: reg10): reg1 {
    //widen run1 to join diagonals, then check overlap
    return boolToReg1(
        (start2 >= start1-(start1==0?0:1) && start2 <= stop1+1) || //start2 inside run1
        (stop2  >= start1-(start1==0?0:1) && stop2  <= stop1+1) || //stop2 inside run1
        (start2 <  start1-(start1==0?0:1) && stop2  >  stop1+1)    //run2 covers all of run1
    );
}

//Run to Blob
export function runToBlob(start: reg10, length: reg10, line: reg10): BlobData {
    const stop: reg10 = length + start - 1;
    return {
        boundTopLeft:     {x:start , y:line  },
        boundBottomRight: {x:stop+1, y:line+1},
        quad: {
            topLeft:      {x:start , y:line  },
            topRight:     {x:stop+1, y:line  },
            bottomRight:  {x:stop+1, y:line+1},
            bottomLeft:   {x:start , y:line+1},
        },
        area: length
    };
}

//Target Null
export let isTargetNull = (target: Target) => target.blobCount == 0;

//In Range/Valid Fixed Point (NOTE: this is only Typescript impl & will be very different in HDL)
export function inAspectRatioRange(width: reg10, height: reg10, min: reg16, max: reg16): reg1 {
    return Math_inRangeInclusive(width, min*height, max*height); //in replacement of inRangeInclusive(width/height, min, max)
}
export function inFullnessRange(area: BlobArea, boundArea: BlobArea, min: reg16, max: reg16): reg1 {
    return Math_inRangeInclusive(area, min*boundArea, max*boundArea);
}
export function inBoundAreaRatioRange(area1: BlobArea, area2: BlobArea, min: reg16, max: reg16): reg1 {
    return Math_inRangeInclusive(area1, min*area2, max*area2);
}
export function inBoundAreaRange(area: BlobArea, min: reg16, max: reg16): reg1 {
    return Math_inRangeInclusive(area >> 3, min, max);
}

//Group Target (target stored in blob)
export interface GroupTarget { //104-bit
    boundTopLeft: Vector2d10, //20-bit
    boundBottomRight: Vector2d10,
    blobCount: reg6,
    blobBoundArea: BlobArea
}
export function asGroupTarget(blob: BlobData): GroupTarget {
    return {
        boundTopLeft: blob.boundTopLeft,
        boundBottomRight: blob.boundBottomRight,
        blobCount: blob.quad.topLeft.x,
        blobBoundArea: blob.area - GROUP_TARGET_AREA_CONST
    }
}
export function asBlob(groupTarget: GroupTarget): BlobData {
    return {
        boundTopLeft: groupTarget.boundTopLeft,
        boundBottomRight: groupTarget.boundBottomRight,
        quad: {
            topLeft: {x:groupTarget.blobCount, y:0},
            topRight: {x:0, y:0},
            bottomRight: {x:0, y:0},
            bottomLeft: {x:0, y:0}
        },
        area: groupTarget.blobBoundArea + GROUP_TARGET_AREA_CONST
    }
}
export function isGroupTarget(blob: BlobData): reg1 {
    return boolToReg1(blob.area > GROUP_TARGET_AREA_CONST);
}
export function mergeGroupTargets(groupTargetA: GroupTarget, groupTargetB: GroupTarget): GroupTarget {
    return {
        boundTopLeft: {
            x: Math_min(groupTargetA.boundTopLeft.x, groupTargetB.boundTopLeft.x),
            y: Math_min(groupTargetA.boundTopLeft.y, groupTargetB.boundTopLeft.y)
        },
        boundBottomRight: {
            x: Math_max(groupTargetA.boundBottomRight.x, groupTargetB.boundBottomRight.x),
            y: Math_max(groupTargetA.boundBottomRight.y, groupTargetB.boundBottomRight.y)
        },
        blobCount: groupTargetA.blobCount + groupTargetB.blobCount,
        blobBoundArea: groupTargetA.blobBoundArea
    }
}
export function groupTargetToTarget(groupTarget: GroupTarget): Target {
    return {
        center: {
            x: (groupTarget.boundBottomRight.x + groupTarget.boundTopLeft.x) >> 1,
            y: (groupTarget.boundBottomRight.y + groupTarget.boundTopLeft.y) >> 1
        },
        width:  groupTarget.boundBottomRight.x - groupTarget.boundTopLeft.x + 1,
        height: groupTarget.boundBottomRight.y - groupTarget.boundTopLeft.y + 1,
        blobCount: groupTarget.blobCount,
        angle: BlobAngle.HORIZONTAL
    }
}
export function makeGroupTarget(blob: BlobData): GroupTarget {
    return {
        boundTopLeft: blob.boundTopLeft,
        boundBottomRight: blob.boundBottomRight,
        blobCount: 1,
        blobBoundArea: (blob.boundBottomRight.x - blob.boundTopLeft.x + 1) * (blob.boundBottomRight.y - blob.boundTopLeft.y + 1) //boundArea = boundWidth * boundHeight
    }
}