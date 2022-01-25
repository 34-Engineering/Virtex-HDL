`timescale 1ns / 1ps
import Util::*;
import CameraManagerParams::*;

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
    output wire SPI_CLK,
    output reg SPI_MOSI,
    input wire SPI_MISO,
    output wire SPI_CS, //active low
    output wire TRIGGER,
    input wire MONITOR,
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
    always @(negedge SPI_CLK) begin //FIXME clock edges
        case (powerUpStage)
            ENABLE_CLOCK_MANAGEMENT_1: begin
                //TODO CS
                writeAllCommands(enableClockManagement1);
            end

            CHECK_PLL_LOCK: begin
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

            REGISTER_UPLOAD: begin
                writeAllCommands(powerUpSequenceRegisterUpload);
            end

            DONE: begin
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
        endcase
    end

    task writeAllCommands(SPIWriteCommand commands []);
        //write all commands
        SPI_MOSI <= commands[writeCommandNumber][writeCommandPointer];

        if (writeCommandPointer == SPIWriteCommandEndIndex) begin
            if (writeCommandNumber == $size(commands) - 1) begin
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
    endtask

    //Reset
    always @(negedge reset) begin
        writeCommandNumber <= 0;
        writeCommandPointer <= 0;
        powerUpStage <= ENABLE_CLOCK_MANAGEMENT_1;
    end

endmodule