//BlobProcessor.ts

//Imports
const fs = require('fs');
const drawing = require('pngjs-draw');
const png = drawing(require('pngjs').PNG);

//Constants
const MIN_AREA = 0;
const MAX_BLOBS = 1000;
const IMAGE_WIDTH = 640;
const IMAGE_HEIGHT = 480;
const IMAGE_PATH = 'images/2019_Noise.png';

//Interfaces
interface Vector {
    x: number,
    y: number
}
interface BlobData {
    boundTopLeft: Vector,
    boundBottomRight: Vector,
    quadTopLeft: Vector,
    quadTopRight: Vector,
    quadBottomLeft: Vector,
    quadBottomRight: Vector,
    area: number,
    pointer: number,
    valid: boolean
}

//Variables
let frameBuffer: boolean[][] = Array.from(Array(IMAGE_WIDTH), () => Array(IMAGE_HEIGHT).fill(0));
let blobBuffer: number[][] = Array.from(Array(IMAGE_WIDTH), () => Array(IMAGE_HEIGHT).fill(0)); //for coloring blobs (only for script version)
let blobIDBuffer: number[] = Array(IMAGE_WIDTH * 2).fill(MAX_BLOBS); //stores last 2 lines of blob IDs
let blobIDBufferHalf: boolean = false; //which section of the blobIDBuffer we are on [639:0] or [1279:640]
let blobs: BlobData[] = Array(MAX_BLOBS).fill({
    boundTopLeft: {x:0, y:0},
    boundBottomRight: {x:0, y:0},
    quadTopLeft: {x:0, y:0},
    quadTopRight: {x:0, y:0},
    quadBottomLeft: {x:0, y:0},
    quadBottomRight: {x:0, y:0},
    area: 0,
    pointer: 0,
    valid: false
});
let blobIndex = 0;

//Read Image
fs.createReadStream(IMAGE_PATH)
    .pipe(new png())
    .on('parsed', function () {
        //Process all Pixels
        for (let y = 0; y < IMAGE_HEIGHT; y++) {
            for (let x = 0; x < IMAGE_WIDTH; x++) {
                const idx = (IMAGE_WIDTH * y + x) << 2;
                //@ts-ignore
                const value = (this.data[idx] + this.data[idx + 1] + this.data[idx + 2]) / 3;
                const threshold = value > 128;
                frameBuffer[x][y] = threshold;

                let blobID = MAX_BLOBS;
                if (threshold) {
                    blobID = processPixel({ x, y });
                }
                
                //push blobID to buffer for every pixel
                blobIDBuffer[x + (blobIDBufferHalf?IMAGE_WIDTH:0)] = blobID;

                blobBuffer[x][y] = blobID;
            }

            //swap which half of the buffer we are using every line
            blobIDBufferHalf = !blobIDBufferHalf;
        }

        //Log Data
        console.log("blob count: ", blobIndex - 1, "max recursion: ", maxRecursion);

        //Draw Blob Color
        for (let y = 0; y < IMAGE_HEIGHT; y++) {
            for (let x = 0; x < IMAGE_WIDTH; x++) {
                if (blobBuffer[x][y] !== MAX_BLOBS) {
                    const idx = (IMAGE_WIDTH * y + x) << 2;
                    const blobIndex = getBlobID(blobBuffer[x][y]);
                    // const blobIndex = blobBuffer[x][y];
                    //@ts-ignore
                    this.data[idx] = Math.sin(blobIndex * 50) * 255;
                    //@ts-ignore
                    this.data[idx + 1] = Math.sin(blobIndex * 100) * 255;
                }
            }
        }

        //Draw Blob Bounding Box + Quad
        for (let i = 0; i < blobs.length; i++) {
            const area = (blobs[i]?.boundBottomRight.x - blobs[i]?.boundTopLeft.x) * (blobs[i]?.boundBottomRight.y - blobs[i]?.boundTopLeft.y);
            if (blobs[i]?.valid && area >= MIN_AREA) {
                //@ts-ignore
                this.drawRect(
                    blobs[i].boundTopLeft.x,
                    blobs[i].boundTopLeft.y,
                    blobs[i].boundBottomRight.x - blobs[i].boundTopLeft.x,
                    blobs[i].boundBottomRight.y - blobs[i].boundTopLeft.y,
                    [255, 0, 0, 255]
                );

                // @ts-ignore
                this.drawLine(
                    blobs[i].quadTopLeft.x,
                    blobs[i].quadTopLeft.y,
                    blobs[i].quadTopRight.x,
                    blobs[i].quadTopRight.y,
                    [0, 255, 0, 255]
                );

                //@ts-ignore
                this.drawLine(
                    blobs[i].quadTopRight.x,
                    blobs[i].quadTopRight.y,
                    blobs[i].quadBottomRight.x,
                    blobs[i].quadBottomRight.y,
                    [0, 255, 0, 255]
                );

                //@ts-ignore
                this.drawLine(
                    blobs[i].quadBottomRight.x,
                    blobs[i].quadBottomRight.y,
                    blobs[i].quadBottomLeft.x,
                    blobs[i].quadBottomLeft.y,
                    [0, 255, 0, 255]
                );

                //@ts-ignore
                this.drawLine(
                    blobs[i].quadBottomLeft.x,
                    blobs[i].quadBottomLeft.y,
                    blobs[i].quadTopLeft.x,
                    blobs[i].quadTopLeft.y,
                    [0, 255, 0, 255]
                );
            }
        }

        //@ts-ignore
        this.pack().pipe(fs.createWriteStream('out.png'));
    });

