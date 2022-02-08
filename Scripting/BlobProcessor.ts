const fs = require('fs');
var drawing = require('pngjs-draw');
const png = drawing(require('pngjs').PNG);

interface Vector {
    x: number,
    y: number
}

interface BlobData {
    boundTopLeft: Vector,
    boundBottomRight: Vector,
    cornerTopLeft: Vector,
    cornerTopRight: Vector,
    cornerBottomLeft: Vector,
    cornerBottomRight: Vector,
    area: number,
    pointer: number,
    valid: boolean
}

const MIN_AREA = 0;
const MAX_BLOBS = 1000;
const IMAGE_WIDTH = 640;
const IMAGE_HEIGHT = 480;

let frameBuffer: boolean[][] = Array.from(Array(IMAGE_WIDTH), () => Array(IMAGE_HEIGHT).fill(0));
let testBlobBuffer: number[][] = Array.from(Array(IMAGE_WIDTH), () => Array(IMAGE_HEIGHT).fill(0))
let blobIDBuffer: number[] = Array(IMAGE_WIDTH * 2).fill(MAX_BLOBS); //stores last 2 lines of blob IDs
let blobIDBufferHalf: boolean = false; //which section of the blobIDBuffer we are on [639:0] or [1279:640]
let blobs: BlobData[] = Array(MAX_BLOBS).fill({
    boundTopLeft: {x:0,y:0},
    boundBottomRight: {x:0,y:0},
    cornerTopLeft: {x:0,y:0},
    cornerTopRight: {x:0,y:0},
    cornerBottomLeft: {x:0,y:0},
    cornerBottomRight: {x:0,y:0},
    area: 0,
    pointer: 0,
    valid: false
});
let blobIndex = 0;

fs.createReadStream('images/2019_Noise.png')
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
                
                blobIDBuffer[x + (blobIDBufferHalf?IMAGE_WIDTH:0)] = blobID;
                testBlobBuffer[x][y] = blobID;
            }

            //swap blobIDBufferHalf
            blobIDBufferHalf = !blobIDBufferHalf;
        }

        console.log("blob count: ", blobIndex - 1, maxCount);

        //Draw Blobs
        for (let y = 0; y < IMAGE_HEIGHT; y++) {
            for (let x = 0; x < IMAGE_WIDTH; x++) {
                if (testBlobBuffer[x][y] !== MAX_BLOBS) {
                    const idx = (IMAGE_WIDTH * y + x) << 2;
                    const blobIndex = getBlobID(testBlobBuffer[x][y]);
                    // const blobIndex = testBlobBuffer[x][y];
                    //@ts-ignore
                    this.data[idx] = Math.sin(blobIndex * 50) * 255;
                    //@ts-ignore
                    this.data[idx + 1] = Math.sin(blobIndex * 100) * 255;
                }
            }
        }
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
                    blobs[i].cornerTopLeft.x,
                    blobs[i].cornerTopLeft.y,
                    blobs[i].cornerTopRight.x,
                    blobs[i].cornerTopRight.y,
                    [0, 255, 0, 255]
                );

                //@ts-ignore
                this.drawLine(
                    blobs[i].cornerTopRight.x,
                    blobs[i].cornerTopRight.y,
                    blobs[i].cornerBottomRight.x,
                    blobs[i].cornerBottomRight.y,
                    [0, 255, 0, 255]
                );

                //@ts-ignore
                this.drawLine(
                    blobs[i].cornerBottomRight.x,
                    blobs[i].cornerBottomRight.y,
                    blobs[i].cornerBottomLeft.x,
                    blobs[i].cornerBottomLeft.y,
                    [0, 255, 0, 255]
                );

                //@ts-ignore
                this.drawLine(
                    blobs[i].cornerBottomLeft.x,
                    blobs[i].cornerBottomLeft.y,
                    blobs[i].cornerTopLeft.x,
                    blobs[i].cornerTopLeft.y,
                    [0, 255, 0, 255]
                );
            }
        }

        //@ts-ignore
        this.pack().pipe(fs.createWriteStream('out.png'));
    });

let maxCount = 0;
function getBlobID(startID: number, count?: number): number {
    if (count) count++;
    else count = 1;
    if (blobs[startID].valid && count > maxCount) maxCount = count; 
    return blobs[startID].valid ? startID : getBlobID(blobs[startID].pointer, count);
}

