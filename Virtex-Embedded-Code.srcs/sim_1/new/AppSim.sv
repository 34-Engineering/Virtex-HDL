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

    localparam GET_FRAME_CODE = 3'b000;
    localparam GET_CONFIG_CODE = 3'b001;
    localparam SET_CONFIG_CODE = 3'b100;
    enum {IDLE, GET_FRAME, SET_CONFIG} state = IDLE;

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
    

    task setConfig(reg [7:0] address, reg [15:0] value);

    endtask

    task getConfig(reg [7:0] address);

    endtask

endmodule