`timescale 1ns / 1ps
`include "Util.sv"
`include "CameraManagerParams.sv"

/* CameraSPIManager - manages register upload & enabling/disabling the sequencer over SPI to the Python 300
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
module CameraSPIManager(
    input wire CLK,
    output wire SPI_CLK, SPI_CS, //active low
    output reg SPI_MOSI,
    input wire SPI_MISO,
    output wire [2:0] TRIGGER,
    input wire [1:0] MONITOR,
    output wire reset, //active low
    input wire sequencerEnabled
    );

    typedef enum {ENABLE_CLOCK_MANAGEMENT_1=0, CHECK_PLL_LOCK=1, REGISTER_UPLOAD=2, DONE=3} PowerUpStage;
    PowerUpStage powerUpStage = ENABLE_CLOCK_MANAGEMENT_1;

    //10MHz Clock
    clk_wiz_0 clk_wiz_0(
        .clk_in1(CLK),
        .clk_out1(SPI_CLK)
    );

    //Crude SPI Implemenation
    reg [7:0] writeCommandNumber = 0;
    reg [4:0] writeCommandPointer = 0;
    reg isSequencerEnabled = 0;
    always @(negedge SPI_CLK) begin
        //Reset
        if (~reset) begin
            writeCommandNumber <= 0;
            writeCommandPointer <= 0;
            powerUpStage <= ENABLE_CLOCK_MANAGEMENT_1;
        end

        //Check PLL Lock
        else if (powerUpStage == CHECK_PLL_LOCK) begin
            if (writeCommandPointer == 25) begin
                //TODO does it really just return a single bit??
                if (SPI_MISO == 0) begin
                    //not unlocked --> keep retrying
                    writeCommandPointer <= 0;
                    writeCommandNumber <= writeCommandNumber + 1;

                    if (writeCommandNumber == 20) begin
                        //TODO error
                    end
                end
                else begin
                    //move to next stage
                    powerUpStage <= powerUpStage.next;
                    writeCommandPointer <= 0;
                    writeCommandNumber <= 0;
                end
            end
            else begin
                //write request for PLL lock status
                SPI_MOSI <= checkPLLLockStatus[writeCommandPointer];
            end
        end

        //Done (enable/disable sequencer)
        else if (powerUpStage == DONE) begin
            //writing enable/disable sequencer
            if (writeCommandNumber) begin
                //write command
                SPI_MOSI <= enableDisableSequencer[isSequencerEnabled][writeCommandPointer];

                if (writeCommandNumber == SPIWriteCommandEndIndex) begin
                    //done writing command
                    writeCommandNumber <= 0;
                end
                else begin
                    //increment pointer
                    writeCommandPointer <= writeCommandPointer + 1;
                end
            end

            //wants to enable/disable sequencer
            else if (sequencerEnabled != isSequencerEnabled) begin
                isSequencerEnabled <= sequencerEnabled;
                writeCommandNumber <= 1;
                writeCommandPointer <= 0;
            end
        end

        //Enable Clock Management 1 & Register Upload
        else begin
            //write all commands
            if (powerUpStage == REGISTER_UPLOAD)
                SPI_MOSI <= powerUpSequenceRegisterUpload[writeCommandNumber][writeCommandPointer];
            else SPI_MOSI <= enableClockManagement1[writeCommandNumber][writeCommandPointer];

            if (writeCommandPointer == SPIWriteCommandEndIndex) begin
                if (powerUpStage == REGISTER_UPLOAD ?
                    writeCommandNumber == $size(powerUpSequenceRegisterUpload) - 1 : 
                    writeCommandNumber == $size(enableClockManagement1) - 1) begin
                    //move to next stage
                    powerUpStage <= powerUpStage.next;
                    writeCommandNumber <= 0;
                end
                else begin
                    //move to next command
                    writeCommandNumber <= writeCommandNumber + 1;
                end

                writeCommandPointer <= 0;
            end
            else begin
                //increment write pointer
                writeCommandPointer <= writeCommandPointer + 1;
            end
        end
    end
endmodule