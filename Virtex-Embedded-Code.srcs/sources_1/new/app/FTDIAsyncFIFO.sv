`timescale 1ns / 1ps

/* FTDI Async FIFO - interface for the async FIFO on FT2232H
    FT2232H Docs: https://www.ftdichip.com/Support/Documents/DataSheets/ICs/DS_FT2232H.pdf
    FIFO Basics: https://ftdichip.com/wp-content/uploads/2020/08/TN_167_FIFO_Basics.pdf
    */
module FTDIAsyncFIFO(
    input wire CLK16,
    inout wire [7:0] FIFO_D,
    input wire FIFO_RXF, //active low, can read
    input wire FIFO_TXE, //active low, can write
    output wire FIFO_RD, //active low, read
    output wire FIFO_WR, //active low, write
    output wire FIFO_SIWUB, //active low, send immediate/wake up signal
    input wire [7:0] writeData,
    input wire writeDataValid, //active high
    output reg [7:0] readData,
    output reg readDataValid, //active high
    output reg [7:0] debug
    );

    enum {IDLE, READ, WRITE} state = IDLE;

    reg [7:0] lastWriteData = 0;

    initial readDataValid = 0;

    assign FIFO_SIWUB = 1;
    assign FIFO_D = (state == WRITE) ? lastWriteData : 8'bzzzzzzzz;
    assign FIFO_WR = ~((state == WRITE) & CLK16); //write after 30ns (min 5ns) for 30ns (min 30ns)
    assign FIFO_RD = ~((state == READ) & ~CLK16); //read for 30ns (min 30ns)

    // assign debug = FIFO_D;

    always_ff @(negedge CLK16) begin
        debug[7] <= FIFO_RXF;
        debug[6] <= FIFO_TXE;
        debug[5] <= FIFO_RD;
        debug[4] <= FIFO_WR;
        debug[3] <= FIFO_SIWUB;
        debug[0] <= writeDataValid;

        //7654 3210
        //1111 1011

        //Write (if valid data & can write)
        if (writeDataValid & ~FIFO_TXE) begin
            state <= WRITE;
            lastWriteData <= writeData;
            readDataValid <= 0;
            debug[1] <= 1;
        end

        //Read (if has data)
        // else if (~FIFO_RXF) begin
        //     state <= READ;
        //     readDataValid <= 0;
        //     debug[2] <= 1;
        // end

        //Idle
        else begin
            state <= IDLE;
        end
    end

    //Save Read Data (after 30ns, min 30ns)
    // always_ff @(posedge CLK16) begin
    //     if (state == READ) begin
    //         readData <= FIFO_D;
    //         readDataValid <= 1;
    //     end
    // end
endmodule

