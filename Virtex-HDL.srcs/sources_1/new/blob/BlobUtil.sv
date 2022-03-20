`timescale 1ns / 1ps

/* BlobUtil -  */
`ifndef BLOB_UTIL_DONE
`define BLOB_UTIL_DONE

`include "../util/Math.sv"
`include "BlobConstants.sv"

//Blob Data
typedef struct packed { //144-bit
    /*Note: relative side of pixel
    ex) top left (0, 0) means pixel #(0, 0) whereas
        top right (1, 1) means pixel #(1, 0)
        bottom right (2, 2) means pixel #(1, 1)
    this makes area calculations easier*/
    Vector boundTopLeft;
    Vector boundBottomRight;
    Quad quad;
    logic [23:0] area;
} BlobData;

//Blob Metadata
typedef enum { UNSCANED, VALID, POINTER, GARBAGE } BlobStatus;
typedef struct packed {
    BlobStatus status;
    logic [MAX_BLOB_ID_SIZE-1:0] pointer;
} BlobMetadata;

//Blob Angles
typedef enum logic [1:0] {
    //calcAngle() has up to 2°? error (norm < 0.5°?)
    //quad calculation can have up to 20°? error (norm < 1°?)
    HORIZONTAL=0, /*  -- (90±~10°)  */
    VERTICAL=1,   /*  || (0±~10°)   */
    FORWARD=2,    /*  //            */
    BACKWARD=3    /*  \\            */
} BlobAngle;
typedef struct packed {
    logic horizontal;
    logic vertical;
    logic forward;
    logic backward;
    logic [11:0] reserved;
} BlobAnglesEnabled;

//?-bit Target
typedef struct packed {
    Vector center;
    logic [9:0] width;
    logic [9:0] height;
    logic [59:0] timestamp; //timestamp is replaced with latency (age) at delivery
    logic [3:0] blobCount;
    BlobAngle angle; //angle of blob A (SINGLE: angle of blob, DUAL: angle of left blob, GROUP: angle of chain start blob)
} Target;

//Target Mode
typedef enum logic [15:0] {
    SINGLE, //only mode without added latency
    DUAL_ANY, //note: may include other combinations besides DUAL_UP & DUAL_DOWN
    DUAL_UP,   /* // \\ */
    DUAL_DOWN, /* \\ // */
    GROUP //2+ targets chained together
} TargetMode;

//Run
typedef struct packed {
    logic [9:0] length;
    logic [MAX_BLOB_ID_SIZE-1:0] blobID;
} Run;

//Run Buffer
typedef struct packed {
    Run [MAX_RUNS_PER_LINE-1:0] runs;
    logic [MAX_RUNS_PER_LINE_POINTER_SIZE-1:0] count; //number of runs filled
    logic [9:0] line;
} RunBuffer;

//Merge Quads
function automatic Quad mergeQuads (Quad quad1, Quad quad2);
    //this algorithm is not perfect but close enough for choosing rough angle of blob
    return '{
        topLeft:     quad1.topLeft.x     + quad1.topLeft.y     < quad2.topLeft.x     + quad2.topLeft.y     ? quad1.topLeft     : quad2.topLeft,
        topRight:    quad1.topRight.x    - quad1.topRight.y    < quad2.topRight.x    - quad2.topRight.y    ? quad2.topRight    : quad1.topRight,
        bottomRight: quad1.bottomRight.x + quad1.bottomRight.y < quad2.bottomRight.x + quad2.bottomRight.y ? quad2.bottomRight : quad1.bottomRight,
        bottomLeft:  quad1.bottomLeft.x  - quad1.bottomLeft.y  < quad2.bottomLeft.x  - quad2.bottomLeft.y  ? quad1.bottomLeft  : quad2.bottomLeft
    };
endfunction

//Merging Blobs
function automatic BlobData mergeBlobs(BlobData blob1, BlobData blob2);
    return '{
        boundTopLeft: '{
            x: min10(blob1.boundTopLeft.x, blob2.boundTopLeft.x),
            y: min10(blob1.boundTopLeft.y, blob2.boundTopLeft.y)
        },
        boundBottomRight: '{
            x: max10(blob1.boundBottomRight.x, blob2.boundBottomRight.x),
            y: max10(blob1.boundBottomRight.y, blob2.boundBottomRight.y)
        },
        quad: mergeQuads(blob1.quad, blob2.quad),
        area: blob1.area + blob2.area
    };
endfunction

//Calculate Blob Angle
function automatic BlobAngle calcAngle(logic signed [9:0] dx, logic signed [9:0] dy);
    localparam t = 896; //best fit for 10° tolerance
    logic [9:0] h = quickDivide10(dx, dy); //how horizontal the line is
    logic [9:0] v = quickDivide10(dy, dx); //how vertical the line is
    return (h > t & v < t) ? HORIZONTAL :
           (h < t & v > t) ? VERTICAL   :
           (dx>0) ^ (dy>0) ? FORWARD : BACKWARD;
endfunction
function automatic BlobAngle calcBlobAngle(BlobData blob);
    //make two center lines from quad centers
    Vector start1 = '{
        x: (blob.quad.topLeft.x + blob.quad.topRight.x-1) >> 1,
        y: (blob.quad.topLeft.y + blob.quad.topRight.y) >> 1
    };
    Vector end1 = '{
        x: (blob.quad.bottomLeft.x   + blob.quad.bottomRight.x-1) >> 1,
        y: (blob.quad.bottomLeft.y-1 + blob.quad.bottomRight.y-1) >> 1
    };
    Vector start2 = '{
        x: (blob.quad.topLeft.x + blob.quad.bottomLeft.x) >> 1,
        y: (blob.quad.topLeft.y + blob.quad.bottomLeft.y-1) >> 1
    };
    Vector end2 = '{
        x: (blob.quad.topRight.x-1 + blob.quad.bottomRight.x-1) >> 1,
        y: (blob.quad.topRight.y   + blob.quad.bottomRight.y-1) >> 1
    };

    //calculate delta values of center lines
    logic signed [9:0] dx1 = end1.x - start1.x;
    logic signed [9:0] dy1 = end1.y - start1.y;
    logic signed [9:0] dx2 = end2.x - start2.x;
    logic signed [9:0] dy2 = end2.y - start2.y;

    //find angle of center lines
    BlobAngle angle1 = calcAngle(dx1, dy1);
    BlobAngle angle2 = calcAngle(dx2, dy2);

    //find length of center lines
    logic [18:0] lengthSq1 = dx1**2 + dy1**2;
    logic [18:0] lengthSq2 = dx2**2 + dy2**2;

    //return best angle
    return lengthSq1 > lengthSq2 ? angle1 : angle2;
endfunction

//Runs Overlap
function automatic logic runsOverlap(Run run1, logic [9:0] start1, Run run2, logic [9:0] start2);
    //widen run1 to join diagonals, then check overlap
    logic [9:0] stop1 = run1.length + start1 - 1;
    logic [9:0] stop2 = run2.length + start2 - 1;
    return (start2 >= start1-(start1==0?0:1) & start2 <= stop1+1) | //start2 inside run1
           (stop2  >= start1-(start1==0?0:1) & stop2  <= stop1+1) | //stop2 inside run1
           (start2 <  start1-(start1==0?0:1) & stop2  >  stop1+1);   //run2 covers all of run1
endfunction

//Run to Blob
function automatic BlobData runToBlob(Run run, logic [9:0] start, logic [9:0] line);
    logic [9:0] stop = run.length + start - 1;
    return '{
        boundTopLeft:     '{x:start , y:line  },
        boundBottomRight: '{x:stop+1, y:line+1},
        quad: '{
            topLeft:     '{x:start , y:line  },
            topRight:    '{x:stop+1, y:line  },
            bottomRight: '{x:stop+1, y:line+1},
            bottomLeft:  '{x:start , y:line+1}
        },
        area: run.length
    };
endfunction

//Get Target Age (returns age of the target in nanoseconds)
function automatic logic [59:0] getTargetAge(Target target);
    //TODO return currentTime - target.timestamp;
    return 2;
endfunction

//Is Target Stale
// function automatic logic isTargetStale(Target target);
//     //TODO
//     return target.timestamp == NULL_TIMESTAMP | getTargetAge(target) > TARGET_AGE_STALE;
// endfunction

`endif