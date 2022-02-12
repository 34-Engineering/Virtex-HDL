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
export const EMPTY_BLOB: BlobData = {
    boundTopLeft: {x:0, y:0},
    boundBottomRight: {x:0, y:0},
    quadTopLeft: {x:0, y:0},
    quadTopRight: {x:0, y:0},
    quadBottomLeft: {x:0, y:0},
    quadBottomRight: {x:0, y:0},
    area: 0
};

export interface BlobBRAMPort {
    addr: number, 
    din: BlobData,
    dout: BlobData,
    ena: boolean,
    wea: boolean,
}

export const BLOB_BRAM_PORT_DEFAULT: BlobBRAMPort = {
    addr: 0,
    din: EMPTY_BLOB,
    dout: EMPTY_BLOB,
    ena: false,
    wea: false
}

export interface Run {
    start: number,
    end: number,
    blobID: number
}

export interface Kernel {
    value: boolean[],
    pos: Vector
}

//Range Functions
export function min(num1: number, num2: number): number {
    return num1 < num2 ? num1 : num2;
}

export function max(num1: number, num2: number): number {
    return num1 > num2 ? num1 : num2;
}