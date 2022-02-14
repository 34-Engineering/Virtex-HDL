# Blob Processor Scripting

This folder is for scripting the functionality of the Blob Processor before writing it in System Verilog (BlobProcessor.sv)

This code is focuses on being easy to translate to System Verilog and has no emphasis on Typescript performance.

Based on `Config.ts`, image(s) are read from the `images` folder, processed, and then output to `output.png` or `output`.

## Running

```
npm i
npm start
```

Note: requires NPM & Node 17.1
