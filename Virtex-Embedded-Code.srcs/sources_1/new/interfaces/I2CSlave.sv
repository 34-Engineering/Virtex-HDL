`timescale 1ns / 1ps

/* I2CSlave - 

    */
module I2CSlave #(parameter ADDR = 'h34) (
    input wire SCL,
    inout reg SDA,
    output bit [7:0] readData,
    output bit readDataValid
    );

    parameter writeQueueSize = 10 - 1;
    bit [0:7] writeQueue[0:writeQueueSize];
    bit [9:0] writeQueueReadPointer = 0;
    bit [9:0] writeQueueWritePointer = 0;
    bit [3:0] writePointer = 0;

    task write(bit [0:7] data);
        writeQueue[writeQueueWritePointer] = data;
        if (writeQueueWritePointer >= writeQueueSize) begin
            writeQueueWritePointer = 0;
        end
        else begin
            writeQueueWritePointer = writeQueueWritePointer + 1;
        end
    endtask
    task clearWriteQueue();
        writeQueueReadPointer = 0;
        writeQueueWritePointer = 0;
    endtask

    bit isReading = 0;
    bit [3:0] readPointer = 0;

    /*
        I2C Slave Cheat Sheet

        MSB first

        Start condition: pulled low
        R/W bit: 0 -> write, 1 -> read
        Ack bit: 0 -> ACK, 1 -> NACK
        Stop condition: pulled high

        Sequence:
        Start condition + [7 bit address + R/W bit + Ack bit] + [data byte + Ack bit] + Stop condition
        [] = section
        reading = write location + read data1...4
        writing = write location + write data1...4
    
    */
endmodule