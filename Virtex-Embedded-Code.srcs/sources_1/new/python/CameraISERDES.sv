`timescale 1ns / 1ps

/* PythonISERDES- 1:8 DDR SerDes implementation for the Python 300 Sync + Data channels
    Docs
     - https://www.xilinx.com/support/documentation/ip_documentation/selectio_wiz/v5_1/pg070-selectio-wiz.pdf
     - https://www.xilinx.com/support/documentation/user_guides/ug471_7Series_SelectIO.pdf
     - https://www.xilinx.com/support/documentation/application_notes/xapp524-serial-lvds-adc-interface.pdf
     - https://www.xilinx.com/support/documentation/sw_manuals/xilinx2012_2/ug953-vivado-7series-libraries.pdf
    */
module PythonISERDES (
    input wire SERIAL_CLK, SERIAL_DATA,
    input wire parallelClk,
    output wire [7:0] parallelData,
    input wire reset, //active low
    input wire [7:0] trainingPattern,
    output wire trainingDone //active low
    );

    //IDELAYE2?
    //IDELAYCTRL?

    //ISERDESE2 Primitive (see docs)
    reg bitslip = 1;
    ISERDESE2 #(
        .INTERFACE_TYPE("NETWORKING"),
        .SERDES_MODE("MASTER"),
        .DATA_WIDTH(8),
        .DATA_RATE("DDR"),
        .OFB_USED("FALSE"),
        .NUM_CE(2),
        .DYN_CLKDIV_INV_EN("FALSE"), 
        .DYN_CLK_INV_EN("FALSE"),
        .IOBDELAY("IFD") // NONE, BOTH, IBUF, IFD
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
        .RST(!reset),
        .BITSLIP(bitslip),
        .CLK(SERIAL_CLK),
        .CLKB(!SERIAL_CLK),
        .CLKDIV(parallelClk),
        .CLKDIVP(1'b0),
        .DYNCLKDIVSEL(1'b0),
        .DYNCLKSEL(1'b0),
        .OCLK(1'b0),
        .OCLKB(1'b0),
        .O(),
        .Q1(parallelData[0]),
        .Q2(parallelData[1]),
        .Q3(parallelData[2]),
        .Q4(parallelData[3]),
        .Q5(parallelData[4]),
        .Q6(parallelData[5]),
        .Q7(parallelData[6]),
        .Q8(parallelData[7])
    );

    //Bitslip w/ Training Pattern (parallelData is shifted right on posedge parallelClk while bitslip is high)
    assign trainingDone = bitslip;
    always_ff @(negedge parallelClk) begin
        //once the parallel data lines up we are done with bitsliping
        if (bitslip & parallelData == trainingPattern) begin
            bitslip <= 0;
        end
    end
endmodule