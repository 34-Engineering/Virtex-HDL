"use strict";
//OtherUtil.ts (scripting only)
exports.__esModule = true;
exports.drawSILine = exports.drawLine = exports.drawQuad = exports.drawRect = exports.drawFillRect = exports.drawCenterFillSquare = exports.drawPixel = exports.drawEllipse = exports.calculateIDX = exports.BLOB_BRAM_PORT_DEFAULT = exports.EMPTY_BLOB = void 0;
var Constants_1 = require("./Constants");
//Blob Data
exports.EMPTY_BLOB = {
    boundTopLeft: { x: 0, y: 0 },
    boundBottomRight: { x: 0, y: 0 },
    quad: {
        topLeft: { x: 0, y: 0 },
        topRight: { x: 0, y: 0 },
        bottomRight: { x: 0, y: 0 },
        bottomLeft: { x: 0, y: 0 }
    },
    area: 0
};
exports.BLOB_BRAM_PORT_DEFAULT = {
    addr: 0,
    din: Object.assign({}, exports.EMPTY_BLOB),
    dout: Object.assign({}, exports.EMPTY_BLOB),
    wea: false
};
//Drawing on Raw Image Data
function calculateIDX(x, y) {
    return (Constants_1.IMAGE_WIDTH * Math.round(y) + Math.round(x)) << 2;
}
exports.calculateIDX = calculateIDX;
function drawEllipse(data, topLeft, bottomRight, color) {
    var center = {
        x: (topLeft.x + bottomRight.x) >> 1,
        y: (topLeft.y + bottomRight.y) >> 1
    };
    var radius = {
        x: center.x - topLeft.x + 1,
        y: center.y - topLeft.y + 1
    };
    drawPixel(data, center, color);
    var lv1 = undefined, lv2 = undefined;
    for (var x = center.x - radius.x; x <= center.x + radius.x; x++) {
        var q = radius.y * Math.sqrt((radius.x + center.x - x) * (radius.x - center.x + x));
        var y1 = (radius.x * center.y + q) / radius.x;
        var y2 = (radius.x * center.y - q) / radius.x;
        var v1 = { x: x, y: y1 };
        var v2 = { x: x, y: y2 };
        if (lv1 && lv2) {
            drawLine(data, lv1, v1, color);
            drawLine(data, lv2, v2, color);
        }
        lv1 = Object.assign({}, v1);
        lv2 = Object.assign({}, v2);
    }
}
exports.drawEllipse = drawEllipse;
function drawPixel(data, p, color) {
    p = { x: Math.round(p.x), y: Math.round(p.y) };
    // source: https://github.com/aloisdeniel/node-pngjs-draw/blob/master/index.js
    if (p.x < 0 || p.y < 0 || p.x > Constants_1.IMAGE_WIDTH - 1 || p.y > Constants_1.IMAGE_HEIGHT - 1)
        return;
    var idx = calculateIDX(p.x, p.y);
    var alpha = color[3] / 255.0;
    data[idx] = Math.round(color[0] * alpha + data[idx] * (1 - alpha));
    data[idx + 1] = Math.round(color[1] * alpha + data[idx + 1] * (1 - alpha));
    data[idx + 2] = Math.round(color[2] * alpha + data[idx + 2] * (1 - alpha));
}
exports.drawPixel = drawPixel;
function drawCenterFillSquare(data, p, offset, color) {
    drawFillRect(data, { x: p.x - offset, y: p.y - offset }, { x: p.x + offset, y: p.y + offset }, color);
}
exports.drawCenterFillSquare = drawCenterFillSquare;
function drawFillRect(data, topLeft, bottomRight, color) {
    for (var y = topLeft.y; y < bottomRight.y; y++) {
        for (var x = topLeft.x; x < bottomRight.x; x++) {
            drawPixel(data, { x: x, y: y }, color);
        }
    }
}
exports.drawFillRect = drawFillRect;
function drawRect(data, topLeft, bottomRight, color) {
    drawQuad(data, {
        topLeft: topLeft,
        topRight: { x: bottomRight.x, y: topLeft.y },
        bottomRight: bottomRight,
        bottomLeft: { x: topLeft.x, y: bottomRight.y }
    }, color);
}
exports.drawRect = drawRect;
function drawQuad(data, quad, color) {
    drawLine(data, { x: quad.topLeft.x, y: quad.topLeft.y }, { x: quad.topRight.x - 1, y: quad.topRight.y }, color);
    drawLine(data, { x: quad.topRight.x - 1, y: quad.topRight.y }, { x: quad.bottomRight.x - 1, y: quad.bottomRight.y - 1 }, color);
    drawLine(data, { x: quad.bottomRight.x - 1, y: quad.bottomRight.y - 1 }, { x: quad.bottomLeft.x, y: quad.bottomLeft.y - 1 }, color);
    drawLine(data, { x: quad.bottomLeft.x, y: quad.bottomLeft.y - 1 }, { x: quad.topLeft.x, y: quad.topLeft.y }, color);
}
exports.drawQuad = drawQuad;
function drawLine(data, p1, p2, color) {
    // derived from https://github.com/aloisdeniel/node-pngjs-draw/blob/master/index.js
    var x = Math.round(p1.x), y = Math.round(p1.y);
    var x1 = Math.round(p2.x), y1 = Math.round(p2.y);
    var dx = Math.abs(x1 - x), dy = Math.abs(y1 - y);
    var sx = (x < x1) ? 1 : -1, sy = (y < y1) ? 1 : -1;
    var err = dx - dy;
    while (x !== x1 || y !== y1) {
        drawPixel(data, { x: x, y: y }, color);
        var e2 = 2 * err;
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
exports.drawLine = drawLine;
function drawSILine(data, m, b, color) {
    for (var x = 0; x < 640; x++) {
        var y = m * x + b;
        drawPixel(data, { x: x, y: y }, color);
    }
}
exports.drawSILine = drawSILine;
