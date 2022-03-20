`timescale 1ns / 1ps

/* FastSerial - Implementation of FTDI's Fast Serial Interface
    Fast Serial Docs: https://ftdichip.com/wp-content/uploads/2020/08/AN_131_FT2232D_H_Fast-Opto-Isolated-Serial-Interface-mode.pdf
    FT2232H Docs: https://www.ftdichip.com/Support/Documents/DataSheets/ICs/DS_FT2232H.pdf
    Fast Serial Notes: https://docs.google.com/document/d/1Sg8LKgYLEdBtbzcvhCJvDzMn8KQxomQIMN0E1RHf6OQ/edit
    */
module FastSerial(
    input wire CLK50,
    output reg FSDI, //FPGA->PC
    output wire FSCLK, //50MHz (FPGA generated)
    input wire FSDO, //PC->FPGA
    input wire FSCTS, //FPGA clear to send, active low
    input wire enabled,
    input wire [7:0] writeData,
    input wire writeDataValid, //active high
    output reg writeBusy, //active high
    output reg [7:0] readData,
    output reg readDataValid, //active high
    input wire reset, //active low
    output reg [7:0] debug
    );

    assign FSCLK = CLK50;

    //Read
    reg isReading = 0;
    reg [3:0] readPointer = 0;
    always_ff @(negedge CLK50) begin
        //reset
        if (~reset) begin
            isReading <= 0;
            readPointer <= 0;
            readDataValid <= 0;
        end

        //reading
        else if (isReading & enabled) begin
            if (readPointer == 8) begin
                // $display ("done reading");
                isReading <= 0;
                readDataValid <= 1;
            end
            else begin
                // $display ("read %p = %b", readPointer, FSDO);
                readData[readPointer] <= FSDO;
                readPointer <= readPointer + 1;
            end
        end

        //start reading
        else if (~FSDO & enabled) begin
            // $display ("start reading");
            readPointer <= 0;
            isReading <= 1;
            readDataValid <= 0;
        end
    end

    //Write
    reg [3:0] writePointer = 0;
    reg lastWriteDataValid = 0;
    initial writeBusy = 0;
    initial FSDI = 1;

    always_ff @(negedge CLK50) begin
        //new write data
        if (writeDataValid & ~lastWriteDataValid & ~writeBusy) begin
            //FIXME remove blocking
            writeBusy = 1;
            writePointer = 0;
        end
        lastWriteDataValid <= writeDataValid;

        //reset
        if (~reset) begin
            writePointer <= 0;
            FSDI <= 1;
        end

        //writing
        else if (writeBusy & enabled) begin
            //reg 0 (START)
            if (writePointer == 0) begin
                // $display ("wrote 0 = 0");
                //if FSCTS is low wait until goes back high
                //else drop FSDI and begin transaction
                FSDI <= ~FSCTS;
                if (FSCTS) writePointer <= 1;    
            end

            //reg 9 (DEST)
            else if (writePointer == 9) begin
                FSDI <= 1;
                writePointer <= 10;
            end

            //reg 10 (END)
            else if (writePointer == 10 & FSCTS) begin
                writeBusy <= 0;
                writePointer <= 0;
            end

            //reg 1-8 (DATA)
            else if (writePointer > 0 & writePointer < 9) begin
                // $display ("wrote %p = %b", writePointer, writeQueue[writeQueueReadPointer][writePointer - 1]);
                FSDI <= writeData[writePointer - 1];
                writePointer <= writePointer + 1;
            end

            //else waiting for FSCTS or interrupted (and reset?)
        end

        //idle
        else FSDI <= 1;
    end
endmodule