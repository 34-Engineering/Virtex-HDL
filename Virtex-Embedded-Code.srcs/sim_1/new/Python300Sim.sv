`timescale 1ns / 1ps
`include "../../sources_1/new/Util.sv"

/* Python300Sim - Simulates the Python 300 Image Sensor
    Python 300 Docs: https://www.onsemi.com/pdf/datasheet/noip1sn1300a-d.pdf

    See CameraManager.sv for more

    Flow:
     - Parallel Data (SYNC & DOUT[3:0]) -> OSERDES -> OBUFDS -> LVDS Lines

    */
module Python300Sim(
    output wire LVDS_CLK_P,
    output wire LVDS_CLK_N,
    output wire LVDS_SYNC_P,
    output wire LVDS_SYNC_N,
    output wire [3:0] LVDS_DOUT_P,
    output wire [3:0] LVDS_DOUT_N,
    input wire SPI_CS,
    input wire SPI_MOSI,
    output reg SPI_MISO,
    input wire SPI_CLK,
    output wire [2:0] TRIGGER,
    output wire [1:0] MONITOR,
    input wire SENSOR_RESET
    //TODO
    );

    reg CLK72 = 0, CLK288 = 0;
    always #(500/72) CLK72 <= !CLK72;
    always #(500/288) CLK288 <= !CLK288;

    //SPI Sim
    wire sequencerEnabled;
    Python300SPISim(
        .CLK(CLK),
        .SPI_CS(SPI_CS),
        .SPI_MOSI(SPI_MOSI),
        .SPI_MISO(SPI_MISO),
        .SPI_CLK(SPI_CLK),
        .TRIGGER(TRIGGER),
        .MONITOR(MONITOR),
        .sequencerEnabled(sequencerEnabled),
        .SENSOR_RESET(SENSOR_RESET)
    );

    //LVDS Output Buffers
    wire LVDS_SYNC;
    wire [3:0] LVDS_DOUT;
    OBUFDS #(.DIFF_TERM("TRUE"),.IBUF_LOW_PWR("FALSE"),.IOSTANDARD("LVDS_25"))
    LVDS_CLK_OBUF   (.I(LVDS_CLK    ),.O(LVDS_CLK_P    ),.OB(LVDS_CLK_N     ));
    OBUFDS  #(.DIFF_TERM("TRUE"),.IBUF_LOW_PWR("FALSE"),.IOSTANDARD("LVDS_25"))
    LVDS_SYNC_OBUF  (.I(LVDS_SYNC   ),.O(LVDS_SYNC_P   ),.OB(LVDS_SYNC_N    ));
    OBUFDS  #(.DIFF_TERM("TRUE"),.IBUF_LOW_PWR("FALSE"),.IOSTANDARD("LVDS_25"))
    LVDS_DOUT0_OBUF (.I(LVDS_DOUT[0]),.O(LVDS_DOUT_P[0]),.OB(LVDS_DOUT_N[0]));
    OBUFDS  #(.DIFF_TERM("TRUE"),.IBUF_LOW_PWR("FALSE"),.IOSTANDARD("LVDS_25"))
    LVDS_DOUT1_OBUF (.I(LVDS_DOUT[1]),.O(LVDS_DOUT_P[1]),.OB(LVDS_DOUT_N[1]));
    OBUFDS  #(.DIFF_TERM("TRUE"),.IBUF_LOW_PWR("FALSE"),.IOSTANDARD("LVDS_25"))
    LVDS_DOUT2_OBUF (.I(LVDS_DOUT[2]),.O(LVDS_DOUT_P[2]),.OB(LVDS_DOUT_N[2]));
    OBUFDS  #(.DIFF_TERM("TRUE"),.IBUF_LOW_PWR("FALSE"),.IOSTANDARD("LVDS_25"))
    LVDS_DOUT3_OBUF (.I(LVDS_DOUT[3]),.O(LVDS_DOUT_P[3]),.OB(LVDS_DOUT_N[3]));

    //OSERDES Sim
    wire [7:0] SYNC;
    wire [7:0] DOUT [3:0];
    CameraOSERDESSim SYNC_OSERDES(
        .SERIAL_CLK(CLK288),
        .SERIAL_DATA(LVDS_SYNC),
        .parallelClk(CLK72),
        .parallelData(SYNC),
        .reset(SENSOR_RESET)
    );
    CameraOSERDESSim DOUT_0_OSERDES(
        .SERIAL_CLK(CLK288),
        .SERIAL_DATA(LVDS_DOUT[0]),
        .parallelClk(CLK72),
        .parallelData(DOUT[0]),
        .reset(SENSOR_RESET)
    );
    CameraOSERDESSim DOUT_1_OSERDES(
        .SERIAL_CLK(CLK288),
        .SERIAL_DATA(LVDS_DOUT[1]),
        .parallelClk(CLK72),
        .parallelData(DOUT[1]),
        .reset(SENSOR_RESET)
    );
    CameraOSERDESSim DOUT_2_OSERDES(
        .SERIAL_CLK(CLK288),
        .SERIAL_DATA(LVDS_DOUT[2]),
        .parallelClk(CLK72),
        .parallelData(DOUT[2]),
        .reset(SENSOR_RESET)
    );
    CameraOSERDESSim DOUT_3_OSERDES(
        .SERIAL_CLK(CLK288),
        .SERIAL_DATA(LVDS_DOUT[3]),
        .parallelClk(CLK72),
        .parallelData(DOUT[3]),
        .reset(SENSOR_RESET)
    );

    //Loop
    reg kernelOdd;
    reg kernelPartion; //whether we are the start or end of kernel
    Vector kernelPos; //(0, 0) to (79, 479)
    reg [7:0] kernel;
    reg isInFrame;

    //TODO return test image
    

endmodule