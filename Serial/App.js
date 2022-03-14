"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
exports.__esModule = true;
var express_1 = __importDefault(require("express"));
var path_1 = __importDefault(require("path"));
var serialport_1 = require("serialport");
var app = (0, express_1["default"])();
//EJS Page
app.use('/assets', express_1["default"].static('assets', { maxAge: '1d' }));
app.set('view engine', 'ejs');
app.get('/', function (req, res) {
    res.render(path_1["default"].join(__dirname, '/App'));
});
//Serial
var serialPort = null;
function initSerialPort() {
    serialPort = new serialport_1.SerialPort({
        path: '\\\\.\\COM6',
        baudRate: 921600,
        parity: 'none'
    });
    serialPort.on('data', onData);
    serialPort.on('error', onError);
    serialPort.write(Buffer.from([1]));
}
initSerialPort();
//Frame
var frames = [
    Buffer.alloc(38400), Buffer.alloc(38400), Buffer.alloc(38400), Buffer.alloc(38400),
    Buffer.alloc(38400), Buffer.alloc(38400), Buffer.alloc(38400), Buffer.alloc(38400)
];
var framePointer = 0;
var frameNumber = 0;
function onData(newData) {
    for (var i = 0; i < newData.length; i++) {
        frames[frameNumber][framePointer] = newData[i];
        framePointer++;
    }
    if (framePointer >= 38400) {
        framePointer = 0;
        if (frameNumber == 7)
            frameNumber = 0;
        else
            frameNumber++;
        serialPort.write(Buffer.from([1]));
    }
}
function onError(err) {
    console.error(err);
}
//Actions
app.use(express_1["default"].json());
app.post('/frame', function (req, res) {
    try {
        res.send({ frames: frames });
    }
    catch (e) {
        res.send({ error: e });
    }
});
//Host Webapp
app.post('/ping', function (req, res) {
    res.send({ pid: process.pid });
});
var port = 34;
app.listen(port, function () {
    return console.log("Serial App @ http://localhost:".concat(port));
});
