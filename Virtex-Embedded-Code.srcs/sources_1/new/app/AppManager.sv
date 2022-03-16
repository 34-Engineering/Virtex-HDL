`timescale 1ns / 1ps
`include "../config/VirtexConfig.sv"
`include "../python/PythonUtil.sv"

/* AppManager - Manages communication with the Virtex App through FTDI's Fast Serial
     1) Streams video & processed blobs to FT2232H
     2) Reads & writes python configurations 
    Virtex Fast Serial Protocol: https://docs.google.com/document/d/1n1cTdPgI_MZJplnfnsV4Gh2vK2MCvT35MewmOGstzLg/edit
    */
module AppManager(
    input wire CLK,
    output wire FSDI, //FPGA->PC
    output wire FSCLK, //50MHz (FPGA generated)
    input wire FSDO, //PC->FPGA
    input wire FSCTS, //FPGA clear to send, active low
    input wire USB_ON,
    input wire USB_PWREN, //usb power enabled, active low
    input wire USB_SUS, //usb in suspend mode, active low
    input wire VirtexConfig virtexConfig,
    output VirtexConfigWriteRequest virtexConfigWriteRequest,
    input wire [15:0] frameBufferWriteAddr,
    input wire [31:0] frameBufferWriteIn,
    input wire frameBufferWriteEnable,
    output reg [7:0] debug,
    input reg [7:0] wave
    );

    //Codes
    localparam GET_FRAME_CODE  = 8'b00000001;
    localparam GET_TARGET_CODE = 8'b00000010;
    localparam CONFIG_BIT = 1'b1;
    localparam CONFIG_GET_BIT = 1'b0; //GET = 10, SET = 11

    //State
    enum {IDLE, GET_FRAME, GET_CONFIG, SET_CONFIG} state = IDLE;
    wire enabled = USB_ON & !USB_PWREN & USB_SUS;

    //Frame buffer
    wire CLKInv = ~CLK;
    reg [15:0] frameBufferAddrRead;
    reg [31:0] frameBufferReadOut;
    blk_mem_frame_buffer frameBuffer ( //a is for reading, b is writing
        .addra(frameBufferAddrRead),
        .clka(CLKInv),
        .dina(),
        .douta(frameBufferReadOut),
        .wea(1'b0),
        .addrb(frameBufferWriteAddr),
        .clkb(CLK),
        .dinb(frameBufferWriteIn),
        .doutb(),
        .web(frameBufferWriteEnable)
    );

    //50MHz clock
    wire CLK50;
    clk_wiz_1(
        .clk_in1(CLK),
        .clk_out1(CLK50)
    );

    //Fast Serial
    reg [7:0] writeData;
    reg writeDataValid = 0;
    wire writeBusy;
    wire [7:0] readData;
    wire readDataValid;
    FastSerial fastSerial (
        .CLK50(CLK50),
        .FSDI(FSDI),
        .FSCLK(FSCLK),
        .FSDO(FSDO),
        .FSCTS(FSCTS),
        .enabled(1'b1),
        .writeData(writeData),
        .writeDataValid(writeDataValid),
        .writeBusy(writeBusy),
        .readData(readData),
        .readDataValid(readDataValid),
        .reset(1'b1),
        .debug()
    );

    //Loop
    reg [15:0] getFrameIndex = 0;
    reg [1:0] getFramePartion = 0;
    reg [5:0] configAddress = 0;
    reg [15:0] configData = 0;
    reg configPartion = 0;
    reg lastReadDataValid = 0;
    reg newReadData = 0;

    always_ff @(posedge CLK50) begin
        //New Read Data
        if (readDataValid & ~lastReadDataValid) begin
            newReadData = 1;
        end
        lastReadDataValid <= readDataValid;

        // if (~writeBusy & writeData != wave) begin
        //     writeData <= wave;
        //     writeDataValid <= 1;
        // end
        // else writeDataValid <= 0;

        if (enabled) begin
            case (state)
                IDLE: begin
                    if (newReadData) begin
                        newReadData <= 0;

                        //Get Frame
                        if (readData == GET_FRAME_CODE) begin
                            state <= GET_FRAME;
                            getFrameIndex <= 0;
                            frameBufferAddrRead <= 0;
                        end

                        //TODO Get Target

                        //Config
                        else if (readData[7] == CONFIG_BIT) begin
                            configAddress <= readData[5:0];
                            configPartion <= 0;
                            state <= (readData[6] == CONFIG_GET_BIT) ? GET_CONFIG : SET_CONFIG;
                        end
                    end
                end

                GET_FRAME: begin
                    //frame buffer read is clocked with ~CLK (100MHz opposite edge of CLK50/FSCLK)
                    //so there relative to this loop there is no read delay
                    //AKA an address is written and next loop data is ready

                    //drop data valid and come back next loop
                    if (writeDataValid) begin
                        writeDataValid <= 0;
                    end

                    else if (~writeBusy) begin
                        //send kernel to PC (2 pixels at a time)
                        if (getFramePartion == 0) writeData <= frameBufferReadOut[7:0];
                        if (getFramePartion == 1) writeData <= frameBufferReadOut[15:8];
                        if (getFramePartion == 2) writeData <= frameBufferReadOut[23:16];
                        if (getFramePartion == 3) writeData <= frameBufferReadOut[31:24];
                        writeDataValid <= 1;

                        if (getFramePartion == 3) begin
                            if (getFrameIndex == 38400) begin //BRAM end
                                //finish reading frame
                                state <= IDLE;
                            end
                            else begin
                                //read next kernel
                                frameBufferAddrRead <= getFrameIndex + 1;

                                //increment index
                                getFrameIndex <= getFrameIndex + 1;
                            end
                        end

                        getFramePartion <= getFramePartion + 1;
                    end
                end

                GET_CONFIG: begin
                    //TODO validate
                    //drop data valid and come back next loop
                    if (writeDataValid) begin
                        writeDataValid <= 0;
                    end

                    //write second partion
                    else if (configPartion & ~writeBusy) begin
                        writeData <= virtexConfig[configAddress*16 + 7 -: 7];
                        writeDataValid <= 1;
                        state <= IDLE;
                    end

                    //write first partion
                    else if (~writeBusy) begin
                        writeData <= virtexConfig[configAddress*16 + 15 -: 7];
                        writeDataValid <= 1;
                        configPartion <= 1;
                    end
                end

                SET_CONFIG: begin

                    //FIXME lastReadDataValid or ???

                    //read second partion
                    if (configPartion & readDataValid) begin
                        configData[7:0] <= readData;
                        configPartion <= 0;
                        state <= IDLE;
                    end

                    //read first partion
                    else if (readDataValid) begin
                        configData[15:8] <= readData;
                        configPartion <= 1;
                    end
                end
            endcase
        end
    end
endmodule