`timescale 1ns / 1ps

/* I2CSlave - 

    */
module I2CSlave #(parameter ADDR = 'h34) (
    input wire SCL,
    inout reg SDA,
    input bit [7:0] writeData,
    input bit writeDataValid,
    output bit [7:0] readData,
    output bit readDataValid,
    input bit reset //active low
    );

    parameter writeQueueSize = 10 - 1;
    bit [0:7] writeQueue[0:writeQueueSize];
    bit [9:0] writeQueueReadPointer = 0;
    bit [9:0] writeQueueWritePointer = 0;
    bit [3:0] writePointer = 0;
    bit isReading = 0;
    bit [3:0] readPointer = 0;

    //Loop
    always @(posedge SCL) begin
        
    end

    /*
        I2C Slave Cheat Sheet

        MSB First

        Sequence:
        Start condition + [7 bit address + R/W bit + Ack bit] + [data byte + Ack bit] + Stop condition
        
        Start condition: pulled low
        R/W bit: 0 -> write, 1 -> read
        Ack bit: 0 -> ACK, 1 -> NACK
        Stop condition: pulled high
        reading = write location + read data1...4
        writing = write location + write data1...4
    
    */

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
endmodule