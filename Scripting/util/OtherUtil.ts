//OtherUtil.ts (scripting only)

import { BlobData } from "../BlobUtil";
import { IMAGE_HEIGHT, IMAGE_WIDTH } from "./Constants";
import { Quad, Vector } from "./Math";

//Blob Data
export const EMPTY_BLOB: BlobData = {
    boundTopLeft: {x:0, y:0},
    boundBottomRight: {x:0, y:0},
    quad: {
        topLeft: {x:0, y:0},
        topRight: {x:0, y:0},
        bottomRight: {x:0, y:0},
        bottomLeft: {x:0, y:0},
    },
    centroid: {x:0,y:0},
    area: 0
};

//BRAM
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

//Drawing on Raw Image Data
export function calculateIDX(x: number, y: number): number {
    return (IMAGE_WIDTH * Math.round(y) + Math.round(x)) << 2;
}

export function drawEllipse(data: any, topLeft: Vector, bottomRight: Vector, color: number[]) {
    const center: Vector = {
        x: (topLeft.x + bottomRight.x) >> 1,
        y: (topLeft.y + bottomRight.y) >> 1
    };
    const radius: Vector = {
        x: center.x - topLeft.x + 1,
        y: center.y - topLeft.y + 1
    };

    drawPixel(data, center, color);

    let lv1: Vector | undefined = undefined, lv2: Vector | undefined = undefined;

    for (let x: number = center.x - radius.x; x <= center.x + radius.x; x++) {
        const q: number = radius.y*Math.sqrt((radius.x+center.x-x)*(radius.x-center.x+x));
        const y1: number = (radius.x*center.y + q) / radius.x;
        const y2: number = (radius.x*center.y - q) / radius.x;

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

export function drawCenterFillSquare(data: any, p: Vector, offset: number, color: number[]) {
    drawFillRect(data, { x: p.x-offset, y: p.y-offset }, { x: p.x+offset, y: p.y+offset }, color);
}

export function drawFillRect(data: any, topLeft: Vector, bottomRight: Vector, color: number[]) {
    for (let y = topLeft.y; y < bottomRight.y; y++) {
        for (let x = topLeft.x; x < bottomRight.x; x++) {
            drawPixel(data, {x, y}, color);
        }
    }
}

export function drawRect(data: any, topLeft: Vector, bottomRight: Vector, color: number[]) {
    drawQuad(data, {
        topLeft: topLeft,
        topRight: { x: bottomRight.x, y: topLeft.y },
        bottomRight: bottomRight,
        bottomLeft: { x: topLeft.x, y: bottomRight.y }
    }, color);
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
    // derived from https://github.com/aloisdeniel/node-pngjs-draw/blob/master/index.js
    let x = Math.round(p1.x), y = Math.round(p1.y);
    const x1 = Math.round(p2.x), y1 = Math.round(p2.y);
    const dx = Math.abs(x1-x), dy = Math.abs(y1-y);
    const sx = (x < x1)?1:-1, sy = (y < y1)?1:-1;
    let err = dx-dy;
    while (x !== x1 || y !== y1) {
        drawPixel(data, {x, y}, color);
        let e2 = 2 * err;
        if (e2 > -dy) {
            err -= dy;
            x += sx;
        }
        if (e2 < dx) {
            err += dx;
            y += sy;
        }
    }
}

export function drawSILine(data: any, m: number, b: number, color: number[]) {
    for (let x = 0; x < 640; x++) {
        const y = m*x + b;
        drawPixel(data, { x, y }, color);
    }
}