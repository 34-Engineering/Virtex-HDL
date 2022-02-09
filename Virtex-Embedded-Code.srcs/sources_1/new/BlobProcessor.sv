`timescale 1ns / 1ps
`include "Util.sv"

/* BlobProcessor - Processes incoming pixels into blobs and selects the target blob based on config
   
    Naming:
    
    Blob: a group of touching pixels
     - Bounding Box: a non-rotated square that covers all pixels in the blob
     - Quad: a quadrilateral that is drawn inside the bounding box that covers most of the pixels (this is used for rotation/slope calculations)
        - Corner: the four corners of the quad
    
    Target: a (group) of blob(s) that represent the entire physical target

   */
module BlobProcessor(
    input wire CLK,
    input wire kernelValid, //active high
    input wire Vector kernelPos, //the leftmost coordinate of the pixel
    input wire [7:0] kernel, //theshold of each pixel in the kernel
    output Blob targetBlob
    );
    
    localparam MAX_BLOBS = 100;
    Blob blobs[0:MAX_BLOBS-1];
    reg [7:0] blobIndex = 0;

    localparam BLOB_ID_BUFFER_WIDTH = $clog2(MAX_BLOBS);
    localparam NULL_BLOB_ID = (2 ** BLOB_ID_BUFFER_WIDTH) - 1;
    reg [BLOB_ID_BUFFER_WIDTH:0] blobIDBuffer [IMAGE_WIDTH*2-1:0]; //stores the last two lines of blob IDs
    reg blobIDBufferHalf = 0;
    initial begin
        for (int i = 0; i <= $size(blobIDBuffer); i++) begin
            blobIDBuffer[i] = NULL_BLOB_ID;
        end
    end
    
    //New Kernel
    always @(posedge kernelValid) begin
        //Process all 8 Pixels
        for (int i = 0; i < 8; i++) begin
            //push blobID to buffer for every pixel
            blobIDBuffer[kernelPos.x + i + (blobIDBufferHalf?IMAGE_WIDTH:0)] = 
                kernel[i] ? processPixel('{ x: kernelPos.x + i, y: kernelPos.y }) : NULL_BLOB_ID;
        end

        //End Frame
        if (kernelPos.y == IMAGE_HEIGHT-1 & kernelPos.x == (IMAGE_WIDTH/8)-1) begin
            //Select Target
            foreach (blobs[i]) begin
                if (blobs[i].valid) begin
                    //TODO proper selection
                    targetBlob <= blobs[i];
                end

                //mark blob as invalid (stale)
                blobs[i].valid <= 0;
            end

            //Prepare for Next Frame
            blobIndex <= 0;
        end
    end

    //Process Pixel
    function automatic processPixel(input Vector pos);
        if (pos.x > 0 & pos.y > 0) begin
            
        end
        if (pos.y > 0) begin
            
        end
        if (pos.x < IMAGE_WIDTH-1 & pos.y > 0) begin
            
        end
        if (pos.x > 0) begin
            
        end
    endfunction

    /*
    //expand bounding box
    blobs[i].boundTopLeft.x <= min(blobs[i].boundTopLeft.x, blobs[joined].boundTopLeft.x);
    blobs[i].boundTopLeft.y <= min(blobs[i].boundTopLeft.y, blobs[joined].boundTopLeft.y);
    blobs[i].boundBottomRight.x <= max(blobs[i].boundBottomRight.x, blobs[joined].boundBottomRight.x);
    blobs[i].boundBottomRight.y <= max(blobs[i].boundBottomRight.y, blobs[joined].boundBottomRight.y);
                        
    //expand quad (sqrt(x^2 + y^2) is too expensive => using x + y which gives similar quality)
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

    //expand bouding box
    if (pos.x < blobs[i].boundTopLeft.x)
        blobs[i].boundTopLeft.x <= blobs[i].boundTopLeft.x - 1;
    else if (pos.x + 1 > blobs[i].boundBottomRight.x)
        blobs[i].boundBottomRight.x <= blobs[i].boundBottomRight.x + 1;
    if (pos.y < blobs[i].boundTopLeft.y)
        blobs[i].boundTopLeft.y <= blobs[i].boundTopLeft.y - 1;
    else if (pos.y + 1 > blobs[i].boundBottomRight.y)
        blobs[i].boundBottomRight.y <= blobs[i].boundBottomRight.y + 1;

    //expand quad (sqrt(x^2 + y^2) is too expensive => using x + y which gives similar quality)
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

    //create blob at next available index
    blobs[blobIndex] <= '{
        boundTopLeft:     '{pos.x  , pos.y  },
        boundBottomRight: '{pos.x+1, pos.y+1},
        quadTopLeft:      '{pos.x  , pos.y  },
        quadTopRight:     '{pos.x+1, pos.y  },
        quadBottomLeft:   '{pos.x  , pos.y+1},
        quadBottomRight:  '{pos.x+1, pos.y+1},
        area: 1,
        pointer: 0,
        valid: 1
    };

    blobIndex <= blobIndex + 1;
    */

    //Get Blob ID "Recursively" (max ~3 recursions, but 5 for safety)
    function automatic getBlobID(logic [BLOB_ID_BUFFER_WIDTH:0] startID);
        reg [BLOB_ID_BUFFER_WIDTH:0] ID = startID;
        for (int i = 0; i < 5; i++) begin
            if (blobs[ID].valid) begin
                return ID;
            end
            else begin
                ID = blobs[ID].pointer;
            end
        end
        //TODO FAULT
        return NULL_BLOB_ID;
    endfunction

    //Calculate Slope
    // function real calculateSlope(Blob blob);
    //     //calculates slope of bottom line of the quad
    //     //instead of calculating the angle on the fpga with atand we do it on the roborio
    //     //before setting the config setting
    //     //bounded between -1 and 1
    //     //todo handle different angles (the bottom line changes)
    //     //todo division
    //     return ((blob.cornerBottomLeft.y - blob.cornerBottomRight.y) / (blob.cornerBottomLeft.x - blob.cornerBottomRight.x));
    // endfunction

    //Range Functions
    function logic [9:0] min(logic [9:0] num1, num2);
        return num1 < num2 ? num1 : num2;
    endfunction

    function logic [9:0] max(logic [9:0] num1, num2);
        return num1 > num2 ? num1 : num2;
    endfunction
endmodule