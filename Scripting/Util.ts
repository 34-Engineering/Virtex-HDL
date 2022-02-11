//Util.ts

//Structs
export interface Vector {
    x: number,
    y: number
}
export interface BlobData {
    boundTopLeft: Vector,
    boundBottomRight: Vector,
    quadTopLeft: Vector,
    quadTopRight: Vector,
    quadBottomLeft: Vector,
    quadBottomRight: Vector,
    area: number
}
export interface BlobDataChunk1 {
    boundTopLeft: Vector,
    boundBottomRight: Vector
}

export interface BlobDataChunk2 {
    quadTopLeft: Vector,
    quadTopRight: Vector,
    quadBottomLeft: Vector,
    quadBottomRight: Vector,
    area: number
}
export interface Run {
    start: number,
    end: number,
    blobID: number
}

//Range Functions
export function min(num1: number, num2: number): number {
    return num1 < num2 ? num1 : num2;
}

export function max(num1: number, num2: number): number {
    return num1 > num2 ? num1 : num2;
}