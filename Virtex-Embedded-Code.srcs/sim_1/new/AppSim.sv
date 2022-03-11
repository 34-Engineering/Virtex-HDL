 `timescale 1ns / 1ps
`include "../../sources_1/new/Util.sv"

/* AppSim

    */
module AppSim(
    input wire FSDI,
    input wire FSCLK,
    output wire FSDO,
    output wire FSCTS
    );

    localparam GET_FRAME_CODE = 8'b00011111;
    localparam GET_CONFIG_CODE = 3'b001;
    localparam SET_CONFIG_CODE = 3'b100;
    enum {IDLE, GET_FRAME, GET_CONFIG, SET_CONFIG} state = IDLE;

    FrameBuffer frameBuffer;
    Vector frameBufferPos = 0; //(0, 0) to (80, 479)
    reg wantsToSetConfig = 0, wantsToGetConfig = 0;
    reg [4:0] address;
    reg [15:0] value;

    //Fast Serial
    reg [7:0] writeData;
    reg writeDataValid = 0;
    wire writeQueueEmpty, readDataValid;
    wire [7:0] readData;
    FastSerialSim(
        .FSDI(FSDI),
        .FSCLK(),
        .FSDO(),
        .FSCTS(),
        .enabled(1'b1),
        .writeData(writeData),
        .writeDataValid(writeDataValid),
        .writeQueueEmpty(writeQueueEmpty),
        .readData(readData),
        .readDataValid(readDataValid),
        .reset(1'b1)
    );

    //Loop
    reg configPartion = 0;
    always_ff @(negedge FSCLK) begin
        case (state) begin
            IDLE: begin
                //Get Config
                if (wantsToGetConfig) begin
                    writeData <= GET_CONFIG_CODE + address;
                    writeDataValid <= 1;
                    state <= GET_CONFIG;
                end

                //Set Config
                else if (wantsToSetConfig) begin
                    writeData <= SET_CONFIG_CODE + address;
                    writeDataValid <= 1;
                    configPartion <= 0;
                    state <= SET_CONFIG;
                end

                //Get Frame
                else begin
                    writeData <= GET_FRAME_CODE;
                    writeDataValid <= 1;
                    configPartion <= 0;
                    state <= GET_FRAME;
                end
            end

            GET_FRAME: begin
                if (readDataValid) begin
                    //throw data into frame buffer
                    frameBuffer[frameBufferPos.x][frameBufferPos.y] <= readData;

                    //increment frame buffer pos
                    if (frameBufferPos.x == 79) begin
                        frameBufferPos.x <= 0;
                        framebufferPos.y <= frameBufferPos.y + 1;
                    end
                    else begin
                        frameBufferPos.x <= frameBufferPos.x + 1;
                    end
                end
            end

            GET_CONFIG: begin
                
            end

            SET_CONFIG: begin
                
            end
        end
    end

endmodule