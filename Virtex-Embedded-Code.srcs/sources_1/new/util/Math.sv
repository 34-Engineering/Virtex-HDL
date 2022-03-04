`timescale 1ns / 1ps

/* Math - */
`ifndef MATH_DONE
`define MATH_DONE

//Range Functions
function automatic logic [9:0] min(logic [9:0] num1, num2);
    //pick the lesser of num1 & num2
    return num1 < num2 ? num1 : num2;
endfunction

function automatic logic [9:0] max(logic [9:0] num1, num2);
    //pick the greater of num1 & num2
    return num1 > num2 ? num1 : num2;
endfunction

function automatic logic [9:0] overflow(logic [9:0] num, max);
    //overflow number between 0 & max by 1 increment max
    return num > max ? 0 : (num < 0 ? max : num);
endfunction

//FIXME reg sizes?
function automatic logic inRangeInclusive(logic [15:0] num, min, max);
    //if number is in range (inclusive / [])
    return num >= min & num <= max;
endfunction

//20-bit Vector
typedef struct packed {
    logic [9:0] x, y;
} Vector;

typedef struct packed { //80-bit
    /*Note: relative side of pixel
    ex) top left (0, 0) means pixel #(0, 0) whereas
        top right (1, 1) means pixel #(1, 0)
        bottom right (2, 2) means pixel #(1, 1)
    this makes area calculations easier*/
    Vector topLeft;
    Vector topRight;
    Vector bottomRight;
    Vector bottomLeft;
} Quad;
function automatic logic [23:0] calcQuadArea(Quad quad);
    Vector[] points = { quad.topLeft, quad.topRight, quad.bottomRight, quad.bottomLeft };
    reg [23:0] total = 0;
    for (integer i = 0; i < 4; i = i + 1) begin
        total <= total + 
        ((points[i].x * points[i === 3 ? 0 : i+1].y) >> 1) - 
        ((points[i === 3 ? 0 : i+1].x * points[i].y) >> 1);
    end
    return Math.abs(total);
endfunction
function automatic logic isValidQuad(Quad quad);
    return (
        quad.topLeft.x < quad.topRight.x & //left < right
        quad.bottomLeft.x < quad.bottomRight.x &
        quad.topLeft.y < quad.bottomLeft.y & //bottom > top
        quad.topRight.y < quad.bottomRight.y
    );
endfunction

//Quick Division //FIXME better naming? //FIXME register size?
function automatic logic [15:0] quickDivide(logic [15:0] dividend, divisor);
    //returns a 10-bit integer that correctlates to the real quotient
    reg [9:0] out = 0;
    for (integer n = 9; n > 0; n--) begin
        str += Math.abs(dividend) > Math.abs(divisor) >> n ? 1:0;
    end
    return parseInt(str, 2);
endfunction

`endif