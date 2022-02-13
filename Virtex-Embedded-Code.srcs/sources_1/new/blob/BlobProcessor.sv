`timescale 1ns / 1ps
`include "BlobUtil.sv"

/* BlobProcessor - Processes incoming pixels into blobs and selects the target blob based on config
   
    Naming:
    
    Blob: a group of touching pixels
     - Bounding Box: a non-rotated square that covers all pixels in the blob
     - Quad: a quadrilateral that is drawn inside the bounding box that covers most of the pixels (this is used for rotation/slope calculations)
        - Corner: the four corners of the quad
    
    Target: a (group) of blob(s) that represent the entire physical target

   */
module BlobProcessor(
    input wire CLK180,
    input wire kernelValid, //active high
    input wire Vector kernelPos, //top left coord of the kernel
    input wire [7:0] kernel, //theshold of each pixel in the kernel
    output Blob targetBlob,
    input wire endFrame
    //TODO invalidate blob w/ enabled
    );
    
    // //Blob ID Buffer (stores the last two lines of blob IDs)
    // localparam BLOB_ID_BUFFER_WIDTH = $clog2(MAX_BLOBS);
    // localparam NULL_BLOB_ID = (2 ** BLOB_ID_BUFFER_WIDTH) - 1;
    // reg [BLOB_ID_BUFFER_WIDTH:0] blobIDBuffer [IMAGE_WIDTH*2-1:0];
    // reg blobIDBufferHalf = 0;
    // initial begin
    //     for (int q = 0; q < $size(blobIDBuffer); q++) begin
    //         blobIDBuffer[q] <= NULL_BLOB_ID;
    //     end
    // end
    
    // /* synthesis keep */
    // reg lastKernelValid = 0;/* synthesis keep */
    // reg lastEndFrame = 0;
    // /* synthesis keep */
    // always @(negedge CLK180) begin /* synthesis keep */
    //     //New Kernel
    //     if (kernelValid & ~lastKernelValid) begin
    //         //Process all 8 Pixels
    //         for (int p = 0; p < 8; p++) begin
    //             //TODO RLE + KERNEL QUEUE

    //             // push blobID to buffer for every pixel
    //             blobIDBuffer[kernelPos.x + 0 + (blobIDBufferHalf?IMAGE_WIDTH:0)] <= 
    //                 kernel[0] ? processPixel('{ x: kernelPos.x + 0, y: kernelPos.y }) : NULL_BLOB_ID;
    //         end

    //         //End Frame
    //         if (kernelPos.y == IMAGE_HEIGHT-1 & kernelPos.x == (IMAGE_WIDTH/8)-1) begin
                
    //         end
    //     end
    //     lastKernelValid <= kernelValid;

    //     //End Frame
    //     if (endFrame & ~lastEndFrame) begin
    //         //Select Target
    //         foreach (blobs[i]) begin
    //             if (blobs[i].valid & blobs[i].area > 10) begin
    //                 //TODO proper selection
    //                 targetBlob <= blobs[i];
    //             end

    //             //mark blob as invalid (stale)
    //             blobs[i].valid <= 0;
    //         end

    //         //Prepare for Next Frame
    //         blobIndex = 0;
    //     end
    //     lastEndFrame <= endFrame;
    // end

    // //Process Pixel & Return BlobID
    // logic [BLOB_ID_BUFFER_WIDTH:0] masterBlobID;
    // function automatic processPixel(input Vector pos);
    //     masterBlobID = NULL_BLOB_ID;

    //     //pick out top left, top, top right, and left pixels from blobIDBuffer
    //     //but only if they are in the bounding of the 640x480 image
    //     if (pos.x > 0 & pos.y > 0) begin
    //         processSurroundingPixel(blobIDBuffer[pos.x-1 + (blobIDBufferHalf?0:IMAGE_WIDTH)]);
    //     end
    //     if (pos.y > 0) begin
    //         processSurroundingPixel(blobIDBuffer[pos.x+0 + (blobIDBufferHalf?0:IMAGE_WIDTH)]);
    //     end
    //     if (pos.x < IMAGE_WIDTH-1 & pos.y > 0) begin
    //         processSurroundingPixel(blobIDBuffer[pos.x+1 + (blobIDBufferHalf?0:IMAGE_WIDTH)]);
    //     end
    //     if (pos.x > 0) begin
    //         processSurroundingPixel(blobIDBuffer[pos.x-1 + (blobIDBufferHalf?IMAGE_WIDTH:0)]);
    //     end

    //     //add this pixel to blob if we have a valid blob to join
    //     if (masterBlobID != NULL_BLOB_ID) begin
    //         blobs[masterBlobID] <= mergeBlobs(pixelToBlob(pos), blobs[masterBlobID]);
    //         return masterBlobID;
    //     end
        
    //     //not touching a blob => make new blob
    //     else begin
    //         blobs[blobIndex] <= pixelToBlob(pos);
    //         blobIndex = blobIndex + 1;
    //         return blobIndex - 1;
    //     end
    // endfunction

    // //Process Surrounding Pixel
    // function automatic processSurroundingPixel(input logic [BLOB_ID_BUFFER_WIDTH:0] slaveBlobID);
    //     //find which blob to join, and merge blobs if it is touching mutliple
    //     if (slaveBlobID != NULL_BLOB_ID) begin
    //         //found master (1st valid blob)
    //         if (masterBlobID == NULL_BLOB_ID) begin
    //             masterBlobID = getRealBlobID(slaveBlobID);
    //         end

    //         //found another valid blob => merge with master
    //         else if (getRealBlobID(slaveBlobID) != masterBlobID) begin
    //             //merge slave into master
    //             blobs[masterBlobID] <= mergeBlobs(blobs[slaveBlobID], blobs[masterBlobID]);

    //             //mark slave as pointer to master
    //             blobs[slaveBlobID] <= '{
    //                 boundTopLeft: 0,
    //                 boundBottomRight: 0,
    //                 quadTopLeft: 0,
    //                 quadTopRight: 0,
    //                 quadBottomLeft: 0,
    //                 quadBottomRight: 0,
    //                 area: 0,
    //                 pointer: masterBlobID,
    //                 valid: 0,
    //                 reserved: 0
    //             };
    //         end
    //     end
    // endfunction

    
    // //Get Real Blob ID "Recursively" (max ~3 recursions, but 5 for safety)
    // reg [BLOB_ID_BUFFER_WIDTH:0] currentID;
    // function automatic getRealBlobID(logic [BLOB_ID_BUFFER_WIDTH:0] startID);
    //     currentID = startID;
    //     for (int i = 0; i < 5; i++) begin
    //         if (blobs[currentID].valid) begin
    //             return currentID;
    //         end
    //         else begin
    //             currentID = blobs[currentID].pointer;
    //         end
    //     end
    //     //TODO FAULT
    //     return NULL_BLOB_ID;
    // endfunction
endmodule /* synthesis keep */
/* synthesis keep */