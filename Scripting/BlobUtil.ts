import { virtexConfig } from "./util/VirtexConfig";
import { calcPolygonArea, inRangeInclusive, max, min, Vector } from "./util/Math";
import { drawPixel } from "./util/OtherUtil";

//144-bit Blob Data
export interface BlobData {
    /*Note: relative side of pixel
    ex) top left (0, 0) means pixel #(0, 0) whereas
        top right (1, 1) means pixel #(1, 0)
        bottom right (2, 2) means pixel #(1, 1)
    this makes area calculations easier*/
    boundTopLeft: Vector,
    boundBottomRight: Vector,
    quadTopLeft: Vector,
    quadTopRight: Vector,
    quadBottomRight: Vector,
    quadBottomLeft: Vector,
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

    const avgDy = ((blob.quadBottomLeft.y + blob.quadBottomRight.y) / 2.0) - ((blob.quadTopLeft.y + blob.quadTopRight.y) / 2.0);
    const avgDx = ((blob.quadTopLeft.x + blob.quadTopRight.x) / 2.0) - ((blob.quadBottomLeft.x + blob.quadBottomRight.x) / 2.0);
    const angleRads = Math.atan2(avgDy, avgDx);

    // if (inRangeInclusive(aspectRatio, virtexConfig.blobAspectRatioMin, virtexConfig.blobAspectRatioMax) &&
    //     inRangeInclusive(size       , virtexConfig.blobSizeMin       , virtexConfig.blobSizeMax       ) &&
    //     inRangeInclusive(fullness   , virtexConfig.blobFullnessMin   , virtexConfig.blobFullnessMax   ) &&
    //     inRangeInclusive(angleRads  , virtexConfig.blobAngleRadsMin  , virtexConfig.blobAngleRadsMax  )) {
    //     console.log({ avgDy, avgDx, angleRads });
    // }

    return inRangeInclusive(aspectRatio, virtexConfig.blobAspectRatioMin, virtexConfig.blobAspectRatioMax) &&
           inRangeInclusive(size       , virtexConfig.blobSizeMin       , virtexConfig.blobSizeMax       ) &&
           inRangeInclusive(fullness   , virtexConfig.blobFullnessMin   , virtexConfig.blobFullnessMax   ) &&
           inRangeInclusive(angleRads  , virtexConfig.blobAngleRadsMin  , virtexConfig.blobAngleRadsMax  );
}

