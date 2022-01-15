`timescale 1ns / 1ps
import Util::*;

/* BlobProcessor - Processes incoming pixels into blobs and selects the target blob based on config
   Virtex Algorithm: https://docs.google.com/document/d/1bz1e-nRzw2SLFKddVVZY3nFoIvRZqutlnkVuUk7gstA/edit
   */
module BlobProcessor(
    input wire CLK36,
    input wire kernelValid,
    input wire Vector kernalPos, //the leftmost coordinate of the pixel
    input wire [3:0] kernel, //theshold of each pixel in the kernel
    input wire endFrame, //chooses blob and resets
    output Blob outputBlob
    );
    
    parameter blobsSize = 100 - 1;
    Blob blobs[0:blobsSize];
    reg [7:0] blobPointer = 0;
    reg [7:0] joined = 255; //the index of of the blob is last joined

    //Loop
    always @(negedge CLK36) begin
        //End Frame
        if (endFrame) begin
            foreach (blobs[i]) begin
                if (blobs[i].valid) begin
                    //todo proper selection
                    outputBlob <= blobs[i];
                end
                blobs[i].valid = 0;
            end

            blobPointer = 0;
        end

        //Process Pixel
        if (kernelValid) begin
            foreach (kernel[i]) begin
                if (kernel[i]) begin
                    processPixel('{ x: kernelPos.x + i, y: kernelPos.y });
                end
            end
        end
    end

    //Process Pixel
    task processPixel(input Vector pos);
        //try to join pixel into an existing blob
        foreach (blobs[i]) begin
            //if point inside blob bounding box
            if (blobs[i].valid &
                pos.x + 2 > blobs[i].boundingTopLeft.x & 
                pos.x - 2 < blobs[i].boundingBottomRight.x & 
                pos.y + 2 > blobs[i].boundingTopLeft.y & 
                pos.y - 2 < blobs[i].boundingBottomRight.y) begin

                //this pixel is touching multiple blobs --> merge them
                if (joined !== 255) begin
                    blobs[joined].valid = 0;

                    //make new bounding box
                    blobs[i].boundingTopLeft.x = min(blobs[i].boundingTopLeft.x, blobs[joined].boundingTopLeft.x);
                    blobs[i].boundingTopLeft.y = min(blobs[i].boundingTopLeft.y, blobs[joined].boundingTopLeft.y);
                    blobs[i].boundBottomRight.x = max(blobs[i].boundBottomRight.x, blobs[joined].boundBottomRight.x);
                    blobs[i].boundBottomRight.y = max(blobs[i].boundBottomRight.y, blobs[joined].boundBottomRight.y);
                                        
                    //make new corners
                    if (blobs[joined].cornerTopLeft.x+blobs[joined].cornerTopLeft.y < blobs[i].cornerTopLeft.x+blobs[i].cornerTopLeft.y) begin
                        blobs[i].cornerTopLeft.x = blobs[joined].cornerTopLeft.x;
                        blobs[i].cornerTopLeft.y = blobs[joined].cornerTopLeft.y;
                    end
                    else if (blobs[joined].cornerTopRight.x-blobs[joined].cornerTopRight.y > blobs[i].cornerTopRight.x-blobs[i].cornerTopRight.y) begin
                        blobs[i].cornerTopRight.x = blobs[joined].cornerTopRight.x;
                        blobs[i].cornerTopRight.y = blobs[joined].cornerTopRight.y;
                    end
                    else if (blobs[joined].cornerBottomRight.x+blobs[joined].cornerBottomRight.y > blobs[i].cornerBottomRight.x+blobs[i].cornerBottomRight.y) begin
                        blobs[i].cornerBottomRight.x = blobs[joined].cornerBottomRight.x;
                        blobs[i].cornerBottomRight.y = blobs[joined].cornerBottomRight.y;
                    end
                    else if (blobs[joined].cornerBottomLeft.x-blobs[joined].cornerBottomLeft.y < blobs[i].cornerBottomLeft.x-blobs[i].cornerBottomLeft.y) begin
                        blobs[i].cornerBottomLeft.x = blobs[joined].cornerBottomLeft.x;
                        blobs[i].cornerBottomLeft.y = blobs[joined].cornerBottomLeft.y;
                    end
                end

                joined = i;

                //expand bouding box
                if (pos.x < blobs[i].boundingTopLeft.x)
                    blobs[i].boundingTopLeft.x = blobs[i].boundingTopLeft.x - 1;
                else if (pos.x + 1 > blobs[i].boundingBottomRight.x)
                    blobs[i].boundingBottomRight.x = blobs[i].boundingBottomRight.x + 1;
                if (pos.y < blobs[i].boundingTopLeft.y)
                    blobs[i].boundingTopLeft.y = blobs[i].boundingTopLeft.y - 1;
                else if (pos.y + 1 > blobs[i].boundingBottomRight.y)
                    blobs[i].boundingBottomRight.y = blobs[i].boundingBottomRight.y + 1;

                //move corner vertexes
                if (pos.x + pos.y < blobs[i].cornerTopLeft.x + blobs[i].cornerTopLeft.y) begin
                    blobs[i].cornerTopLeft.x = pos.x;
                    blobs[i].cornerTopLeft.y = pos.y;
                end
                else if (pos.x - pos.y > blobs[i].cornerTopRight.x - blobs[i].cornerTopRight.y) begin
                    blobs[i].cornerTopRight.x = pos.x;
                    blobs[i].cornerTopRight.y = pos.y;
                end
                else if (pos.x + pos.y > blobs[i].cornerBottomRight.x + blobs[i].cornerBottomRight.y) begin
                    blobs[i].cornerBottomRight.x = pos.x;
                    blobs[i].cornerBottomRight.y = pos.y;
                end
                else if (pos.x - pos.y < blobs[i].cornerBottomLeft.x - blobs[i].cornerBottomLeft.y) begin
                    blobs[i].cornerBottomLeft.x = pos.x;
                    blobs[i].cornerBottomLeft.y = pos.y;
                end
            end
        end

        //didnt join any blobs --> make new blob
        if (joined == 255) begin
            blobs[blobPointer] = '{
                '{pos.x, pos.y},
                '{pos.x + 1, pos.y + 1},
                '{pos.x, pos.y},
                '{pos.x, pos.y}, //x+1?
                '{pos.x, pos.y}, //x+1,y+1?
                '{pos.x, pos.y}, //y+1?
                1
            };
            blobPointer++;
            fixBlobIndex();
        end
    endtask

    //Fix Blob Index
    task fixBlobIndex();
        //out of bounds
        if (blobPointer > blobsSize) begin
            blobPointer = 0;
            fixBlobIndex();
        end

        //on top of existing blob
        else if (blobs[blobPointer].valid == 1) begin
            blobPointer++;
            fixBlobIndex();
        end
    endtask

    //Calculate Slope
    function real calculateSlope(Blob blob);
        //calculates slope of bottom line of the quad
        //instead of calculating the angle on the fpga with atand we do it on the roborio
        //before setting the config setting
        //bounded between -1 and 1
        //todo handle different angles (the bottom line changes)
        //todo division
        return ((blob.cornerBottomLeft.y - blob.cornerBottomRight.y) / (blob.cornerBottomLeft.x - blob.cornerBottomRight.x));
    endfunction
endmodule