import express from 'express';
import path from 'path';
import { Server } from 'socket.io';
import * as http from 'http';
import * as fs from 'fs';

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

    // socket.on('read', async () => {
    //     const data = fs.readFileSync("output.txt");
    //     io.emit('frame', data);
    // });

    socket.on('disconnect', () => {
        console.log('Web Disconnected');
    });
});

setInterval(() => {
    const data = fs.readFileSync("output.txt");
    io.emit('frame', data);
}, 50);

//Host
server.listen(34, function () {
    console.log(`Hosting @ http://localhost:${34}`);
});