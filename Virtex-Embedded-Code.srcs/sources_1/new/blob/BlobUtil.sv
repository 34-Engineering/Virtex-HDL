`timescale 1ns / 1ps

/* BlobUtil -  */
`ifndef BLOB_UTIL_DONE
`define BLOB_UTIL_DONE

`include "../util/Math.sv"
`include "BlobConstants.sv"

//144-bit Blob
typedef struct packed {
    Vector boundTopLeft, boundBottomRight;
    Vector quadTopLeft, quadTopRight, quadBottomRight, quadBottomLeft;
    logic [23:0] area;
} Blob;

//Run
typedef struct packed {
    logic [9:0] length;
    logic [MAX_BLOB_ID_SIZE-1:0] blobID;
} Run;

//Run Buffer
typedef struct packed {
    Run [MAX_RUNS_PER_LINE-1:0] runs;
    logic [9:0] count; //number of runs filled
    logic [9:0] number;
} RunBuffer;

//Merge Blobs
function automatic Blob mergeBlobs(Blob blob1, blob2);
    return '{
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

//Overlap
function automatic logic runsOverlap(Run run1, logic [9:0] start1, Run run2, logic [9:0] start2);
    //widen run1 to join diagonals, then check overlap
    reg stop1 = run1.length + start1 - 1;
    reg stop2 = run2.length + start2 - 1;
    return (start2 >= start1-(start1==0?0:1) && start2 <= stop1+1) || //start2 inside run1
           (stop2  >= start1-(start1==0?0:1) && stop2  <= stop1+1) || //stop2 inside run1
           (start2 <  start1-(start1==0?0:1) && stop2  >  stop1+1);   //run2 covers all of run1
endfunction

//Run to Blob
function automatic Blob runToBlob(Run run, logic [9:0] start, logic [9:0] line);
    reg stop = run.length + start - 1;
    return '{
        boundTopLeft:     '{x:start , y:line  },
        boundBottomRight: '{x:stop+1, y:line+1},
        quadTopLeft:      '{x:start , y:line  },
        quadTopRight:     '{x:stop  , y:line  },
        quadBottomLeft:   '{x:start , y:line  },
        quadBottomRight:  '{x:stop  , y:line  },
        area: run.length
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