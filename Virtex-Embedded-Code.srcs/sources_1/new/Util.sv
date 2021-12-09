`timescale 1ns / 1ps

/* Util -  

    */
package Util;
    typedef struct {
        reg [9:0] x1, y1;
    } Vector;

    typedef struct {
        Vector boundingTopLeft, boundingBottomRight;
        Vector cornerTopLeft, cornerTopRight, cornerBottomRight, cornerBottomLeft;
        reg valid;
    } Blob;

    //function min
    //function max
    //function atan2
endpackage