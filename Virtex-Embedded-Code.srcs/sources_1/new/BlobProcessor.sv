`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 34 Engineering
// Engineer: Liam Snow
// 
// Create Date: 06/28/2021 09:54:34 PM
// Module Name: BlobProcessor
// Project Name: Virtex
// 
//////////////////////////////////////////////////////////////////////////////////

/* BlobProcessor - Processes on AXI-4 Stream and outputs to Top.targetBlob & Top.targetBlobValid */
module BlobProcessor(
    input CLK200,
    input [7:0] TDATA,
    input [63:0] TUSER,
    input TVALID
    );

    /*
        TUSER
        63-48 Word Count
        47-32 Line Number
        31-16 Frame Number
        15-2 Reserved
        1 Packet Error
        0 Start of Frame
    */

    /* blob register reference
        bx1, by1, bx2, by2, 
        c{1-4}x1, c{1-4}y1, c{1-4}x2, c{1-4}y2
        
        ordered clockwise starting at the top left
        xy1  xy2
        xy4  xy3*/
    reg [9:0] blobs [99:0][12:0];

    // always @(posedge CLK && active_video) begin
    //     //pixel
    //     if (vsync && hsync) begin
    //         //TODO: send pixel to USB
            
    //         pixel <= data > Top.threshold;
            
    //         didTouch <= 0;
        
    //         //detect collision w/ existing blobs
    //         for (b=0; b<blobIndex; b=b+1) begin
    //             if (blobs[b][13] && x+2 > blobs[b][1] && x-2 < blobs[b][3] && y+2 > blobs[b][2] && y-2 < blobs[b][4]) begin
    //                 //merge blobs
    //                 if (didTouch) begin
    //                     blobs[touching][13] = 0;
                        
    //                     blobs[b][1] <= min(blobs[b][1], blobs[touching][1]);
    //                     blobs[b][2] <= min(blobs[b][2], blobs[touching][2]);
    //                     blobs[b][3] <= max(blobs[b][3], blobs[touching][3]);
    //                     blobs[b][4] <= max(blobs[b][4], blobs[touching][4]);
                                            
    //                     if (blobs[touching][5]+blobs[touching][6] < blobs[b][5]+blobs[b][6]) begin
    //                         blobs[b][5] <= blobs[touching][5];
    //                         blobs[b][6] <= blobs[touching][6];
    //                     end 
    //                     else if (blobs[touching][7]-blobs[touching][8] > blobs[b][7]-blobs[b][8]) begin
    //                         blobs[b][7] <= blobs[touching][7];
    //                         blobs[b][8] <= blobs[touching][8];
    //                     end 
    //                     else if (blobs[touching][9]+blobs[touching][10] > blobs[b][9]+blobs[b][10]) begin
    //                         blobs[b][9] <= blobs[touching][9];
    //                         blobs[b][10] <= blobs[touching][10];
    //                     end 
    //                     else if (blobs[touching][11]-blobs[touching][12] < blobs[b][11]-blobs[b][12]) begin
    //                         blobs[b][11] <= blobs[touching][11];
    //                         blobs[b][12] <= blobs[touching][12];
    //                     end
    //                 end
    //                 else begin
    //                     didTouch <= 1;
    //                 end
    //                 touching <= b; //this might not work with verilog for loop
                    
    //                 //expand bounding box
    //                 if (x < blobs[b][1]) begin
    //                     blobs[b][1] <= blobs[b][1] - 1;
    //                 end
    //                 else if (x+1 > blobs[b][3]) begin
    //                     blobs[b][3] <= blobs[b][3] + 1;
    //                 end
    //                 if (y < blobs[b][2]) begin
    //                     blobs[b][2] <= blobs[b][2] - 1;
    //                 end
    //                 else if (y+1 > blobs[b][4]) begin
    //                     blobs[b][4] <= blobs[b][4] + 1;
    //                 end
                    
    //                 //move corner vextexes
    //                 if (x+y < blobs[b][5]+blobs[b][6]) begin
    //                     blobs[b][5] <= x;
    //                     blobs[b][6] <= y;
    //                 end
    //                 else if (x-y > blobs[b][7]-blobs[b][8]) begin
    //                     blobs[b][7] <= x;
    //                     blobs[b][8] <= y;
    //                 end
    //                 else if (x+y > blobs[b][9]+blobs[b][10]) begin
    //                     blobs[b][9] <= x;
    //                     blobs[b][10] <= y;
    //                 end
    //                 else if (x-y < blobs[b][11]-blobs[b][12]) begin
    //                     blobs[b][11] <= x;
    //                     blobs[b][12] <= y;
    //                 end
    //             end
    //         end
            
    //         //make new blob
    //         if (~didTouch) begin
    //             blobIndex = blobIndex + 1;
    //             blobs[blobIndex] = { x,y, x+1,y+1, x,y, x,y, x,y, x,y, 1 };
    //         end

    //         x <= x + 1;
    //     end

    //     //next line
    //     if (~hsync && lastHsync) begin
    //         x <= 0;
    //         y <= y + 1;
    //     end

    //     //next frame
    //     if (~vsync && lastVsync) begin
    //         //TODO: pick final blob and send to USB & cache for RIO
    //         Top.targetBlob = blobs[0];

    //         x <= 0;
    //         y <= 0;
    //     end

    //     //save ref values
    //     lastVsync <= vsync;
    //     lastHsync <= hsync;
    // end

endmodule

let min(a,b) = a < b ? a : b;
let max(a,b) = a > b ? a : b;