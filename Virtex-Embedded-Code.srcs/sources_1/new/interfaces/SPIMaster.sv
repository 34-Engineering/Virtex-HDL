`timescale 1ns / 1ps

/* SPIMaster - 

    */
interface SPIMaster(
    input wire CLK,
    output bit CS,
    output bit MOSI,
    input bit MISO,
    input bit [7:0] writeData,
    input bit writeDataValid,
    output bit [7:0] readData,
    output bit readDataValid,
    input bit reset
    );

    parameter writeQueueSize = 10 - 1;
    bit [0:7] writeQueue[0:writeQueueSize];
    bit [9:0] writeQueueReadPointer = 0;
    bit [9:0] writeQueueWritePointer = 0;
    bit [3:0] writePointer = 0;
    bit isReading = 0;
    bit [3:0] readPointer = 0;

    //Loop
    always @(posedge CLK) begin
        
    end

    //Add to Write Queue
    always @(posedge writeDataValid) begin
        writeQueue[writeQueueWritePointer] = writeData;
        if (writeQueueWritePointer >= writeQueueSize) begin
            writeQueueWritePointer = 0;
        end
        else begin
            writeQueueWritePointer = writeQueueWritePointer + 1;
        end
    end

    //Reset (active low)
    always @(negedge reset) begin
        writeQueueReadPointer = 0;
        writeQueueWritePointer = 0;
        writePointer = 0;
        isReading = 0;
        readPointer = 0;
        readDataValid = 0;
    end
endinterface