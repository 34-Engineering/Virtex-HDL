`timescale 1ns / 1ps
`include "VirtexConfig.sv"

/* ConfigManager
    Transfers config from EEPROM to FPGA fabric at boot
    Saves config to FPGA fabric & EEPROM on each external write request
    
    VirtexConfig: 64 x 16-bit (see Util.sv for individual configurations & defaults)

    EEPROM: AT25010B-MAHL-E (128 x 8-bit); Docs: https://ww1.microchip.com/downloads/en/DeviceDoc/20006251A.pdf

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
    input wire CLK100, CLK10,
    output reg SPI_CS, //active low
    output wire SPI_WP, //active low
    output wire SPI_HOLD, //active low
    output wire SPI_CLK,
    output reg SPI_MOSI,
    input wire SPI_MISO,
    output VirtexConfig virtexConfig,
    input VirtexConfigWriteRequest virtexConfigWriteRequests [1:0],
    output reg bootDone,
    output reg [7:0] debug
    );

    localparam WRITE_STATUS = 8'h1; //opcode + 8-bits; only modifies bits [3:2]
    localparam WRITE        = 8'h2; //see notes above
    localparam READ         = 8'h3; //see notes above
    localparam DISABLE_WEL  = 8'h4; //opcode only
    localparam READ_STATUS  = 8'h5; //opcode + 8-bits
    localparam ENABLE_WEL   = 8'h6; //opcode only; must occur before every WRITE_STATUS and WRITE
    localparam MEM_VALID_ADDR = 127;
    localparam MEM_VALID_CODE = 8'h34;

    initial virtexConfig = DefaultVirtexConfig;

    reg inTransaction = 0;
    reg hasValidData = 1;
    reg [4:0] byteNumber = 0;
    wire [4:0] bootReadNumber = byteNumber - 2;
    wire [4:0] bootWriteNumber = byteNumber - 7;
    reg [2:0] bytePointer = 0;
    reg lastBytePointerZero = 1;
    reg [7:0] readData = 0;
    
    assign SPI_CLK = CLK10;
    assign SPI_HOLD = inTransaction;
    assign SPI_WP = inTransaction & (bootDone | ~hasValidData);
    initial bootDone = 0;
    initial SPI_CS = 1;

    VirtexConfigWriteRequest newConfigFIFOOut, newConfigFIFOIn = 0;
    wire newConfigFIFOEmpty, newConfigFIFOFull;
    reg newConfigFIFORead = 0, newConfigFIFOWrite = 0;
    
    // initial debug = 8'b10101010;
    assign debug = {inTransaction, hasValidData, bootDone, byteNumber};

    //100 11111

    //Process Loop
    always_ff @(negedge CLK10) begin
        newConfigFIFORead <= 0;

        //Increment Byte Number
        if (bytePointer == 0 & ~lastBytePointerZero) begin
            byteNumber = byteNumber + 1;
        end
        lastBytePointerZero = bytePointer == 0;

        //Load EEPROM @ Boot
        if (~bootDone) begin
            //Check EEPROM Validity
            if (byteNumber == 0) begin
                // debug <= 8'b01010101;
                //write READ opcode
                SPI_CS <= 0;
                inTransaction <= 1;
                SPI_MOSI <= READ[bytePointer];
                bytePointer <= bytePointer + 1;
            end
            else if (byteNumber == 1) begin
                //write MEM_VALID addr
                SPI_MOSI <= MEM_VALID_ADDR[bytePointer];
                bytePointer <= bytePointer + 1;
            end
            else if (byteNumber == 2) begin
                //read response
                readData[bytePointer] <= SPI_MISO;
                bytePointer <= bytePointer + 1;
                hasValidData <= readData == MEM_VALID_CODE;
            end

            //Continue READ (overflows 127 -> 0) & Transfer [0:126] EEPROM into virtexConfig [0:63]
            else if (hasValidData & bootReadNumber < 127) begin
                // debug <= 8'b11110000;
                //split each config into 2x 8-bit parts and then load them out one bit at a time
                virtexConfig[(getConfigAddrIndex(bootReadNumber >> 1) - (bootReadNumber[0] ? 8 : 0)) - bytePointer] <= SPI_MOSI;
                bytePointer <= bytePointer + 1;
            end

            //Stop READ then WRITE virtexConfig (DefaultVirtexConfig) [0:63] to EEPROM [0:127]
            else if (~hasValidData & (byteNumber == 3 | byteNumber == 5)) begin
                // debug <= 8'b00001111;
                //pull up CS to write new command
                SPI_CS <= 1;
                byteNumber <= byteNumber + 1;
            end
            else if (~hasValidData & byteNumber == 4) begin
                //write ENABLE_WEL opcode
                SPI_CS <= 0;
                SPI_MOSI <= ENABLE_WEL[bytePointer];
                bytePointer <= bytePointer + 1;
            end
            else if (~hasValidData & byteNumber == 6) begin
                //write WRITE opcode
                SPI_CS <= 0;
                SPI_MOSI <= WRITE[bytePointer];
                bytePointer <= bytePointer + 1;
            end
            else if (~hasValidData & byteNumber == 7) begin
                //write address 0
                SPI_MOSI <= 0;
                bytePointer <= bytePointer + 1;
            end
            else if (~hasValidData & bootWriteNumber < 128) begin
                //split each config into 2x 8-bit parts and then write them out one bit at a time
                SPI_MOSI <= virtexConfig[(getConfigAddrIndex(bootWriteNumber >> 1) - (bootWriteNumber[0] ? 8 : 0)) - bytePointer];
                bytePointer <= bytePointer + 1;
            end

            //Done
            else begin
                // debug <= 8'b11111111;
                SPI_CS <= 1;
                bootDone <= 1;
                byteNumber <= 0;
                inTransaction <= 0;
            end
        end

        //Write New Data to EEPROM & RAM
        else if (inTransaction) begin
            if (byteNumber == 0) begin
                //write new data to virtexConfig (FPGA RAM)
                if (bytePointer == 0) begin
                    virtexConfig[getConfigAddrIndex(newConfigFIFOOut.addr) -: 16] <= newConfigFIFOOut.data;
                end

                //write ENABLE_WEL opcode
                SPI_CS <= 0;
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
                SPI_MOSI <= newConfigFIFOOut.addr[bytePointer];
                bytePointer <= bytePointer + 1;
            end
            else if (byteNumber == 4 | byteNumber == 5) begin
                //split config into 2x 8-bit parts and then write them out one bit at a time
                SPI_MOSI <= newConfigFIFOOut.data[(byteNumber[0] ? 7 : 15) - bytePointer];
                bytePointer <= bytePointer + 1;
            end
            else begin
                // debug <= 8'b00111100;

                //done
                SPI_CS <= 1;
                byteNumber <= 0;
                inTransaction <= 0;
            end
        end

        //Read New Data from FIFO
        else if (~newConfigFIFOEmpty) begin
            // debug <= 8'b00110011;
            newConfigFIFORead <= 1;
            inTransaction <= 1;
        end
    end

    //New Config Data FIFO
    fifo_virtex_config fifo_virtex_config(
        .empty(newConfigFIFOEmpty),
        .dout(newConfigFIFOAddrOut),
        .rd_en(newConfigFIFORead),
        .rd_clk(CLK10),
        .full(newConfigFIFOFull),
        .din(newConfigFIFOAddrIn),
        .wr_en(newConfigFIFOWrite),
        .wr_clk(CLK100)
    );

    //Write Requests
    reg virtexConfigWriteRequestIndex = 0;
    reg [$size(virtexConfigWriteRequests)-1:0] lastVirtexConfigWriteRequestValids;
    always_ff @(negedge CLK100) begin
        //New Request //TODO fix potential metastability with virtexConfigWriteRequest
        if (virtexConfigWriteRequests[virtexConfigWriteRequestIndex].valid & ~lastVirtexConfigWriteRequestValids[virtexConfigWriteRequestIndex]) begin
            //Add to EEPROM Memory Write Queue
            newConfigFIFOIn <= virtexConfigWriteRequests[virtexConfigWriteRequestIndex];
            newConfigFIFOWrite <= 1;

            //TODO fault @ newConfigFIFOFull ?
        end
        else newConfigFIFOWrite <= 0;

        lastVirtexConfigWriteRequestValids[virtexConfigWriteRequestIndex] <= virtexConfigWriteRequests[virtexConfigWriteRequestIndex].valid;
        virtexConfigWriteRequestIndex <= ~virtexConfigWriteRequestIndex;
    end
endmodule