`timescale 1ns / 1ps

/* Math - */
`ifndef MATH_DONE
`define MATH_DONE

//20-bit Vector
typedef struct packed {
    logic [9:0] x, y;
} Vector;

//10-bit Range Functions
function automatic logic [9:0] min(logic [9:0] num1, num2);
    //pick the lesser of num1 & num2
    return num1 < num2 ? num1 : num2;
endfunction

function automatic logic [9:0] max(logic [9:0] num1, num2);
    //pick the greater of num1 & num2
    return num1 > num2 ? num1 : num2;
endfunction

function automatic logic [9:0] overflow1(logic [9:0] num, max);
    //overflow number between 0 & max by 1 increment max
    return num > max ? 0 : (num < 0 ? max : num);
endfunction

`endif