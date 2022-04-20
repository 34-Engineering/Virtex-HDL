import express from 'express';
import path from 'path';
import { SerialPort } from 'serialport';
import { Server } from 'socket.io';
import * as http from 'http';

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
let frame: Buffer = Buffer.alloc(153600);
let target: Buffer = Buffer.alloc(6);
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
        if (isTargetRequest) target[readPointer] = newData[i];
        else frame[readPointer] = newData[i];
        readPointer++;
    }

    //End Read
    if (isTargetRequest ? readPointer >= 6 : readPointer >= 153600) {
        //Reset
        readPointer = 0;
                
        //Write Command Queue
        if (queue.length > 0) {
            serialPort.write(Buffer.from(queue));
            queue = [];
        }

        //Send to Web
        if (isTargetRequest) io.emit('target', target);
        else io.emit('frame', frame);

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