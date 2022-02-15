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
        quadTopRight:     {x:stop+1, y:line+1}, //TODO
        quadBottomLeft:   {x:start , y:line  },
        quadBottomRight:  {x:stop+1, y:line+1}, //TODO
        area: run.length
    };
}