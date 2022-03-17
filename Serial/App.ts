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
let framePointer: number = 0;
let queue: number[] = [];
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
    //Load Buffer Chunks into Frame Buffer
    for (let i = 0; i < newData.length; i++) {
        frame[framePointer] = newData[i];
        framePointer++;
    }

    //Frame Done
    if (framePointer >= 153600) {
        //Send to Web
        io.emit('frame', frame);
        
        //Reset
        framePointer = 0;
        
        //Write Command Queue
        if (queue.length > 0) {
            serialPort.write(Buffer.from(queue));
            queue = [];
        }

        //Request New Frame
        serialPort.write(Buffer.from([0b00000001]));
    }
}
function onError(err: any) {
    console.error(err);
}
initSerialPort();

//Host
server.listen(34, function () {
    console.log(`Hosting @ http://localhost:${34}`);
});