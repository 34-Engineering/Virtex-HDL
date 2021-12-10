`timescale 1ns / 1ps

/* FastSerialTest - 

    */
module FastSerialTest(
    input wire FSDI,
    input wire FSCLK,
    output bit FSDO,
    output bit FSCTS,
    input wire enabled,
    output bit [0:7] readData,
    output bit readDataValid
    );

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
    bit [3:0] readPointer = 0;

    //Loop
    always @(posedge FSCLK) begin
        //reading
        if (isReading & enabled) begin
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
        else if (writeQueueWritePointer !== writeQueueReadPointer & enabled) begin
            //bit 0
            if (writePointer == 0) begin
                // $display ("test wrote 0 = 0");
                FSDO = 0;
                writePointer <= 1;
            end

            //bit 9
            else if (writePointer == 9) begin
                // $display ("test wrote 9 = 1");
                FSDO = 1;

                if (writeQueueReadPointer >= writeQueueSize) begin
                    writeQueueReadPointer = 0;
                end
                else begin
                    writeQueueReadPointer = writeQueueReadPointer + 1;
                end
                writePointer = 0;
            end

            //bit 1-8
            else begin
                // $display ("test wrote %p = %b", writePointer, writeQueue[writeQueueReadPointer][writePointer - 1]);
                FSDO = writeQueue[writeQueueReadPointer][writePointer - 1];
                writePointer <= writePointer + 1;
            end

            FSCTS <= 1;
        end

        //start reading
        else if (!FSDI & FSCTS) begin
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
    end
endmodule