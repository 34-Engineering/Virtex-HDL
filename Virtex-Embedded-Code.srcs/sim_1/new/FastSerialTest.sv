
/* FastSerialTest - 

    */
module FastSerialTest(
    input wire FSDI,
    input wire FSCLK,
    output reg FSDO,
    output reg FSCTS
    );

    reg [0:7] writeQueue [$] = {};
    reg [3:0] writePointer = 0;
    
    task write(reg [0:7] data);
        writeQueue.push_back(data);
    endtask
    task clearWriteQueue();
        writeQueue.delete();
    endtask
    
    reg isReading = 0;
    reg [0:7] readData;
    reg [3:0] readPointer = 0;

    //Loop
    always @(negedge FSCLK) begin
        //reading
        if (isReading) begin
            if (readPointer == 8) begin
                // $display ("test done reading");
                FSCTS <= 1;
                readPointer <= 0;
                isReading <= 0;
                onData(readData);
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
        else if (writeQueue.size() > 0) begin
            //bit 0
            if (writePointer == 0) begin
                // $display ("test wrote 0 = 0");
                FSDO = 0;
                writePointer <= 1;
            end

            //bit 9
            else if (writePointer == 9) begin
                // $display ("test wrote 9 = 1");
                //send destination bit
                FSDO = 1;

                //prepare for next byte
                writeQueue.pop_front();
                writePointer <= 0;
            end

            //bit 1-8
            else begin
                // $display ("test wrote %p = %b", writePointer, writeQueue[0][writePointer - 1]);
                FSDO = writeQueue[0][writePointer - 1];
                writePointer <= writePointer + 1;
            end

            FSCTS <= 1;
        end

        //start reading
        else if (!FSDI & FSCTS) begin
            // $display ("test start reading");
            readPointer <= 0;
            isReading <= 1;
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