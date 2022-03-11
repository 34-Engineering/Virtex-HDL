`timescale 1ns / 1ps
`include "../util/Fault.sv"
`include "PythonUtil.sv"

/* PythonSPIManager - manages register upload & enabling/disabling the sequencer over SPI to the Python 300
    Python 300 Docs: https://www.onsemi.com/pdf/datasheet/noip1sn1300a-d.pdf
    
    Power Up Sequence
     - Enable Clock Management 1 & 2 (initialized the sensor for operation)
        - to transition from 1 to 2 you loop until DevRead16(0, 24) != 0 // check PLL lock status
     - Required Register Upload (sets values of registers for power control and misc. functions)
     - Soft Power Up (turns on biases etc; internal power control)

    Power Down Sequence TODO How can we do this/should we do this?
     - Disable Sequencer
     - Soft Power Down
     - Disable Clock Management

    10MHz
    9-bit address, 16-bit words
    10th bit = r/w
    MSB first
    Some registers can only be changed while the sequencer is disabled

    //TODO update based on changed to virtexConfig
     */
module PythonSPIManager(
    input wire CLK,
    output wire SPI_CLK,
    output reg SPI_MOSI, SPI_CS, //active low
    input wire SPI_MISO,
    output wire [2:0] TRIGGER,
    input wire [1:0] MONITOR,
    input wire sequencerEnabled,
    output reg PYTHON_300_PLL_FAULT,
    output reg [7:0] debug
    );

    //10MHz Clock
    wire CLK10;
    clk_wiz_0 clk_wiz_0(
        .clk_in1(CLK),
        .clk_out1(CLK10)
    );

    //SPI Interface
    reg inSequence = 0;
    reg [4:0] sequencePointer = 0;
    localparam SEQUENCE_END_INDEX = 30;
    wire isBlanking = sequencePointer < 2 | sequencePointer > 27;
    assign SPI_CS = ~(inSequence & sequencePointer < 29);
    assign SPI_CLK = (inSequence & sequencePointer > 0 & sequencePointer < 28) ? CLK10 : 0;

    //State
    enum {ENABLE_CLOCK_MANAGEMENT_1=0, CHECK_PLL_LOCK=1, REGISTER_UPLOAD=2, DONE=3} bootState = ENABLE_CLOCK_MANAGEMENT_1;
    reg [7:0] commandNumber = 0; //which SPI command we are on in the current stage
    wire commandPointer = sequencePointer - 2; //where we are in the PythonSPICommand
    reg [15:0] response = 0; //response data for check PLL lock
    reg isSequencerEnabled = 0; //the actual sequencer state of the python
    wire wantsToSetSequencer = bootState == DONE & sequencerEnabled != isSequencerEnabled; //we need to write enable/disable sequencer

    //SPI Loop
    always_ff @(negedge CLK10) begin
        /* Sequence
        Index | 0  1  2  3  4  5  6  7  8  9  10 11 12  13  14  15  16  17  18 19 20 21 22 23 24 25 26 27 28 29 30
        Data  | BL BL A8 A7 A6 A5 A4 A3 A2 A1 A0 RW D15 D14 D13 D12 D11 D10 D9 D8 D7 D6 D5 D4 D3 D2 D1 D0 BL BL BL
        ClkEn | 0  1  1  1  1  1  1  1  1  1  1  1   1   1   1   1   1   1  1  1  1  1  1  1  1  1  1  1  0  0  0
        CS    | 0  0  0  0  0  0  0  0  0  0  0  0   0   0   0   0   0   0  0  0  0  0  0  0  0  0  0  0  0  1  1*/
        //Read/Write Sequence Data (address + read/write + word)
        if (inSequence) begin
            //Check PLL Lock
            if (bootState == CHECK_PLL_LOCK & ~isBlanking) begin
                //write address [0:8] + read/write [9:9]
                if (commandPointer < 10) begin
                    SPI_MOSI <= checkPLLLockStatus[commandPointer];
                end

                //read response [10:25]
                else begin
                    response[commandPointer - 10] = SPI_MISO;
                end

                //finish @ 25
                if (commandPointer == PythonSPICommandEndIndex) begin
                    //PLL not unlocked
                    if (response == 0) begin
                        //do command again
                        commandNumber <= commandNumber + 1;

                        //throw fault @ 20 times
                        if (commandNumber == 20) begin
                            PYTHON_300_PLL_FAULT <= 1;
                        end
                    end

                    //PLL unlocked
                    else begin
                        //go to next stage
                        bootState <= bootState.next;
                        commandNumber <= 0;
                        PYTHON_300_PLL_FAULT <= 0;
                    end
                end
            end

            //Done (enable/disable sequencer)
            else if (bootState == DONE & ~isBlanking) begin
                //write command [0:25]
                SPI_MOSI <= enableDisableSequencer[isSequencerEnabled][commandPointer];

                //finish @ 25
                if (commandPointer == PythonSPICommandEndIndex) begin
                    isSequencerEnabled <= sequencerEnabled;
                end
            end

            //Enable Clock Management 1 & Register Upload
            else if (~isBlanking) begin
                //write all commands [0:25]
                if (bootState == REGISTER_UPLOAD)
                    SPI_MOSI <= powerUpSequenceRegisterUpload[commandNumber][commandPointer];
                else SPI_MOSI <= enableClockManagement1[commandNumber][commandPointer];

                //finish @ 25
                if (commandPointer == PythonSPICommandEndIndex) begin
                    if (bootState == REGISTER_UPLOAD ?
                        commandNumber == $size(powerUpSequenceRegisterUpload) - 1 : 
                        commandNumber == $size(enableClockManagement1) - 1) begin
                        //go to next stage
                        bootState <= bootState.next;
                        commandNumber <= 0;
                    end
                    else begin
                        //go to next command
                        commandNumber <= commandNumber + 1;
                    end
                end
            end

            //Finish or Increment
            if (sequencePointer == SEQUENCE_END_INDEX) begin
                inSequence <= 0;
            end
            else sequencePointer <= sequencePointer + 1;
        end

        //Wants to Start Another Sequence
        else if (bootState != DONE | wantsToSetSequencer) begin
            inSequence <= 1;
            sequencePointer <= 0;
        end
    end
endmodule