//Merging Blobs
export function mergeBlobs(blob1: BlobData, blob2: BlobData): BlobData {
    const quad = makeBiggestQuad(blob1, blob2);
    return {
        boundTopLeft: {
            x: min(blob1.boundTopLeft.x, blob2.boundTopLeft.x),
            y: min(blob1.boundTopLeft.y, blob2.boundTopLeft.y)
        },
        boundBottomRight: {
            x: max(blob1.boundBottomRight.x, blob2.boundBottomRight.x),
            y: max(blob1.boundBottomRight.y, blob2.boundBottomRight.y)
        },
        quadTopLeft: quad[0],
        quadTopRight: quad[1],
        quadBottomRight: quad[2],
        quadBottomLeft: quad[3],
        // quadTopLeft: mergeExtremeTopLeft(blob1.quadTopLeft, blob2.quadTopLeft),
        // quadTopRight: mergeExtremeTopRight(blob1.quadTopRight, blob2.quadTopRight),
        // quadBottomRight: mergeExtremeBottomRight(blob1.quadBottomRight, blob2.quadBottomRight),
        // quadBottomLeft: mergeExtremeBottomLeft(blob1.quadBottomLeft, blob2.quadBottomLeft),
        area: blob1.area + blob2.area
    };
}
function makeBiggestQuad(blob1: BlobData, blob2: BlobData): Vector[] {
    const quads: Vector[][] = [
        [ blob1.quadTopLeft, blob1.quadTopRight, blob1.quadBottomRight, blob1.quadBottomLeft ],
        [ blob1.quadTopLeft, blob1.quadTopRight, blob1.quadBottomRight, blob2.quadBottomLeft ],
        [ blob1.quadTopLeft, blob1.quadTopRight, blob2.quadBottomRight, blob1.quadBottomLeft ],
        [ blob1.quadTopLeft, blob1.quadTopRight, blob2.quadBottomRight, blob2.quadBottomLeft ],
        [ blob1.quadTopLeft, blob2.quadTopRight, blob1.quadBottomRight, blob1.quadBottomLeft ],
        [ blob1.quadTopLeft, blob2.quadTopRight, blob1.quadBottomRight, blob2.quadBottomLeft ],
        [ blob1.quadTopLeft, blob2.quadTopRight, blob2.quadBottomRight, blob1.quadBottomLeft ],
        [ blob1.quadTopLeft, blob2.quadTopRight, blob2.quadBottomRight, blob2.quadBottomLeft ],
        [ blob2.quadTopLeft, blob1.quadTopRight, blob1.quadBottomRight, blob1.quadBottomLeft ],
        [ blob2.quadTopLeft, blob1.quadTopRight, blob1.quadBottomRight, blob2.quadBottomLeft ],
        [ blob2.quadTopLeft, blob1.quadTopRight, blob2.quadBottomRight, blob1.quadBottomLeft ],
        [ blob2.quadTopLeft, blob1.quadTopRight, blob2.quadBottomRight, blob2.quadBottomLeft ],
        [ blob2.quadTopLeft, blob2.quadTopRight, blob1.quadBottomRight, blob1.quadBottomLeft ],
        [ blob2.quadTopLeft, blob2.quadTopRight, blob1.quadBottomRight, blob2.quadBottomLeft ],
        [ blob2.quadTopLeft, blob2.quadTopRight, blob2.quadBottomRight, blob1.quadBottomLeft ],
        [ blob2.quadTopLeft, blob2.quadTopRight, blob2.quadBottomRight, blob2.quadBottomLeft ],
    ];

    let biggestQuadIndex = 0;
    for (let i = 1; i < quads.length; i++) {
        if (calcPolygonArea(quads[i]) > calcPolygonArea(quads[biggestQuadIndex]) && //pick max area
            isValidQuad(quads[i])) { 
            biggestQuadIndex = i;
        }
    }

    return quads[biggestQuadIndex];
}
function isValidQuad(points: Vector[]): boolean {
    //0 = topLeft, 1 = topRight, 2 = bottomRight, 3 = bottomLeft
    return points[0].x < points[1].x && points[3].x < points[2].x && //make sure left < right
           points[0].y < points[3].y && points[1].y < points[2].y; //& bottom > top
}
//FIXME FIXME FIXME
export function mergeExtremeTopLeft(a: Vector, b: Vector): Vector {
    //note: these need to be signed
    return isVectorSmaller({x: a.x, y: a.y}, {x: b.x, y: b.y}) ? a : b;
}
export function mergeExtremeTopRight(a: Vector, b: Vector): Vector {
    return isVectorSmaller({x: a.x, y: -a.y}, {x: b.x, y: -b.y}) ? b : a;
}
export function mergeExtremeBottomRight(a: Vector, b: Vector): Vector {
    return isVectorSmaller({x: a.x, y: a.y}, {x: b.x, y: b.y}) ? b : a;
}
export function mergeExtremeBottomLeft(a: Vector, b: Vector): Vector {
    return isVectorSmaller({x: a.x, y: -a.y}, {x: b.x, y: -b.y}) ? a : b;
}
export function isVectorSmaller(a: Vector, b: Vector): boolean {
    //(sqrt(x^2 + y^2) is too expensive => using x + y which gives similar quality)
    return a.x + a.y < b.x + b.y;
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
        quadTopLeft:      {x:start , y:line  },
        quadTopRight:     {x:stop+1, y:line  },
        quadBottomRight:  {x:stop+1, y:line+1},
        quadBottomLeft:   {x:start , y:line+1},
        area: run.length
    };
}