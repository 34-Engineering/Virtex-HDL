import { virtexConfig } from "./util/VirtexConfig";
import { calcPolygonArea, calcQuadArea, inRangeInclusive, invertY, isSmaller, isValidQuad, max, min, pickLarger, pickLargerInverseY, pickSmaller, pickSmallerInverseY, Quad, Vector } from "./util/Math";
import { drawCenterFillSquare, drawFillRect, drawLine, drawPixel, drawQuad, drawRect, drawSILine } from "./util/OtherUtil";

//144-bit Blob Data
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
    angle: number, //16-bit (sign + 15-bit int), [-32767, 32767] where 32767 = 360°
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
    angle: number;
    fullness: number;
    //TODO
};

//Angle
export enum BlobAngle {
    //bound in range [0°, 180°] (angles increase counter-clockwise)
    HORIZONTAL, //[0, 10°], [170°, 180°]
    VERTICAL, //[80°, 100°]
    DIAGONAL_FORWARD, //(10°, 80°)
    DIAGONAL_BACKWARD //(100°, 170°)
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
export function doesBlobMatchCriteria(blob: BlobData, angle: number): boolean {
    const boundWidth = blob.boundBottomRight.x - blob.boundTopLeft.x;
    const boundHeight = blob.boundBottomRight.y - blob.boundTopLeft.y;

    //boundWidth / boundHeight = (1/640) to 640
    //10.6?
    const aspectRatio = boundWidth / boundHeight; //
    const size = boundWidth * boundHeight; //16-bit
    const fullness = blob.area / size; //16-bit (Q1.15)

    return inRangeInclusive(aspectRatio, virtexConfig.blobAspectRatioMin, virtexConfig.blobAspectRatioMax) &&
           inRangeInclusive(size       , virtexConfig.blobSizeMin       , virtexConfig.blobSizeMax       ) &&
           inRangeInclusive(fullness   , virtexConfig.blobFullnessMin   , virtexConfig.blobFullnessMax   ) &&
           inRangeInclusive(angle  , virtexConfig.blobAngleMin  , virtexConfig.blobAngleMax  );
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
        quad: mergeQuadsDistance(blob1.quad, blob2.quad),
        centroid: mergeCentroids(blob1, blob2),
        angle: 0, //angle is only saved once a blob is "done" & at that point no merges can occur
        area: blob1.area + blob2.area
    };
}

//Merge Quads
function mergeQuadsDistance(quad1: Quad, quad2: Quad): Quad {
    return {
        topLeft: pickSmaller(quad1.topLeft, quad2.topLeft),
        topRight: pickLargerInverseY(quad1.topRight, quad2.topRight),
        bottomRight: pickLarger(quad1.bottomRight, quad2.bottomRight),
        bottomLeft: pickSmallerInverseY(quad1.bottomLeft, quad2.bottomLeft),
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
export function calcBlobAngle(blob: BlobData, data: any = false): number {
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

    //find angle of center lines //TODO CORDIC
    const angle1 = Math.atan2(start1.y - end1.y, start1.x - end1.x);
    const angle2 = Math.atan2(end2.y - start2.y, end2.x - start2.x);

    //calculate distance^2 between line & centroid (& length^2 of line while your at it)
    const { distSq: centDistSq1, lengthSq: lengthSq1 } = calcPointToLineParams(blob.centroid, start1, end1);
    const { distSq: centDistSq2, lengthSq: lengthSq2 } = calcPointToLineParams(blob.centroid, start2, end2);

    //find if the distance touching line (within epsilon/tolerance)
    const sqCentDistEpsilon = 16; //FIXME should this be a parameter?
    const centInLine1 = centDistSq1 < sqCentDistEpsilon;
    const centInLine2 = centDistSq2 < sqCentDistEpsilon;

    //draw lines (scripting only)
    if (data) {
        if (centInLine1 && (!centInLine2 || (lengthSq1 > lengthSq2))) {
            drawLine(data, start1, end1, [255, 255, 0, 255]);
        }
        else if (centInLine1 || centInLine2) {
            drawLine(data, start2, end2, [255, 255, 0, 255]);
        }
    }

    //return best angle
    return (centInLine1 && (!centInLine2 || (lengthSq1 > lengthSq2))) ? angle1 : (centInLine1 || centInLine2) ? angle2 : 0;
}
function calcPointToLineParams(point: Vector, lineStart: Vector, lineEnd: Vector): { distSq: number, lengthSq: number } {
    //derived from: https://stackoverflow.com/questions/849211/shortest-distance-between-a-point-and-a-line-segment
    const dot = (point.x - lineStart.x) * (lineEnd.x - lineStart.x) + (point.y - lineStart.y) * (lineEnd.y - lineStart.y);
    const lengthSq = (lineEnd.x - lineStart.x)**2 + (lineEnd.y - lineStart.y)**2;
    const param = (lengthSq !== 0) ? dot / lengthSq : -1; //TODO DIVISIONJ???????????
    const xx = (param < 0) ? lineStart.x : (param > 1) ? lineEnd.x : lineStart.x + param * (lineEnd.x - lineStart.x);
    const yy = (param < 0) ? lineStart.y : (param > 1) ? lineEnd.y : lineStart.y + param * (lineEnd.y - lineStart.y);
    return { distSq: (point.x - xx)**2 + (point.y - yy)**2, lengthSq };
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