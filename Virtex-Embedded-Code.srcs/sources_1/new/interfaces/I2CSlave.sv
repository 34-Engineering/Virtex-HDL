`timescale 1ns / 1ps

/* I2CSlave - 

    */
module I2CSlave #(parameter ADDRESS = 'h34) (
    input wire SCL,
    inout wire SDA,
    input wire enabled,
    input reg [7:0] responseData, //data byte to respond to the master with when they request a read
    input reg responseDataValid,
    output reg requestResponse, //the master requested a read
    output reg [7:0] readData, //data byte the master wrote to us
    output reg readDataValid,
    input reg reset //active low
    );

    reg [4:0] transactionPointer = 0;
    reg inTransaction = 0;
    reg [6:0] readAddress = 0;

    //Loop
    always @(negedge SCL) begin
        //in transaction: reading address
        if (inTransaction & transactionPointer < 7 & enabled) begin
            readAddress[transactionPointer] = SDA;
        end

        //in transaction
        else if (inTransaction & readAddress == ADDRESS & enabled) begin
            //R/W reg
            if (transactionPointer < 8) begin
                
            end

            //ack reg
            if (transactionPointer < 9) begin
                
            end

            //data byte
            if (transactionPointer < 17) begin
                
            end

            //ack reg
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
        Start condition + [7 reg address + R/W reg + Ack reg] + [data byte + Ack reg] + Stop condition
        
        Start condition: pulled low
        R/W reg: 0 -> write, 1 -> read
        Ack reg: 0 -> ACK, 1 -> NACK
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