`timescale 1ns / 1ps

/* SPIMaster - 

    */
interface SPIMaster(
    input wire CLK,
    output reg CS,
    output reg MOSI,
    input reg MISO,
    input reg [7:0] writeData,
    input reg writeDataValid,
    output reg [7:0] readData,
    output reg readDataValid,
    input reg reset
    );

    parameter writeQueueSize = 10 - 1;
    reg [0:7] writeQueue[0:writeQueueSize];
    reg [9:0] writeQueueReadPointer = 0;
    reg [9:0] writeQueueWritePointer = 0;
    reg [3:0] writePointer = 0;
    reg isReading = 0;
    reg [3:0] readPointer = 0;

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