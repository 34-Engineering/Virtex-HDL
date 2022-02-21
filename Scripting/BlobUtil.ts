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
        // quad: mergeQuads(blob1.quad, blob2.quad),
        area: blob1.area + blob2.area
    };
}

let image: any;
export function test(img: any) {
    // image = img;
    // drawFillRect(image.data, {x:0,y:0}, {x:639,y:479}, [0,0,0,255]);

    // const q1: Quad = {
    //     topLeft:     {x:50,y:100},
    //     topRight:    {x:200,y:150},
    //     bottomRight: {x:200,y:200},
    //     bottomLeft:  {x:100,y:200},
    // };
    // const q2: Quad = {
    //     topLeft:     {x:50,y:100},
    //     topRight:    {x:300,y:80},
    //     bottomRight: {x:300,y:200},
    //     bottomLeft:  {x:50,y:160},
    // };

    // drawQuad(image.data, q1, [255, 0, 125, 128]);
    // drawQuad(image.data, q2, [128, 255, 0, 128]);

    // drawQuad(image.data, mergeQuads(q1, q2), [255, 255, 0, 255]);
}

function mergeQuads(quad1: Quad, quad2: Quad): Quad {
    //pick most extreme points
    let extremes: Vector[] = [
        pickSmaller(quad1.topLeft, quad2.topLeft),
        pickLargerInverseY(quad1.topRight, quad2.topRight),
        pickSmallerInverseY(quad1.bottomLeft, quad2.bottomLeft),
        pickLarger(quad1.bottomRight, quad2.bottomRight)
    ];

    drawCenterFillSquare(image.data, extremes[0], 2, [0,255,255,255]);
    drawCenterFillSquare(image.data, extremes[1], 2, [0,255,255,255]);
    drawCenterFillSquare(image.data, extremes[2], 2, [0,255,255,255]);
    drawCenterFillSquare(image.data, extremes[3], 2, [0,255,255,255]);

    let avg: Vector = {
        x: (extremes[0].x+extremes[1].x+extremes[2].x+extremes[3].x)>>2,
        y: (extremes[0].y+extremes[1].y+extremes[2].y+extremes[3].y)>>2
    };
    drawCenterFillSquare(image.data, avg, 2, [255, 255, 0, 255]);

    //pick center line from two furthest points
    let maxInd = 0;
    let combos = [ //1001, 1010, 1100, 0101, 0110, 0011
        [0,3, 2,1], //last two numbers are just for pP
        [0,2, 1,3],
        [0,1, 2,3],
        [1,3, 0,2],
        [1,2, 0,3],
        [2,3, 0,1]
    ];
    for (let i = 1; i < 6; i++) {
        function dist(a: Vector, b: Vector): number {
            return Math.sqrt((a.x - b.x)**2 + (a.y - b.y)**2);
        }
        if (dist(extremes[combos[i][1]], extremes[combos[i][0]]) > 
            dist(extremes[combos[maxInd][1]], extremes[combos[maxInd][0]])) {
            maxInd = i;
        }
    }
    let pF1: Vector = extremes[combos[maxInd][0]]; //start center line
    let pF2: Vector = extremes[combos[maxInd][1]]; //end
    let pP1: Vector = extremes[combos[maxInd][2]]; //perp1 to cl
    let pP2: Vector = extremes[combos[maxInd][3]]; //perp2

    //calculate center line & offsets
    let m = (pF2.y - pF1.y) / (pF2.x - pF1.x); //center slope
    let mInv = -(1.0 / m);
    let bPF1Inv = pF1.y - mInv * pF1.x;
    let bPF2Inv = pF2.y - mInv * pF2.x;
    let bPP1 = pP1.y - m * pP1.x; //edge offsets from center line
    let bPP2 = pP2.y - m * pP2.x; //y=mx+b => b=y-mx

    //calculate 4 corners
    let x0 = (bPF1Inv - bPP1) / ((m**2 + 1) / (m));
    let x1 = (bPF2Inv - bPP1) / ((m**2 + 1) / (m));
    let x2 = (bPF2Inv - bPP2) / ((m**2 + 1) / (m));
    let x3 = (bPF1Inv - bPP2) / ((m**2 + 1) / (m));
    let quadPoints: Vector[] = [
        { x: x0, y: m * x0 + bPP1 },
        { x: x1, y: m * x1 + bPP1 },
        { x: x2, y: m * x2 + bPP2 },
        { x: x3, y: m * x3 + bPP2 }
    ];

    //make quad through four points
    return {
        topLeft: quadPoints[0],
        topRight: quadPoints[1],
        bottomRight: quadPoints[2],
        bottomLeft: quadPoints[3]
    };
}
function mergeQuadsMaxArea(quad1: Quad, quad2: Quad): Quad {
    let maxAreaQuadIndex = 0;
    //try every quad combination (0001 thru 1111, 0000 default ^)
    for (let i = 1; i < 16; i++) {
        const quad_i = mergeQuadsWithIndex(i, quad1, quad2);
        const quad_m = mergeQuadsWithIndex(maxAreaQuadIndex, quad1, quad2);

        if (calcQuadArea(quad_i) > calcQuadArea(quad_m)) {// && isValidQuad(quad_i)) { 
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
        topRight: pickLargerInverseY(quad1.topRight, quad2.topRight),
        bottomRight: pickLarger(quad1.bottomRight, quad2.bottomRight),
        bottomLeft: pickSmallerInverseY(quad1.bottomLeft, quad2.bottomLeft),
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