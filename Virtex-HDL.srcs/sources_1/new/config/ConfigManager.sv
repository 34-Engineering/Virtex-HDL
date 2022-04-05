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

    3.3V Timing:
    f_SCK = 10MHz (100ns period) (SCK Clock Frequenecy)
    t_RI, t_FI = 2us (Input Rise/Fall Time)
    t_WH, t_WL = 40ns (SCK Low/High Time)
    t_CS = 100ns (CS High Time)
    t_CSS = 100ns (CS Setup Time)
    t_CSH = 100ns (CS Hold Time)
    t_SU = 40ns (Data In Setup Time)
    t_H = 40ns (Data In Hold Time)
    t_HD = 40ns (HOLD Setup Time)
    t_CD = 40ns (HOLD Hold Time)
    t_V = 40ns (Output Valid)
    t_HO = 0ns (Output Hold time)
    t_LZ = 50ns (HOLD to Output Low-Z)
    t_HZ = 50ns (HOLD to Output High-Z)
    t_DIS = 50ns (Output Disable Time)
    t_WC = 5ms (Write Cycle time)

    */
module ConfigManager(
    input wire CLK100, CLK10,
    output reg SPI_CS, //active low
    output wire SPI_WP, //prevent writing when low
    output wire SPI_HOLD, //pause comms when low
    output wire SPI_CLK,
    output reg SPI_MOSI,
    input wire SPI_MISO,
    `ifndef SIM
    output VirtexConfig virtexConfig,
    `endif
    input VirtexConfigWriteRequest virtexConfigWriteRequests [1:0],
    output wire isBooted,
    output reg [7:0] debug
    );

    `ifndef SIM
    initial virtexConfig = DefaultVirtexConfig;
    `else
    VirtexConfig virtexConfig = DefaultVirtexConfig;
    `endif

    //No-EEPROM Version
    reg [$size(virtexConfigWriteRequests)-1:0] lastVirtexConfigWriteRequestValids;
    always_ff @(negedge CLK100) begin
        //TODO fix potential metastability with virtexConfigWriteRequest
        for (int i = 0; i < $size(virtexConfigWriteRequests); i++) begin
            if (virtexConfigWriteRequests[i].valid & ~lastVirtexConfigWriteRequestValids[i]) begin
                //Add to EEPROM Memory Write Queue
                virtexConfig[getConfigAddrIndex(virtexConfigWriteRequests[i].addr) -: 16] <= 
                    virtexConfigWriteRequests[i].data;
            end

            lastVirtexConfigWriteRequestValids[i] <= virtexConfigWriteRequests[i].valid;
        end
    end

    //TODO work on EEPROM
    // localparam logic [7:0] WRITE_STATUS = 8'h1; //opcode + 8-bits; only modifies bits [3:2]
    // localparam logic [7:0] WRITE_OP     = 8'h2; //see notes above
    // localparam logic [7:0] READ_OP      = 8'h3; //see notes above
    // localparam logic [7:0] DISABLE_WEL  = 8'h4; //opcode only
    // localparam logic [7:0] READ_STATUS  = 8'h5; //opcode + 8-bits
    // localparam logic [7:0] ENABLE_WEL   = 8'h6; //opcode only; must occur before every WRITE_STATUS and WRITE
    // localparam logic [7:0] MEM_VALID_ADDR = 8;
    // localparam logic [7:0] MEM_VALID_CODE = DefaultVirtexConfig.memValid[7:0];

    // //New Config Write FIFO
    // VirtexConfigWriteRequest newConfigFIFOOut;
    // VirtexConfigWriteRequest newConfigFIFOIn = 0;
    // wire newConfigFIFOEmpty, newConfigFIFOFull;
    // reg newConfigFIFORead = 0, newConfigFIFOWrite = 0;

    // //State
    // enum logic [3:0] {
    //     WAIT=0,
    //     CLEAR_STATUS_WEL=1, CLEAR_STATUS=2,
    //     CHECK_MEM_VALID=3,
    //     LOAD_MEM=4,
    //     WRITE_DEFAULT_WEL=5, WRITE_DEFAULT=6,
    //     WRITE_NEW_WEL=7, WRITE_NEW=8,
    //     IDLE=9
    // } state = WAIT;

    // /* Sequence
    //     Index | 0  1  2  3    -3 -2 -1 End
    //     Data  | X  D  D  D ... D D  X  X
    //     ClkEn | 0  0  1  1     1 1  0  0
    //     CS    | 1  0  0  0     0 0  0  1 */
    // reg [10:0] sequenceIndex = 0;
    // localparam [10:0] stateEndIndexes [10] = '{
    //     (2   << 3) + 3, //WAIT
    //     (1   << 3) + 3, //CLEAR_STATUS_WEL
    //     (2   << 3) + 3, //CLEAR_STATUS
    //     (3   << 3) + 3, //CHECK_MEM_VALID
    //     (129 << 3) + 3, //LOAD_MEM
    //     (1   << 3) + 3, //WRITE_DEFAULT_WEL
    //     (10  << 3) + 3, //WRITE_DEFAULT
    //     (1   << 3) + 3, //WRITE_NEW_WEL
    //     (4   << 3) + 3, //WRITE_NEW
    //     0 //IDLE
    // };
    // wire [10:0] currentStateEndIndex = stateEndIndexes[state];
    // wire isBlanking = sequenceIndex < 1 | sequenceIndex > currentStateEndIndex-2;
    // assign SPI_CS = sequenceIndex < 1 | sequenceIndex >= currentStateEndIndex | state == WAIT;
    // assign SPI_CLK = (sequenceIndex > 1 & sequenceIndex < currentStateEndIndex-1 & state != WAIT) ? CLK10 : 0;
    // assign SPI_HOLD = 1;
    // assign SPI_WP = 1;//state == WRITE_DEFAULT_WEL | state == WRITE_DEFAULT | state == WRITE_NEW_WEL | state == WRITE_NEW;
    // reg [7:0] memValidResponse;
    // wire hasValidData = memValidResponse == MEM_VALID_CODE;
    // wire [8:0] byteNumber = (sequenceIndex - 1) >> 3;
    // wire [8:0] lastByteNumber = (sequenceIndex - 2) >> 3;
    // wire [2:0] bytePointer = 7 - ((sequenceIndex - 1) - ((sequenceIndex - 1) >> 3 << 3)); //7 down to 1
    // wire [2:0] nextBytePointer = bytePointer + 1;
    // reg [3:0] writeDefaultIndex = 0; //what page we are on
    // wire [7:0] writeDefaultAddr = writeDefaultIndex << 3;
    // assign isBooted = state == IDLE | state == WRITE_NEW_WEL | state == WRITE_NEW;

    // assign debug = memValidResponse;

    // //01100100
    // //

    // //Process Loop
    // always_ff @(negedge CLK10) begin
    //     //WEL (Enable Write)
    //     if ((state == CLEAR_STATUS_WEL | state == WRITE_DEFAULT_WEL | state == WRITE_NEW_WEL) & ~isBlanking) begin
    //         SPI_MOSI <= ENABLE_WEL[bytePointer];
    //     end

    //     //Clear Status
    //     if (state == CLEAR_STATUS & ~isBlanking) begin
    //         if (byteNumber == 0) begin
    //             SPI_MOSI <= WRITE_STATUS[bytePointer];
    //         end
    //         else if (byteNumber == 1) begin
    //             SPI_MOSI <= 0; //disable block write protection
    //         end
    //     end

    //     //Check EEPROM Memory Validity
    //     if (state == CHECK_MEM_VALID & ~isBlanking) begin
    //         if (byteNumber == 0) begin
    //             SPI_MOSI <= READ_OP[bytePointer];
    //         end
    //         else if (byteNumber == 1) begin
    //             SPI_MOSI <= MEM_VALID_ADDR[bytePointer];
    //         end
    //     end
        
    //     //Load EEPROM Memory into Virtex Config
    //     else if (state == LOAD_MEM & ~isBlanking) begin
    //         if (byteNumber == 0) begin
    //             SPI_MOSI <= READ_OP[bytePointer];
    //         end
    //         else if (byteNumber == 1) begin
    //             SPI_MOSI <= 0;
    //         end
    //     end
        
    //     //Write Default Virtex Config to EEPROM
    //     else if (state == WRITE_DEFAULT & ~isBlanking) begin
    //         if (byteNumber == 0) begin
    //             SPI_MOSI <= WRITE_OP[bytePointer];
    //         end
    //         else if (byteNumber == 1) begin
    //             SPI_MOSI <= writeDefaultAddr[bytePointer];
    //         end
    //         else if (byteNumber <= 9) begin //[0:7] -> [2:9]
    //             SPI_MOSI <= MEM_VALID_CODE[bytePointer];
    //             //Write virtexConfig (DefaultVirtexConfig) [0:63] into EEPROM [0:127]
    //             // SPI_MOSI <= virtexConfig[
    //             //     getConfigAddrIndex((writeDefaultIndex<<2) + ((byteNumber-2)>>1)) - //get index of 16-bit config register
    //             //     (byteNumber[0] ? 8:0) - //split 16-bit register into 2x 8-bit
    //             //     bytePointer //read out one bit at a time
    //             // ];
    //         end
    //     end

    //     //Write New Data to EEPROM & RAM
    //     else if (state == WRITE_NEW & ~isBlanking) begin
    //         if (byteNumber == 0) begin
    //             SPI_MOSI <= WRITE_OP[bytePointer];
    //         end
    //         else if (byteNumber == 1) begin
    //             SPI_MOSI <= newConfigFIFOOut.addr[bytePointer];
    //         end
    //         else if (byteNumber == 2 | bytePointer == 3) begin
    //             SPI_MOSI <= newConfigFIFOOut.data[(byteNumber[0] ? 7 : 15) - bytePointer];
    //         end
    //     end

    //     //Increment & Change State
    //     if (sequenceIndex == currentStateEndIndex) begin
    //         sequenceIndex <= 0;
    //         case (state)
    //             WAIT: state <= CLEAR_STATUS_WEL;
    //             CLEAR_STATUS_WEL: state <= CLEAR_STATUS;
    //             CLEAR_STATUS: state <= CHECK_MEM_VALID;
    //             CHECK_MEM_VALID: begin
    //                 if (hasValidData) state <= LOAD_MEM;
    //                 else state <= WRITE_DEFAULT_WEL;
    //             end
    //             LOAD_MEM: state <= IDLE;
    //             WRITE_DEFAULT_WEL: state <= WRITE_DEFAULT;
    //             WRITE_DEFAULT: begin
    //                 if (writeDefaultIndex == 15) state <= IDLE;
    //                 else begin
    //                     writeDefaultIndex <= writeDefaultIndex + 1;
    //                     state <= WRITE_DEFAULT_WEL;
    //                 end
    //             end
    //             WRITE_NEW_WEL: state <= WRITE_NEW;
    //             WRITE_NEW: state <= IDLE;
    //         endcase
    //     end
    //     else sequenceIndex <= sequenceIndex + 1;

    //     //Read New Data from FIFO
    //     newConfigFIFORead <= 0;
    //     if (state == IDLE & ~newConfigFIFOEmpty) begin
    //         newConfigFIFORead <= 1;
    //         state <= WRITE_NEW_WEL;
    //     end
    // end

    // //Read Loop
    // always_ff @(posedge CLK10) begin
    //     //Check EEPROM Memory Validity (Read Response)
    //     if (state == CHECK_MEM_VALID & lastByteNumber == 2) begin
    //         memValidResponse[nextBytePointer] <= SPI_MISO; //[7:0] [8:0]
    //     end

    //     //Load EEPROM Memory into Virtex Config (Read Response)
    //     //FIXME
    //     else if (state == LOAD_MEM & lastByteNumber <= 128) begin
    //         //Load EEPROM [0:126] (we already read 127) into virtexConfig [0:62]
    //         virtexConfig[
    //             getConfigAddrIndex((byteNumber - 2) >> 1) - //get index of 16-bit config register
    //             (byteNumber[0] ? 8 : 0) - //split 16-bit register into 2x 8-bit
    //             nextBytePointer //read out one bit at a time
    //         ] <= SPI_MISO;
    //     end

    //     //TODO LOAD FIFO READ INTO VCONFIG
    //     // virtexConfig[getConfigAddrIndex(newConfigFIFOOut.addr) -: 16] <= newConfigFIFOOut.data;
    // end

    // //New Config Data FIFO
    // fifo_virtex_config fifo_virtex_config(
    //     .empty(newConfigFIFOEmpty),
    //     .dout(newConfigFIFOOut),
    //     .rd_en(newConfigFIFORead),
    //     .rd_clk(CLK10),
    //     .full(newConfigFIFOFull),
    //     .din(newConfigFIFOIn),
    //     .wr_en(newConfigFIFOWrite),
    //     .wr_clk(CLK100)
    // );

    // //Write Requests
    // reg virtexConfigWriteRequestIndex = 0;
    // reg [$size(virtexConfigWriteRequests)-1:0] lastVirtexConfigWriteRequestValids;
    // always_ff @(negedge CLK100) begin
    //     //New Request //TODO fix potential metastability with virtexConfigWriteRequest
    //     if (virtexConfigWriteRequests[virtexConfigWriteRequestIndex].valid & ~lastVirtexConfigWriteRequestValids[virtexConfigWriteRequestIndex]) begin
    //         //Add to EEPROM Memory Write Queue
    //         newConfigFIFOIn <= virtexConfigWriteRequests[virtexConfigWriteRequestIndex];
    //         newConfigFIFOWrite <= 1;

    //         //TODO fault @ newConfigFIFOFull ?
    //     end
    //     else newConfigFIFOWrite <= 0;

    //     lastVirtexConfigWriteRequestValids[virtexConfigWriteRequestIndex] <= virtexConfigWriteRequests[virtexConfigWriteRequestIndex].valid;
    //     virtexConfigWriteRequestIndex <= ~virtexConfigWriteRequestIndex;
    // end
endmodule