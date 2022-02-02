`timescale 1ns / 1ps
`include "../../sources_1/new/Util.sv"

/* AT25010BMAHLESim - simulates the EEPROM Memory for the ConfigManager

    Docs: https://ww1.microchip.com/downloads/en/DeviceDoc/20006251A.pdf

    See ConfigManager.sv for more details

    Note: Does not simulate the block write protection register functionality

    */
module AT25010BMAHLESim(
    input wire SPI_CS, SPI_WP, SPI_HOLD, SPI_CLK, SPI_MOSI,
    output reg SPI_MISO
    );

    localparam WRITE_STATUS = 8'h1; //opcode + 8-bits; only modifies bits [3:2]
    localparam WRITE        = 8'h2; //see notes above
    localparam READ         = 8'h3; //see notes above
    localparam DISABLE_WEL  = 8'h4; //opcode only
    localparam READ_STATUS  = 8'h5; //opcode + 8-bits
    localparam ENABLE_WEL   = 8'h6; //opcode only; must occur before every WRITE_STATUS and WRITE

    reg [7:0] memory [127:0];
    reg WEL = 0;
    reg [1:0] BLOCK_WRITE_PROTECTION = 2'b0; //non-functional
    reg BUSY = 0;
    wire [7:0] STATUS = '{4'b0, BLOCK_WRITE_PROTECTION, WEL, BUSY};

    reg inTransaction = 0;
    reg [7:0] byteNumber = 0;
    reg [2:0] bytePointer = 0;
    reg lastBytePointerZero = 1;
    reg [7:0] readData = 0;
    reg [7:0] opcode;
    reg [7:0] address;
    reg lastCS = 1;

    always @(posedge SPI_CLK) begin
        //Start Transaction
        if (SPI_CS & ~lastCS) begin
            inTransaction <= 1;
            byteNumber <= 0;
            bytePointer <= 0;
            opcode <= 0;
            readData <= 0;
        end
        //End Transaction
        if (~SPI_CS & lastCS) begin
            inTransaction <= 0;

            //ENABLE_WEL
            if (opcode == ENABLE_WEL) begin
                WEL <= 1;
            end

            //DISABLE_WEL
            else if (opcode == DISABLE_WEL) begin
                WEL <= 0;
            end

            //WRITE_STATUS
            else if (opcode == WRITE & byteNumber == 2) begin
                BLOCK_WRITE_PROTECTION <= readData[3:2];
            end
        end
        lastCS <= SPI_CS;

        //In Transaction
        if (inTransaction) begin
            //Read Opcode
            if (byteNumber == 0) begin
                readMOSI();
            end

            //READ/WRITE Address
            else if ((opcode == READ | opcode == WRITE) & byteNumber == 1) begin
                readMOSI();

                if (bytePointer == 7) begin
                    address <= readData;
                end
            end

            //WRITE
            else if (opcode == WRITE) begin
                readMOSI();

                if (bytePointer == 7) begin
                    memory[address + byteNumber - 2] <= readData;
                end
            end

            //READ
            else if (opcode == READ) begin
                writeMISO(memory[address + byteNumber - 2][bytePointer]);
            end


            //WRITE_STATUS
            else if (opcode == WRITE_STATUS & byteNumber == 1) begin
                readMOSI();
            end

            //READ_STATUS
            else if (opcode == READ_STATUS & byteNumber == 1) begin
                writeMISO(STATUS[bytePointer]);
            end
        end

        //increment byteNumber w/ bytePointer latch
        if (bytePointer == 0 & !lastBytePointerZero) begin
            if (byteNumber == 129) begin
                //overflow for READ/WRITE
                byteNumber <= 2;
            end
            else begin
                byteNumber <= byteNumber + 1;
            end
        end
        lastBytePointerZero <= bytePointer == 0;
    end

    task readMOSI();
        readData[bytePointer] <= SPI_MOSI;
        bytePointer <= bytePointer + 1;
    endtask

    task writeMISO(logic data);
        SPI_MISO <= data;
        bytePointer <= bytePointer + 1;
    endtask

endmodule