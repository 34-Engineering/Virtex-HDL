import { BlobData } from "../BlobUtil";
import { IMAGE_WIDTH } from "./Constants";
import { Vector } from "./Math";

//PythonUtil
export interface Kernel {
    value: boolean[],
    pos: Vector,
    valid: boolean
}
export const KERNEL_MAX_X = IMAGE_WIDTH / 8 - 1;

//(scripting only)
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