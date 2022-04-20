`timescale 1ns / 1ps
`include "../config/VirtexConfig.sv"
`include "../python/PythonUtil.sv"

/* AppManager - Manages communication with the Virtex App through FTDI's Fast Serial
     1) Streams video & processed blobs to FT2232H
     2) Reads & writes python configurations 
    Virtex Fast Serial Protocol: https://docs.google.com/document/d/1n1cTdPgI_MZJplnfnsV4Gh2vK2MCvT35MewmOGstzLg/edit
    */
module AppManager(
    input wire CLK100, CLK50,
    output wire FSDI, //FPGA->PC
    output wire FSCLK, //50MHz (FPGA generated)
    input wire FSDO, //PC->FPGA
    input wire FSCTS, //FPGA clear to send, active low
    input wire USB_ON,
    input wire USB_PWREN, //usb power enabled, active low
    input wire USB_SUS, //usb in suspend mode, active low
    input VirtexConfig virtexConfig,
    output VirtexConfigWriteRequest virtexConfigWriteRequest,
    output reg enabled,
    input wire Target target,
    input wire [15:0] frameBufferWriteAddr,
    input wire [31:0] frameBufferWriteIn,
    input wire frameBufferWriteEnable,
    output reg [7:0] debug
    );

    //Codes
    localparam GET_FRAME_CODE  = 8'b00000001;
    localparam GET_TARGET_CODE = 8'b00000010;
    localparam CONFIG_BIT = 1'b1;
    localparam CONFIG_GET_BIT = 1'b0; //GET = 10, SET = 11

    //State
    enum {IDLE, GET_FRAME, GET_CONFIG, SET_CONFIG, GET_TARGET} state = IDLE;
    wire USB_ENABLED = USB_ON & ~USB_PWREN & USB_SUS;

    //Frame buffer
    wire CLK100Inv = ~CLK100;
    reg [15:0] frameBufferAddrRead;
    wire [31:0] frameBufferReadOut;
    blk_mem_frame_buffer frameBuffer ( //a is for reading, b is writing
        .addra(frameBufferAddrRead),
        .clka(CLK100Inv),
        .dina(),
        .douta(frameBufferReadOut),
        .wea(1'b0),
        .addrb(frameBufferWriteAddr),
        .clkb(CLK100),
        .dinb(frameBufferWriteIn),
        .doutb(),
        .web(frameBufferWriteEnable)
    );

    //Fast Serial
    reg [7:0] writeData;
    reg writeDataValid = 0;
    wire writeBusy;
    wire [7:0] readData;
    wire readDataValid;
    FastSerial fastSerial (//TODO fast serial full sync (every loop dataValid it will write/doesn't care about change)
        .CLK50(CLK50),
        .FSDI(FSDI),
        .FSCLK(FSCLK),
        .FSDO(FSDO),
        .FSCTS(FSCTS),
        .enabled(USB_ENABLED),
        .writeData(writeData),
        .writeDataValid(writeDataValid),
        .writeBusy(writeBusy),
        .readData(readData),
        .readDataValid(readDataValid),
        .reset(1'b1),
        .debug()
    );

    //Loop
    reg [15:0] commandIndex = 0;
    reg [1:0] getFramePartion = 0;
    reg [5:0] configAddress = 0;
    reg [7:0] configDataPartion0 = 0;
    reg lastReadDataValid = 0;
    wire newReadData = readDataValid & ~lastReadDataValid;
    initial virtexConfigWriteRequest = 0;
    initial enabled = 0;

    always_ff @(posedge CLK50) begin
        if (USB_ENABLED) begin
            case (state)
                IDLE: begin
                    if (newReadData) begin
                        virtexConfigWriteRequest.valid <= 0;

                        //Get Frame
                        if (readData == GET_FRAME_CODE) begin
                            state <= GET_FRAME;
                            commandIndex <= 0;
                            frameBufferAddrRead <= 0;
                        end

                        //Config
                        else if (readData[7] == CONFIG_BIT) begin
                            configAddress <= readData[5:0];
                            commandIndex <= '0;
                            state <= (readData[6] == CONFIG_GET_BIT) ? GET_CONFIG : SET_CONFIG;
                        end

                        //Get Target
                        if (readData == GET_TARGET_CODE) begin
                            state <= GET_TARGET;
                            commandIndex <= 0;
                        end

                        //Enable/Disable
                        else if (readData == 8'hA) enabled <= 0;
                        else if (readData == 8'hB) enabled <= 1;
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
                        writeData <= frameBufferReadOut[((getFramePartion << 3) + 7) -: 8];
                        writeDataValid <= 1;

                        if (getFramePartion == 3) begin
                            if (commandIndex == 38400) begin
                                //finish reading frame
                                state <= IDLE;
                            end
                            else begin
                                //read next kernel
                                frameBufferAddrRead <= commandIndex + 1;

                                //increment index
                                commandIndex <= commandIndex + 1;
                            end
                        end

                        getFramePartion <= getFramePartion + 1;
                    end
                end

                GET_CONFIG: begin
                    //drop data valid and come back next loop
                    if (writeDataValid) begin
                        writeDataValid <= 0;
                    end

                    //write second partion
                    else if (commandIndex & ~writeBusy) begin
                        writeData <= virtexConfig[getConfigAddrIndex(configAddress) - 8 -: 8];
                        writeDataValid <= 1;
                        state <= IDLE;
                    end

                    //write first partion
                    else if (~writeBusy) begin
                        writeData <= virtexConfig[getConfigAddrIndex(configAddress) -: 8];
                        writeDataValid <= 1;
                        commandIndex <= 1;
                    end
                end

                SET_CONFIG: begin
                    //read second partion
                    if (commandIndex & newReadData) begin
                        virtexConfigWriteRequest <= '{ addr: configAddress, data: {configDataPartion0, readData}, valid: 1 };
                        commandIndex <= '0;
                        state <= IDLE;
                    end

                    //read first partion
                    else if (newReadData) begin
                        configDataPartion0 <= readData;
                        commandIndex <= 1;
                    end
                end

                GET_TARGET: begin
                    if (writeDataValid) begin
                        writeDataValid <= '0;
                    end

                    else if (~writeBusy) begin
                        //send target to PC (in 6 bytes)
                        writeData <= target[(47 - (commandIndex << 3)) -: 8];
                        writeDataValid <= 1;

                        if (commandIndex == 5) begin
                            //finish reading frame
                            state <= IDLE;
                        end
                        else begin
                            //increment index
                            commandIndex <= commandIndex + 1;
                        end
                    end
                end
            endcase
        end

        lastReadDataValid <= readDataValid;
    end
endmodule