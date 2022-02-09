`timescale 1ns / 1ps
`include "../../sources_1/new/Util.sv"
`include "../../sources_1/new/PythonManagerParams.sv"

/* Python300SPISim

    */
module Python300SPISim(
    input wire CLK,
    output wire SPI_CLK, SPI_CS, //active low
    input reg SPI_MOSI,
    output wire SPI_MISO,
    input wire [2:0] TRIGGER,
    output wire [1:0] MONITOR,
    input wire SENSOR_RESET, //active low
    output wire sequencerEnabled
    );

    reg [15:0] registers [499:0] = 0;

    localparam PLLLockDelay = $urandom % 10 + 5;
    reg [5:0] PLLLoopCount = 0;

    assign sequencerEnabled = registers[enableSequencer.address] == enableSequencer.word;

    reg [4:0] commandPointer = 0;
    reg [8:0] address;
    reg readWrite;
    always @(posedge SPI_CLK) begin
        //Reset
        if (~reset) begin
            commandNumber <= 0;
            commandPointer <= 0;
            powerUpStage <= ENABLE_CLOCK_MANAGEMENT_1;
        end

        //Transaction
        else if (~SPI_CS) begin
            //Skip Cycle
            if (commandPointer == 0) begin end

            //Read Address
            else if (commandPointer < 10) begin
                //[9:1] - 1 => [8:0]
                address[commandPointer - 1] <= SPI_MOSI;    
            end

            //Read RW Bit
            else if (commandPointer == 11) begin
                readWrite <= SPI_MOSI;
            end

            //Handle Word
            else if (commandPointer < 28) begin
                //Write to Register
                if (readWrite) begin
                    //[27:12] - 12 => [15:0]
                    registers[address][commandPointer - 12] <= SPI_MOSI;
                end
                
                //Read from Register
                else begin
                    SPI_MISO <= registers[address][commandPointer - 12];     
                end
            end

            commandPointer <= commandPointer + 1;
        end

        //Idle
        else begin
            commandNumber <= 0;
            commandPointer <= 0;
        end

        //PLL Simulation
        if (completedEnableClockManagement1()) begin
            if (PLLLoopCount > PLLLockDelay) begin
                //unlock pll
                registers[checkPLLLockStatus.address] = 16'b0000000000000001;
            end
            PLLLoopCount <= PLLLoopCount + 1;
        end
    end

    function reg completedEnableClockManagement1();
        reg done = 1;

        foreach (enableClockManagement1[i]) begin
            if (registers[enableClockManagement1[i].address] != enableClockManagement1[i].word) begin
                done = 0;
            end
        end

        return done;
    endfunction

endmodule