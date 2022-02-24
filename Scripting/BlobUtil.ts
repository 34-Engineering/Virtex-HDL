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
    centroid: Vector, //"center of gravity"
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
        centroid: mergeCentroids(blob1, blob2),
        area: blob1.area + blob2.area
    };
}

//Merge Quads
let image: any;
export function test(img: any) {
    image = img;
    drawFillRect(image.data, {x:0,y:0}, {x:639,y:479}, [0,0,0,255]);

    const q1: Quad = {
        topLeft:     {x:50,y:100},
        topRight:    {x:200,y:150},
        bottomRight: {x:200,y:200},
        bottomLeft:  {x:100,y:200},
    };
    const q2: Quad = {
        topLeft:     {x:50,y:100},
        topRight:    {x:300,y:80},
        bottomRight: {x:300,y:200},
        bottomLeft:  {x:50,y:160},
    };

    drawQuad(image.data, q1, [255, 0, 125, 128]);
    drawQuad(image.data, q2, [128, 255, 0, 128]);

    mergeQuads(q1, q2);
    drawQuad(image.data, mergeQuads(q1, q2), [255, 255, 0, 255]);
}
function mergeQuads(quad1: Quad, quad2: Quad): Quad {
    //merge quads by drawing the smallest rotated rect that encapsulates them
    
    const points: Vector[] = [
        quad1.topLeft, quad2.topLeft,
        quad1.topRight, quad2.topRight,
        quad1.bottomLeft, quad2.bottomLeft,
        quad1.bottomRight, quad2.bottomRight
    ];
    
    //pick center line from two furthest points
    let bestComboIndex = 0;
    let combos = [
        [0,1],[0,2],[0,3],[0,4],[0,5],[0,6],[0,7],
        [1,2],[1,3],[1,4],[1,5],[1,6],[1,7],
        [2,3],[2,4],[2,5],[2,6],[2,7],
        [3,4],[3,5],[3,6],[3,7],
        [4,5],[4,6],[4,7],
        [5,6],[5,7],
        [6,7]
    ];
    for (let i = 1; i < combos.length; i++) {
        function dist(a: Vector, b: Vector): number {
            return Math.sqrt((a.x - b.x)**2 + (a.y - b.y)**2);
        }
        if (dist(points[combos[i][1]], points[combos[i][0]]) > 
            dist(points[combos[bestComboIndex][1]], points[combos[bestComboIndex][0]])) {
                bestComboIndex = i;
        }
    }
    const center1: Vector = points[combos[bestComboIndex][0]]; //center end point #1
    const center2: Vector = points[combos[bestComboIndex][1]]; //center end point #2
    const m = (center2.y - center1.y) / (center2.x - center1.x); //center slope
    const mInv = -(1.0 / m); //inverse of center slope
    const b = center1.y - m * center1.x;

    //pick points furthest perpendictular to center line
    let perp1: Vector = {x:0,y:0}; //above cl
    let perp2: Vector = {x:0,y:0}; //below cl
    let perp1Dist: number = 0; //cached dist
    let perp2Dist: number = 0;
    for (let i = 0; i < points.length; i++) {
        const point = points[i];

        //find distance between a point and line segment
        //with sign of whether the point is above or below the line
        //& assuming the point is between the lineStart & lineEnd if they were extended via invSlope
        const p = point.x;
        const q = point.y;
        const m1 = mInv;

        const b2 = q-m1*p;

        const x1 = (b2-b)/(m-m1);
        const y1 = m*x1+b;

        const dist = Math.sqrt((p-x1)**2+(q-y1)**2);

        const aboveLine = (p-x1)<0;
        
        if (aboveLine && dist > perp1Dist) {
            perp1Dist = dist;
            perp1 = point;
        }
        else if (!aboveLine && dist > perp2Dist) {
            perp2Dist = dist;
            perp2 = point;
        }
    }

    drawCenterFillSquare(image.data, center1, 2, [255,0,255,255]);
    drawCenterFillSquare(image.data, center2, 2, [255,0,255,255]);
    drawCenterFillSquare(image.data, perp1, 2, [0,255,255,255]);
    drawCenterFillSquare(image.data, perp2, 2, [0,255,255,255]);

    //calculate center line & offsets ("b" of y=mx+b)
    let bPF1Inv = center1.y - mInv * center1.x;
    let bPF2Inv = center2.y - mInv * center2.x;
    let bPP1 = perp1.y - m * perp1.x; //edge offsets from center line
    let bPP2 = perp2.y - m * perp2.x; //y=mx+b => b=y-mx

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