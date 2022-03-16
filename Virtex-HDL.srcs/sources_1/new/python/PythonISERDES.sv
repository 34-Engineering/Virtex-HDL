`timescale 1ns / 1ps
`include "PythonUtil.sv"

/* PythonISERDES- 1:8 DDR SerDes implementation for the Python 300 Sync + Data channels
    Docs
     - https://www.xilinx.com/support/documentation/ip_documentation/selectio_wiz/v5_1/pg070-selectio-wiz.pdf
     - https://www.xilinx.com/support/documentation/user_guides/ug471_7Series_SelectIO.pdf
     - https://www.xilinx.com/support/documentation/application_notes/xapp524-serial-lvds-adc-interface.pdf
     - https://www.xilinx.com/support/documentation/sw_manuals/xilinx2012_2/ug953-vivado-7series-libraries.pdf
    */
module PythonISERDES (
    input wire SERIAL_CLK, SERIAL_DATA,
    input wire PARALLEL_CLK,
    output wire [7:0] PARALLEL_DATA,
    input wire RESET, //active high
    output reg trainingDone //active high
    );

    wire SERIAL_CLK_INV = ~SERIAL_CLK;

    //TODO IDELAYE2 to line up all 5 LVDS lines?

    //Bitslip (see below)
    reg bitslip = 1;
    initial trainingDone <= 0;
    reg [1:0] waitCounter = 0;

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
     - read delay of three clock cycles between bitslip operation and output on Q1-8 */
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