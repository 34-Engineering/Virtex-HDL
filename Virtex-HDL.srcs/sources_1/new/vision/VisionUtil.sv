`timescale 1ns / 1ps

/* BlobUtil -  */
`ifndef BLOB_UTIL_DONE
`define BLOB_UTIL_DONE

`include "../util/Math.sv"
`include "VisionConstants.sv"

//Index Types
typedef logic [$clog2(MAX_BLOBS+3)-1:0] BlobIndex; //+3 is to account for NULL_BLOB_INDEX & NULL_BLACK_RUN_BLOB_INDEX)
typedef logic [$clog2(MAX_RUNS_PER_LINE+2)-1:0] RunBufferIndex; //FIXME what is the +2 for? there is no null, dont we just need +1?
typedef logic [$clog2((640*480) + GROUP_TARGET_AREA_CONST + 1):0] BlobArea; //[20:0]

//Blob Data
typedef struct packed { //144-bit
    /*Note: relative side of pixel
    ex) top left (0, 0) means pixel #(0, 0) whereas
        top right (1, 1) means pixel #(1, 0)
        bottom right (2, 2) means pixel #(1, 1)
    this makes area calculations easier*/
    Math::Vector2d10 boundTopLeft; //20-bit
    Math::Vector2d10 boundBottomRight; //20-bit
    Math::Quad10 quad; //80-bit
    BlobArea area;
    logic [2:0] reserved;
} BlobData;

//Blob Metadata
typedef enum { UNSCANED, VALID, POINTER, GARBAGE } BlobStatus;
typedef struct packed {
    BlobStatus status;
    BlobIndex pointer;
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

//Target
typedef struct packed { //48-bit
    Math::Vector2d10 center; //20-bit
    logic [9:0] width;
    logic [9:0] height;
    logic [5:0] blobCount;
    BlobAngle angle; //2-bit - angle of blob A (SINGLE: angle of blob, DUAL: angle of left blob, GROUP: angle of chain start blob)
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
typedef struct packed { //21-bit
    logic [9:0] length, line;
    logic black;
} Run;

//Run Buffer
typedef struct packed {
    logic [9:0] start, stop; //used start & stop for run buffer so it can be
    BlobIndex blobIndex;     //processed in one clock cylce w/ for-statement
} RunBufferRun;
typedef struct packed {
    RunBufferRun [MAX_RUNS_PER_LINE-1:0] runs;
    RunBufferIndex count; //number of runs filled (valid = [count-1:0])
    logic [9:0] line;
} RunBuffer;

//Merge Quads
function automatic Math::Quad10 mergeQuad10s (Math::Quad10 quad1, Math::Quad10 quad2);
    reg signed [12:0] quad1TopLeftD     = quad1.topLeft.x     + quad1.topLeft.y;
    reg signed [12:0] quad2TopLeftD     = quad2.topLeft.x     + quad2.topLeft.y;
    reg signed [12:0] quad1TopRightD    = quad1.topRight.x    - quad1.topRight.y;
    reg signed [12:0] quad2TopRightD    = quad2.topRight.x    - quad2.topRight.y;
    reg signed [12:0] quad1BottomRightD = quad1.bottomRight.x + quad1.bottomRight.y;
    reg signed [12:0] quad2BottomRightD = quad2.bottomRight.x + quad2.bottomRight.y;
    reg signed [12:0] quad1BottomLeftD  = quad1.bottomLeft.x  - quad1.bottomLeft.y;
    reg signed [12:0] quad2BottomLeftD  = quad2.bottomLeft.x  - quad2.bottomLeft.y;

    //does not create a perfect quad, but is good enough for rough angle calculations
    return '{
        topLeft:     quad1TopLeftD     < quad2TopLeftD     ? quad1.topLeft     : quad2.topLeft,
        topRight:    quad1TopRightD    < quad2TopRightD    ? quad2.topRight    : quad1.topRight,
        bottomRight: quad1BottomRightD < quad2BottomRightD ? quad2.bottomRight : quad1.bottomRight,
        bottomLeft:  quad1BottomLeftD  < quad2BottomLeftD  ? quad1.bottomLeft  : quad2.bottomLeft
    };
endfunction

//Merging Blobs
function automatic BlobData mergeBlobs(BlobData blob1, BlobData blob2);
    return '{
        boundTopLeft: '{
            x: `Math_min(blob1.boundTopLeft.x, blob2.boundTopLeft.x),
            y: `Math_min(blob1.boundTopLeft.y, blob2.boundTopLeft.y)
        },
        boundBottomRight: '{
            x: `Math_max(blob1.boundBottomRight.x, blob2.boundBottomRight.x),
            y: `Math_max(blob1.boundBottomRight.y, blob2.boundBottomRight.y)
        },
        quad: mergeQuad10s(blob1.quad, blob2.quad),
        area: blob1.area + blob2.area,
        reserved: '0
    };
endfunction

//Calculate Blob Angle
function automatic BlobAngle calcAngle(logic signed [10:0] dx, logic signed [10:0] dy);
    localparam t = 896; //best fit for 10° tolerance
    logic [9:0] h = Math::quickDivide10(dx, dy); //how horizontal the line is
    logic [9:0] v = Math::quickDivide10(dy, dx); //how vertical the line is
    return (h > t & v < t) ? HORIZONTAL :
           (h < t & v > t) ? VERTICAL   :
           (dx>0) ^ (dy>0) ? FORWARD : BACKWARD;
endfunction
function automatic BlobAngle calcBlobAngle(BlobData blob);
    //make two center lines from quad centers
    Math::Vector2d10 start1 = '{
        x: (blob.quad.topLeft.x + blob.quad.topRight.x-1) >> 1, //FIXME outputs before shift may be > 1023
        y: (blob.quad.topLeft.y + blob.quad.topRight.y) >> 1
    };
    Math::Vector2d10 end1 = '{
        x: (blob.quad.bottomLeft.x   + blob.quad.bottomRight.x-1) >> 1,
        y: (blob.quad.bottomLeft.y-1 + blob.quad.bottomRight.y-1) >> 1
    };
    Math::Vector2d10 start2 = '{
        x: (blob.quad.topLeft.x + blob.quad.bottomLeft.x) >> 1,
        y: (blob.quad.topLeft.y + blob.quad.bottomLeft.y-1) >> 1
    };
    Math::Vector2d10 end2 = '{
        x: (blob.quad.topRight.x-1 + blob.quad.bottomRight.x-1) >> 1,
        y: (blob.quad.topRight.y   + blob.quad.bottomRight.y-1) >> 1
    };

    //calculate delta values of center lines
    logic signed [12:0] dx1 = end1.x - start1.x;
    logic signed [12:0] dy1 = end1.y - start1.y;
    logic signed [12:0] dx2 = end2.x - start2.x;
    logic signed [12:0] dy2 = end2.y - start2.y;

    //find angle of center lines
    BlobAngle angle1 = calcAngle(dx1, dy1);
    BlobAngle angle2 = calcAngle(dx2, dy2);

    //find length of center lines
    logic [20:0] lengthSq1 = dx1**2 + dy1**2;
    logic [20:0] lengthSq2 = dx2**2 + dy2**2;

    //return best angle
    return lengthSq1 > lengthSq2 ? angle1 : angle2;
endfunction

//Runs Overlap
function automatic logic runsOverlap(reg [9:0] start1, stop1, start2, stop2);
    //widen run1 to join diagonals, then check overlap
    return (
        (start2 >= start1-(start1==0?0:1) && start2 <= stop1+1) || //start2 inside run1
        (stop2  >= start1-(start1==0?0:1) && stop2  <= stop1+1) || //stop2 inside run1
        (start2 <  start1-(start1==0?0:1) && stop2  >  stop1+1)    //run2 covers all of run1
    );
endfunction

//Run to Blob
function automatic BlobData runToBlob(reg [9:0] start, length, line);
    reg [9:0] stop = length + start - 1;
    return '{
        boundTopLeft:     '{x:start , y:line  },
        boundBottomRight: '{x:stop+1, y:line+1},
        quad: '{
            topLeft:      '{x:start , y:line  },
            topRight:     '{x:stop+1, y:line  },
            bottomRight:  '{x:stop+1, y:line+1},
            bottomLeft:   '{x:start , y:line+1}
        },
        area: length,
        reserved: '0
    };
endfunction

//Target Null
function automatic logic isTargetNull(Target target);
    return target.blobCount == 0;
endfunction

//In Range/Valid //TODO
function automatic logic inAspectRatioRange(logic [9:0] width, height, logic [15:0] min, max);
    /*
    fixed point notes:
    multiply the two numbers as integers and shfit back by the Q num decimal places (which means output int will be very big at first)
    we should make specific helper functions for multity each config BLOB UTIL FTW
    */
    //width, //TODO fixed point mult
    //virtexConfig.targetAspectRatioMin*height, virtexConfig.targetAspectRatioMax*height
    return 1;
endfunction
function automatic logic inFullnessRange(BlobArea area, boundArea, logic [15:0] min, max);
    return 1;
endfunction
function automatic logic inBoundAreaRatioRange(BlobArea area1, area2, logic [15:0] min, max);
    return 1;
endfunction
function automatic logic inBoundAreaRange(BlobArea area, logic [15:0] min, max);
    return `Math_inRangeInclusive(area >> 3, min, max);
