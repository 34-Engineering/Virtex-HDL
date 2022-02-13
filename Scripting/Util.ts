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
    wea: boolean,
}
export const BLOB_BRAM_PORT_DEFAULT: BlobBRAMPort = {
    addr: 0,
    din: Object.assign({}, EMPTY_BLOB),
    dout: Object.assign({}, EMPTY_BLOB),
    wea: false
}

export interface Run {
    start: number,
    end: number,
    blobID: number
}
export interface RunBuffer {
    runs: Run[],
    count: number //number of runs
    line: number
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

export function overflow(num: number, max: number): number { //overflow number between 0 & max by 1 increment max
    return num > max ? 0 : (num < 0 ? max : num);
}

//Fault
export enum Fault {
    NO_FAULT = 0,
    PYTHON_300_PLL_FAULT = 1, //python 300 PLL could not stabalize
    IR_LED_FAULT = 2, //from MAX chip
    OUT_OF_BLOB_MEM_FAULT = 3, //tried to create more blobs than available in mem => image is too noisy
    OUT_OF_RLE_MEM_FAULT = 4, //out of runs => image is too noisy
    BLOB_POINTER_DEPTH_FAULT = 5, //tried recursively following blob pointer, but it was too deep
    BLOB_PROCESSOR_TOO_SLOW_FAULT = 6 //blob processor took too long on line(s)
};