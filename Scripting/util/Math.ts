

//20-bit Vector
export interface Vector {
    x: number,
    y: number
}

//Range Functions
export function min(num1: number, num2: number): number {
    return num1 < num2 ? num1 : num2;
}
export function max(num1: number, num2: number): number {
    return num1 > num2 ? num1 : num2;
}
export function overflow(num: number, max: number): number {
    //overflow number between 0 & max by 1 increment max
    return num > max ? 0 : (num < 0 ? max : num);
}