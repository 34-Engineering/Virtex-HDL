`timescale 1ns / 1ps
`include "VirtexConfig.sv"

/* ConfigManager
    Transfers config from EEPROM to FPGA fabric at boot
    Saves config to FPGA fabric & EEPROM on each external write request
    
    VirtexConfig: 32 x 16-bit (see Util.sv for individual configurations & defaults)

    EEPROM: AT25010B-MAHL-E (128 x 8-bit); Docs: https://ww1.microchip.com/downloads/en/DeviceDoc/20006251A.pdf
     [0] Validity
      - 0x34 EEPROM will be read at boot into virtexConfig
      - 0xXX EEPROM DefaultVirtexConfig will be written to at boot
     [1:64] virtexConfig

    Status Register (8-bits):
     [7:4] Reserved for Future Use (read only)
      - 000 device not in write cycle
      - 111 device in write cycle

     [3:2] Block write protection
      - 00 No array write protection (factory default)
      - 01 Quarter array write protection
      - 10 Half array write protection
      - 11 Entire array write protection

     [1] Write Enabled Latch (WEL) (read only)
      - 0 write disabled (power-up default)
      - 1 write enabled

     [0] Busy (read only)
      - 0 ready for transaction
      - 1 device busy with internal operation

    READ Transaction:
     - opcode (8-bits)
     - address (8-bits)
     - data byte at address, address + 1, ... until CS is pulled high

    WRITE Transaction (WP must be low & ENABLE_WEL must be written before every WRITE):
     - opcode (8-bits)
     - address (8-bits)
     - data byte at address, address + 1, ... until CS is pulled high

    Note: CS must be pulled high between commands

    */
