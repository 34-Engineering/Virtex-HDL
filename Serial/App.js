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
var buffer;
function initSerialPort() {
    serialPort = new serialport_1.SerialPort({
        path: '\\\\.\\COM6',
        baudRate: 921600,
        parity: 'none'
    });
    serialPort.on('data', onData);
    serialPort.on('error', onError);
}
initSerialPort();
function onData(newData) {
    if (buffer) {
        buffer = Buffer.concat([buffer, newData], buffer.length + newData.length);
    }
    buffer = newData;
}
function onError(err) {
    console.error(err);
}
//Actions
app.use(express_1["default"].json());
app.post('/update', function (req, res) {
    try {
        res.send({ buffer: buffer });
        buffer = null;
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
