`timescale 1ns / 1ps

/* Util -  

    */
package Util;
    //Structs
    typedef struct {
        bit [9:0] x1, y1;
    } Vector;

    typedef struct {
        Vector boundingTopLeft, boundingBottomRight;
        Vector cornerTopLeft, cornerTopRight, cornerBottomRight, cornerBottomLeft;
        bit valid = 0;
    } Blob;

    //Range
    function bit [9:0] min(input bit [9:0] num1, num2);
        return num1 < num2 ? num1 : num2;
    endfunction

    function bit [9:0] max(input bit [9:0] num1, num2);
        return num1 > num2 ? num1 : num2;
    endfunction
endpackage