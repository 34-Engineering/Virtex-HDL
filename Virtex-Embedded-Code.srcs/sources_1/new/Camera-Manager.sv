`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 34 Engineering
// Engineer: Liam Snow
// 
// Create Date: 06/08/2021 11:14:59 AM
// Module Name: CameraManager
// Project Name: Virtex
// 
//////////////////////////////////////////////////////////////////////////////////


module CameraManager(
    input CLK,
    input MCLK_N,
    input MCLK_P,
    input MD1_N,
    input MD1_P,
    input MD2_N,
    input MD2_P,
    inout [3:0] GPIO,
    output XSHDN
    );

    reg active_video;
    reg data;
    reg hblank;
    reg hsync;
    reg vblank;
    reg vsync;

    assign XSHDN = 0;
    assign GPIO = 4'b0000;

    MIPICSI2Reader MIPICSI2Reader(
        .CLK(CLK),
        .ENABLED(1),
        .RESET(1),
        .FID(0),
        .MCLK_N(MCLK_N),
        .MCLK_P(MCLK_P),
        .MD_N({ MD1_N, MD2_N }),
        .MD_P({ MD1_P, MD2_P }),
        .OUT_ACTIVE_VIDEO(active_video),
        .OUT_DATA(data),
        .OUT_HBLANK(hblank),
        .OUT_HSYNC(hsync),
        .OUT_VBLANK(vblank),
        .OUT_VSYNC(vsync)
    );

    reg pixel;
    reg [9:0] x;
    reg [9:0] y;
    reg didTouch;
    reg [7:0] b;
    reg [7:0] touching;
    reg [7:0] blobIndex = 0;
    reg [9:0] blobs [99:0][12:0]; //bx1, by1, bx2, by2, c{1-4}x1, c{1-4}y1, c{1-4}x2, c{1-4}y2 (1-4 order clockwise starting at top-left)
    reg lastVsync;
    reg lastHsync;

    //100mHz
    always @(posedge CLK && active_video) begin
        //pixel
        if (vsync && hsync) begin
            //TODO: send pixel to USB
            
            pixel <= data > Top.threshold;
            
            didTouch <= 0;
        
            //detect collision w/ existing blobs
            for (b=0; b<blobIndex; b=b+1) begin
                if (blobs[b][13] && x+2 > blobs[b][1] && x-2 < blobs[b][3] && y+2 > blobs[b][2] && y-2 < blobs[b][4]) begin
                    //merge blobs
                    if (didTouch) begin
                        blobs[touching][13] = 0;
                        
                        blobs[b][1] <= min(blobs[b][1], blobs[touching][1]);
                        blobs[b][2] <= min(blobs[b][2], blobs[touching][2]);
                        blobs[b][3] <= max(blobs[b][3], blobs[touching][3]);
                        blobs[b][4] <= max(blobs[b][4], blobs[touching][4]);
                                            
                        if (blobs[touching][5]+blobs[touching][6] < blobs[b][5]+blobs[b][6]) begin
                            blobs[b][5] <= blobs[touching][5];
                            blobs[b][6] <= blobs[touching][6];
                        end 
                        else if (blobs[touching][7]-blobs[touching][8] > blobs[b][7]-blobs[b][8]) begin
                            blobs[b][7] <= blobs[touching][7];
                            blobs[b][8] <= blobs[touching][8];
                        end 
                        else if (blobs[touching][9]+blobs[touching][10] > blobs[b][9]+blobs[b][10]) begin
                            blobs[b][9] <= blobs[touching][9];
                            blobs[b][10] <= blobs[touching][10];
                        end 
                        else if (blobs[touching][11]-blobs[touching][12] < blobs[b][11]-blobs[b][12]) begin
                            blobs[b][11] <= blobs[touching][11];
                            blobs[b][12] <= blobs[touching][12];
                        end
                    end
                    else begin
                        didTouch <= 1;
                    end
                    touching <= b; //this might not work with verilog for loop
                    
                    //expand bounding box
                    if (x < blobs[b][1]) begin
                        blobs[b][1] <= blobs[b][1] - 1;
                    end
                    else if (x+1 > blobs[b][3]) begin
                        blobs[b][3] <= blobs[b][3] + 1;
                    end
                    if (y < blobs[b][2]) begin
                        blobs[b][2] <= blobs[b][2] - 1;
                    end
                    else if (y+1 > blobs[b][4]) begin
                        blobs[b][4] <= blobs[b][4] + 1;
                    end
                    
                    //move corner vextexes
                    if (x+y < blobs[b][5]+blobs[b][6]) begin
                        blobs[b][5] <= x;
                        blobs[b][6] <= y;
                    end
                    else if (x-y > blobs[b][7]-blobs[b][8]) begin
                        blobs[b][7] <= x;
                        blobs[b][8] <= y;
                    end
                    else if (x+y > blobs[b][9]+blobs[b][10]) begin
                        blobs[b][9] <= x;
                        blobs[b][10] <= y;
                    end
                    else if (x-y < blobs[b][11]-blobs[b][12]) begin
                        blobs[b][11] <= x;
                        blobs[b][12] <= y;
                    end
                end
            end
            
            //make new blob
            if (~didTouch) begin
                blobIndex = blobIndex + 1;
                blobs[blobIndex] = { x,y, x+1,y+1, x,y, x,y, x,y, x,y, 1 };
            end

            x <= x + 1;
        end

        //next line
        if (~hsync && lastHsync) begin
            x <= 0;
            y <= y + 1;
        end

        //next frame
        if (~vsync && lastVsync) begin
            //TODO: pick final blob and send to USB & UART

            x <= 0;
            y <= 0;
        end

        //save ref values
        lastVsync <= vsync;
        lastHsync <= hsync;
    end

endmodule

let min(a,b) = a < b ? a : b;
let max(a,b) = a > b ? a : b;