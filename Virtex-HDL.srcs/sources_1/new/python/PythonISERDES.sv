`timescale 1ns / 1ps
`include "PythonUtil.sv"

/* PythonISERDES- 1:8 DDR SerDes implementation for the Python 300 Sync + Data channels
    Docs
     - https://www.xilinx.com/support/documentation/ip_documentation/selectio_wiz/v5_1/pg070-selectio-wiz.pdf
     - https://www.xilinx.com/support/documentation/user_guides/ug471_7Series_SelectIO.pdf
     - https://www.xilinx.com/support/documentation/application_notes/xapp524-serial-lvds-adc-interface.pdf
     - https://www.xilinx.com/support/documentation/sw_manuals/xilinx2012_2/ug953-vivado-7series-libraries.pdf

    TL;DR
    Takes in a single line serial stream and converts it to 8 parallel lines
    
    Initially we don't know where the start of one serial word starts and where they end.
    So the Python will output "training data" on its line when its idle (just a repeating pattern).
    We can "bitslip" the SERDES until parallel data lines up with the training data.

    */
module PythonISERDES (
    input wire SERIAL_CLK, SERIAL_DATA,
    input wire PARALLEL_CLK,
    output wire [7:0] PARALLEL_DATA,
    input wire RESET, //active high
    output reg trainingDone //active high
    );

    wire SERIAL_CLK_INV = ~SERIAL_CLK;

    // wire SERIAL_DATA_DLY;
    // IDELAYE2 #(
    //     .CINVCTRL_SEL(),
    //     .DELAY_SRC(),
    //     .HIGH_PERFORMANCE_MODE("TRUE"),
    //     .IDELAY_TYPE(),
    //     .IDELAY_VALUE(),
    //     .PIPE_SEL(),
    //     .REFCLK_FREQUENCY(),
    //     .SIGNAL_PATTERN()
    // ) IDELAYE2_Inst (
    //     // .DATAIN(),
    //     .IDATAIN(SERIAL_DATA),
    //     .CNTVALUEIN(),
    //     .CE(),
    //     .INC(),
    //     .LD(),
    //     .LDPIPEEN(),
    //     .REGRS(),
    //     .C(SERIAL_CLK),
    //     .CINVCTRL(),
    //     .DATAOUT(SERIAL_DATA_DLY),
    //     .CNTVALUEOUT()
    // );

    //Bitslip (see below)
    reg bitslip = 1;
    initial trainingDone <= 0;

    //ISERDESE2 Primitive (see docs)
    ISERDESE2 #(
        .INTERFACE_TYPE("NETWORKING"),
        .SERDES_MODE("MASTER"),
        .DATA_WIDTH(8),
        .DATA_RATE("DDR"),
        .OFB_USED("FALSE"),
        .NUM_CE(2),
        .DYN_CLKDIV_INV_EN("FALSE"), 
        .DYN_CLK_INV_EN("FALSE"),
        .IOBDELAY("NONE") //NONE only uses D and not DDLY (because we aren't using an IDELAYE2)
    )
    ISERDESE2_Inst (
        .SHIFTIN1(1'b0),
        .SHIFTIN2(1'b0),
        .SHIFTOUT1(),
        .SHIFTOUT2(),
        .OFB(1'b0),
        .D(SERIAL_DATA),
        .DDLY(1'b0),
        .CE1(1'b1),
        .CE2(1'b1),
        .RST(RESET),
        .BITSLIP(bitslip),
        .CLK(SERIAL_CLK),
        .CLKB(SERIAL_CLK_INV),
        .CLKDIV(PARALLEL_CLK),
        .CLKDIVP(1'b0),
        .DYNCLKDIVSEL(1'b0),
        .DYNCLKSEL(1'b0),
        .OCLK(1'b0),
        .OCLKB(1'b0),
        .O(),
        .Q1(PARALLEL_DATA[0]),
        .Q2(PARALLEL_DATA[1]),
        .Q3(PARALLEL_DATA[2]),
        .Q4(PARALLEL_DATA[3]),
        .Q5(PARALLEL_DATA[4]),
        .Q6(PARALLEL_DATA[5]),
        .Q7(PARALLEL_DATA[6]),
        .Q8(PARALLEL_DATA[7])
    );

    /*Bitslip Operation (DDR):
     - every CLKDIV cycle bitslip is high data with either be shifted right 1 or left 3 (alternating)
     - bitslip cannot be asserted for multiple consecutive CLKDIV cycles
     - read delay of 3 clock cycles between bitslip operation and output on Q1-8 */
    reg [1:0] waitCounter = 0; //waits for the 3 clock cycles when the bitslip operation succeeded
    always_ff @(negedge PARALLEL_CLK) begin
        if (~trainingDone) begin
            //PARALLEL_DATA bad => bitslip again
            bitslip <= !waitCounter & PARALLEL_DATA != PYTHON_TRAINING_PATTERN;

            //PARALLEL_DATA good => we are done here
            trainingDone <= !waitCounter & PARALLEL_DATA == PYTHON_TRAINING_PATTERN;

            //increment wait counter
            waitCounter <= waitCounter + 1;
        end
    end
endmodule