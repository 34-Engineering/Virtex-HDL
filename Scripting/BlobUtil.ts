import { max, min, Vector } from "./util/Math";

export interface BlobData {
    boundTopLeft: Vector,
    boundBottomRight: Vector,
    extremeTopLeft: Vector,
    extremeTopRight: Vector,
    extremeBottomLeft: Vector,
    extremeBottomRight: Vector,
    area: number
}
export interface Run {
    length: number,
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
        extremeTopLeft: mergeExtremeTopLeft(blob1.extremeTopLeft, blob2.extremeTopLeft),
        extremeTopRight: mergeExtremeTopRight(blob1.extremeTopRight, blob2.extremeTopRight),
        extremeBottomLeft: mergeExtremeBottomLeft(blob1.extremeBottomLeft, blob2.extremeBottomLeft),
        extremeBottomRight: mergeExtremeBottomRight(blob1.extremeBottomRight, blob2.extremeBottomRight),
        area: blob1.area + blob2.area
    };
}
//FIXME FIXME FIXME
export function mergeExtremeTopLeft(a: Vector, b: Vector): Vector {
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

//Overlap
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
        extremeTopLeft:      {x:start , y:line  },
        extremeTopRight:     {x:stop  , y:line  },
        extremeBottomLeft:   {x:start , y:line  },
        extremeBottomRight:  {x:stop  , y:line  },
        area: run.length
    };
}