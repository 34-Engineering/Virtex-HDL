`timescale 1ns / 1ps
import Util::*;

/* AppManager - Manages communication with the Virtex App through FTDI's Fast Serial
     1) Streams video & processed blobs to FT2232H
     2) Reads & writes camera configurations 
    Virtex Fast Serial Protocol: https://docs.google.com/document/d/1n1cTdPgI_MZJplnfnsV4Gh2vK2MCvT35MewmOGstzLg/edit
    */
module AppManager(
    input wire CLK,
    output wire FSDI, //FPGA->PC
    output wire FSCLK, //48MHz (FPGA generated)
    input wire FSDO, //PC->FPGA
    input wire FSCTS, //FPGA clear to send, active low
    input wire USB_ON,
    input wire USB_PWREN, //usb power enabled, active low
    input wire USB_SUS, //usb in suspend mode, active low
    input wire VirtexConfig virtexConfig,
    output VirtexConfigWriteRequest virtexConfigWriteRequest,
    input wire ImageFrame imageFrame
    );

    parameter GET_FRAME_CODE = 3'b000;
    parameter GET_CONFIG_CODE = 3'b001;
    parameter SET_CONFIG_CODE = 3'b100;
    enum {IDLE, GET_FRAME, SET_CONFIG} state = IDLE;
    wire enabled = USB_ON & !USB_PWREN & USB_SUS;

    //48MHz clock
    wire CLK48;
    clk_wiz_1 clk_wiz_1(
        .clk_in1(CLK),
        .clk_out1(CLK48)
    );

    //Fast Serial
    reg [7:0] writeData;
    reg writeDataValid;
    wire writeQueueEmpty;
    wire [7:0] readData;
    wire readDataValid;
    FastSerial FastSerial(
        .CLK48(CLK48),
        .FSDI(FSDI),
        .FSCLK(FSCLK),
        .FSDO(FSDO),
        .FSCTS(FSCTS),
        .enabled(enabled),
        .writeData(writeData),
        .writeDataValid(writeDataValid),
        .writeQueueEmpty(writeQueueEmpty),
        .readData(readData),
        .readDataValid(readDataValid),
        .reset(1'b1)
    );

    //On Data
    Vector getFrameKernelPos;
    reg [4:0] setConfigAddress = 0;
    reg [15:0] setConfigData = 0;
    reg setConfigPartion = 0;
    always @(posedge CLK48) begin
        if (enabled) begin
            case (state)
                IDLE: begin
                    //Get Frame
                    if (readDataValid & readData[2:0] == GET_FRAME_CODE) begin
                        state <= GET_FRAME;
                        getFrameKernelPos <= 0;
                    end

                    //Get Config
                    else if (readDataValid & readData[2:0] == GET_CONFIG_CODE) begin
                        //TODO parallelize
                        writeData = virtexConfig[readData[7:3]*16 + 15 -: 7];
                        writeDataValid = 1;
                        writeDataValid = 0;
                        writeData = virtexConfig[readData[7:3]*16 + 7 -: 7]; 
                        writeDataValid = 1;
                        writeDataValid = 0;
                    end

                    //Set Config
                    else if (readDataValid & readData[2:0] == SET_CONFIG_CODE) begin
                        state <= SET_CONFIG;
                        setConfigPartion <= 0;
                        setConfigAddress <= readData[7:3];
                    end
                end

                GET_FRAME: begin
                    //38,400 loops
                    writeData = imageFrame[getFrameKernelPos.x][getFrameKernelPos.y];

                    if (getFrameKernelPos.x > 79) begin
                        if (getFrameKernelPos.y > 478) begin
                            state <= IDLE;
                        end

                        getFrameKernelPos.x <= 0;
                        getFrameKernelPos.y <= getFrameKernelPos.y + 1;
                    end
                end

                SET_CONFIG: begin
                    //second partion of data
                    if (setConfigPartion & readDataValid) begin
                        setConfigData[7:0] <= readData;
                        state <= IDLE;
                        setConfigPartion <= 0;
                    end

                    //first partion of data
                    else if (readDataValid) begin
                        setConfigData[15:8] <= readData;
                        setConfigPartion <= 1;
                    end
                end
            endcase
        end
    end
endmodule