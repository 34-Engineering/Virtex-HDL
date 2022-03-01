//Math.ts
import * as fs from 'fs';

//Range Functions
export function min(num1: number, num2: number): number {
    //returns the smaller of the two numbers
    return num1 < num2 ? num1 : num2;
}
export function max(num1: number, num2: number): number {
    //returns the larger of the two numbers
    return num1 > num2 ? num1 : num2;
}
export function overflow(num: number, max: number): number {
    //overflow number between 0 & max by 1 increment max
    //ex neg) overflow(-1, 2) = 2, overflow(-2, 2) = 2
    //ex pos) overflow(3, 2) = 0, overflow(4, 2) = 0
    //ex nor) overflow(0, 2) = 0, overflow(1, 2) = 1, overflow (2, 2) = 2
    return num > max ? 0 : (num < 0 ? max : num);
}
export function inRangeInclusive(num: number, min: number, max: number): boolean {
    //if number is in range (inclusive / [])
    return num >= min && num <= max;
}

//Vectors
export interface Vector { //20-bit
    x: number,
    y: number
}

//Polygons
export interface Quad { //80-bit
    /*Note: relative side of pixel
    ex) top left (0, 0) means pixel #(0, 0) whereas
        top right (1, 1) means pixel #(1, 0)
        bottom right (2, 2) means pixel #(1, 1)
    this makes area calculations easier*/
    topLeft: Vector,
    topRight: Vector,
    bottomRight: Vector,
    bottomLeft: Vector
}
export function quadToVectorArray(quad: Quad): Vector[] {
    return [ quad.topLeft, quad.topRight, quad.bottomRight, quad.bottomLeft ];
}
export function vectorArrayToQuad(points: Vector[]): Quad {
    return {
        topLeft: points[0],
        topRight: points[1],
        bottomRight: points[2],
        bottomLeft: points[3]
    };
}
export function calcQuadArea(quad: Quad): number {
    return calcPolygonArea(quadToVectorArray(quad));
}
export function calcPolygonArea(points: Vector[]): number {
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
export function isValidQuad(quad: Quad): boolean {
    return (
        quad.topLeft.x < quad.topRight.x && //left < right
        quad.bottomLeft.x < quad.bottomRight.x &&
        quad.topLeft.y < quad.bottomLeft.y && //bottom > top
        quad.topRight.y < quad.bottomRight.y
    );
}

//Quick Division //FIXME better naming? 
export function quickDivide(dividend: number, divisor: number): number {
    //returns a 10-bit integer that correctlates to the real quotient
    let str = '';
    for (let n = 5; n > 0; n--)
        str += Math.abs(dividend) > Math.abs(divisor) >> n ? 1:0;
    for (let n = 0; n < 5; n++)
        str += Math.abs(dividend) > Math.abs(divisor) << n ? 1:0;
    return parseInt(str, 2);
}