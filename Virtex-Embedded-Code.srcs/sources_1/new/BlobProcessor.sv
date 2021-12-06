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

/* BlobProcessor - Processes incoming pixels into blobs and selects the target blob based on config
   Virtex Algorithm: https://docs.google.com/document/d/1bz1e-nRzw2SLFKddVVZY3nFoIvRZqutlnkVuUk7gstA/edit
   */
module BlobProcessor();
    typedef struct {
        reg [9:0] x1, y1;
    } Vector;

    typedef struct {
        Vector boundingTopLeft, boundingBottomRight;
        Vector cornerTopLeft, cornerTopRight, cornerBottomRight, cornerBottomLeft;
        reg valid;
    } Blob;

    parameter numBlobs = 99;
    Blob blobs[0:numBlobs];
    reg [7:0] blobIndex = 0;

    reg [7:0] joined = 255; //the index of of the blob is last joined
    function void processPixel(input Vector pos);
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
                    blobs[i].boundingTopLeft.x = $min(blobs[i].boundingTopLeft.x, blobs[joined].boundingTopLeft.x);
                    blobs[i].boundingTopLeft.y = $min(blobs[i].boundingTopLeft.y, blobs[joined].boundingTopLeft.y);
                    blobs[i].boundBottomRight.x = $max(blobs[i].boundBottomRight.x, blobs[joined].boundBottomRight.x);
                    blobs[i].boundBottomRight.y = $max(blobs[i].boundBottomRight.y, blobs[joined].boundBottomRight.y);
                                        
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
            blobs[blobIndex] = '{
                '{pos.x, pos.y},
                '{pos.x + 1, pos.y + 1},
                '{pos.x, pos.y},
                '{pos.x, pos.y}, //x+1?
                '{pos.x, pos.y}, //x+1,y+1?
                '{pos.x, pos.y}, //y+1?
                1
            };
            blobIndex++;
            fixBlobIndex();
        end
    endfunction

    function void reset();
        //invalidate all blobs
        foreach (blobs[i]) begin
            blobs[i].valid = 0;
        end

        //reset counter
        blobIndex = 0;
    endfunction

    function Blob chooseBlob();
        foreach (blobs[i]) begin
            if (blobs[i].valid) begin
                return blobs[i]; //TODO
            end
        end
    endfunction

    function real calculateTheta(Blob blob);
        return $atan((blob.cornerBottomLeft.y - blob.cornerBottomRight.y) / (blob.cornerBottomLeft.x - blob.cornerBottomRight.x));
    endfunction

    function void fixBlobIndex();
        //out of bounds
        if (blobIndex > numBlobs) begin
            blobIndex = 0;
            fixBlobIndex();
        end

        //on top of existing blob
        else if (blobs[blobIndex].valid == 1) begin
            blobIndex++;
            fixBlobIndex();
        end

        //is ok
        else begin
            return;
        end
    endfunction
endmodule