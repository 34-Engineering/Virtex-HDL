`timescale 1ns / 1ps

/* RoboRIOManager - I2C Slave to the RoboRIO
    Sets config on request
    Sends config or processed data on request */
module RoboRIOManager(
    input wire CLK,
    input wire I2C_SCL,
    inout wire I2C_SDA
    );

    parameter ADDR = 7'h34;

    bit hasComms = 0;
    bit inSequence = 0;
    enum { WRITE, READ } rwMode = READ;
    bit [2:0] sectionCount = 0; //which section we are in in the sequence
    bit [2:0] sectionInd = 0; //where we are in the section
    bit [6:0] addr = 0; //saved data from the section
    bit [7:0] location = 0;
    bit [31:0] data = 0;

    always @(posedge I2C_SCL) begin
        if (inSequence) begin
            
            if (sectionCount == 0) begin
                if (sectionInd == 7) begin
                    rwMode <= I2C_SDA ? READ : WRITE;
                end
                else begin
                    addr[sectionInd] <= I2C_SDA;
                end
            end
            else if (sectionCount == 1) begin
                location[sectionInd] <= I2C_SDA;
            end
            else begin
                data[sectionInd * (sectionCount - 1)] <= I2C_SDA;
            end

            if (sectionInd == 7) begin
                //last data section
                if (sectionCount == 5 && addr == ADDR) begin
                    
                end

                sectionCount++;
            end
            sectionInd++;
        end
        else begin
            if (I2C_SDA == 0) begin
                inSequence <= 1;
                sectionCount <= 0;
                sectionInd <= 0;
            end
        end
    end

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
