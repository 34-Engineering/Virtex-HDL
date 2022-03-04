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
    output wire FSCLK, //48MHz (FPGA generated)
    input wire FSDO, //PC->FPGA
    input wire FSCTS, //FPGA clear to send, active low
    input wire USB_ON,
    input wire USB_PWREN, //usb power enabled, active low
    input wire USB_SUS, //usb in suspend mode, active low
    input wire VirtexConfig virtexConfig,
    output VirtexConfigWriteRequest virtexConfigWriteRequest,
    input wire Kernel frameBufferWriteRequest
    );

    localparam GET_FRAME_CODE = 8'b00011111;
    localparam GET_CONFIG_CODE = 3'b001;
    localparam SET_CONFIG_CODE = 3'b100;
    //TODO GET_TARGET
    enum {IDLE, GET_FRAME, GET_CONFIG, SET_CONFIG} state = IDLE;
    wire enabled = USB_ON & !USB_PWREN & USB_SUS;

    reg [15:0] frameBufferAddrRead, frameBufferAddrWrite;
    reg [7:0] frameBufferReadOut, frameBufferWriteIn;
    reg frameBufferWriteEnable;
    blk_mem_frame_buffer frameBuffer ( //a is for reading, b is writing
        .addra(frameBufferAddrRead),
        .clka(FSCLK),
        .dina(),
        .douta(frameBufferReadOut),
        .wea(1'b0),
        .addrb(frameBufferAddrWrite),
        .clkb(CLK),
        .dinb(frameBufferWriteIn),
        .doutb(),
        .web(frameBufferWriteEnable)
    );

    //48MHz clock
    wire CLK48;
    clk_wiz_1(
        .clk_in1(CLK),
        .clk_out1(CLK48)
    );

    //Fast Serial
    reg [7:0] writeData;
    reg writeDataValid;
    wire writeQueueEmpty;
    wire [7:0] readData;
    wire readDataValid;
    FastSerial(
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

    //Loop
    Vector getFrameKernelPos;
    reg [4:0] configAddress = 0;
    reg [15:0] configData = 0;
    reg configPartion = 0;
    always @(posedge CLK48) begin //TODO should this be negedge?
        if (enabled) begin
            case (state)
                IDLE: begin
                    //Get Frame
                    if (readDataValid & readData == GET_FRAME_CODE) begin
                        state <= GET_FRAME;
                        getFrameKernelPos <= 0;
                    end

                    //Get Config
                    else if (readDataValid & readData[2:0] == GET_CONFIG_CODE) begin
                        state <= GET_CONFIG;
                        configPartion <= 0;
                        configAddress <= readData[7:3];
                    end

                    //Set Config
                    else if (readDataValid & readData[2:0] == SET_CONFIG_CODE) begin
                        state <= SET_CONFIG;
                        configPartion <= 0;
                        configAddress <= readData[7:3];
                    end
                end

                GET_FRAME: begin
                    //38,400 loops //FIXME
                    //skip first look
                    // writeData <= frameBuffer[getFrameKernelPos.y][getFrameKernelPos.x +: 7];

                    //inc + read new
                    if (getFrameKernelPos.x > 79) begin
                        if (getFrameKernelPos.y > 478) begin
                            state <= IDLE;
                        end

                        getFrameKernelPos.x <= 0;
                        getFrameKernelPos.y <= getFrameKernelPos.y + 1;
                    end
                end

                GET_CONFIG: begin
                    //TODO validate
                    //drop data valid and come back next loop
                    if (writeDataValid) begin
                        writeDataValid <= 0;
                    end

                    //write second partion
                    else if (configPartion & writeQueueEmpty) begin
                        writeData <= virtexConfig[configAddress*16 + 7 -: 7];
                        writeDataValid <= 1;
                        state <= IDLE;
                    end

                    //write first partion
                    else if (writeQueueEmpty) begin
                        writeData <= virtexConfig[configAddress*16 + 15 -: 7];
                        writeDataValid <= 1;
                        configPartion <= 1;
                    end
                end

                SET_CONFIG: begin
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

    //Add to Frame Buffer //FIXME
    reg lastFrameBufferWriteRequestValid = 0;
    always @(negedge CLK) begin
        if (frameBufferWriteRequest.valid && ~lastFrameBufferWriteRequestValid) begin
            frameBufferAddrWrite <= frameBufferWriteRequest.kernelPos.y * frameBufferWriteRequest.kernelPos.x;
            frameBufferWriteIn <= frameBufferWriteRequest.kernel;
            frameBufferWriteEnable <= 1;
        end

        lastFrameBufferWriteRequestValid <= frameBufferWriteRequest.valid;
    end
endmodule