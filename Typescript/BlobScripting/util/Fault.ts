import { reg1 } from "./VerilogUtil";

//Fault
export interface Fault {
    PYTHON_300_PLL_FAULT: reg1, //python 300 PLL could not stabalize
    IR_LED_FAULT: reg1, //from MAX chip
    OUT_OF_BLOB_MEM_FAULT: reg1, //tried to create more blobs than available in mem => image is too noisy
    OUT_OF_RLE_MEM_FAULT: reg1, //out of runs => image is too noisy
    BLOB_POINTER_DEPTH_FAULT: reg1, //tried recursively following blob pointer, but it was too deep
    BLOB_PROCESSOR_TOO_SLOW_FAULT: reg1 //blob processor took too long on line(s)
};