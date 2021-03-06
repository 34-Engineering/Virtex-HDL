import express from 'express';
import path from 'path';
import { Server } from 'socket.io';
import * as http from 'http';
import * as fs from 'fs';
import { PNG } from 'pngjs';
import * as v8 from 'v8';
import { drawCenterFillSquare, drawLine, drawQuad10, drawRect } from '../VisionScripting/src/DrawUtil';

//Express (PC->Web)
const app: express.Application = express();
app.use('/assets', express.static('assets', { maxAge: '1d' }));
app.set('view engine', 'ejs');
app.get('/', (req, res) => res.render(path.join(__dirname, '/App')));
app.use("/socket.io.js", express.static(path.join(__dirname, 'node_modules/socket.io/client-dist/socket.io.js')));
app.use("/socket.io.js.map", express.static(path.join(__dirname, 'node_modules/socket.io/client-dist/socket.io.js.map')));
const server = http.createServer(app);

//Read Image
const IMAGE_URL = '../images/2019.png';
let image = PNG.sync.read(fs.readFileSync(IMAGE_URL));

//Write Bitfile for System Verilog
let bitfile = '';
for (let i = 0; i < image.data.length; i += 32) {
    let bit = "8'b";
    for (let b = 0; b < 32; b += 4) {
        const val = (image.data[i+b] + image.data[i+b+1] + image.data[i+b+2]) / 3;
        bit += (val > 128) ? 1 : 0;
    }
    bitfile += ((i > 0) ? ",\n" : "") + bit;
}
bitfile = `\`ifndef IMAGE_DONE\n\`define IMAGE_DONE\nreg [7:0] image [38400] = '{\n${bitfile}\n};\n\`endif`;
fs.writeFileSync("../../Virtex-HDL.srcs/test_1/new/Image.sv", bitfile);

//Socket (PC->Web)
const io = new Server(server);
io.on('connection', (socket) => {
    console.log('Web Connected');

    socket.on('disconnect', () => {
        console.log('Web Disconnected');
    });
});

setInterval(() => {
    //Copy Image
    let tempImage = v8.deserialize(v8.serialize(image));

    //Read Objects
    const lines = fs.readFileSync("output.txt").toString().split("\n");

    //Draw Objects
    for (const line of lines) {
        if (line.length < 1) continue;

        try {
            const obj = JSON.parse(line.replace(/(['"])?([a-z0-9A-Z_]+)(['"])?:/g, '"$2": '));
            
            //Target
            if (obj.target) {
                //bound
                drawRect(tempImage.data, {
                    x: obj.center.x - (obj.width >> 1),
                    y: obj.center.y - (obj.height >> 1)
                }, {
                    x: obj.center.x + (obj.width >> 1),
                    y: obj.center.y + (obj.height >> 1)
                }, [125, 255, 125, 255]);

                //center
                drawCenterFillSquare(tempImage.data, obj.center, 2, [125, 255, 125, 255]);
            }

            //BLob
            else if (obj.blob) {
                //bound
                drawRect(tempImage.data, obj.topLeft, obj.bottomRight, [255, 0, 0, 100]);

                //quad
                drawQuad10(tempImage.data, obj.quad, [0, 255, 0, 100]);
            }
        }
        catch (e) { console.error("PARSE ERROR"); }
    }

    //Send Frame
    io.emit('frame', tempImage.data);
}, 100);

//Host
server.listen(34, function () {
    console.log(`Hosting @ http://localhost:${34}`);
});