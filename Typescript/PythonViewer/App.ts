import express from 'express';
import path from 'path';
import { SerialPort } from 'serialport';
import { Server } from 'socket.io';
import * as http from 'http';
import { drawCenterFillSquare, drawRect } from '../VisionScripting/src/DrawUtil';

//Express (PC->Web)
const app: express.Application = express();
app.use('/assets', express.static('assets', { maxAge: '1d' }));
app.set('view engine', 'ejs');
app.use(express.json());
app.get('/', (req, res) => res.render(path.join(__dirname, '/App')));
app.use("/socket.io.js", express.static(path.join(__dirname, 'node_modules/socket.io/client-dist/socket.io.js')));
app.use("/socket.io.js.map", express.static(path.join(__dirname, 'node_modules/socket.io/client-dist/socket.io.js.map')));
const server = http.createServer(app);

//Socket (PC->Web)
const io = new Server(server);
io.on('connection', (socket) => {
    console.log('Web Connected');

    socket.on('disable', () => {
        console.log(' > diabling');
        queue.push(0xA);
    });
    socket.on('enable', () => {
        console.log(' > enabling');
        queue.push(0xB);
    });
    socket.on('setting', (req: { addr: number, value: number }) => {
        console.log(` > updating setting ${req.addr} to ${req.value}`);
        queue.push(0b11000000 + req.addr);
        queue.push(req.value >> 8);
        queue.push(req.value & 0xFF);
    });

    socket.on('disconnect', () => {
        console.log('Web Disconnected');
    });
});

//Serial (PC->FT2232H->FPGA)
let serialPort: any | null = null;
let frame: Buffer = Buffer.alloc(640 * 480 << 2);
let target: string = "";
let readPointer: number = 0;
let queue: number[] = [];
let isTargetRequest: boolean = false;
async function initSerialPort() {
    serialPort = new SerialPort({
        path: '\\\\.\\COM6',
        baudRate: 921600,
        parity: 'none'
    });
    serialPort.on('data', onData);
    serialPort.on('error', onError);
    serialPort.on('open', () => console.log("Virtex Connected"));
    serialPort.on('close', () => process.exit(1));

    //Request First Frame
    serialPort.write(Buffer.from([0b00000001]));
}
function onData(newData: Buffer) {
    //Copy Buffer
    for (let i = 0; i < newData.length; i++) {
        if (isTargetRequest) {
            let padByte = (str: string) => "0".repeat(8 - str.length) + str;
            target += padByte(newData[i].toString(2));
        }
        else {
            //split byte into 2 pixels -> covert to 8-bit RGBA
            const idx = readPointer << 3;
            const pix1 = (newData[i] & 0xF) * 17;// > 128 ? 255 : 0;
            const pix2 = (newData[i] >> 4) * 17 ;// > 128 ? 255 : 0;

            frame[idx+0] = pix1;
            frame[idx+1] = pix1;
            frame[idx+2] = pix1;
            frame[idx+3] = 255;

            frame[idx+4] = pix2;
            frame[idx+5] = pix2;
            frame[idx+6] = pix2;
            frame[idx+7] = 255;
        }
        readPointer++;
    }

    //End Read
    if (isTargetRequest ? readPointer >= 6 : readPointer >= (640 * 480 >> 1)) {
        //Write Command Queue
        if (queue.length > 0) {
            serialPort.write(Buffer.from(queue));
            queue = [];
        }

        //Draw Target & Send to Web
        if (isTargetRequest) {
            //parse target string => object
            const obj = {
                center: {
                    x: parseInt(target.slice(0, 10), 2),
                    y: parseInt(target.slice(10, 20), 2)
                },
                width: parseInt(target.slice(20, 30), 2),
                height: parseInt(target.slice(30, 40), 2),
                blobCount: parseInt(target.slice(40, 46), 2),
                angle: parseInt(target.slice(46, 48), 2)
            };

            //bound
            drawRect(frame, {
                x: Math.max(obj.center.x - (obj.width >> 1), 0),
                y: Math.max(obj.center.y - (obj.height >> 1), 0)
            }, {
                x: Math.min(obj.center.x + (obj.width >> 1), 639),
                y: Math.min(obj.center.y + (obj.height >> 1), 479)
            }, [125, 255, 125, 255]);

            //center
            drawCenterFillSquare(frame, obj.center, 2, [125, 255, 125, 255]);

            io.emit('frame', frame);
        }

        //Reset
        readPointer = 0;
        target = "";

        //Request New
        isTargetRequest = !isTargetRequest;
        serialPort.write(Buffer.from([isTargetRequest ? 0b00000010 : 0b00000001]));
    }
}
function onError(err: any) {
    console.error(err);
}
initSerialPort(); //TODO reconnect

//Host
server.listen(34, function () {
    console.log(`Hosting @ http://localhost:${34}`);
});