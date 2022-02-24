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
    angleRads: number;
    fullness: number;
    //TODO
};

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
export function doesBlobMatchCriteria(blob: BlobData): boolean {
    const boundWidth = blob.boundBottomRight.x - blob.boundTopLeft.x;
    const boundHeight = blob.boundBottomRight.y - blob.boundTopLeft.y;

    //boundWidth / boundHeight = (1/640) to 640
    //10.6?
    const aspectRatio = boundWidth / boundHeight; //
    const size = boundWidth * boundHeight; //16-bit
    const fullness = blob.area / size; //16-bit (Q1.15)
    const angleRads = calcBlobAngleRads(blob);

    return inRangeInclusive(aspectRatio, virtexConfig.blobAspectRatioMin, virtexConfig.blobAspectRatioMax) &&
           inRangeInclusive(size       , virtexConfig.blobSizeMin       , virtexConfig.blobSizeMax       ) &&
           inRangeInclusive(fullness   , virtexConfig.blobFullnessMin   , virtexConfig.blobFullnessMax   ) &&
           inRangeInclusive(angleRads  , virtexConfig.blobAngleRadsMin  , virtexConfig.blobAngleRadsMax  );
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

//Calc Blob Angle
export function calcBlobAngleRads(blob: BlobData, data: any = false): number {
    //the forming of quads is not perfect BUT
    //we can correct for the majority of the fault by checking
    //whether the center lines travel through the centroid (within a tolerance--epsilon)

    //two center lines drawn from quad centers
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
    const delta1: Vector = {
        x: start1.x - end1.x, //TODO check sign
        y: start1.y - end1.y,
    };
    const delta2: Vector = {
        x: end2.x - start2.x, //TODO check sign
        y: end2.y - start2.y,
    };

    //put center line segments into y=mx+b
    const m1 = (delta1.y)/(delta1.x); //slope
    const m2 = (delta2.y)/(delta2.x);
    const b1 = start1.y - m1 * start1.x; //y-intercept
    const b2 = start2.y - m2 * start2.x;
    const mInv1 = -1/m1; //inverse slope
    const mInv2 = -1/m2;

    //angle of lines from slope
    const angleRads1 = Math.atan(m1);
    const angleRads2 = Math.atan(m2);

    //length of line segments (for selection)
    const lengthSq1 = Math.abs(delta1.x**2 + delta1.y**2); //using length^2 because
    const lengthSq2 = Math.abs(delta2.x**2 + delta2.y**2); //the sqrts cancel in comparison

    //distance between centroid and line
    let centDistSq1, centDistSq2;
    if (delta1.x == 0) { //vertical line
        centDistSq1 = (blob.centroid.x - start1.x)**2;
    }
    else if (delta1.y == 0) { //horizontal line
        centDistSq1 = (blob.centroid.y - start1.y)**2;
    }
    else { //normal line; using dist^2 because sqrt cancels
        const bCent1 = blob.centroid.y - mInv1 * blob.centroid.x; //y-intercept
        const intCentX1 = (bCent1 - b1)/(m1 - mInv1); //intersection between line & centroid
        const intCentY1 = m1 * intCentX1 + b1;
        centDistSq1 = (blob.centroid.x-intCentX1)**2 + (blob.centroid.y-intCentY1)**2;
    }
    if (delta2.x == 0) { //vertical line
        centDistSq2 = (blob.centroid.x - start2.x)**2;
    }
    else if (delta2.y == 0) { //horizontal line
        centDistSq2 = (blob.centroid.y - start2.y)**2;
    }
    else { //normal line
        const bCent2 = blob.centroid.y - mInv2 * blob.centroid.x;
        const intCentX2 = (bCent2 - b2)/(m2 - mInv2);
        const intCentY2 = m2 * intCentX2 + b2;
        centDistSq2 = (blob.centroid.x-intCentX2)**2 + (blob.centroid.y-intCentY2)**2;
    }

    //find if the distance is negligable
    const sqCentDistEpsilon = 5; //FIXME ??
    const centInLine1 = centDistSq1 < sqCentDistEpsilon;
    const centInLine2 = centDistSq2 < sqCentDistEpsilon;

    if (centInLine1 && (!centInLine2 || (lengthSq1 > lengthSq2))) {
        //(scripting only)
        if (data) {
            drawLine(data, start1, end1, [255, 255, 0, 255]);
        }
        
        return angleRads1;
    }
    else if (!centInLine1 && !centInLine2) {
    //FAULT? no valid angle...
        return 0; //FIXME?
    }
    else {
        //(scripting only)
        if (data) {
            drawLine(data, start2, end2, [255, 255, 0, 255]);
        }
        return angleRads2;
    }
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
        area: run.length
    };
}