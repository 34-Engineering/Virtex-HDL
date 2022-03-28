// VerilogUtil - Types and Functions to simulate Verilog/FPGA behaivor

import { MAX_BLOBS, NULL_BLOB_INDEX } from "../BlobConstants";
import { BlobAngle, BlobData, Run, Target } from "../BlobUtil";
import { deepCopy } from "./DrawUtil";

//Types
export type reg1 = 0|1;
export let boolToReg1 = (bool: boolean): reg1 => bool ? 1 : 0;
export let invertReg1 = (reg: reg1): reg1 => boolToReg1(!Boolean(reg));
export type reg2 = 0|1|2|3;
export type reg3 = 0|1|2|3|4|5|6|7;
export type reg4 = 0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15;
export type reg8 = number;
export type reg10 = number;
export type signed_reg10 = number; //[10:0]
export type BlobIndex = number; //[MAX_BLOB_INDEX_SIZE-1:0]
export type RunBufferIndex = number; //[MAX_RUN_BUFFER_INDEX-1:0]
export type reg24 = number; //[23:0] (area)

//Run FIFO
export let runFIFOMem: Run[] = [];
let lastRunFIFOShifted: Run = {length:0, line:0, black:0};
export let runFIFOLength = () => runFIFOMem.length;
export let addToRunFIFO = (run: Run) => runFIFOMem.push(run);
export let clearRunFIFO = () => runFIFOMem = [];
export function processRunFIFO(obj: {read: reg1}): [reg1, Run] {
    if (obj.read) {
        if (runFIFOMem.length < 1) {
            console.error("ERROR CANNOT READ FROM EMPTY FIFO");
        }
        
        const out = runFIFOMem.shift();
        if (out != undefined) lastRunFIFOShifted = out;
    }
    
    return [
        boolToReg1(runFIFOMem.length < 1),
        lastRunFIFOShifted
    ];
}

//Blob BRAM
export let blobBRAMMem: BlobData[] = [...Array(MAX_BLOBS)].map(_=>(Object.assign({}, makeZeroBlobData())));
let lastAddra: BlobIndex = NULL_BLOB_INDEX;
let lastAddrb: BlobIndex = NULL_BLOB_INDEX;
let douta: BlobData, doutb: BlobData;
export function processBlobBRAM(obj: {addra: BlobIndex, dina: BlobData, wea: reg1, addrb: BlobIndex, dinb: BlobData, web: reg1}): [BlobData, BlobData] {
    //Port A Read/Write
    if (obj.wea) {
        blobBRAMMem[obj.addra] = deepCopy(obj.dina);
    }
    else {
        douta = deepCopy(blobBRAMMem[lastAddra]);
    }
    lastAddra = obj.addra;

    //Port B Read/Write
    if (obj.web) {
        blobBRAMMem[obj.addrb] = deepCopy(obj.dinb);
    }
    else {
        doutb = deepCopy(blobBRAMMem[lastAddrb]);
    }
    lastAddrb = obj.addrb;

    return [ douta, doutb ];
}

export function makeZeroBlobData(): BlobData {
    return {
        boundTopLeft: {x:0, y:0},
        boundBottomRight: {x:0, y:0},
        quad: {
            topLeft: {x:0, y:0},
            topRight: {x:0, y:0},
            bottomRight: {x:0, y:0},
            bottomLeft: {x:0, y:0},
        },
        area: 0
    };
}

export function makeZeroTarget(): Target {
    return {
        center: {x:0, y:0},
        width: 0,
        height: 0,
        blobCount: 0,
        angle: BlobAngle.HORIZONTAL
    }
}