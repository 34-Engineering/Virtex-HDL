`timescale 1ns / 1ps

/* I2CSlave - 

    */
module I2CSlave #(parameter ADDRESS = 'h34) (
    input wire SCL,
    inout wire SDA,
    input wire enabled,
    input bit [7:0] responseData, //data byte to respond to the master with when they request a read
    input bit responseDataValid,
    output bit requestResponse, //the master requested a read
    output bit [7:0] readData, //data byte the master wrote to us
    output bit readDataValid,
    input bit reset //active low
    );

    bit [4:0] transactionPointer = 0;
    bit inTransaction = 0;
    bit [6:0] readAddress = 0;

    //Loop
    always @(negedge SCL) begin
        //in transaction: reading address
        if (inTransaction & transactionPointer < 7 & enabled) begin
            readAddress[transactionPointer] = SDA;
        end

        //in transaction
        else if (inTransaction & readAddress == ADDRESS & enabled) begin
            //R/W bit
            if (transactionPointer < 8) begin
                
            end

            //ack bit
            if (transactionPointer < 9) begin
                
            end

            //data byte
            if (transactionPointer < 17) begin
                
            end

            //ack bit
            if (transactionPointer < 18) begin
                
            end
        end

        //start transaction
        else if (!SDA & enabled) begin
            inTransaction = 1;
            transactionPointer = 0;
            readDataValid = 0;
        end

        //idle
        else begin
            
        end
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

    //Reset (active low)
    always @(negedge reset) begin
        transactionPointer = 0;
        inTransaction = 0;
        readDataValid = 0;
    end
endmodule