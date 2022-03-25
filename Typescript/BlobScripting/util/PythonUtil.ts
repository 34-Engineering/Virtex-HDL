//PythonUtil.ts

import { IMAGE_WIDTH } from "./Constants";
import { Vector2d10 } from "./Math";
import { reg8 } from "./VerilogUtil";

export interface Kernel {
    value: reg8,
    pos: Vector2d10
}
export const KERNEL_MAX_X = IMAGE_WIDTH / 8 - 1;