`timescale 1ns / 1ps

/* FastSerial - Implementation of FTDI's Fast Serial Interface
    Fast Serial Docs: https://ftdichip.com/wp-content/uploads/2020/08/AN_131_FT2232D_H_Fast-Opto-Isolated-Serial-Interface-mode.pdf
    FT2232H Docs: https://www.ftdichip.com/Support/Documents/DataSheets/ICs/DS_FT2232H.pdf
    Fast Serial Notes: https://docs.google.com/document/d/1Sg8LKgYLEdBtbzcvhCJvDzMn8KQxomQIMN0E1RHf6OQ/edit
    */
module FastSerial(
    input wire CLK48,
    output reg FSDI, //FPGA->PC
    output wire FSCLK, //48MHz (FPGA generated)
    input wire FSDO, //PC->FPGA
    input wire FSCTS, //FPGA clear to send, active low
    input wire enabled,
    input reg [7:0] writeData,
    input reg writeDataValid,
    output wire writeQueueEmpty,
    output reg [0:7] readData,
    output reg readDataValid,
    input reg reset //active low
    );

    assign FSCLK = CLK48;

    reg [0:7] writeQueue [0:319];
    reg [9:0] writeQueueReadPointer = 0;
    reg [9:0] writeQueueWritePointer = 0;
    reg [3:0] writePointer = 0;
    reg isReading = 0;
    reg [3:0] readPointer = 0;
    assign writeQueueEmpty = writeQueueWritePointer == writeQueueReadPointer;

    //Loop
    always @(negedge FSCLK) begin
        //reading
        if (isReading & enabled) begin
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
            FSDI <= 1;
        end

        //start reading
        else if (!FSDO & enabled) begin
            // $display ("start reading");
            readPointer <= 0;
            isReading <= 1;
            readDataValid <= 0;
            FSDI <= 1;
        end

        //writing
        else if (!writeQueueEmpty & enabled) begin
            //reg 0
            if (writePointer == 0) begin
                // $display ("wrote 0 = 0");
                FSDI <= 0;
                writePointer <= 1;
            end

            //reg 9
            else if (writePointer == 9 & !FSCTS) begin
                // $display ("wrote 9 = 1");
                FSDI <= 1;

                if (writeQueueReadPointer >= $size(writeQueue) - 1) begin
                    writeQueueReadPointer <= 0;
                end
                else begin
                    writeQueueReadPointer <= writeQueueReadPointer + 1;
                end
                writePointer <= 0;
            end

            //reg 1-8
            else if (!FSCTS) begin
                // $display ("wrote %p = %b", writePointer, writeQueue[writeQueueReadPointer][writePointer - 1]);
                FSDI <= writeQueue[writeQueueReadPointer][writePointer - 1];
                writePointer <= writePointer + 1;
            end

            //else waiting for FSCTS or interrupted (and reset?)
        end

        //idle
        else begin
            FSDI <= 1;
        end
    end

    //Add to Write Queue
    always @(posedge writeDataValid) begin
        writeQueue[writeQueueWritePointer] <= writeData;
        if (writeQueueWritePointer >= $size(writeQueue) - 1) begin
            writeQueueWritePointer <= 0;
        end
        else begin
            writeQueueWritePointer <= writeQueueWritePointer + 1;
        end
    end

    //Reset (active low)
    always @(negedge reset) begin
        writeQueueReadPointer <= 0;
        writeQueueWritePointer <= 0;
        writePointer <= 0;
        isReading <= 0;
        readPointer <= 0;
        readDataValid <= 0;
        FSDI <= 1;
    end
endmodule