module ConfigManager(
    input wire CLK,
    output reg SPI_CS, //active low
    output wire SPI_WP, //active low
    output wire SPI_HOLD, //active low
    output wire SPI_CLK,
    output reg SPI_MOSI,
    input wire SPI_MISO,
    output VirtexConfig virtexConfig,
    input VirtexConfigWriteRequest virtexConfigWriteRequests [1:0],
    output reg bootDone
    );

    localparam WRITE_STATUS = 8'h1; //opcode + 8-bits; only modifies bits [3:2]
    localparam WRITE        = 8'h2; //see notes above
    localparam READ         = 8'h3; //see notes above
    localparam DISABLE_WEL  = 8'h4; //opcode only
    localparam READ_STATUS  = 8'h5; //opcode + 8-bits
    localparam ENABLE_WEL   = 8'h6; //opcode only; must occur before every WRITE_STATUS and WRITE
    localparam VALID_DATA   = 8'h34;

    //10MHz Clock (20MHz is only allowed at 5V)
    clk_wiz_3 clk_wiz_3(
        .clk_in1(CLK),
        .clk_out1(SPI_CLK)
    );

    initial begin
        bootDone = 0;
        SPI_CS = 1;
    end

    reg inTransaction = 0;
    reg hasValidData = 1;
    reg [4:0] byteNumber = 0;
    reg [2:0] bytePointer = 0;
    reg lastBytePointerZero = 1;
    reg [7:0] readData = 0;
    
    reg [4:0] writeQueue[0:31]; //stores write address
    reg [4:0] writeQueueReadPointer = 0;
    reg [4:0] writeQueueWritePointer = 0;

    assign SPI_HOLD = inTransaction;
    assign SPI_WP = inTransaction & (bootDone | !hasValidData);

    always @(negedge SPI_CLK) begin
        if (~bootDone) begin
            //Check EEPROM Validity
            if (byteNumber == 0) begin
                //write READ opcode
                SPI_CS <= 0;
                inTransaction <= 1;
                SPI_MOSI <= READ[bytePointer];
                bytePointer <= bytePointer + 1;
            end
            else if (byteNumber == 1) begin
                //write address 0
                SPI_MOSI <= 0;
                bytePointer <= bytePointer + 1;
            end
            else if (byteNumber == 2) begin
                //read response from READ address 0
                readData[bytePointer] <= SPI_MISO;
                bytePointer <= bytePointer + 1;
                hasValidData <= readData == VALID_DATA;
            end

            //Continue READ & Transfer [1-64] (3-66) EEPROM into virtexConfig
            else if (hasValidData & byteNumber > 2 & byteNumber < 67) begin
                /*first find config register number, then * 16 to find its index
                  then we count [15:0] to read in whole register
                  since byteNumber = 3 at start LSB is 1 so * 8 + 7 to split register into [15:8] & [7:0]*/
                virtexConfig[(((byteNumber - 3) >> 1) * 16) + (byteNumber[0] * 8 + 7 - bytePointer)] <= SPI_MISO;
                bytePointer <= bytePointer + 1;
            end

            //Stop READ & WRITE DefaultVirtexConfig to EEPROM [1-64] then WRITE VALID_DATA to [0]
            else if (!hasValidData & (byteNumber == 3 | byteNumber == 5 | byteNumber == 72 | byteNumber == 74)) begin
                //pull up CS to write new command
                SPI_CS <= 1;
                byteNumber <= byteNumber + 1;
            end
            else if (!hasValidData & (byteNumber == 4 | byteNumber == 73)) begin
                //write ENABLE_WEL opcode
                SPI_CS <= 0;
                SPI_MOSI <= ENABLE_WEL[bytePointer];
                bytePointer <= bytePointer + 1;
            end
            else if (!hasValidData & (byteNumber == 6 | byteNumber == 75)) begin
                //write WRITE opcode
                SPI_CS <= 0;
                SPI_MOSI <= WRITE[bytePointer];
                bytePointer <= bytePointer + 1;
            end
            else if (!hasValidData & byteNumber == 7) begin
                //write address 1
                SPI_MOSI <= bytePointer == 7;
                bytePointer <= bytePointer + 1;
            end
            else if (!hasValidData & byteNumber == 76) begin
                //write address 0
                SPI_MOSI <= 0;
                bytePointer <= bytePointer + 1;
            end
            else if (!hasValidData & byteNumber > 7 & byteNumber < 72) begin
                //write DefaultVirtexConfig [0:31] into [1-64] (8-71)
                /*first find config register number, then * 16 to find its index
                  then we count [15:0] to read in whole register
                  since byteNumber = 8 at start !LSB is 1 so * 8 + 7 to split register into [15:8] & [7:0]*/
                SPI_MOSI <= DefaultVirtexConfig[(((byteNumber - 8) >> 1) * 16) + (!byteNumber[0] * 8 + 7 - bytePointer)];
                bytePointer <= bytePointer + 1;
            end
            else if (!hasValidData & byteNumber == 77) begin
                //write 0x34
                /*note: we are writing 0x34 AFTER writing entire DefaultVirtexConfig
                  this is incase there is an interuption while writing DefaultVirtexConfig,
                  we do not want a partially written config marked as valid!*/
                SPI_MOSI <= VALID_DATA[bytePointer];
                bytePointer <= bytePointer + 1;
            end

            //Done
            else if ((hasValidData & byteNumber > 2) | (!hasValidData & byteNumber == 78)) begin
                SPI_CS <= 1;
                bootDone <= 1;
                byteNumber <= 0;
                inTransaction <= 0;
            end
        end

        else if (writeQueueReadPointer != writeQueueWritePointer) begin
            if (byteNumber == 0) begin
                //write ENABLE_WEL opcode
                SPI_CS <= 0;
                inTransaction <= 1;
                SPI_MOSI <= ENABLE_WEL[bytePointer];
                bytePointer <= bytePointer + 1;
            end
            else if (byteNumber == 1) begin
                //pull up CS to write new command
                SPI_CS <= 1;
                byteNumber <= byteNumber + 1;
            end
            else if (byteNumber == 2) begin
                //write WRITE opcode
                SPI_CS <= 0;
                SPI_MOSI <= WRITE[bytePointer];
                bytePointer <= bytePointer + 1;
            end
            else if (byteNumber == 3) begin
                //write address
                SPI_MOSI <= writeQueue[writeQueueReadPointer];
                bytePointer <= bytePointer + 1;
            end
            else if (byteNumber == 4 | byteNumber == 5) begin
                //write virtexConfig[address] into address
                /*first get config address, then * 16 to find its index
                  then we count [15:0] to read in whole register
                  since byteNumber = 4 at start !LSB is 1 so * 8 + 7 to split register into [15:8] & [7:0]*/
                SPI_MOSI <= virtexConfig[(writeQueue[writeQueueReadPointer] * 16) + (!byteNumber[0] * 8 + 7 - bytePointer)];
                bytePointer <= bytePointer + 1;
            end
            else begin
                //done
                SPI_CS <= 1;
                byteNumber <= 0;
                inTransaction <= 0;
            end
        end

        //increment byteNumber w/ bytePointer latch
        if (bytePointer == 0 & !lastBytePointerZero) begin
            byteNumber <= byteNumber + 1;
        end
        lastBytePointerZero <= bytePointer == 0;
    end

    //Write Requests
    genvar i;
    generate
        for (i=0; i < $size(virtexConfigWriteRequests); i = i + 1) begin
            always @(posedge virtexConfigWriteRequests[i].valid) begin
                write(virtexConfigWriteRequests[i].address, virtexConfigWriteRequests[i].data);
            end
        end
    endgenerate
    task write(logic [4:0] address, logic [15:0] data);
        //write to FPGA fabric
        virtexConfig[address] <= data;

        //add to address EEPROM write queue
        /*we only need to add the address to the write queue
          because the value is already in virtexConfig*/
        writeQueue[writeQueueWritePointer] <= address;
        if (writeQueueWritePointer >= $size(writeQueue) - 1) begin
            writeQueueWritePointer <= 0;
        end
        else begin
            writeQueueWritePointer <= writeQueueWritePointer + 1;
        end
    endtask
endmodule