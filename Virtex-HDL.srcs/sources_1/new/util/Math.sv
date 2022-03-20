`timescale 1ns / 1ps

/* Math - */
`ifndef MATH_DONE
`define MATH_DONE

//Clamp Functions
function automatic logic [9:0] min10(logic [9:0] num1, num2);
    //pick the lesser of num1 & num2
    return num1 < num2 ? num1 : num2;
endfunction

function automatic logic [9:0] max10(logic [9:0] num1, num2);
    //pick the greater of num1 & num2
    return num1 > num2 ? num1 : num2;
endfunction

//Overflow Functions (overflows number between 0 & max by 1 increment max)
function automatic logic [1:0] overflow2(logic [1:0] num, max);
    return num > max ? 0 : (num < 0 ? max : num);
endfunction
function automatic logic [9:0] overflow10(logic [9:0] num, max);
    return num > max ? 0 : (num < 0 ? max : num);
endfunction

//In Range Functions
function automatic logic inRangeInclusive16(logic [15:0] num, min, max);
    //if number is in range (inclusive / [])
    return num >= min & num <= max;
endfunction
function automatic logic inRangeInclusive24(logic [23:0] num, min, max);
    //if number is in range (inclusive / [])
    return num >= min & num <= max;
endfunction

//Difference
function automatic logic [9:0] diff10(logic [9:0] a, b);
    return (a > b) ? (a - b) : (b - a);
endfunction
function automatic logic [23:0] diff24(logic [23:0] a, b);
    return (a > b) ? (a - b) : (b - a);
endfunction

//Signed Functions
function automatic logic [9:0] abs10(logic signed [10:0] num);
    return num[10];
endfunction
function automatic logic [23:0] abs24(logic signed [24:0] num);
    return num[24];
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
    Vector [3:0] points = { quad.topLeft, quad.topRight, quad.bottomRight, quad.bottomLeft };
    logic [23:0] total = 0;
    for (int i = 0; i < 4; i = i + 1) begin
        total = total +
        ((points[i].x * points[i == 3 ? 0 : i+1].y) >> 1) - 
        ((points[i == 3 ? 0 : i+1].x * points[i].y) >> 1);
    end
    return total > 0 ? total : -total;
endfunction
function automatic logic isValidQuad(Quad quad);
    return (
        quad.topLeft.x < quad.topRight.x & //left < right
        quad.bottomLeft.x < quad.bottomRight.x &
        quad.topLeft.y < quad.bottomLeft.y & //bottom > top
        quad.topRight.y < quad.bottomRight.y
    );
endfunction

//Quick Division //FIXME better naming?
function automatic logic [9:0] quickDivide10(logic signed [10:0] dividend, divisor);
    //returns a 10-bit integer that correctlates to the real quotient
    logic [9:0] out = 0;
    for (reg [3:0] i = 0; i < 10; i++) begin
        out[i] = abs10(dividend) > (
            i < 5 ?
            abs10(divisor) >> diff10(5, i) :
            abs10(divisor) << diff10(5, i)
        );
    end
    return out;
endfunction

`endif