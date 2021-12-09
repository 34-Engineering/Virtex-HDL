
/* Implementation of FTDI's Fast Serial Interface
    Fast Serial Docs: https://ftdichip.com/wp-content/uploads/2020/08/AN_131_FT2232D_H_Fast-Opto-Isolated-Serial-Interface-mode.pdf
    FT2232H Docs: https://www.ftdichip.com/Support/Documents/DataSheets/ICs/DS_FT2232H.pdf
    Fast Serial Notes: https://docs.google.com/document/d/1Sg8LKgYLEdBtbzcvhCJvDzMn8KQxomQIMN0E1RHf6OQ/edit
    */
module FastSerial(
    input wire CLK,
    output reg FSDI, //FPGA->PC
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
    always @(posedge CLK48) begin
        //reading
        if (isReading & enabled) begin
            if (readPos == 8) begin
                // $display ("done reading");
                readPos <= 0;
                isReading <= 0;
                onData(readData);
            end
            else begin
                // $display ("read %p = %b", readPos, FSDO);
                readData[readPos] = FSDO;
                readPos <= readPos + 1;
            end
            FSDI <= 1;
        end

        //start reading
        else if (!FSDO & enabled) begin
            // $display ("start reading");
            readPos <= 0;
            isReading <= 1;
            FSDI <= 1;
        end

        //writing
        else if (writeQueue.size() > 0 & enabled) begin
            //bit 0
            if (writePos == 0) begin
                // $display ("wrote 0 = 0");
                FSDI = 0;
                writePos <= 1;
            end

            //bit 9
            else if (writePos == 9 & !FSCTS) begin
                // $display ("wrote 9 = 1");
                //send destination bit
                FSDI = 1;

                //prepare for next byte
                writeQueue.pop_front();
                writePos <= 0;
            end

            //bit 1-8
            else if (!FSCTS) begin
                // $display ("wrote %p = %b", writePos, writeQueue[0][writePos - 1]);
                FSDI = writeQueue[0][writePos - 1];
                writePos <= writePos + 1;
            end

            //else waiting for FSCTS or interrupted (and reset?)
        end

        //idle
        else begin
            FSDI <= 1;
        end
    end
endmodule