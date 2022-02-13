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

    
     */
module PythonSPIManager(
    input wire CLK,
    output wire SPI_CLK,
    output reg SPI_MOSI, SPI_CS, //active low
    input wire SPI_MISO,
    output wire [2:0] TRIGGER,
    input wire [1:0] MONITOR,
    input wire sequencerEnabled,
    output Fault fault
    );

    typedef enum {ENABLE_CLOCK_MANAGEMENT_1=0, CHECK_PLL_LOCK=1, REGISTER_UPLOAD=2, DONE=3} PowerUpStage;
    PowerUpStage powerUpStage = ENABLE_CLOCK_MANAGEMENT_1;

    //10MHz Clock
    clk_wiz_0 clk_wiz_0(
        .clk_in1(CLK),
        .clk_out1(SPI_CLK)
    );

    //Crude SPI Implemenation
    reg [7:0] commandNumber = 0;
    reg [4:0] commandPointer = 0;
    reg isSequencerEnabled = 0;
    always @(negedge SPI_CLK) begin
        //Check PLL Lock
        if (powerUpStage == CHECK_PLL_LOCK) begin
            if (SPI_CS) begin
                //drop CS and come back next loop
                SPI_CS <= 0;
            end

            else if (commandPointer == 25) begin //addr + rw + word - 1 = 25
                //returns 16-bit word, but we only care about [0]
                if (SPI_MISO == 0) begin //TODO check
                    //not unlocked --> keep retrying
                    commandNumber <= commandNumber + 1;

                    if (commandNumber == 20) begin
                        fault <= PYTHON_300_PLL_FAULT;
                    end
                end
                else begin
                    //move to next stage
                    powerUpStage <= powerUpStage.next;
                    commandNumber <= 0;
                    fault <= NO_FAULT;
                end

                commandPointer <= 0;
                SPI_CS <= 1;
            end
            else if (commandPointer < 11) begin
                //write request for PLL lock status
                SPI_MOSI <= checkPLLLockStatus[commandPointer];
            end
        end

        //Done (enable/disable sequencer)
        else if (powerUpStage == DONE) begin
            
            //writing enable/disable sequencer
            if (commandNumber & SPI_CS) begin
                //drop CS and come back next loop
                SPI_CS <= 0;
            end
            else if (commandNumber) begin
                //write command
                SPI_MOSI <= enableDisableSequencer[isSequencerEnabled][commandPointer];

                if (commandNumber == PythonSPICommandEndIndex) begin
                    //done writing command
                    commandNumber <= 0;
                end
                else begin
                    //increment pointer
                    commandPointer <= commandPointer + 1;
                end
            end

            //wants to enable/disable sequencer
            else if (sequencerEnabled != isSequencerEnabled) begin
                isSequencerEnabled <= sequencerEnabled;
                commandNumber <= 1;
                commandPointer <= 0;
            end
        end

        //Enable Clock Management 1 & Register Upload
        else begin
            if (SPI_CS) begin
                //pull down CS and come back next loop
                SPI_CS <= 0;
            end
            
            else begin
                //write all commands
                if (powerUpStage == REGISTER_UPLOAD)
                    SPI_MOSI <= powerUpSequenceRegisterUpload[commandNumber][commandPointer];
                else SPI_MOSI <= enableClockManagement1[commandNumber][commandPointer];

                //end of command
                if (commandPointer == PythonSPICommandEndIndex) begin
                    if (powerUpStage == REGISTER_UPLOAD ?
                        commandNumber == $size(powerUpSequenceRegisterUpload) - 1 : 
                        commandNumber == $size(enableClockManagement1) - 1) begin
                        //move to next stage
                        powerUpStage <= powerUpStage.next;
                        commandNumber <= 0;
                    end
                    else begin
                        //move to next command
                        commandNumber <= commandNumber + 1;
                    end

                    SPI_CS <= 1;
                    commandPointer <= 0;
                end

                //increment write pointer
                else begin
                    commandPointer <= commandPointer + 1;
                end
            end
        end
    end
endmodule