//Follow Pointers to get true Blob ID (max ~3 recursion)
let maxRecursion = 0;
function getBlobID(startID: number, recursion?: number): number {
    //track recursion count (script only)
    recursion = recursion ? 1 : recursion + 1;
    if (blobs[startID].valid && recursion > maxRecursion) {
        maxRecursion = recursion;
    }

    //if this blob is valid return its ID, otherwise follow pointer
    return blobs[startID].valid ? startID : getBlobID(blobs[startID].pointer, recursion);
}

//Process Pixel & Return BlobID
function processPixel(pos: Vector): number {
    //pick out top left, top, top right, and left pixels from blobIDBuffer
    //but only if they are in the bounding of the 640x480 image
    let blobIDBufferIndexes: number[] = [];
    if (pos.x > 0 && pos.y > 0)
        blobIDBufferIndexes.push(pos.x-1 + (blobIDBufferHalf?0:IMAGE_WIDTH));
    if (pos.y > 0)
        blobIDBufferIndexes.push(pos.x+0 + (blobIDBufferHalf?0:IMAGE_WIDTH));
    if (pos.x < IMAGE_WIDTH-1 && pos.y > 0)
        blobIDBufferIndexes.push(pos.x+1 + (blobIDBufferHalf?0:IMAGE_WIDTH));
    if (pos.x > 0)
        blobIDBufferIndexes.push(pos.x-1 + (blobIDBufferHalf?IMAGE_WIDTH:0));

    //find which blob to join, and merge blobs if it is touching mutliple
    let masterBlobID;
    for (let i = 0; i < blobIDBufferIndexes.length; i++) {
        const slaveBlobID = blobIDBuffer[blobIDBufferIndexes[i]];
        if (slaveBlobID !== MAX_BLOBS) {
            //found master (1st valid blob)
            if (!masterBlobID) {
                masterBlobID = getBlobID(slaveBlobID);
            }

            //found another valid blob => merge with master
            else if (getBlobID(slaveBlobID) !== masterBlobID) {
                //expand bounding box
                blobs[masterBlobID].boundTopLeft.x = min(blobs[slaveBlobID].boundTopLeft.x, blobs[masterBlobID].boundTopLeft.x);
                blobs[masterBlobID].boundTopLeft.y = min(blobs[slaveBlobID].boundTopLeft.y, blobs[masterBlobID].boundTopLeft.y);
                blobs[masterBlobID].boundBottomRight.x = max(blobs[slaveBlobID].boundBottomRight.x, blobs[masterBlobID].boundBottomRight.x);
                blobs[masterBlobID].boundBottomRight.y = max(blobs[slaveBlobID].boundBottomRight.y, blobs[masterBlobID].boundBottomRight.y);
                
                //expand quad
                if (blobs[slaveBlobID].quadTopLeft.x+blobs[slaveBlobID].quadTopLeft.y < blobs[masterBlobID].quadTopLeft.x+blobs[masterBlobID].quadTopLeft.y) {
                    blobs[masterBlobID].quadTopLeft.x = blobs[slaveBlobID].quadTopLeft.x;
                    blobs[masterBlobID].quadTopLeft.y = blobs[slaveBlobID].quadTopLeft.y;
                }
                else if (blobs[slaveBlobID].quadTopRight.x-blobs[slaveBlobID].quadTopRight.y > blobs[masterBlobID].quadTopRight.x-blobs[masterBlobID].quadTopRight.y) {
                    blobs[masterBlobID].quadTopRight.x = blobs[slaveBlobID].quadTopRight.x;
                    blobs[masterBlobID].quadTopRight.y = blobs[slaveBlobID].quadTopRight.y;
                }
                else if (blobs[slaveBlobID].quadBottomRight.x+blobs[slaveBlobID].quadBottomRight.y > blobs[masterBlobID].quadBottomRight.x+blobs[masterBlobID].quadBottomRight.y) {
                    blobs[masterBlobID].quadBottomRight.x = blobs[slaveBlobID].quadBottomRight.x;
                    blobs[masterBlobID].quadBottomRight.y = blobs[slaveBlobID].quadBottomRight.y;
                }
                else if (blobs[slaveBlobID].quadBottomLeft.x-blobs[slaveBlobID].quadBottomLeft.y < blobs[masterBlobID].quadBottomLeft.x-blobs[masterBlobID].quadBottomLeft.y) {
                    blobs[masterBlobID].quadBottomLeft.x = blobs[slaveBlobID].quadBottomLeft.x;
                    blobs[masterBlobID].quadBottomLeft.y = blobs[slaveBlobID].quadBottomLeft.y;
                }

                //combine areas
                blobs[masterBlobID].area = blobs[masterBlobID].area + blobs[slaveBlobID].area;

                //mark slave as pointer to master
                blobs[slaveBlobID].valid = false;
                blobs[slaveBlobID].pointer = masterBlobID;
            }
        }
    }

    //add this pixel to blob if we have a valid blob to join
    if (masterBlobID) {
        //expand bounding box
        if (pos.x < blobs[masterBlobID].boundTopLeft.x)
            blobs[masterBlobID].boundTopLeft.x = blobs[masterBlobID].boundTopLeft.x - 1;
        else if (pos.x + 1 > blobs[masterBlobID].boundBottomRight.x)
            blobs[masterBlobID].boundBottomRight.x = blobs[masterBlobID].boundBottomRight.x + 1;
        if (pos.y < blobs[masterBlobID].boundTopLeft.y)
            blobs[masterBlobID].boundTopLeft.y = blobs[masterBlobID].boundTopLeft.y - 1;
        else if (pos.y + 1 > blobs[masterBlobID].boundBottomRight.y)
            blobs[masterBlobID].boundBottomRight.y = blobs[masterBlobID].boundBottomRight.y + 1;
        
        //expand quad
        if (pos.x + pos.y < blobs[masterBlobID].quadTopLeft.x + blobs[masterBlobID].quadTopLeft.y) {
            blobs[masterBlobID].quadTopLeft.x = pos.x;
            blobs[masterBlobID].quadTopLeft.y = pos.y;
        }
        else if (pos.x - pos.y > blobs[masterBlobID].quadTopRight.x - blobs[masterBlobID].quadTopRight.y) {
            blobs[masterBlobID].quadTopRight.x = pos.x;
            blobs[masterBlobID].quadTopRight.y = pos.y;
        }
        else if (pos.x + pos.y > blobs[masterBlobID].quadBottomRight.x + blobs[masterBlobID].quadBottomRight.y) {
            blobs[masterBlobID].quadBottomRight.x = pos.x;
            blobs[masterBlobID].quadBottomRight.y = pos.y;
        }
        else if (pos.x - pos.y < blobs[masterBlobID].quadBottomLeft.x - blobs[masterBlobID].quadBottomLeft.y) {
            blobs[masterBlobID].quadBottomLeft.x = pos.x;
            blobs[masterBlobID].quadBottomLeft.y = pos.y;
        }

        //increment area
        blobs[masterBlobID].area++;

        return masterBlobID;
    }
    
    //not touching a blob => make new blob
    else {
        //create blob at next available index
        blobs[blobIndex] = {
            boundTopLeft:     {x:pos.x  , y:pos.y  },
            boundBottomRight: {x:pos.x+1, y:pos.y+1},
            quadTopLeft:      {x:pos.x  , y:pos.y  },
            quadTopRight:     {x:pos.x+1, y:pos.y  },
            quadBottomLeft:   {x:pos.x  , y:pos.y+1},
            quadBottomRight:  {x:pos.x+1, y:pos.y+1},
            area: 1,
            pointer: 0,
            valid: true
        };

        //increment index for next blob
        blobIndex++;
        
        //return the index that we used
        return blobIndex - 1;
    }
}

//Range Functions
function min(num1: number, num2: number): number {
    return num1 < num2 ? num1 : num2;
}

function max(num1: number, num2: number): number {
    return num1 > num2 ? num1 : num2;
}