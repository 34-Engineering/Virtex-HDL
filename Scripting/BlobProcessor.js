const fs = require('fs');
var drawing = require('pngjs-draw');
const png = drawing(require('pngjs').PNG);

let blobs = [];
let blobPointer = 0;
let joined = 255; //the index of of the blob is last joined

fs.createReadStream('images/2019_Noise2.png')
    .pipe(new png())
    .on('parsed', function() {

    //Process all Pixels
    for (let y = 0; y < this.height; y++) {
        for (let x = 0; x < this.width; x++) {
            const idx = (this.width * y + x) << 2;
            const value = (this.data[idx] + this.data[idx+1] + this.data[idx+2]) / 3; 

            if (value > 128) {
                processPixel({x, y});
            }
        }
    }

    console.log("num:"+blobs.length);

    //Draw Blobs
    for (let i = 0; i < blobs.length; i++) {
        if (blobs[i].valid) {
            this.drawRect(
                blobs[i].boundTopLeft.x,
                blobs[i].boundTopLeft.y,
                blobs[i].boundBottomRight.x - blobs[i].boundTopLeft.x,
                blobs[i].boundBottomRight.y - blobs[i].boundTopLeft.y,
                this.colors.red(255)
            );

            // this.drawLine(
            //     blobs[i].cornerTopLeft.x,
            //     blobs[i].cornerTopLeft.y,
            //     blobs[i].cornerTopRight.x,
            //     blobs[i].cornerTopRight.y,
            //     this.colors.green(255)
            // );

            // this.drawLine(
            //     blobs[i].cornerTopRight.x,
            //     blobs[i].cornerTopRight.y,
            //     blobs[i].cornerBottomRight.x,
            //     blobs[i].cornerBottomRight.y,
            //     this.colors.green(255)
            // );

            // this.drawLine(
            //     blobs[i].cornerBottomRight.x,
            //     blobs[i].cornerBottomRight.y,
            //     blobs[i].cornerBottomLeft.x,
            //     blobs[i].cornerBottomLeft.y,
            //     this.colors.green(255)
            // );

            // this.drawLine(
            //     blobs[i].cornerBottomLeft.x,
            //     blobs[i].cornerBottomLeft.y,
            //     blobs[i].cornerTopLeft.x,
            //     blobs[i].cornerTopLeft.y,
            //     this.colors.green(255)
            // );
        }
    }

    this.pack().pipe(fs.createWriteStream('out.png'));
});

