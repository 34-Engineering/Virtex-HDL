`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 34 Engineering
// Engineer: Liam Snow
// 
// Create Date: 06/28/2021
// Module Name: BlobProcessor
// Project Name: Virtex
// 
//////////////////////////////////////////////////////////////////////////////////

/* BlobProcessor -  
   Python 300 Notes: https://docs.google.com/document/d/1I_gz72WDF619c93o520tFeQNC_jHlEsQBOqtdv9CuxE/edit?usp=sharing*/
module BlobProcessor(
    input wire CLK200,
    input wire LVDS_CLK,
    input wire LVDS_SYNC,
    input wire [3:0] LVDS_DOUT
    );

    

    /* blob register reference
        bx1, by1, bx2, by2, 
        c{1-4}x1, c{1-4}y1, c{1-4}x2, c{1-4}y2
        
        ordered clockwise starting at the top left
        xy1  xy2
        xy4  xy3*/
    reg [9:0] blobs [99:0][12:0];



     /*
        Cheat sheet
        
    */

endmodule

let min(a,b) = a < b ? a : b;
let max(a,b) = a > b ? a : b;