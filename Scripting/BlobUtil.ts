import { max, min, Vector } from "./util/Math";

export interface BlobData {
    boundTopLeft: Vector,
    boundBottomRight: Vector,
    quadTopLeft: Vector,
    quadTopRight: Vector,
    quadBottomLeft: Vector,
    quadBottomRight: Vector,
    area: number
}
export interface Run {
    start: number,
    stop: number,
    blobID: number
}
export interface RunBuffer {
    runs: Run[],
    count: number //number of runs
    line: number
}

//Merging
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
        quadTopLeft: mergeQuadTopLeft(blob1.quadTopLeft, blob2.quadTopLeft),
        quadTopRight: mergeQuadTopRight(blob1.quadTopRight, blob2.quadTopRight),
        quadBottomLeft: mergeQuadBottomLeft(blob1.quadBottomLeft, blob2.quadBottomLeft),
        quadBottomRight: mergeQuadBottomRight(blob1.quadBottomRight, blob2.quadBottomRight),
        area: blob1.area + blob2.area
    };
}
export function mergeQuadTopLeft(a: Vector, b: Vector): Vector {
    //(sqrt(x^2 + y^2) is too expensive => using x + y which gives similar quality)
    return (a.x + a.y < b.x + b.y) ? a : b;
}
export function mergeQuadTopRight(a: Vector, b: Vector): Vector {
    return (a.x - a.y > b.x - b.y) ? a : b;
}
export function mergeQuadBottomRight(a: Vector, b: Vector): Vector {
    return (a.x + a.y > b.x + b.y) ? a : b;
}
export function mergeQuadBottomLeft(a: Vector, b: Vector): Vector {
    return (a.x - a.y < b.x - b.y) ? a : b;
}

//Overlap
export function runsOverlap(run1: Run, run2: Run): boolean {
    //widen run1 to join diagonals, then check overlap
    return (run2.start >= run1.start-(run1.start==0?0:1) && run2.start <= run1.stop+1) ||
           (run2.stop  >= run1.start-(run1.start==0?0:1) && run2.stop  <= run1.stop+1) ||
           (run2.start <  run1.start-(run1.start==0?0:1) && run2.stop  >  run1.stop+1);
}

//Run to Blob
export function runToBlob(run: Run, line: number): BlobData {
    return {
        boundTopLeft:     {x:run.start , y:line  },
        boundBottomRight: {x:run.stop+1, y:line+1},
        quadTopLeft:      {x:run.start , y:line  },
        quadTopRight:     {x:run.stop  , y:line  },
        quadBottomLeft:   {x:run.start , y:line  },
        quadBottomRight:  {x:run.stop  , y:line  },
        area: run.stop - run.start + 1
    };
}