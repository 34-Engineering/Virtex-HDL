`timescale 1ns / 1ps

/* Util -  

    */
package Util;
    //Types
    typedef struct {
        bit [9:0] x, y;
    } Vector;

    typedef struct {
        Vector boundingTopLeft, boundingBottomRight;
        Vector cornerTopLeft, cornerTopRight, cornerBottomRight, cornerBottomLeft;
        bit valid = 0;
    } Blob;

    typedef enum {
       OFF=0, ON_VERTICAL=1, ON_HORIZONTAL=2, ON_DIAGONAL=3
    } DualObjectMode;

    typedef enum {
       NORMAL=0, COUNTER_CLOCKWISE_90=1, UPSIDE_DOWN=2, CLOCKWISE_90=3
    } Orientation;

    //Range
    function bit [9:0] min(input bit [9:0] num1, num2);
        return num1 < num2 ? num1 : num2;
    endfunction

    function bit [9:0] max(input bit [9:0] num1, num2);
        return num1 > num2 ? num1 : num2;
    endfunction
endpackage