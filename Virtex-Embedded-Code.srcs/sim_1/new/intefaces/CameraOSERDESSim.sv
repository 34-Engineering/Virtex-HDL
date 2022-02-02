`timescale 1ns / 1ps

/* CameraOSERDESSim - Simulates the 1:8 DDR SerDes from the Python 300

    See CameraISERDES.sv for more
    
    */
module CameraOSERDESSim(
    input wire SERIAL_CLK,
    output wire SERIAL_DATA,
    input wire parallelClk,
    input wire [7:0] parallelData,
    input wire reset //active low
    );

    //OSERDESE2 Primitive (see docs)
    OSERDESE2 #(
        .DATA_RATE_OQ("DDR"), //TODO check
        .DATA_RATE_TQ("SDR"), //TODO check
        .DATA_WIDTH(8),
        .SERDES_MODE("MASTER"),
        .TRISTATE_WIDTH(1),
        .TBYTE_CTL("FALSE"),
        .TBYTE_SRC("FALSE")
    )
    OSERDESE2_Inst (
        .SHIFTIN1(1'b0),
        .SHIFTIN2(1'b0),
        .SHIFTOUT1(),
        .SHIFTOUT2(),
        .OQ(SERIAL_DATA),
        .OFB(),
        .TQ(),
        .TFB(),
        .CLK(SERIAL_CLK),
        .CLKDIV(parallelClk),
        .D1(parallelData[0]),
        .D2(parallelData[1]),
        .D3(parallelData[2]),
        .D4(parallelData[3]),
        .D5(parallelData[4]),
        .D6(parallelData[5]),
        .D7(parallelData[6]),
        .D8(parallelData[7]),
        .TCE(1'b1),
        .OCE(1'b1),
        .TBYTEIN(1'b0),
        .TBYTEOUT(),
        .RST(!reset),
        .T1(1'b0),
        .T2(1'b0),
        .T3(1'b0), 
        .T4(1'b0)
    );
endmodule