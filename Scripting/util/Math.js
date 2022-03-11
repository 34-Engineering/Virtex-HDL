"use strict";
//Math.ts
exports.__esModule = true;
exports.quickDivide = exports.isValidQuad = exports.calcQuadArea = exports.inRangeInclusive = exports.overflow = exports.max = exports.min = void 0;
//Range Functions
function min(num1, num2) {
    //returns the smaller of the two numbers
    return num1 < num2 ? num1 : num2;
}
exports.min = min;
function max(num1, num2) {
    //returns the larger of the two numbers
    return num1 > num2 ? num1 : num2;
}
exports.max = max;
function overflow(num, max) {
    //overflow number between 0 & max by 1 increment max
    //ex neg) overflow(-1, 2) = 2, overflow(-2, 2) = 2
    //ex pos) overflow(3, 2) = 0, overflow(4, 2) = 0
    //ex nor) overflow(0, 2) = 0, overflow(1, 2) = 1, overflow (2, 2) = 2
    return num > max ? 0 : (num < 0 ? max : num);
}
exports.overflow = overflow;
function inRangeInclusive(num, min, max) {
    //if number is in range (inclusive / [])
    return num >= min && num <= max;
}
exports.inRangeInclusive = inRangeInclusive;
function calcQuadArea(quad) {
    var points = [quad.topLeft, quad.topRight, quad.bottomRight, quad.bottomLeft];
    var total = 0;
    for (var i = 0; i < points.length; i++) {
        var addX = points[i].x;
        var addY = points[i === points.length - 1 ? 0 : i + 1].y;
        var subX = points[i === points.length - 1 ? 0 : i + 1].x;
        var subY = points[i].y;
        total += ((addX * addY) >> 1) - ((subX * subY) >> 1);
    }
    return Math.abs(total);
}
exports.calcQuadArea = calcQuadArea;
function isValidQuad(quad) {
    return (quad.topLeft.x < quad.topRight.x && //left < right
        quad.bottomLeft.x < quad.bottomRight.x &&
        quad.topLeft.y < quad.bottomLeft.y && //bottom > top
        quad.topRight.y < quad.bottomRight.y);
}
exports.isValidQuad = isValidQuad;
//Quick Division //FIXME better naming? 
function quickDivide(dividend, divisor) {
    //returns a 10-bit integer that correctlates to the real quotient
    var out = [];
    for (var i = 0; i < 10; i++) {
        var n = Math.abs(5 - i);
        out[i] = Math.abs(dividend) > (i < 5 ? Math.abs(divisor) >> n : Math.abs(divisor) << n) ? 1 : 0;
    }
    return parseInt(out.join(""), 2);
}
exports.quickDivide = quickDivide;
