`timescale 1ns / 1ps

/* Implementation of FTDI's Fast Serial Interface
    Fast Serial Docs: https://ftdichip.com/wp-content/uploads/2020/08/AN_131_FT2232D_H_Fast-Opto-Isolated-Serial-Interface-mode.pdf
    FT2232H Docs: https://www.ftdichip.com/Support/Documents/DataSheets/ICs/DS_FT2232H.pdf
    Fast Serial Notes: https://docs.google.com/document/d/1Sg8LKgYLEdBtbzcvhCJvDzMn8KQxomQIMN0E1RHf6OQ/edit
    */
module FastSerial(
    input wire CLK,
    output bit FSDI, //FPGA->PC
    output wire FSCLK, //48MHz (FPGA generated)
    input wire FSDO, //PC->FPGA
    input wire FSCTS, //FPGA clear to send, active low
    input wire enabled
    );

    //48MHz Clock
    wire CLK48;
    clk_wiz_1 clk_wiz_1(
        .clk_in1(CLK),
        .clk_out1(CLK48)
    );
    assign FSCLK = CLK48;

    parameter writeQueueSize = 320 - 1;
    bit [0:7] writeQueue[0:writeQueueSize];
    bit [9:0] writeQueueReadPointer = 0;
    bit [9:0] writeQueueWritePointer = 0;
    bit [3:0] writePointer = 0;
    
    task write(bit [0:7] data);
        writeQueue[writeQueueWritePointer] = data;
        if (writeQueueWritePointer >= writeQueueSize) begin
            writeQueueWritePointer = 0;
        end
        else begin
            writeQueueWritePointer = writeQueueWritePointer + 1;
        end
    endtask
    task clearWriteQueue();
        writeQueueReadPointer = 0;
        writeQueueWritePointer = 0;
    endtask
    
    bit isReading = 0;
    bit [0:7] readData = 0;
    bit [3:0] readPointer = 0;

    //Loop
    always @(negedge FSCLK) begin
        //reading
        if (isReading & enabled) begin
            if (readPointer == 8) begin
                // $display ("done reading");
                readPointer = 0;
                isReading = 0;
                // Top.AppManager.onData(readData);
            end
            else begin
                // $display ("read %p = %b", readPointer, FSDO);
                readData[readPointer] = FSDO;
                readPointer = readPointer + 1;
            end
            FSDI <= 1;
        end

        //start reading
        else if (!FSDO & enabled) begin
            // $display ("start reading");
            readPointer = 0;
            isReading = 1;
            FSDI <= 1;
        end

        //writing
        else if (writeQueueWritePointer !== writeQueueReadPointer & enabled) begin
            //bit 0
            if (writePointer == 0) begin
                // $display ("wrote 0 = 0");
                FSDI = 0;
                writePointer = 1;
            end

            //bit 9
            else if (writePointer == 9 & !FSCTS) begin
                // $display ("wrote 9 = 1");
                FSDI = 1;

                if (writeQueueReadPointer >= writeQueueSize) begin
                    writeQueueReadPointer = 0;
                end
                else begin
                    writeQueueReadPointer = writeQueueReadPointer + 1;
                end
                writePointer = 0;
            end

            //bit 1-8
            else if (!FSCTS) begin
                // $display ("wrote %p = %b", writePointer, writeQueue[writeQueueReadPointer][writePointer - 1]);
                FSDI = writeQueue[writeQueueReadPointer][writePointer - 1];
                writePointer = writePointer + 1;
            end

            //else waiting for FSCTS or interrupted (and reset?)
        end

        //idle
        else begin
            FSDI <= 1;
        end
    end
endmodule