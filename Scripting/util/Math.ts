//Math.ts

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
export interface Vector { //20-bit //TODO VectorU20?
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
export function calcQuadArea(quad: Quad): number {
    const points: Vector[] = [ quad.topLeft, quad.topRight, quad.bottomRight, quad.bottomLeft ];
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
    let out: number[] = [];
    for (let i = 0; i < 10; i++) {
        const n = Math.abs(5 - i);
        out[i] = Math.abs(dividend) > (i < 5 ? Math.abs(divisor) >> n : Math.abs(divisor) << n) ? 1:0;
    }
    return parseInt(out.join(""), 2);
}