//Process Pixel & Return BlobID
function processPixel(pos: Vector): number {
    let blobIDBufferIndexes: number[] = [];
    if (pos.x > 0 && pos.y > 0)
        blobIDBufferIndexes.push(pos.x-1 + (blobIDBufferHalf?0:IMAGE_WIDTH));
    if (pos.y > 0)
        blobIDBufferIndexes.push(pos.x+0 + (blobIDBufferHalf?0:IMAGE_WIDTH));
    if (pos.x < IMAGE_WIDTH-1 && pos.y > 0)
        blobIDBufferIndexes.push(pos.x+1 + (blobIDBufferHalf?0:IMAGE_WIDTH));
    if (pos.x > 0)
        blobIDBufferIndexes.push(pos.x-1 + (blobIDBufferHalf?IMAGE_WIDTH:0));

    let masterBlobID;
    for (let i = 0; i < blobIDBufferIndexes.length; i++) {
        const slaveBlobID = blobIDBuffer[blobIDBufferIndexes[i]];
        if (slaveBlobID !== MAX_BLOBS) {
            //found master
            if (!masterBlobID) {
                masterBlobID = getBlobID(slaveBlobID);
            }

            //merge blobs
            else if (getBlobID(slaveBlobID) !== masterBlobID) {
                blobs[masterBlobID].boundTopLeft.x = min(blobs[slaveBlobID].boundTopLeft.x, blobs[masterBlobID].boundTopLeft.x);
                blobs[masterBlobID].boundTopLeft.y = min(blobs[slaveBlobID].boundTopLeft.y, blobs[masterBlobID].boundTopLeft.y);
                blobs[masterBlobID].boundBottomRight.x = max(blobs[slaveBlobID].boundBottomRight.x, blobs[masterBlobID].boundBottomRight.x);
                blobs[masterBlobID].boundBottomRight.y = max(blobs[slaveBlobID].boundBottomRight.y, blobs[masterBlobID].boundBottomRight.y);
                
                if (blobs[slaveBlobID].cornerTopLeft.x+blobs[slaveBlobID].cornerTopLeft.y < blobs[masterBlobID].cornerTopLeft.x+blobs[masterBlobID].cornerTopLeft.y) {
                    blobs[masterBlobID].cornerTopLeft.x = blobs[slaveBlobID].cornerTopLeft.x;
                    blobs[masterBlobID].cornerTopLeft.y = blobs[slaveBlobID].cornerTopLeft.y;
                }
                else if (blobs[slaveBlobID].cornerTopRight.x-blobs[slaveBlobID].cornerTopRight.y > blobs[masterBlobID].cornerTopRight.x-blobs[masterBlobID].cornerTopRight.y) {
                    blobs[masterBlobID].cornerTopRight.x = blobs[slaveBlobID].cornerTopRight.x;
                    blobs[masterBlobID].cornerTopRight.y = blobs[slaveBlobID].cornerTopRight.y;
                }
                else if (blobs[slaveBlobID].cornerBottomRight.x+blobs[slaveBlobID].cornerBottomRight.y > blobs[masterBlobID].cornerBottomRight.x+blobs[masterBlobID].cornerBottomRight.y) {
                    blobs[masterBlobID].cornerBottomRight.x = blobs[slaveBlobID].cornerBottomRight.x;
                    blobs[masterBlobID].cornerBottomRight.y = blobs[slaveBlobID].cornerBottomRight.y;
                }
                else if (blobs[slaveBlobID].cornerBottomLeft.x-blobs[slaveBlobID].cornerBottomLeft.y < blobs[masterBlobID].cornerBottomLeft.x-blobs[masterBlobID].cornerBottomLeft.y) {
                    blobs[masterBlobID].cornerBottomLeft.x = blobs[slaveBlobID].cornerBottomLeft.x;
                    blobs[masterBlobID].cornerBottomLeft.y = blobs[slaveBlobID].cornerBottomLeft.y;
                }

                blobs[masterBlobID].area = blobs[masterBlobID].area + blobs[slaveBlobID].area;

                //mark slave as pointer to master
                blobs[slaveBlobID].valid = false;
                blobs[slaveBlobID].pointer = masterBlobID;
            }
        }
    }

    //add this pixel to blob
    if (masterBlobID) {
        blobs[masterBlobID].area++;

        if (pos.x < blobs[masterBlobID].boundTopLeft.x)
            blobs[masterBlobID].boundTopLeft.x = blobs[masterBlobID].boundTopLeft.x - 1;
        else if (pos.x + 1 > blobs[masterBlobID].boundBottomRight.x)
            blobs[masterBlobID].boundBottomRight.x = blobs[masterBlobID].boundBottomRight.x + 1;
        if (pos.y < blobs[masterBlobID].boundTopLeft.y)
            blobs[masterBlobID].boundTopLeft.y = blobs[masterBlobID].boundTopLeft.y - 1;
        else if (pos.y + 1 > blobs[masterBlobID].boundBottomRight.y)
            blobs[masterBlobID].boundBottomRight.y = blobs[masterBlobID].boundBottomRight.y + 1;
        
        if (pos.x + pos.y < blobs[masterBlobID].cornerTopLeft.x + blobs[masterBlobID].cornerTopLeft.y) {
            blobs[masterBlobID].cornerTopLeft.x = pos.x;
            blobs[masterBlobID].cornerTopLeft.y = pos.y;
        }
        else if (pos.x - pos.y > blobs[masterBlobID].cornerTopRight.x - blobs[masterBlobID].cornerTopRight.y) {
            blobs[masterBlobID].cornerTopRight.x = pos.x;
            blobs[masterBlobID].cornerTopRight.y = pos.y;
        }
        else if (pos.x + pos.y > blobs[masterBlobID].cornerBottomRight.x + blobs[masterBlobID].cornerBottomRight.y) {
            blobs[masterBlobID].cornerBottomRight.x = pos.x;
            blobs[masterBlobID].cornerBottomRight.y = pos.y;
        }
        else if (pos.x - pos.y < blobs[masterBlobID].cornerBottomLeft.x - blobs[masterBlobID].cornerBottomLeft.y) {
            blobs[masterBlobID].cornerBottomLeft.x = pos.x;
            blobs[masterBlobID].cornerBottomLeft.y = pos.y;
        }

        return masterBlobID;
    }
    
    //not touching a blob => make new blob
    else {
        blobs[blobIndex] = {
            boundTopLeft:      {x:pos.x  , y:pos.y  },
            boundBottomRight:  {x:pos.x+0, y:pos.y+0},
            cornerTopLeft:     {x:pos.x  , y:pos.y  },
            cornerTopRight:    {x:pos.x+1, y:pos.y  },
            cornerBottomLeft:  {x:pos.x  , y:pos.y+1},
            cornerBottomRight: {x:pos.x+1, y:pos.y+1},
            area: 1,
            pointer: 0,
            valid: true
        };

        blobIndex++;
                
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