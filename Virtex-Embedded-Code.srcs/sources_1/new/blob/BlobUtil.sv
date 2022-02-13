`timescale 1ns / 1ps

/* BlobUtil -  */
`ifndef BLOB_UTIL_DONE
`define BLOB_UTIL_DONE

`include "../util/Math.sv"

//144-bit Blob
typedef struct packed {
    Vector boundTopLeft, boundBottomRight;
    Vector quadTopLeft, quadTopRight, quadBottomRight, quadBottomLeft;
    logic [23:0] area;
} Blob;

//30-bit Run
typedef struct packed {
    logic [9:0] start, stop;
    logic [9:0] blobID; //FIXME
} Run;

//
typedef struct packed {
    Run [1:0] runs; //FIXME
    logic [9:0] count; //number of runs
    logic [9:0] number;
} RunBuffer;

//Merge Blobs
function automatic Blob mergeBlobs(Blob blob1, blob2);
    return '{ //FIXME
        boundTopLeft: '{
            x: min(blob1.boundTopLeft.x, blob2.boundTopLeft.x),
            y: min(blob1.boundTopLeft.y, blob2.boundTopLeft.y)
        },
        boundBottomRight: '{
            x: max(blob1.boundBottomRight.x, blob2.boundBottomRight.x),
            y: max(blob1.boundBottomRight.y, blob2.boundBottomRight.y)
        },
        quadTopLeft: mergeQuadTopLeft(blob1.quadTopLeft, blob2.quadTopLeft),
        quadTopRight: mergeQuadTopRight(blob1.quadTopRight, blob2.quadTopRight),
        quadBottomLeft: mergeQuadBottomLeft(blob1.quadBottomLeft, blob2.quadBottomLeft),
        quadBottomRight: mergeQuadBottomRight(blob1.quadBottomRight, blob2.quadBottomRight),
        area: blob1.area + blob2.area
    };
endfunction

//Merge Quads
function automatic Vector mergeQuadTopLeft(Vector a, b);
    //(sqrt(x^2 + y^2) is too expensive => using x + y which gives similar quality)
    return (a.x + a.y < b.x + b.y) ? a : b;
endfunction
function automatic Vector mergeQuadTopRight(Vector a, b);
    return (a.x - a.y > b.x - b.y) ? a : b;
endfunction
function automatic Vector mergeQuadBottomRight(Vector a, b);
    return (a.x + a.y > b.x + b.y) ? a : b;
endfunction
function automatic Vector mergeQuadBottomLeft(Vector a, b);
    return (a.x - a.y < b.x - b.y) ? a : b;
endfunction

//Run to Blob
function automatic Blob runToBlob(Vector pos); //FIXME
    return '{
        boundTopLeft:     '{x:pos.x  , y:pos.y  },
        boundBottomRight: '{x:pos.x+1, y:pos.y+1},
        quadTopLeft:      '{x:pos.x  , y:pos.y  },
        quadTopRight:     '{x:pos.x+1, y:pos.y  },
        quadBottomLeft:   '{x:pos.x  , y:pos.y+1},
        quadBottomRight:  '{x:pos.x+1, y:pos.y+1},
        area: 1
    };
endfunction

//Calculate Slope
function automatic real calculateSlope(Blob blob);
    //calculates slope of bottom line of the quad
    //instead of calculating the angle on the fpga with atand we do it on the roborio
    //before setting the config setting
    //bounded between -1 and 1
    //todo handle different angles (the bottom line changes)
    return ((blob.cornerBottomLeft.y - blob.cornerBottomRight.y) / (blob.cornerBottomLeft.x - blob.cornerBottomRight.x));
endfunction

`endif