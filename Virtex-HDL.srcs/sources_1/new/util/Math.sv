`timescale 1ns / 1ps

/* Math - */
`ifndef MATH_DONE
`define MATH_DONE

package Math;

    //Min/Max (picks the smaller/bigger number between the two)
    // let min(a, b) = (a < b) ? a : b;
    `define min(a, b) (a < b) ? a : b
    // let max(a, b) = (a > b) ? a : b;
    `define max(a, b) (a > b) ? a : b

    //Overflow (overflows number between 0 & max by 1 increment max)
    // let overflow(num, max) = (num > max) ? 0 : ((num < 0) ? max : num);
    `define overflow(num, max) (num > max) ? 0 : ((num < 0) ? max : num)

    //In Range
    // let inRangeInclusive(num, min, max) = num >= min & num <= max;
    `define inRangeInclusive(num, min, max) num >= min & num <= max

    //Difference
    // let diff(a, b) = (a > b) ? (a - b) : (b - a);
    `define diff(a, b) (a > b) ? (a - b) : (b - a)

    //Absolute Value (of signed number counted [N:0])
    // let abs(num) = num[$bits(num)-1];
    `define abs(num) num[$bits(num)-1]

    //Vector 2d 10-bit (20-bit total)
    typedef struct packed {
        logic [9:0] x, y;
    } Vector2d10;

    //Quad 2d 10-bit
    typedef struct packed { //80-bit
        /*Note: relative side of pixel
        ex) top left (0, 0) means pixel #(0, 0) whereas
            top right (1, 1) means pixel #(1, 0)
            bottom right (2, 2) means pixel #(1, 1)
        this makes area calculations easier*/
        Math::Vector2d10 topLeft;
        Math::Vector2d10 topRight;
        Math::Vector2d10 bottomRight;
        Math::Vector2d10 bottomLeft;
    } Quad10;
    // function automatic logic [23:0] calcQuad10Area(Quad10 quad);
    //     Math::Vector2d10 [3:0] points = { quad.topLeft, quad.topRight, quad.bottomRight, quad.bottomLeft };
    //     logic [23:0] total = 0;
    //     for (int i = 0; i < 4; i = i + 1) begin
    //         total = total +
    //         ((points[i].x * points[i == 3 ? 0 : i+1].y) >> 1) - 
    //         ((points[i == 3 ? 0 : i+1].x * points[i].y) >> 1);
    //     end
    //     return total > 0 ? total : -total;
    // endfunction
    // function automatic logic isValidQuad10(Quad10 quad);
    //     return (
    //         quad.topLeft.x < quad.topRight.x & //left < right
    //         quad.bottomLeft.x < quad.bottomRight.x &
    //         quad.topLeft.y < quad.bottomLeft.y & //bottom > top
    //         quad.topRight.y < quad.bottomRight.y
    //     );
    // endfunction

    //Quick Division //FIXME better naming?
    function automatic logic [9:0] quickDivide10(logic signed [10:0] dividend, divisor);
        //returns a 10-bit integer that correctlates to the real quotient
        logic [9:0] out = 0;
        for (reg [3:0] i = 0; i < 10; i++) begin
            out[i] = `abs(dividend) > (
                i < 5 ?
                `abs(divisor) >> `diff(5, i) :
                `abs(divisor) << `diff(5, i)
            );
        end
        return out;
    endfunction

endpackage

`endif