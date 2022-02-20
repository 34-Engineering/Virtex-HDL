import { virtexConfig } from "./util/VirtexConfig";
import { calcPolygonArea, calcQuadArea, inRangeInclusive, invertY, isSmaller, isValidQuad, max, min, pickLarger, pickSmaller, Quad, Vector } from "./util/Math";
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
    quad: Quad
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

    const avgDy = ((blob.quad.bottomLeft.y + blob.quad.bottomRight.y) / 2.0) - ((blob.quad.topLeft.y + blob.quad.topRight.y) / 2.0);
    const avgDx = ((blob.quad.topLeft.x + blob.quad.topRight.x) / 2.0) - ((blob.quad.bottomLeft.x + blob.quad.bottomRight.x) / 2.0);
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
    return {
        boundTopLeft: {
            x: min(blob1.boundTopLeft.x, blob2.boundTopLeft.x),
            y: min(blob1.boundTopLeft.y, blob2.boundTopLeft.y)
        },
        boundBottomRight: {
            x: max(blob1.boundBottomRight.x, blob2.boundBottomRight.x),
            y: max(blob1.boundBottomRight.y, blob2.boundBottomRight.y)
        },
        // quad: mergeQuadsMaxArea(blob1.quad, blob2.quad),
        quad: mergeQuadsDistance(blob1.quad, blob2.quad),
        area: blob1.area + blob2.area
    };
}
function mergeQuadsMaxArea(quad1: Quad, quad2: Quad): Quad {
    let maxAreaQuadIndex = 0;
    //try every quad combination (0001 thru 1111, 0000 default ^)
    for (let i = 1; i < 16; i++) {
        const quad_i = mergeQuadsWithIndex(i, quad1, quad2);
        const quad_m = mergeQuadsWithIndex(maxAreaQuadIndex, quad1, quad2);

        if (calcQuadArea(quad_i) > calcQuadArea(quad_m) && isValidQuad(quad_i)) { 
            maxAreaQuadIndex = i;
        }
    }
    return mergeQuadsWithIndex(maxAreaQuadIndex, quad1, quad2);
}
function mergeQuadsWithIndex(index: number, quad0: Quad, quad1: Quad): Quad {
    //merges two quads based on a 4-bit register
    //ex) 0101 => quad0.topLeft, quad1.topRight, quad0.bottomRight, quad1.bottomLeft
    return {
        topLeft:     (index >> 3 & 0x1 ? quad1 : quad0).topLeft,
        topRight:    (index >> 2 & 0x1 ? quad1 : quad0).topRight,
        bottomRight: (index >> 1 & 0x1 ? quad1 : quad0).bottomRight,
        bottomLeft:  (index >> 0 & 0x1 ? quad1 : quad0).bottomLeft
    };
}
function mergeQuadsDistance(quad1: Quad, quad2: Quad): Quad {
    return {
        topLeft: pickSmaller(quad1.topLeft, quad2.topLeft),
        topRight: pickLarger(invertY(quad1.topRight), invertY(quad2.topRight)),
        bottomRight: pickLarger(quad1.bottomRight, quad2.bottomRight),
        bottomLeft: pickSmaller(invertY(quad1.bottomLeft), invertY(quad2.bottomLeft)),
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
        area: run.length
    };
}