

//20-bit Vector
export interface Vector {
    x: number,
    y: number
}

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

//Polygon
export function calcPolygonArea(points: Vector[]): number {
    let total = 0;
    for (let i = 0; i < points.length; i++) {
        const addX = points[i].x;
        const addY = points[i === points.length - 1 ? 0 : i + 1].y;
        const subX = points[i === points.length - 1 ? 0 : i + 1].x;
        const subY = points[i].y;
        total += (addX * addY * 0.5) - (subX * subY * 0.5);
    }
    return Math.abs(total);
}