//PythonUtil.ts

import { IMAGE_WIDTH } from "./Constants";
import { Vector } from "./Math";

export interface Kernel {
    value: boolean[],
    pos: Vector,
    valid: boolean
}
export const KERNEL_MAX_X = IMAGE_WIDTH / 8 - 1;