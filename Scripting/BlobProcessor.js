const fs = require('fs');
var drawing = require('pngjs-draw');
const png = drawing(require('pngjs').PNG);

let blobs = [];
let blobPointer = 0;
let joined = 255; //the index of of the blob is last joined
let frameBuffer = [...Array(1000)].map(e => Array(1000));

fs.createReadStream('images/2019_Noise3.png')
    .pipe(new png())
    .on('parsed', function () {

        //Process all Pixels
        for (let y = 0; y < this.height; y++) {
            for (let x = 0; x < this.width; x++) {
                const idx = (this.width * y + x) << 2;
                const value = (this.data[idx] + this.data[idx + 1] + this.data[idx + 2]) / 3;
                const threshold = value > 128;

                if (threshold) {
                    processPixel({
                        x,
                        y
                    });
                }

                frameBuffer[x][y] = threshold;
            }
        }

        console.log("num:" + blobs.length);

        //Draw Blobs
        for (let i = 0; i < blobs.length; i++) {
            const area = (blobs[i].boundBottomRight.x - blobs[i].boundTopLeft.x) * (blobs[i].boundBottomRight.y - blobs[i].boundTopLeft.y);
            if (blobs[i].valid && area > 1000) {
                this.drawRect(
                    blobs[i].boundTopLeft.x,
                    blobs[i].boundTopLeft.y,
                    blobs[i].boundBottomRight.x - blobs[i].boundTopLeft.x,
                    blobs[i].boundBottomRight.y - blobs[i].boundTopLeft.y,
                    this.colors.red(255)
                );

                const stats = getStats(blobs[i]);

                this.drawLine(
                    stats.cornerTopLeft.x,
                    stats.cornerTopLeft.y,
                    stats.cornerTopRight.x,
                    stats.cornerTopRight.y,
                    this.colors.green(255)
                );

                this.drawLine(
                    stats.cornerTopRight.x,
                    stats.cornerTopRight.y,
                    stats.cornerBottomRight.x,
                    stats.cornerBottomRight.y,
                    this.colors.green(255)
                );

                this.drawLine(
                    stats.cornerBottomRight.x,
                    stats.cornerBottomRight.y,
                    stats.cornerBottomLeft.x,
                    stats.cornerBottomLeft.y,
                    this.colors.green(255)
                );

                this.drawLine(
                    stats.cornerBottomLeft.x,
                    stats.cornerBottomLeft.y,
                    stats.cornerTopLeft.x,
                    stats.cornerTopLeft.y,
                    this.colors.green(255)
                );
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
        }
    }

    //didnt join any blobs --> make new blob
    if (joined == 255) {
        blobs[blobPointer] = {
            boundTopLeft: {
                x: pos.x,
                y: pos.y
            },
            boundBottomRight: {
                x: pos.x + 1,
                y: pos.y + 1
            },
            valid: 1,
            reserved: 0
        };
        blobPointer = blobPointer + 1;
        fixBlobPointer();
    }
}

//Get Stats
function getStats(blob) {
    const middleX = (blob.boundTopLeft.x + blob.boundBottomRight.x) / 2;
    const middleY = (blob.boundTopLeft.y + blob.boundBottomRight.y) / 2;

    let cornerTopLeft = {x: middleX, y: middleY},
        cornerTopRight = {x: middleX, y: middleY},
        cornerBottomRight = {x: middleX, y: middleY},
        cornerBottomLeft = {x: middleX, y: middleY};

    for (let y = blob.boundTopLeft.y; y < blob.boundBottomRight.y; y++) {
        for (let x = blob.boundTopLeft.x; x < blob.boundBottomRight.x; x++) {
            if (frameBuffer[x][y]) {
                //move corner vertexes
                if (x + y < cornerTopLeft.x + cornerTopLeft.y) {
                    cornerTopLeft.x = x;
                    cornerTopLeft.y = y;
                }
                else if (x - y > cornerTopRight.x - cornerTopRight.y) {
                    cornerTopRight.x = x;
                    cornerTopRight.y = y;
                }
                else if (x + y > cornerBottomRight.x + cornerBottomRight.y) {
                    cornerBottomRight.x = x;
                    cornerBottomRight.y = y;
                }
                else if (x - y < cornerBottomLeft.x - cornerBottomLeft.y) {
                    cornerBottomLeft.x = x;
                    cornerBottomLeft.y = y;
                }
            }
        }
    }

    return {
        cornerTopLeft,
        cornerTopRight,
        cornerBottomRight,
        cornerBottomLeft
    };
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