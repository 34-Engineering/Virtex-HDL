`timescale 1ns / 1ps
import Util::*;

/* RoboRIOManager - SPI Slave to the RoboRIO
    
    Setup:
     - 4MHz active high?
     - MSB First
     - CS active low
     - 8-bit bytes
    
    Transactions begin with a command from the master and data bytes are sent/recieved based on the command
    
    Command (1 byte):
     - 7-bit register address
     - 1-bit R/W bit (0 = read, 1 = write)

    Register Addresses (7-bits):
     - 0000001 get blob, 8 bytes
        - returns a blob matching all criteria from config selects the closest to (CenterX, CenterY)
        - see blob structure in Util.sv
     - 0000011 get all blobs, 1+8*b bytes (byte 1 = num blobs)
        - returns all blobs matching criteria from config (excluding CenterX & CenterY)
        - see blob structure in Util.sv
     - 0100001 get/set enabled, 1 byte data 
     - 10XXXXX get/set config, 2 bytes data
     
    */
module RoboRIOManager(
    input wire CLK,
    input wire SPI_CLK, //4MHz
    input wire SPI_MOSI,
    output reg SPI_MISO,
    input wire SPI_CS,
    input wire VirtexConfig virtexConfig,
    output VirtexConfigWriteRequest virtexConfigWriteRequest,
    output reg hasCommunication,
    output reg enabled,
    input wire Blob targetBlob
    );

    localparam GET_BLOB = 8'b00000010;
    localparam GET_ALL_BLOBS = 8'b00000110;
    localparam GET_ENABLED = 8'b01000010;
    localparam SET_ENABLED = 8'b01000011;

    //Crude SPI slave implementation
    reg [3:0] byteNumber = 0; //what byte we are on
    reg [2:0] bytePointer = 0; //where we are in the byte
    reg [7:0] readData = 0;
    reg [7:0] writeData = 0;
    reg [7:0] command = 0; //register addr + r/w
    always @(posedge SPI_CLK) begin
        if (!SPI_CS) begin
            //write data to MISO
            SPI_MISO <= writeData[bytePointer];

            //read data from MOSI (cant be parallel, onDataByte() requires it)
            readData[bytePointer] = SPI_MOSI;
            
            if (bytePointer == 7) begin
                onByteDone();
            end

            bytePointer <= bytePointer + 1;
        end

        else begin
            //idle
            byteNumber <= 0;
            bytePointer <= 0;
        end
    end

    wire commandIsGetConfig = command[7:6] == 2'b10 & !command[0];
    wire commandIsSetConfig = command[7:6] == 2'b10 & command[0];
    reg [7:0] setConfigValuePartion;
    task onByteDone();
        if (byteNumber == 0) begin
            command <= readData;
            byteNumber <= byteNumber + 1;
        end

        //Get Blob
        if (command == GET_BLOB & byteNumber < 9) begin
            //splits the 64-bit blob into 8x 8-bit sections
            writeData <= targetBlob[63 - (byteNumber*8) -: 7];
            byteNumber <= byteNumber + 1;
        end
        else if (command == GET_BLOB) begin
            endTransaction();
        end

        //Get All Blobs
        if (command == GET_ALL_BLOBS) begin
            //TODO
        end

        //Get Enabled
        if (command == GET_ENABLED & byteNumber == 0) begin
            writeData <= enabled;
            byteNumber <= byteNumber + 1;
        end
        else if (command == GET_ENABLED) begin
            endTransaction();
        end

        //Set Enabled
        if (command == SET_ENABLED & byteNumber == 1) begin
           enabled <= readData;
           endTransaction();
        end

        //Get Config
        if (commandIsGetConfig & byteNumber < 2) begin
            //finds the config register index w/ * 16
            //then split 16-bit config into [15:8] & [7:0]
            writeData <= virtexConfig[(command[5:1]*16) + (byteNumber*8+7) -: 7];
            byteNumber <= byteNumber + 1;
        end
        else if (commandIsGetConfig) begin
            endTransaction();
        end

        //Set Config
        if (commandIsSetConfig & byteNumber == 1) begin
            //reset from last write request
            virtexConfigWriteRequest <= 0;
            setConfigValuePartion <= readData;
        end
        else if (commandIsSetConfig & byteNumber == 2) begin
            //make a write request to ConfigManager with the register address, combined value, and mark it as valid
            virtexConfigWriteRequest <= '{command[5:1], {readData, setConfigValuePartion}, 1'b1};
            endTransaction();
        end
    endtask

    task endTransaction();
        byteNumber <= 0; //TODO is this the behavior we want at end of transaction?
    endtask
endmodule