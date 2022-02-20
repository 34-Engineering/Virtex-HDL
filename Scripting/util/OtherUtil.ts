//OtherUtil.ts (scripting only)

import { BlobData } from "../BlobUtil";
import { IMAGE_HEIGHT, IMAGE_WIDTH } from "./Constants";
import { Quad, Vector } from "./Math";

export const EMPTY_BLOB: BlobData = {
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

export function calculateIDX(x: number, y: number): number {
    return (IMAGE_WIDTH * Math.round(y) + Math.round(x)) << 2;
}

export function drawEllipse(data: any, p1: Vector, p2: Vector, p3: Vector, p4: Vector, color: number[]) {
    //FIXME
    let points: Vector[] = [ p1, p2, p3, p4 ];
    let left: Vector = points.reduce((a, b) => Math.min(a.x, b.x) ? a : b);
    let right: Vector = points.reduce((a, b) => Math.max(a.x, b.x) ? a : b);
    let top: Vector = points.reduce((a, b) => Math.min(a.y, b.y) ? a : b);
    let bottom: Vector = points.reduce((a, b) => Math.max(a.y, b.y) ? a : b);

    const center: Vector = {
        x: (left.x + right.x)/2.0,
        y: (p1.y + p4.y)/2.0
    };

    const radius = Math.sqrt((p1.x - center.x)**2 + (p1.y - center.y)**2);

    drawPixel(data, center, color);

    let lv1: Vector | undefined = undefined, lv2: Vector | undefined = undefined;

    for (let x: number = center.x - radius; x <= 1 + center.x + radius; x++) {
        const dy: number = Math.sqrt(Math.max(0, radius**2 - (x - center.x)**2));
        const y1: number = center.y + dy;
        const y2: number = center.y - dy;

        const v1: Vector = {x, y: y1};
        const v2: Vector = {x, y: y2};

        if (lv1 && lv2) {
            drawLine(data, lv1, v1, color);
            drawLine(data, lv2, v2, color);
        }
        
        lv1 = Object.assign({}, v1);
        lv2 = Object.assign({}, v2);
    }
}

export function drawPixel(data: any, p: Vector, color: number[]) {
    p = { x: Math.round(p.x), y: Math.round(p.y) };

    // source: https://github.com/aloisdeniel/node-pngjs-draw/blob/master/index.js
    if(p.x < 0 || p.y < 0 || p.x > IMAGE_WIDTH-1 || p.y > IMAGE_HEIGHT-1)
        return;

    const idx: number = calculateIDX(p.x, p.y);
    const alpha: number = color[3] / 255.0;
    data[idx]   = Math.round(color[0] * alpha + data[idx  ] * (1-alpha));
    data[idx+1] = Math.round(color[1] * alpha + data[idx+1] * (1-alpha));
    data[idx+2] = Math.round(color[2] * alpha + data[idx+2] * (1-alpha));
}

export function drawQuad(data: any, quad: Quad, color: number[]) {
    drawLine(
        data,
        { x: quad.topLeft.x   , y: quad.topLeft.y },
        { x: quad.topRight.x-1, y: quad.topRight.y },
        color
    );
    drawLine(
        data,
        { x: quad.topRight.x-1   , y: quad.topRight.y     },
        { x: quad.bottomRight.x-1, y: quad.bottomRight.y-1},
        color
    );
    drawLine(
        data,
        { x: quad.bottomRight.x-1, y: quad.bottomRight.y-1},
        { x: quad.bottomLeft.x   , y: quad.bottomLeft.y-1 },
        color
    );
    drawLine(
        data,
        { x: quad.bottomLeft.x, y: quad.bottomLeft.y-1},
        { x: quad.topLeft.x   , y: quad.topLeft.y   },
        color
    );
}

export function drawLine(data: any, p1: Vector, p2: Vector, color: number[]) {
    let x0 = Math.round(p1.x), y0 = Math.round(p1.y);
    let x1 = Math.round(p2.x), y1 = Math.round(p2.y);

    // source: https://github.com/aloisdeniel/node-pngjs-draw/blob/master/index.js
    var dx = Math.abs(x1-x0);
    var dy = Math.abs(y1-y0);
    var sx = (x0 < x1) ? 1 : -1;
    var sy = (y0 < y1) ? 1 : -1;
    var err = dx-dy;

    while(true){
        drawPixel(data, {x: x0, y: y0}, color);

        if ((x0==x1) && (y0==y1)) break;
        var e2 = 2*err;
        if (e2 >-dy){ err -= dy; x0  += sx; }
        if (e2 < dx){ err += dx; y0  += sy; }
    }
}