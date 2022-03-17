import express from 'express';
import path from 'path';
import { calculateIDX, drawCenterFillSquare, drawEllipse, drawLine, drawPixel, drawQuad, drawRect } from '../Scripting/util/OtherUtil';
import { SerialPort } from 'serialport';
const app: express.Application = express();

//EJS Page
app.use('/assets', express.static('assets', {maxAge: '1d'}));
app.set('view engine', 'ejs');
app.get('/', (req: express.Request, res: express.Response) => {
    res.render(path.join(__dirname, '/App'));
});

//Serial
let serialPort: any | null = null;
const sleep = ms => new Promise(r => setTimeout(r, ms));
async function initSerialPort() {
    serialPort = new SerialPort({
        path: '\\\\.\\COM6',
        baudRate: 921600,
        parity: 'none'
    });
    serialPort.on('data', onData);
    serialPort.on('error', onError);
    serialPort.on('close', () => { process.exit(1); });

    serialPort.write(Buffer.from([0b00000001]));
}
initSerialPort();

//Frame
let frame: Buffer = Buffer.alloc(153600);
let framePointer: number = 0;
let queue: number[] = [];

function onData(newData: Buffer) {
    // console.log(newData);
    for (let i = 0; i < newData.length; i++) {
        frame[framePointer] = newData[i];
        framePointer++;
    }

    if (framePointer >= 153600) {
        framePointer = 0;
        if (queue.length > 0) {
            serialPort.write(Buffer.from(queue));
            queue = [];
        }
        serialPort.write(Buffer.from([0b00000001]));
    }
}
function onError(err: any) {
    console.error(err);
}

//Actions
app.use(express.json());
app.post('/frame', (req: express.Request, res: express.Response) => {
    try {
        res.send({ frame });
    }
    catch (e) { res.send({ error: e }); }
});
app.post('/setting', (req: express.Request, res: express.Response) => {
    try {
        queue.push(0b11000000 + req.body.addr);
        queue.push(req.body.value >> 8);
        queue.push(req.body.value & 0xFF);
        res.send({ ok: true });
    }
    catch (e) { res.send({ error: e }); }
});
app.post('/disable', (req: express.Request, res: express.Response) => {
    try {
        queue.push(0xA);
        res.send({ ok: true });
    }
    catch (e) { res.send({ error: e }); }
});
app.post('/enable', (req: express.Request, res: express.Response) => {
    try {
        queue.push(0xB);
        res.send({ ok: true });
    }
    catch (e) { res.send({ error: e }); }
});

//Host Webapp
app.post('/ping', (req: express.Request, res: express.Response) => {
    res.send({ pid: process.pid });
});
const port: number = 34;
app.listen(port, () => {
  return console.log(`Serial App @ http://localhost:${port}`);
});