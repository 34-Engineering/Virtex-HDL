`timescale 1ns / 1ps
`include "Util.sv"

/* BlobProcessor - Processes incoming pixels into blobs and selects the target blob based on config
   
   */
module BlobProcessor(
    input wire CLK72,
    input wire kernelValid, //active high
    input wire Vector kernelPos, //the leftmost coordinate of the pixel
    input wire [7:0] kernel, //theshold of each pixel in the kernel
    input wire endFrame, //active high
    output Blob targetBlob
    );
    
    Blob blobs[0:99];
    reg [7:0] blobPointer = 0;
    reg [7:0] joined = 255; //the index of of the blob is last joined

    //End Frame --> Output Blob
    always @(posedge endFrame) begin
        foreach (blobs[i]) begin
            if (blobs[i].valid) begin
                //todo proper selection
                targetBlob <= blobs[i];
            end
            blobs[i].valid <= 0;
        end

        blobPointer <= 0;
    end

    //New Kernel
    always @(posedge kernelValid) begin
        //process every pixel of the kernel
        foreach (kernel[i]) begin
            if (kernel[i]) begin
                processPixel('{ x: kernelPos.x, y: kernelPos.y });
            end
        end

        //old blob is stale --> mark as invalid
        targetBlob.valid <= 0;
    end

    //Process Pixel
    task processPixel(input Vector pos);
        //try to join pixel into an existing blob
        foreach (blobs[i]) begin
            //if point inside blob bounding box
            if (blobs[i].valid &
                pos.x + 2 > blobs[i].boundTopLeft.x & 
                pos.x - 2 < blobs[i].boundBottomRight.x & 
                pos.y + 2 > blobs[i].boundTopLeft.y & 
                pos.y - 2 < blobs[i].boundBottomRight.y) begin

                //this pixel is touching multiple blobs --> merge them
                if (joined != 255) begin
                    blobs[joined].valid <= 0;

                    //make new bounding box
                    blobs[i].boundTopLeft.x <= min(blobs[i].boundTopLeft.x, blobs[joined].boundTopLeft.x);
                    blobs[i].boundTopLeft.y <= min(blobs[i].boundTopLeft.y, blobs[joined].boundTopLeft.y);
                    blobs[i].boundBottomRight.x <= max(blobs[i].boundBottomRight.x, blobs[joined].boundBottomRight.x);
                    blobs[i].boundBottomRight.y <= max(blobs[i].boundBottomRight.y, blobs[joined].boundBottomRight.y);
                                        
                    //make new corners
                    if (blobs[joined].cornerTopLeft.x+blobs[joined].cornerTopLeft.y < blobs[i].cornerTopLeft.x+blobs[i].cornerTopLeft.y) begin
                        blobs[i].cornerTopLeft.x <= blobs[joined].cornerTopLeft.x;
                        blobs[i].cornerTopLeft.y <= blobs[joined].cornerTopLeft.y;
                    end
                    else if (blobs[joined].cornerTopRight.x-blobs[joined].cornerTopRight.y > blobs[i].cornerTopRight.x-blobs[i].cornerTopRight.y) begin
                        blobs[i].cornerTopRight.x <= blobs[joined].cornerTopRight.x;
                        blobs[i].cornerTopRight.y <= blobs[joined].cornerTopRight.y;
                    end
                    else if (blobs[joined].cornerBottomRight.x+blobs[joined].cornerBottomRight.y > blobs[i].cornerBottomRight.x+blobs[i].cornerBottomRight.y) begin
                        blobs[i].cornerBottomRight.x <= blobs[joined].cornerBottomRight.x;
                        blobs[i].cornerBottomRight.y <= blobs[joined].cornerBottomRight.y;
                    end
                    else if (blobs[joined].cornerBottomLeft.x-blobs[joined].cornerBottomLeft.y < blobs[i].cornerBottomLeft.x-blobs[i].cornerBottomLeft.y) begin
                        blobs[i].cornerBottomLeft.x <= blobs[joined].cornerBottomLeft.x;
                        blobs[i].cornerBottomLeft.y <= blobs[joined].cornerBottomLeft.y;
                    end
                end

                joined <= i;

                //expand bouding box
                if (pos.x < blobs[i].boundTopLeft.x)
                    blobs[i].boundTopLeft.x <= blobs[i].boundTopLeft.x - 1;
                else if (pos.x + 1 > blobs[i].boundBottomRight.x)
                    blobs[i].boundBottomRight.x <= blobs[i].boundBottomRight.x + 1;
                if (pos.y < blobs[i].boundTopLeft.y)
                    blobs[i].boundTopLeft.y <= blobs[i].boundTopLeft.y - 1;
                else if (pos.y + 1 > blobs[i].boundBottomRight.y)
                    blobs[i].boundBottomRight.y <= blobs[i].boundBottomRight.y + 1;

                //move corner vertexes
                if (pos.x + pos.y < blobs[i].cornerTopLeft.x + blobs[i].cornerTopLeft.y) begin
                    blobs[i].cornerTopLeft.x <= pos.x;
                    blobs[i].cornerTopLeft.y <= pos.y;
                end
                else if (pos.x - pos.y > blobs[i].cornerTopRight.x - blobs[i].cornerTopRight.y) begin
                    blobs[i].cornerTopRight.x <= pos.x;
                    blobs[i].cornerTopRight.y <= pos.y;
                end
                else if (pos.x + pos.y > blobs[i].cornerBottomRight.x + blobs[i].cornerBottomRight.y) begin
                    blobs[i].cornerBottomRight.x <= pos.x;
                    blobs[i].cornerBottomRight.y <= pos.y;
                end
                else if (pos.x - pos.y < blobs[i].cornerBottomLeft.x - blobs[i].cornerBottomLeft.y) begin
                    blobs[i].cornerBottomLeft.x <= pos.x;
                    blobs[i].cornerBottomLeft.y <= pos.y;
                end
            end
        end

        //didnt join any blobs --> make new blob
        if (joined == 255) begin
            blobs[blobPointer] <= '{
                '{pos.x, pos.y},
                '{pos.x + 1, pos.y + 1},
                '{pos.x, pos.y},
                '{pos.x, pos.y}, //x+1?
                '{pos.x, pos.y}, //x+1,y+1?
                '{pos.x, pos.y}, //y+1?
                1, 0
            };
            blobPointer <= blobPointer + 1;
            fixBlobIndex();
        end
    endtask

    //Fix Blob Index
    task fixBlobIndex();
        //out of bounds OR on top of existing blob --> find empty blob
        //if all blobs are full it won't change blobPointer and just overwrite the blob its on; is this the behavior we want? should it clear the blob in that case?
        if (blobPointer > $size(blobs) - 1 | blobs[blobPointer].valid) begin
            foreach (blobs[i]) begin
                if (!blobs[i].valid) begin
                    blobPointer <= i;
                    return;
                end
            end
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