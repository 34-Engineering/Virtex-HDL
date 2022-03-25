//Math.ts

import { reg10, signed_reg10 } from "./VerilogUtil";

//Range Functions
export function min(num1: number, num2: number): number { //MACRO
    //returns the smaller of the two numbers
    return num1 < num2 ? num1 : num2;
}
export function max(num1: number, num2: number): number { //MACRO
    //returns the larger of the two numbers
    return num1 > num2 ? num1 : num2;
}
export function overflow(num: number, max: number): number { //MACRO
    //overflow number between 0 & max by 1 increment max
    return num > max ? 0 : (num < 0 ? max : num);
}
export function inRangeInclusive(num: number, min: number, max: number): boolean {  //MACRO
    //if number is in range (inclusive / [])
    return num >= min && num <= max;
}

//Vector2d10s
export interface Vector2d10 { //20-bit
    x: reg10,
    y: reg10
}

//Polygons
export interface Quad10 { //80-bit
    /*Note: relative side of pixel
    ex) top left (0, 0) means pixel #(0, 0) whereas
        top right (1, 1) means pixel #(1, 0)
        bottom right (2, 2) means pixel #(1, 1)
    this makes area calculations easier*/
    topLeft: Vector2d10,
    topRight: Vector2d10,
    bottomRight: Vector2d10,
    bottomLeft: Vector2d10
}
export function calcQuad10Area(quad: Quad10): number {
    const points: Vector2d10[] = [ quad.topLeft, quad.topRight, quad.bottomRight, quad.bottomLeft ];
    let total = 0;
    for (let i = 0; i < points.length; i++) {
        const addX = points[i].x;
        const addY = points[i === points.length- 1 ? 0 : i+1].y;
        const subX = points[i === points.length- 1 ? 0 : i+1].x;
        const subY = points[i].y;
        total += ((addX * addY) >> 1) - ((subX * subY) >> 1);
    }
    return Math.abs(total);
}
export function isValidQuad10(quad: Quad10): boolean {
    return (
        quad.topLeft.x < quad.topRight.x && //left < right
        quad.bottomLeft.x < quad.bottomRight.x &&
        quad.topLeft.y < quad.bottomLeft.y && //bottom > top
        quad.topRight.y < quad.bottomRight.y
    );
}

//Quick Division //FIXME better naming? 
export function quickDivide(dividend: signed_reg10, divisor: signed_reg10): reg10 {
    //returns a 10-bit integer that correctlates to the real quotient
    let out: number[] = [];
    for (let i = 0; i < 10; i++) {
        const n = Math.abs(5 - i);
        out[i] = Math.abs(dividend) > (i < 5 ? Math.abs(divisor) >> n : Math.abs(divisor) << n) ? 1:0;
    }
    return parseInt(out.join(""), 2);
}