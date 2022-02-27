import { virtexConfig } from "./util/VirtexConfig";
import { inRangeInclusive, max, min, Quad, Vector } from "./util/Math";
import { drawLine } from "./util/OtherUtil";

//?-bit Blob Data
export interface BlobData {
    /*Note: relative side of pixel
    ex) top left (0, 0) means pixel #(0, 0) whereas
        top right (1, 1) means pixel #(1, 0)
        bottom right (2, 2) means pixel #(1, 1)
    this makes area calculations easier*/
    boundTopLeft: Vector,
    boundBottomRight: Vector,
    quad: Quad,
    centroid: Vector, //"center of area/mass",
    angle: BlobAngle, //16-bit (sign + 15-bit int), [-32767, 32767] where 32767 = 360°
    area: number
}

//Blob Metadata
export enum BlobStatus { UNSCANED, VALID, POINTER, GARBAGE };
export interface BlobMetadata {
    status: BlobStatus; //[1:0]
    pointer: number; //[MAX_BLOB_ID_SIZE-1:0]
}

//?-bit Target
export interface Target {
    center: Vector;
    boundTopLeft: Vector;
    boundBottomRight: Vector;
    timestamp: number; //timestamp is replaced with latency at delivery
    blobCount: number;
    //TODO
};

//Blob Angles
export enum BlobAngle {
    //bound in range [0°, 180°] (angles increase counter-clockwise)
    HORIZONTAL, //0 _ ~[0, 10°], [170°, 180°]
    VERTICAL,   //1 | ~[80°, 100°]
    FORWARD,    //2 / ~(10°, 80°)
    BACKWARD    //3 \ ~(100°, 170°)
}
export interface BlobAnglesEnabled {
    horizontal: boolean,
    vertical: boolean,
    forward: boolean,
    backward: boolean
}
export const enum BlobIntersection {
    ANY,
    UP,    // / \
    BOTTOM // \ /
}

//Run
export interface Run {
    length: number, //[9:0]
    blobID: number //[MAX_BLOB_ID_SIZE-1:0]
}

//Run Buffer
export interface RunBuffer {
    runs: Run[],
    count: number //number of runs
    line: number //[9:0]
}

//Blob Criteria
export function doesBlobMatchCriteria(blob: BlobData, angle: BlobAngle): boolean {
    const boundWidth: number = blob.boundBottomRight.x - blob.boundTopLeft.x;
    const boundHeight: number = blob.boundBottomRight.y - blob.boundTopLeft.y;

    //TODO fixed point mult
    const inAspectRatioRange: boolean = inRangeInclusive(boundWidth,
        virtexConfig.blobAspectRatioMin*boundHeight, virtexConfig.blobAspectRatioMax*boundHeight);

    const boundArea: number = boundWidth * boundHeight;
    const inBoundAreaRange: boolean = inRangeInclusive(boundArea,
        virtexConfig.blobBoundAreaMin, virtexConfig.blobBoundAreaMax);

    //TODO fixed point mult (blobFullness is a 16-bit (Q1.15)
    const inFullnessRange: boolean = inRangeInclusive(blob.area,
        virtexConfig.blobFullnessMin*boundArea, virtexConfig.blobFullnessMax*boundArea);

    // console.log(angle, Object.keys(virtexConfig.blobAnglesEnabled), Object.keys(virtexConfig.blobAnglesEnabled)[angle], virtexConfig.blobAnglesEnabled, virtexConfig.blobAnglesEnabled[Object.keys(virtexConfig.blobAnglesEnabled)[angle]]);
    // const isValidAngle: boolean = virtexConfig.blobAnglesEnabled[Object.keys(virtexConfig.blobAnglesEnabled)[angle]];
    const isValidAngle: boolean = true;

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
        centroid: mergeCentroids(blob1, blob2),
        angle: 0, //angle is only saved once a blob is "done" & at that point no merges can occur
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

//Merge Centroid
function mergeCentroids(blob1: BlobData, blob2: BlobData): Vector {
    //TODO optimize
    const b1Power = blob1.area / (blob1.area + blob2.area);
    const b2Power = blob2.area / (blob1.area + blob2.area);
    return {
        x: (blob1.centroid.x*b1Power) + (blob2.centroid.x*b2Power),
        y: (blob1.centroid.y*b1Power) + (blob2.centroid.y*b2Power)
    }
}

//Calculate Blob Angle
export function calcBlobAngle(blob: BlobData, data: any = false): BlobAngle {
    //the forming of quads is not perfect BUT
    //we can correct for the majority of the fault by checking
    //whether the center lines travel through the centroid (within a tolerance--epsilon)

    //make two center lines from quad centers
    const start1: Vector = {
        x: (blob.quad.topLeft.x + blob.quad.topRight.x-1) >> 1,
        y: (blob.quad.topLeft.y + blob.quad.topRight.y) >> 1
    };
    const end1: Vector = {
        x: (blob.quad.bottomLeft.x + blob.quad.bottomRight.x-1) >> 1,
        y: (blob.quad.bottomLeft.y-1 + blob.quad.bottomRight.y-1) >> 1
    };
    const start2: Vector = {
        x: (blob.quad.topLeft.x + blob.quad.bottomLeft.x) >> 1,
        y: (blob.quad.topLeft.y + blob.quad.bottomLeft.y-1) >> 1
    };
    const end2: Vector = {
        x: (blob.quad.topRight.x-1 + blob.quad.bottomRight.x-1) >> 1,
        y: (blob.quad.topRight.y + blob.quad.bottomRight.y-1) >> 1
    };

    //calculate delta values of center lines (signed 10-bit??)
    const dx1 = end1.x - start1.x;
    const dy1 = end1.y - start1.y;
    const dx2 = end2.x - start2.x;
    const dy2 = end2.y - start2.y;

    //find angle of center lines //TODO Look up table angles
    const angle1: BlobAngle = Math.atan2(dy1, dx1);
    const angle2: BlobAngle = Math.atan2(dy2, dx2);

    //find length of center lines
    const lengthSq1 = dx1**2 + dy1**2;
    const lengthSq2 = dx2**2 + dy2**2;

    //find if the center lines are interescting the centroid (within epsilon/tolerance)
    const centriodDistSqEpsilon = 16; //FIXME should this be a parameter?
    const nearCentroid1 = isPointNearLine(blob.centroid, start1, dx1 >> 3, dy1 >> 3, centriodDistSqEpsilon);
    const nearCentroid2 = isPointNearLine(blob.centroid, start2, dx2 >> 3, dy2 >> 3, centriodDistSqEpsilon);

    //draw lines (scripting only)
    if (data) {
        if (nearCentroid1 && (!nearCentroid2 || (lengthSq1 > lengthSq2))) {
            drawLine(data, start1, end1, [255, 255, 0, 255]);
        }
        else if (nearCentroid1 || nearCentroid2) {
            drawLine(data, start2, end2, [255, 255, 0, 255]);
        }
    }

    //return best angle
    return (nearCentroid1 && (!nearCentroid2 || (lengthSq1 > lengthSq2))) ? angle1 : (nearCentroid1 || nearCentroid2) ? angle2 : BlobAngle.HORIZONTAL;
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
        centroid: { x: start + (run.length >> 1), y: line },
        angle: 0, //angle is calculated later, once the blob is "done"
        area: run.length
    };
}