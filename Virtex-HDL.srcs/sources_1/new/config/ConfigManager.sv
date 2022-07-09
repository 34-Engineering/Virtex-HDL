`timescale 1ns / 1ps
`include "VirtexConfig.sv"

/* ConfigManager

    FIXME FIXME TODO TODO update to new EEPROM CAT93C46BHU4I-GT3

    Transfers config from EEPROM to FPGA fabric at boot
    Saves config to FPGA fabric & EEPROM on each external write request
    
    VirtexConfig: 64 x 16-bit (see VirtexConfig.sv for individual configurations & defaults)
    
    ----------------------------
    EEPROM: CAT93C46BHU4I-GT3 (64 x 16-bit); Docs: https://www.onsemi.com/pdf/datasheet/cat93c46b-d.pdf

    ----------------------------

    ConfigManager summary:
     - check if EEPROM memory is valid
        -> valid: read all 63 other registers from EEPROM, load into Vconfig
        -> invalid: write all 64 registers from DefVConfig to EEPROM
     - @ write request -> write to Vconfig & EEPROM

//TODO is CS active high??

    */
module ConfigManager(
    input wire CLK100, CLK2,
    output reg SPI_CS, //active low
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
    localparam logic [1:0] READ_CMD  = 8'b10; //+6-bit addr, +16-bit data
    localparam logic [1:0] WRITE_CMD = 8'b01; //+6-bit addr, +16-bit data
    localparam logic [7:0] WRITE_EN_CMD  = 8'b00110000; //write enable
    localparam logic [7:0] WRITE_DIS_CMD = 8'b00001111; //write disable
    localparam logic [7:0] WRITE_ALL_CMD = 8'b00010000; //write to all addr, +16-bitx64 data
    localparam logic [5:0] MEM_VALID_ADDR = 63;
    localparam logic [15:0] MEM_VALID_CODE = DefaultVirtexConfig.memValid[15:0];

    // //New Config Write FIFO
    // VirtexConfigWriteRequest newConfigFIFOOut;
    // VirtexConfigWriteRequest newConfigFIFOIn = 0;
    // wire newConfigFIFOEmpty, newConfigFIFOFull;
    // reg newConfigFIFORead = 0, newConfigFIFOWrite = 0;

    //State
    typedef enum logic [2:0] {
        WRITE_EN=0,
        CHECK_VAL=1,
        LOAD_MEM=2,
        WRITE_DEF=3,
        WRITE_NEW=4,
        IDLE=5
    } ConfigManagerState;
    ConfigManagerState state = WRITE_ENABLE;
    ConfigManagerState nextState;
    always_comb begin
        case (state)
            WRITE_EN: nextState = CHECK_VAL,
            CHECK_VAL: begin
                nextState = ??
            end,
            default: nextState = IDLE,
        endcase
    end
    localparam [7:0] STATE_LENGTHS [6] = '{1, 1+2, 1+126, 1+128, 1+2, 0};

    //Sequence:
    // - DROP CS, START BIT (1), CMD (1-byte), WAIT?, DATA (2-byte), PULLUP CS

    reg [7:0] byteNumber = 0;
    reg [7:0] bytePointer = 0;
    wire isAtStateEnd = byteNumber >= STATE_LENGTHS[state];
    wire [7:0] nextByteNumber = (isAtStateEnd) ? 0 : (byteNumber + 1);
    wire [7:0] nextBytePointer = bytePointer + 1;

    always_ff @(negedge CLK2) begin
        WRITE_EN=0,
        CHECK_VAL=1,
        LOAD_MEM=2,
        WRITE_DEF=3,
        WRITE_NEW=4,
        IDLE=5 //cs high

        if (state = )

        if (bytePointer == 7) begin
            if (isAtStateEnd) state <= nextState;
            byteNumber <= nextByteNumber;
        end
        bytePointer <= nextBytePointer;
    end

    // //New Config Data FIFO
    // fifo_virtex_config fifo_virtex_config(
    //     .empty(newConfigFIFOEmpty),
    //     .dout(newConfigFIFOOut),
    //     .rd_en(newConfigFIFORead),
    //     .rd_clk(CLK2),
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