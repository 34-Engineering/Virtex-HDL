# Blob Processor Scripting

This folder is for scripting the functionality of the Blob Processor before writing it in System Verilog (BlobProcessor.sv) and is not directly used for the FPGA HDL.

This code is focuses on being easy to translate to System Verilog and has no emphasis on Typescript performance.

Based on `Config.ts`, image(s) are read from the `images` folder, processed, and then output to `output.png` or `output`.

## Running

Install Dependencies: `npm i`

Run Single Image: `npm run single`

Run All Images: `npm run all`

Note: requires NPM & Node 17.1
