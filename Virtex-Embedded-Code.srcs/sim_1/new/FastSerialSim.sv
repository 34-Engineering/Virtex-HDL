`timescale 1ns / 1ps
`include "../../../sources_1/new/Util.sv"

/* FastSerialSim

    */
module FastSerialSim(
    input wire FSDI, //FPGA->PC
    input wire FSCLK, //48MHz (FPGA generated)
    output reg FSDO, //PC->FPGA
    output reg FSCTS, //FPGA clear to send, active low
    input wire enabled, //active high
    input wire [7:0] writeData,
    input wire writeDataValid, //active high
    output wire writeQueueEmpty, //active high
    output reg [0:7] readData,
    output reg readDataValid, //active high
    input reg reset //active low
    );

    reg [0:7] writeQueue[0:319];
    reg [9:0] writeQueueReadPointer = 0;
    reg [9:0] writeQueueWritePointer = 0;
    reg [3:0] writePointer = 0;
    reg isReading = 0;
    reg [3:0] readPointer = 0;
    assign writeQueueEmpty = writeQueueWritePointer == writeQueueReadPointer;
    reg lastWriteDataValid = 0;

    //Loop
    always @(posedge FSCLK) begin
        //reset
        if (~reset) begin
            writeQueueReadPointer <= 0;
            writeQueueWritePointer <= 0;
            writePointer <= 0;
            isReading <= 0;
            readPointer <= 0;
            readDataValid <= 0;
            FSCTS <= 1;
            FSDO <= 0;
        end

        //reading
        else if (isReading & enabled) begin
            if (readPointer == 8) begin
                // $display ("test done reading");
                FSCTS = 1;
                isReading = 0;
                readDataValid = 1;
            end
            else begin
                // $display ("test read %p = %b", readPointer, FSDO);
                readData[readPointer] = FSDI;
                readPointer <= readPointer + 1;
            end
            FSCTS <= 0;
            FSDO <= 1;
        end

        //writing
        else if (writeQueueWritePointer != writeQueueReadPointer & enabled) begin
            //reg 0
            if (writePointer == 0) begin
                // $display ("test wrote 0 = 0");
                FSDO = 0;
                writePointer <= 1;
            end

            //reg 9
            else if (writePointer == 9) begin
                // $display ("test wrote 9 = 1");
                FSDO = 1;

                if (writeQueueReadPointer >= $size(writeQueue) - 1) begin
                    writeQueueReadPointer = 0;
                end
                else begin
                    writeQueueReadPointer = writeQueueReadPointer + 1;
                end
                writePointer = 0;
            end

            //reg 1-8
            else begin
                // $display ("test wrote %p = %b", writePointer, writeQueue[writeQueueReadPointer][writePointer - 1]);
                FSDO = writeQueue[writeQueueReadPointer][writePointer - 1];
                writePointer <= writePointer + 1;
            end

            FSCTS <= 1;
        end

        //start reading
        else if (~FSDI & FSCTS) begin
            // $display ("test start reading");
            readPointer = 0;
            isReading = 1;
            readDataValid = 0;
            FSCTS <= 0;
            FSDO <= 1;
        end

        //idle
        else begin
            FSDO <= 1;
            FSCTS <= 1;
        end

        //add to write queue
        if (writeDataValid & ~lastWriteDataValid) begin
            writeQueue[writeQueueWritePointer] <= writeData;
            if (writeQueueWritePointer >= $size(writeQueue) - 1) begin
                writeQueueWritePointer <= 0;
            end
            else begin
                writeQueueWritePointer <= writeQueueWritePointer + 1;
            end
        end
        lastWriteDataValid <= writeDataValid;
    end

endmodule