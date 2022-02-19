import express from 'express';
const app: express.Application = express();
const port: number = 3000;

app.get('/', (req: express.Request, res: express.Response) => {
  res.send('Hello World!');
});

app.listen(port, () => {
  return console.log(`Blob App @ http://localhost:${port}`);
});