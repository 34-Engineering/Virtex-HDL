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
    output wire SPI_CLK, SPI_CS, //active low
    output reg SPI_MOSI,
    input wire SPI_MISO,
    output wire [2:0] TRIGGER,
    input wire [1:0] MONITOR,
    output reg RESET_SENSOR,
    input wire sequencerEnabled, //what state they want the python to be in
    output reg isSequencerEnabled, //what state the actual sensor is in
    output wire isBooted,
    output reg PYTHON_300_PLL_FAULT,
    output reg [7:0] debug,
    output reg [7:0] wave
    );

    //10MHz Clock
    wire CLK10;
    clk_wiz_0 clk_wiz_0(
        .clk_in1(CLK),
        .clk_out1(CLK10)
    );

    //SPI Interface
    /* Sequence
        Index | 0  1  2  3  4  5  6  7  8  9  10 11 12  13  14  15  16  17  18 19 20 21 22 23 24 25 26 27 28 29
        Data  | BL A8 A7 A6 A5 A4 A3 A2 A1 A0 RW D15 D14 D13 D12 D11 D10 D9 D8 D7 D6 D5 D4 D3 D2 D1 D0 BL BL BL
        ClkEn | 0  0  1  1  1  1  1  1  1  1  1   1   1   1   1   1   1  1  1  1  1  1  1  1  1  1  1  1  0  0
        CS    | 0  0  0  0  0  0  0  0  0  0  0   0   0   0   0   0   0  0  0  0  0  0  0  0  0  0  0  0  0  1*/
    reg inSequence = 0;
    reg [4:0] sequencePointer = 0;
    localparam SEQUENCE_END_INDEX = 30; //FIXME 29 //FIXME no og blank?
    wire isBlanking = sequencePointer < 1 | sequencePointer > 26;
    assign SPI_CS = ~inSequence | sequencePointer > 28;
    assign SPI_CLK = (inSequence & sequencePointer > 1 & sequencePointer < 28) ? CLK10 : 0;

    //State
    enum logic [1:0] {ENABLE_CLOCK_MANAGEMENT_1=0, CHECK_PLL_LOCK=1, REGISTER_UPLOAD=2, DONE=3} bootState = ENABLE_CLOCK_MANAGEMENT_1;
    assign isBooted = bootState == DONE;
    reg [7:0] commandNumber = 0; //which SPI command we are on in the current stage
    wire [4:0] commandPointer = sequencePointer - 1; //where we are in the PythonSPICommand
    reg [15:0] response = 0; //response data for check PLL lock
    reg currentSequencerEnabled = 0; //what sequencer state we are currently setting to
    wire wantsToSetSequencer = bootState == DONE & sequencerEnabled != isSequencerEnabled; //we need to write enable/disable sequencer
    initial isSequencerEnabled = 0;
    reg reset = 0;
    assign RESET_SENSOR = reset;

    //TODO update virtexConfig live

    //SPI Loop
    reg [7:0] counter = 0;
    reg last = 0;
    always_ff @(negedge CLK10) begin
        //Pull Down Reset
        if (~reset) begin
            reset <= 1;
        end

        //Read/Write Sequence Data (address + read/write + word)
        else if (inSequence) begin
            //Enable Clock Management 1
            if (bootState == ENABLE_CLOCK_MANAGEMENT_1 & ~isBlanking) begin
                //write all commands [0:25]
                SPI_MOSI <= enableClockManagement1[commandNumber][PythonSPICommandEndIndex - commandPointer];

                //finish @ 25
                if (commandPointer == PythonSPICommandEndIndex) begin
                    if (commandNumber == ($size(enableClockManagement1) - 1)) begin
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

            //Check PLL Lock
            else if (bootState == CHECK_PLL_LOCK) begin
                //write request [0:9]
                if (commandPointer < 10) begin
                    SPI_MOSI <= checkPLLLockStatus[PythonSPICommandEndIndex - commandPointer];
                end

                //read response [11:26] (bc MISO is delayed 1 clock cycle relative to us)
                else if (commandPointer > 10 & commandPointer < 27) begin
                    //blocking because we immediately use response below
                    response[commandPointer - 11] = SPI_MISO;
                end

                //finish @ 26
                if (commandPointer == PythonSPICommandEndIndex+1) begin
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

            //Register Upload
            else if (bootState == REGISTER_UPLOAD & ~isBlanking) begin
                //write all commands [0:25]
                SPI_MOSI <= powerUpSequenceRegisterUpload[commandNumber][PythonSPICommandEndIndex - commandPointer];

                //finish @ 25
                if (commandPointer == PythonSPICommandEndIndex) begin
                    if (commandNumber == ($size(powerUpSequenceRegisterUpload) - 1)) begin
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

            //Done (enable/disable sequencer)
            else if (bootState == DONE & ~isBlanking) begin
                //write command [0:25]
                SPI_MOSI <= enableDisableSequencer[currentSequencerEnabled][PythonSPICommandEndIndex - commandPointer];

                //finish @ 25
                if (commandPointer == PythonSPICommandEndIndex) begin
                    //flag what state the sensor is now in
                    isSequencerEnabled <= currentSequencerEnabled;
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

            if (wantsToSetSequencer) begin
                //save what state we are setting to for transaction
                //in case sequencerEnabled changes mid transaction
                currentSequencerEnabled <= sequencerEnabled;
            end
        end
    end
endmodule