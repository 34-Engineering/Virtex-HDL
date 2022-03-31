import { boolToReg1, reg1, reg10, signed_reg10 } from "./VerilogUtil";

//Range Functions
export function Math_min(num1: number, num2: number): number { //MACRO
    //returns the smaller of the two numbers
    return num1 < num2 ? num1 : num2;
}
export function Math_max(num1: number, num2: number): number { //MACRO
    //returns the larger of the two numbers
    return num1 > num2 ? num1 : num2;
}
export function Math_overflow(num: number, max: number): number { //MACRO
    //overflow number between 0 & max by 1 increment max
    return num > max ? 0 : (num < 0 ? max : num);
}
export function Math_inRangeInclusive(num: number, min: number, max: number): reg1 {  //MACRO
    //if number is in range (inclusive / [])
    return boolToReg1(num >= min && num <= max);
}
export function Math_diff(a: number, b: number): number { //MACRO
    return (a > b) ? (a - b) : (b - a);
}
export function Math_abs(num: number): number {
    return Math.abs(num); //will be diff in HDL
}

//Vectors
export interface Vector2d10 { //20-bit
    x: reg10,
    y: reg10
}

//Quad
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