endfunction

//Group Target (target stored in Blob BRAM)
typedef struct packed {
    Math::Vector2d10 boundTopLeft, boundBottomRight; //20-bit
    logic [5:0] blobCount;
    BlobArea blobBoundArea; //20-bit
} GroupTarget;
function automatic GroupTarget asGroupTarget(BlobData blob);
    return '{
        boundTopLeft: blob.boundTopLeft,
        boundBottomRight: blob.boundBottomRight,
        blobCount: blob.quad.topLeft.x,
        blobBoundArea: blob.area - GROUP_TARGET_AREA_CONST
    };
endfunction
function automatic BlobData asBlob(GroupTarget groupTarget);
    return '{
        boundTopLeft: groupTarget.boundTopLeft,
        boundBottomRight: groupTarget.boundBottomRight,
        quad: '{
            topLeft: '{x:groupTarget.blobCount, y:'0},
            topRight: '0,
            bottomRight: '0,
            bottomLeft: '0
        },
        area: groupTarget.blobBoundArea + GROUP_TARGET_AREA_CONST,
        reserved: '0
    };
endfunction
function automatic logic isGroupTarget(BlobData blob);
    return blob.area > GROUP_TARGET_AREA_CONST;
endfunction
function automatic GroupTarget mergeGroupTargets(GroupTarget groupTargetA, groupTargetB);
    return '{
        boundTopLeft: '{
            x: `Math_min(groupTargetA.boundTopLeft.x, groupTargetB.boundTopLeft.x),
            y: `Math_min(groupTargetA.boundTopLeft.y, groupTargetB.boundTopLeft.y)
        },
        boundBottomRight: '{
            x: `Math_max(groupTargetA.boundBottomRight.x, groupTargetB.boundBottomRight.x),
            y: `Math_max(groupTargetA.boundBottomRight.y, groupTargetB.boundBottomRight.y)
        },
        blobCount: groupTargetA.blobCount + groupTargetB.blobCount,
        blobBoundArea: groupTargetA.blobBoundArea
    };
endfunction
function automatic Target groupTargetToTarget(GroupTarget groupTarget);
    return '{
        center: '{
            x: (groupTarget.boundBottomRight.x + groupTarget.boundTopLeft.x) >> 1,
            y: (groupTarget.boundBottomRight.y + groupTarget.boundTopLeft.y) >> 1
        },
        width:  groupTarget.boundBottomRight.x - groupTarget.boundTopLeft.x + 1,
        height: groupTarget.boundBottomRight.y - groupTarget.boundTopLeft.y + 1,
        blobCount: groupTarget.blobCount,
        angle: HORIZONTAL
    };
endfunction
function automatic GroupTarget makeGroupTarget(BlobData blob);
    return '{
        boundTopLeft: blob.boundTopLeft,
        boundBottomRight: blob.boundBottomRight,
        blobCount: 1,
        blobBoundArea: (blob.boundBottomRight.x - blob.boundTopLeft.x + 1) * (blob.boundBottomRight.y - blob.boundTopLeft.y + 1) //boundArea = boundWidth * boundHeight
    };
endfunction

`endif