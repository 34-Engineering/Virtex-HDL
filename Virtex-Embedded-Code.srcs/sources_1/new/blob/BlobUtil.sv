`timescale 1ns / 1ps

/* BlobUtil -  */
`ifndef BLOB_UTIL_DONE
`define BLOB_UTIL_DONE

`include "../util/Math.sv"
`include "BlobConstants.sv"

//144-bit Blob Data
typedef struct packed {
    /*Note: relative side of pixel
    ex) top left (0, 0) means pixel #(0, 0) whereas
        top right (1, 1) means pixel #(1, 0)
        bottom right (2, 2) means pixel #(1, 1)
    this makes area calculations easier*/
    Vector boundTopLeft;
    Vector boundBottomRight;
    Quad quad;
    logic [23:0] area;
} BlobData;

//Blob Metadata
typedef enum { UNSCANED, VALID, POINTER, GARBAGE } BlobStatus;
typedef struct packed {
    BlobStatus status;
    logic [MAX_BLOB_ID_SIZE-1:0] pointer;
} BlobMetadata;

//?-bit Target
typedef struct packed {
    Vector center;
    logic [9:0] width;
    logic [9:0] height;
    logic [59:0] latency; //timestamp is replaced with latency at delivery
    logic [3:0] blobCount;
    BlobAngle angle; //angle of blob A (SINGLE: angle of blob, DUAL: angle of left blob, GROUP: angle of chain start blob)
} Target;

//Blob Angles
typedef enum { //[1:0]
    //calcAngle() has up to 2°? error (norm < 0.5°?)
    //quad calculation can have up to 20°? error (norm < 1°?)
    HORIZONTAL, //0 -- (90±~10°)
    VERTICAL,   //1 || (0±~10°)
    FORWARD,    //2 //
    BACKWARD    //3 \\
} BlobAngle;
typedef struct packed {
    logic horizontal;
    logic vertical;
    logic forward;
    logic backward;
    logic [11:0] reserved;
} BlobAnglesEnabled;

//Target Mode
typedef enum logic [15:0] {
    SINGLE, //only mode without added latency
    DUAL_ANY, //note: may include other combinations besides DUAL_UP & DUAL_DOWN
    DUAL_UP,   /* // \\ */
    DUAL_DOWN, /* \\ // */
    GROUP //2+ targets chained together
} TargetMode;

//Run
typedef struct packed {
    logic [9:0] length;
    logic [MAX_BLOB_ID_SIZE-1:0] blobID;
} Run;

//Run Buffer
typedef struct packed {
    Run [MAX_RUNS_PER_LINE-1:0] runs;
    logic [MAX_RUNS_PER_LINE_POINTER_SIZE-1:0] count; //number of runs filled
    logic [9:0] line;
} RunBuffer;

//Blob Criteria
export function doesBlobMatchCriteria(blob: BlobData): boolean {
    const boundWidth: number = blob.boundBottomRight.x - blob.boundTopLeft.x;
    const boundHeight: number = blob.boundBottomRight.y - blob.boundTopLeft.y;

    //TODO fixed point mult
    const inAspectRatioRange: boolean = inRangeInclusive(boundWidth,
        virtexConfig.blobAspectRatioMin*boundHeight, virtexConfig.blobAspectRatioMax*boundHeight);

    const boundAreaUnshifted: number = boundWidth * boundHeight;
    const inBoundAreaRange: boolean = inRangeInclusive(boundAreaUnshifted >> 1,
        virtexConfig.blobBoundAreaMin, virtexConfig.blobBoundAreaMax);

    //TODO fixed point mult
    const inFullnessRange: boolean = inRangeInclusive(blob.area,
        virtexConfig.blobFullnessMin*boundAreaUnshifted, virtexConfig.blobFullnessMax*boundAreaUnshifted);

    const isValidAngle: boolean = virtexConfig.blobAnglesEnabled[(Object.keys(virtexConfig.blobAnglesEnabled) as Array<keyof BlobAnglesEnabled>)[calcBlobAngle(blob)]];

    return inAspectRatioRange && inBoundAreaRange && inFullnessRange && isValidAngle;
}

//Merging Blobs
export function mergeBlobs(blob1: BlobData, blob2: BlobData): BlobData {
    return {
        boundTopLeft: {
            x: min(blob1.boundTopLeft.x, blob2.boundTopLeft.x),
            y: min(blob1.boundTopLeft.y, blob2.boundTopLeft.y)
        },
        boundBottomRight: {
            x: max(blob1.boundBottomRight.x, blob2.boundBottomRight.x),
            y: max(blob1.boundBottomRight.y, blob2.boundBottomRight.y)
        },
        quad: mergeQuads(blob1.quad, blob2.quad),
        area: blob1.area + blob2.area
    };
}

//Merge Quads
function mergeQuads(quad1: Quad, quad2: Quad): Quad {
    //this algorithm is not perfect but close enough for choosing rough angle of blob
    return {
        topLeft:     quad1.topLeft.x     + quad1.topLeft.y     < quad2.topLeft.x     + quad2.topLeft.y     ? quad1.topLeft     : quad2.topLeft,
        topRight:    quad1.topRight.x    - quad1.topRight.y    < quad2.topRight.x    - quad2.topRight.y    ? quad2.topRight    : quad1.topRight,
        bottomRight: quad1.bottomRight.x + quad1.bottomRight.y < quad2.bottomRight.x + quad2.bottomRight.y ? quad2.bottomRight : quad1.bottomRight,
        bottomLeft:  quad1.bottomLeft.x  - quad1.bottomLeft.y  < quad2.bottomLeft.x  - quad2.bottomLeft.y  ? quad1.bottomLeft  : quad2.bottomLeft
    }
}

//Calculate Blob Angle
export function calcBlobAngle(blob: BlobData, data: any = false): BlobAngle {
    //make two center lines from quad centers
    const start1: Vector = {
        x: (blob.quad.topLeft.x + blob.quad.topRight.x-1) >> 1,
        y: (blob.quad.topLeft.y + blob.quad.topRight.y) >> 1
    };
    const end1: Vector = {
        x: (blob.quad.bottomLeft.x   + blob.quad.bottomRight.x-1) >> 1,
        y: (blob.quad.bottomLeft.y-1 + blob.quad.bottomRight.y-1) >> 1
    };
    const start2: Vector = {
        x: (blob.quad.topLeft.x + blob.quad.bottomLeft.x) >> 1,
        y: (blob.quad.topLeft.y + blob.quad.bottomLeft.y-1) >> 1
    };
    const end2: Vector = {
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
function isPointNearLine(point: Vector, lineStart: Vector, dx8: number, dy8: number, epsilon: number): boolean {
    //break up the line into 9 points and estimate point-line distance by
    //finding the minimum distance between point and 9 points in line
    return (lineStart.x         - point.x)**2 + (lineStart.y         - point.y)**2 < epsilon ||
           (lineStart.x +   dx8 - point.x)**2 + (lineStart.y +   dy8 - point.y)**2 < epsilon ||
           (lineStart.x + 2*dx8 - point.x)**2 + (lineStart.y + 2*dy8 - point.y)**2 < epsilon ||
           (lineStart.x + 3*dx8 - point.x)**2 + (lineStart.y + 3*dy8 - point.y)**2 < epsilon ||
           (lineStart.x + 4*dx8 - point.x)**2 + (lineStart.y + 4*dy8 - point.y)**2 < epsilon ||
           (lineStart.x + 5*dx8 - point.x)**2 + (lineStart.y + 5*dy8 - point.y)**2 < epsilon ||
           (lineStart.x + 6*dx8 - point.x)**2 + (lineStart.y + 6*dy8 - point.y)**2 < epsilon ||
           (lineStart.x + 7*dx8 - point.x)**2 + (lineStart.y + 7*dy8 - point.y)**2 < epsilon ||
           (lineStart.x + 8*dx8 - point.x)**2 + (lineStart.y + 8*dy8 - point.y)**2 < epsilon;
}
function calcAngle(dx: number, dy: number): BlobAngle {
    const t = 896; //best fit for 10° tolerance
    const h = quickDivide(dx, dy); //how horizontal the line is
    const v = quickDivide(dy, dx); //how vertical the line is
    return (h > t && v < t) ? BlobAngle.HORIZONTAL :
           (h < t && v > t) ? BlobAngle.VERTICAL   :
           Math.sign(dx) * Math.sign(dy) < 0 ? BlobAngle.FORWARD : BlobAngle.BACKWARD;
}

//Runs Overlap
export function runsOverlap(run1: Run, start1: number, run2: Run, start2: number): boolean {
    //widen run1 to join diagonals, then check overlap
    const stop1 = run1.length + start1 - 1;
    const stop2 = run2.length + start2 - 1;
    return (start2 >= start1-(start1==0?0:1) && start2 <= stop1+1) || //start2 inside run1
           (stop2  >= start1-(start1==0?0:1) && stop2  <= stop1+1) || //stop2 inside run1
           (start2 <  start1-(start1==0?0:1) && stop2  >  stop1+1);   //run2 covers all of run1
}

//Run to Blob
export function runToBlob(run: Run, start: number, line: number): BlobData {
    const stop = run.length + start - 1;
    return {
        boundTopLeft:     {x:start , y:line  },
        boundBottomRight: {x:stop+1, y:line+1},
        quad: {
            topLeft:      {x:start , y:line  },
            topRight:     {x:stop+1, y:line  },
            bottomRight:  {x:stop+1, y:line+1},
            bottomLeft:   {x:start , y:line+1},
        },
        area: run.length
    };
}

//Distance^2 Between Vector and Target Center
export function distSqToTargetCenter(v: Vector): number {
    return (v.x - virtexConfig.targetCenterX)**2 + (v.y - virtexConfig.targetCenterY)**2;
}

`endif