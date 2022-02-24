import { virtexConfig } from "./util/VirtexConfig";
import { calcPolygonArea, calcQuadArea, inRangeInclusive, invertY, isSmaller, isValidQuad, max, min, pickLarger, pickLargerInverseY, pickSmaller, pickSmallerInverseY, Quad, Vector } from "./util/Math";
import { drawCenterFillSquare, drawFillRect, drawLine, drawPixel, drawQuad, drawRect } from "./util/OtherUtil";

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
    centroid: Vector, //"center of gravity",
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
    latency: number;
    blobCount: number;
    slope: number;
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
    const aspectRatio = boundWidth / boundHeight;
    const size = boundWidth * boundHeight;
    const fullness = blob.area / size;
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
export function calcBlobAngleRads(blob: BlobData): number {
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
        x: start2.x - end2.x, //TODO check sign
        y: start2.y - end2.y,
    };

    //the forming of quads is not perfect BUT
    //we can correct for the majority of the fault by checking
    //whether the center lines travel through the centroid (within a tolerance--epsilon)
    let angleRads = 0; //FIXME remove = 0
    // if (#1 & #2 thru centroid within epsilon) {
    //     //both passed through centroid; quad formuation worked fine
    //     // => pick the longest center line as our basis for angle calculation
    //     const length1_ish = Math.abs(delta1.x + delta1.y); //should be dx^2 + dy^2 but this is easier
    //     const length2_ish = Math.abs(delta2.x + delta2.y); //sqrt is canceled by > operation below
    //     angleRads = (length1_ish > length2_ish) ? Math.atan2(delta1.y, delta1.x) : Math.atan2(delta2.y, delta2.x);
    // }
    // else if (#1 thru centroid within epsilon) {
    //     angleRads = Math.atan2(delta1.y, delta1.x);
    // }
    // else if (#2 thru centroid within epsilon) {
    //     angleRads = Math.atan2(delta2.y, delta2.x);
    // }
    // else {
    //     //fault??
    //     angleRads = 0; //FIXME ???
    // }
    
    //TODO save angle on blobdata

    return angleRads;
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