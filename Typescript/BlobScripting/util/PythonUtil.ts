//PythonUtil.ts

import { IMAGE_WIDTH } from "./Constants";
import { Vector2d10 } from "./Math";

export interface Kernel {
    value: boolean[],
    pos: Vector2d10,
    valid: boolean
}
export const KERNEL_MAX_X = IMAGE_WIDTH / 8 - 1;