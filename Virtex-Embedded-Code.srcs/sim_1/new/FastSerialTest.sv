

module FastSerialTest(
    input wire FSDI,
    input wire FSCLK,
    output reg FSDO,
    output reg FSCTS
    );

    reg [0:7] writeQueue [$] = {};
    reg [3:0] writePos = 0;
    
    task write(reg [0:7] data);
        writeQueue.push_back(data);
    endtask
    task clearWriteQueue();
        writeQueue.delete();
    endtask
    
    reg isReading = 0;
    reg [0:7] readData;
    reg [3:0] readPos = 0;

    //Loop
    always @(negedge FSCLK) begin
        //writing
        if (writeQueue.size() > 0) begin
            
        end

        if (!FSDI & FSCTS) begin
            // $display ("got 0 = 0");
            FSCTS <= 0;
            readPos <= 1;
        end
        else if (readPos > 0 & !FSCTS) begin
            if (readPos == 9) begin
                FSCTS <= 1;
                readPos <= 0;
                onData(readData);
            end
            else begin
                readData[readPos - 1] = FSDI;
                readPos <= readPos + 1;
            end
        end
    end
endmodule