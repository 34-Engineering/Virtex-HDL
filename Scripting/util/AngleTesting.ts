//returns a number that represents a ratio between a & b
function quickDivide(a: number, b: number): number {
    let str = '';
    for (let n = 5; n > 0; n--)
        str += Math.abs(b) > Math.abs(a) >> n ? 1:0;
    for (let n = 0; n < 5; n++)
        str += Math.abs(b) > Math.abs(a) << n ? 1:0;
    return parseInt(str, 2);
}

//get the angle of a line using horizontal/vertical comparison
function calcAngle(x: number, y: number): string {
    const t = 896; //best fit for 10° tolerance

    const h = quickDivide(y, x); //how horizontal the line is
    const v = quickDivide(x, y); //how vertical the line is

    if (h > t && v < t)
        return "--";
    
    if (h < t && v > t)
        return "||";
    
    return Math.sign(x) * Math.sign(y) > 0 ? "//" : "\\";
}

//returns the actual value of made by line
function calcTrueAngle(x: number, y: number): string {
    const tolerance = 10; //means hori and vertical are ±10°
    const angle = Math.atan(y / x) * (180 / Math.PI);

    if (Math.abs(angle) > 90 - tolerance)
        return "||";

    else if (Math.abs(angle) < tolerance)
        return "--";

    return Math.sign(x) * Math.sign(y) > 0 ? "//" : "\\";
}

testArray();

//test all values (-640, -480) thru (640, 480)
function testAll() {
    let out: { x: number, y: number, h: number, v: number, a: string, g: string, ang: string }[] = [];
    let error = 0;
    for (let y = -480; y <= 480; y++) {
        for (let x = -640; x <= 640; x++) {
            const g = calcAngle(x, y);
            const a = calcTrueAngle(x, y);
            if (g !== a) {
                if (error % 100 == 0 && x % 10 == 0 && y % 10 == 0) {
                    out.push({
                        x, y,
                        h: quickDivide(y, x),
                        v: quickDivide(x, y),
                        a, g,
                        ang: (Math.atan(y / x) * (180 / Math.PI)).toFixed(2) 
                    });
                }
                error++;
            }
        }
    }
    console.table(out);
    console.log("Error:", error, (error / (640*2*480*2) * 100).toFixed(2) + "%");
}

//test a set array of vectors
function testArray() {
    let arr: number[][] = [
        [ 4 ,  0 ],
        [ 0 ,  4 ],

        [ 6 ,  1 ],
        [ 6 ,  2 ],

        [ 1 ,  6 ],
        [ 2 ,  6 ],

        [300,  0 ],
        [600,  0 ],
        [600, 100],
        [12 ,  2 ],
        [10 , -1 ],
        [300, 50 ],

        [ 0 , 400],
        [ 2 , 12 ],
        [-1 , 10 ],

        [ 3 ,  1 ],
        [ 3 ,  3 ],
        [300, 300],
        [-3 , -3 ],

        [ 3 , -1 ],
        [-3 ,  3 ],

        [-90, 360],
        [101, 420],
        [-120, -480],
        [-40, 180],
        [-620, -130],
        [-600, -40],
        [-40, 180]
    ];
    let out: { x: number, y: number, h: number, v: number, a: string, g: string, err: boolean, ang: string }[] = [];
    for (let i = 0; i < arr.length; i++) {
        const x = arr[i][0];
        const y = arr[i][1];
        const a = calcTrueAngle(x, y);
        const g = calcAngle(x, y);
        out.push({
            x, y,
            h: quickDivide(y, x),
            v: quickDivide(x, y),
            a, g,
            err: a !== g,
            ang: (Math.atan(y / x) * (180 / Math.PI)).toFixed(2)
        });
    }
    console.table(out);
}