//Process Pixel
function processPixel(pos) {
    joined = 255;

    //try to join pixel into an existing blob
    for (let i = 0; i < blobs.length; i++) {
        //if point inside blob bounding box
        if (blobs[i].valid &&
            pos.x + 2 > blobs[i].boundTopLeft.x && 
            pos.x - 2 < blobs[i].boundBottomRight.x &&
            pos.y + 2 > blobs[i].boundTopLeft.y &&
            pos.y - 2 < blobs[i].boundBottomRight.y) {

            //this pixel is touching multiple blobs --> merge them
            if (joined != 255) {
                blobs[joined].valid = 0;

                //make new bounding box
                blobs[i].boundTopLeft.x = min(blobs[i].boundTopLeft.x, blobs[joined].boundTopLeft.x);
                blobs[i].boundTopLeft.y = min(blobs[i].boundTopLeft.y, blobs[joined].boundTopLeft.y);
                blobs[i].boundBottomRight.x = max(blobs[i].boundBottomRight.x, blobs[joined].boundBottomRight.x);
                blobs[i].boundBottomRight.y = max(blobs[i].boundBottomRight.y, blobs[joined].boundBottomRight.y);
                                    
                //make new corners
                // if (blobs[joined].cornerTopLeft.x+blobs[joined].cornerTopLeft.y < blobs[i].cornerTopLeft.x+blobs[i].cornerTopLeft.y) {
                //     blobs[i].cornerTopLeft.x = blobs[joined].cornerTopLeft.x;
                //     blobs[i].cornerTopLeft.y = blobs[joined].cornerTopLeft.y;
                // }
                // else if (blobs[joined].cornerTopRight.x-blobs[joined].cornerTopRight.y > blobs[i].cornerTopRight.x-blobs[i].cornerTopRight.y) {
                //     blobs[i].cornerTopRight.x = blobs[joined].cornerTopRight.x;
                //     blobs[i].cornerTopRight.y = blobs[joined].cornerTopRight.y;
                // }
                // else if (blobs[joined].cornerBottomRight.x+blobs[joined].cornerBottomRight.y > blobs[i].cornerBottomRight.x+blobs[i].cornerBottomRight.y) {
                //     blobs[i].cornerBottomRight.x = blobs[joined].cornerBottomRight.x;
                //     blobs[i].cornerBottomRight.y = blobs[joined].cornerBottomRight.y;
                // }
                // else if (blobs[joined].cornerBottomLeft.x-blobs[joined].cornerBottomLeft.y < blobs[i].cornerBottomLeft.x-blobs[i].cornerBottomLeft.y) {
                //     blobs[i].cornerBottomLeft.x = blobs[joined].cornerBottomLeft.x;
                //     blobs[i].cornerBottomLeft.y = blobs[joined].cornerBottomLeft.y;
                // }
            }

            joined = i;

            //expand bouding box
            if (pos.x < blobs[i].boundTopLeft.x)
                blobs[i].boundTopLeft.x = blobs[i].boundTopLeft.x - 1;
            else if (pos.x + 1 > blobs[i].boundBottomRight.x)
                blobs[i].boundBottomRight.x = blobs[i].boundBottomRight.x + 1;
            if (pos.y < blobs[i].boundTopLeft.y)
                blobs[i].boundTopLeft.y = blobs[i].boundTopLeft.y - 1;
            else if (pos.y + 1 > blobs[i].boundBottomRight.y)
                blobs[i].boundBottomRight.y = blobs[i].boundBottomRight.y + 1;

            //move corner vertexes
            // if (pos.x + pos.y < blobs[i].cornerTopLeft.x + blobs[i].cornerTopLeft.y) {
            //     blobs[i].cornerTopLeft.x = pos.x;
            //     blobs[i].cornerTopLeft.y = pos.y;
            // }
            // else if (pos.x - pos.y > blobs[i].cornerTopRight.x - blobs[i].cornerTopRight.y) {
            //     blobs[i].cornerTopRight.x = pos.x;
            //     blobs[i].cornerTopRight.y = pos.y;
            // }
            // else if (pos.x + pos.y > blobs[i].cornerBottomRight.x + blobs[i].cornerBottomRight.y) {
            //     blobs[i].cornerBottomRight.x = pos.x;
            //     blobs[i].cornerBottomRight.y = pos.y;
            // }
            // else if (pos.x - pos.y < blobs[i].cornerBottomLeft.x - blobs[i].cornerBottomLeft.y) {
            //     blobs[i].cornerBottomLeft.x = pos.x;
            //     blobs[i].cornerBottomLeft.y = pos.y;
            // }
        }
    }

    //didnt join any blobs --> make new blob
    if (joined == 255) {
        blobs[blobPointer] = {
            boundTopLeft: {x:pos.x, y:pos.y},
            boundBottomRight: {x:pos.x + 1, y:pos.y + 1},
            // cornerTopLeft: {x:pos.x, y:pos.y},
            // cornerTopRight: {x:pos.x, y:pos.y}, //x+1?
            // cornerBottomRight: {x:pos.x, y:pos.y}, //x+1,y+1?
            // cornerBottomLeft: {x:pos.x, y:pos.y}, //y+1?
            valid: 1,
            reserved: 0
        };
        blobPointer = blobPointer + 1;
        fixBlobPointer();
    }
}

//Fix Blob Pointer
function fixBlobPointer() {
    //out of bounds OR on top of existing blob --> find empty blob
    //if all blobs are full it won't change blobPointer and just overwrite the blob its on; is this the behavior we want? should it clear the blob in that case?
    // if (blobPointer > blobs.length - 1 || blobs[blobPointer].valid) {
    //     if (blobPointer > blobs.length - 1) {
    //         blobPointer = 0;
    //     }
        
    //     for (let i = 0; i < blobs.length; i++) {
    //         if (!blobs[i].valid) {
    //             blobPointer = i;
    //             return;
    //         }
    //     }
    // }
}

//Range Functions
function min(num1, num2) {
    return num1 < num2 ? num1 : num2;
}

function max(num1, num2) {
    return num1 > num2 ? num1 : num2;
}