`timescale 1ns / 1ps

/* ISERDES- 1:10 DDR SerDes implementation for the Python 300 Sync + Data channels
    Docs1: https://www.xilinx.com/support/documentation/ip_documentation/selectio_wiz/v5_1/pg070-selectio-wiz.pdf
    Docs2: https://www.xilinx.com/support/documentation/user_guides/ug471_7Series_SelectIO.pdf
    Example: https://www.xilinx.com/support/documentation/application_notes/xapp524-serial-lvds-adc-interface.pdf
    */
module ISERDES (
    input SERIAL_CLK,
    input SERIAL_DATA,
    input PARALLEL_CLK,
    output [9:0] PARALLEL_DATA,
    input RESET //active low
    );

    //IDELAYE2?
    //IDELAYCTRL?

    //Serial Clock Buffer
    wire serial_clk;
    BUFIO SERIAL_CLK_BUFIO (
        .I (SERIAL_CLK),
        .O (serial_clk)
    );

    //Reset Generator
    reg [3:0] reset_sr = 4'hF;
    wire reset = reset_sr[0];
    always @(posedge PARALLEL_CLK) begin
        if (RESET)
            reset_sr <= 4'hF;
        else
            reset_sr <= reset_sr >> 1;
    end
        

    //ISERDES1
    wire ISERDES1_SHIFTOUT1;
    wire ISERDES1_SHIFTOUT2;
    ISERDESE2 #(
        .INTERFACE_TYPE("NETWORKING"),
        .SERDES_MODE("MASTER"),
        .DATA_WIDTH(10),
        .DATA_RATE("DDR"),
        .OFB_USED("FALSE"),
        .NUM_CE(2),
        .DYN_CLKDIV_INV_EN("FALSE"), 
        .DYN_CLK_INV_EN("FALSE"),
        .IOBDELAY("IFD") // NONE, BOTH, IBUF, IFD
    )
    ISERDES1 (
        .SHIFTIN1(1'b0),
        .SHIFTIN2(1'b0),
        .OFB(1'b0),
        .D(SERIAL_DATA),
        .DDLY(1'b0),
        .CE1(1'b1),
        .CE2(1'b1),
        .RST(!reset),
        .BITSLIP(1'b0),
        .CLK(serial_clk),
        .CLKB(!serial_clk),
        .CLKDIV(PARALLEL_CLK),
        .CLKDIVP(1'b0),
        .DYNCLKDIVSEL(1'b0),
        .DYNCLKSEL(1'b0),
        .OCLK(1'b0),
        .OCLKB(1'b0),
        .SHIFTOUT1(ISERDES1_SHIFTOUT1),
        .SHIFTOUT2(ISERDES1_SHIFTOUT2),
        .O(),
        .Q1(PARALLEL_DATA[0]),
        .Q2(PARALLEL_DATA[1]),
        .Q3(PARALLEL_DATA[2]),
        .Q4(PARALLEL_DATA[3]),
        .Q5(PARALLEL_DATA[4])
    );

    //ISERDES2
    ISERDESE2 #(
        .INTERFACE_TYPE("NETWORKING"),
        .SERDES_MODE("MASTER"),
        .DATA_WIDTH(10),
        .DATA_RATE("DDR"),
        .OFB_USED("FALSE"),
        .NUM_CE(2),
        .DYN_CLKDIV_INV_EN("FALSE"), 
        .DYN_CLK_INV_EN("FALSE"),
        .IOBDELAY("NONE") // NONE, BOTH, IBUF, IFD
    )
    ISERDES2 (
        .SHIFTIN1(ISERDES1_SHIFTOUT1),
        .SHIFTIN2(ISERDES1_SHIFTOUT2),
        .OFB(1'b0),
        .D(SERIAL_DATA),
        .DDLY(1'b0),
        .CE1(1'b1),
        .CE2(1'b1),
        .RST(!reset),
        .BITSLIP(1'b0),
        .CLK(serial_clk),
        .CLKB(!serial_clk),
        .CLKDIV(PARALLEL_CLK),
        .CLKDIVP(1'b0),
        .DYNCLKDIVSEL(1'b0),
        .DYNCLKSEL(1'b0),
        .OCLK(1'b0),
        .OCLKB(1'b0),
        .SHIFTOUT1(),
        .SHIFTOUT2(),
        .O(),
        .Q1(PARALLEL_DATA[5]),
        .Q2(PARALLEL_DATA[6]),
        .Q3(PARALLEL_DATA[7]),
        .Q4(PARALLEL_DATA[8]),
        .Q5(PARALLEL_DATA[9])
    );
endmodule