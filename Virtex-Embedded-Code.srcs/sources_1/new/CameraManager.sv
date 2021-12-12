`timescale 1ns / 1ps

/* CameraManager - Manages the Python 300 Image Sensor
    Python 300 Docs: https://www.onsemi.com/pdf/datasheet/noip1sn1300a-d.pdf
    Python 300 Notes: https://docs.google.com/document/d/1I_gz72WDF619c93o520tFeQNC_jHlEsQBOqtdv9CuxE/edit?usp=sharing

    Summary:
    Data is read out in an 8 pixel kernel, where PIX_[0-3] read out 2 pixels each with pixel 0 MSB First and pixel 1 LSB First
    */
module CameraManager(
    input wire CLK,
    input wire LVDS_CLK_P,
    input wire LVDS_CLK_N,
    input wire LVDS_SYNC_P,
    input wire LVDS_SYNC_N,
    input wire [3:0] LVDS_DOUT_P,
    input wire [3:0] LVDS_DOUT_N,
    output wire SPI_CS,
    output wire SPI_MOSI,
    input wire SPI_MISO,
    output wire SPI_CLK,
    output wire TRIGGER,
    input wire MONITOR,
    output wire RESET
    );

    //LVDS Input Buffers
    wire LVDS_CLK;
    wire LVDS_SYNC;
    wire [3:0] LVDS_DOUT;
    IBUFGDS #(.DIFF_TERM("TRUE"),.IBUF_LOW_PWR("FALSE"),.IOSTANDARD("LVDS_25"))
    LVDS_CLK_IBUF   (.O(LVDS_CLK    ),.I(LVDS_CLK_P    ),.IB(LVDS_CLK_N     ));
    IBUFDS  #(.DIFF_TERM("TRUE"),.IBUF_LOW_PWR("FALSE"),.IOSTANDARD("LVDS_25"))
    LVDS_SYNC_IBUF  (.O(LVDS_SYNC   ),.I(LVDS_SYNC_P   ),.IB(LVDS_SYNC_N    ));
    IBUFDS  #(.DIFF_TERM("TRUE"),.IBUF_LOW_PWR("FALSE"),.IOSTANDARD("LVDS_25"))
    LVDS_DOUT0_IBUF (.O(LVDS_DOUT[0]),.I(LVDS_DOUT_P[0]),.IB(LVDS_DOUT_N[0]));
    IBUFDS  #(.DIFF_TERM("TRUE"),.IBUF_LOW_PWR("FALSE"),.IOSTANDARD("LVDS_25"))
    LVDS_DOUT1_IBUF (.O(LVDS_DOUT[1]),.I(LVDS_DOUT_P[1]),.IB(LVDS_DOUT_N[1]));
    IBUFDS  #(.DIFF_TERM("TRUE"),.IBUF_LOW_PWR("FALSE"),.IOSTANDARD("LVDS_25"))
    LVDS_DOUT2_IBUF (.O(LVDS_DOUT[2]),.I(LVDS_DOUT_P[2]),.IB(LVDS_DOUT_N[2]));
    IBUFDS  #(.DIFF_TERM("TRUE"),.IBUF_LOW_PWR("FALSE"),.IOSTANDARD("LVDS_25"))
    LVDS_DOUT3_IBUF (.O(LVDS_DOUT[3]),.I(LVDS_DOUT_P[3]),.IB(LVDS_DOUT_N[3]));

    //36MHz Parallel Clock (360MHz / 10)
    wire parallel_clk;
    clk_wiz_2 clk_wiz_2(
        .clk_in1(CLK),
        .clk_out1(parallel_clk)
    );

    //ISERDES
    wire [9:0] SYNC;
    wire [9:0] DOUT [3:0];
    ISERDES SYNC_ISERDES(
        .SERIAL_CLK(LVDS_CLK),
        .SERIAL_DATA(LVDS_SYNC),
        .PARALLEL_RESET(1'b1),
        .PARALLEL_CLK(parallel_clk),
        .PARALLEL_DATA(SYNC)
    );
    ISERDES DOUT_0_ISERDES(
        .SERIAL_CLK(LVDS_CLK),
        .SERIAL_DATA(LVDS_SYNC),
        .PARALLEL_RESET(1'b1),
        .PARALLEL_CLK(parallel_clk),
        .PARALLEL_DATA(DOUT[0])
    );
    ISERDES DOUT_1_ISERDES(
        .SERIAL_CLK(LVDS_CLK),
        .SERIAL_DATA(LVDS_SYNC),
        .PARALLEL_RESET(1'b1),
        .PARALLEL_CLK(parallel_clk),
        .PARALLEL_DATA(DOUT[1])
    );
    ISERDES DOUT_2_ISERDES(
        .SERIAL_CLK(LVDS_CLK),
        .SERIAL_DATA(LVDS_SYNC),
        .PARALLEL_RESET(1'b1),
        .PARALLEL_CLK(parallel_clk),
        .PARALLEL_DATA(DOUT[2])
    );
    ISERDES DOUT_3_ISERDES(
        .SERIAL_CLK(LVDS_CLK),
        .SERIAL_DATA(LVDS_SYNC),
        .PARALLEL_RESET(1'b1),
        .PARALLEL_CLK(parallel_clk),
        .PARALLEL_DATA(DOUT[3])
    );

    //Blob Processor
    BlobProcessor BlobProcessor();

    //Camera Config Manager
    CameraConfigManager CameraConfigManager(
        .CLK(CLK),
        .SPI_CS(SPI_CS),
        .SPI_MOSI(SPI_MOSI),
        .SPI_MISO(SPI_MISO),
        .SPI_CLK(SPI_CLK),
        .TRIGGER(TRIGGER),
        .MONITOR(MONITOR),
        .RESET(RESET)
    );

    //Init
    initial begin
        // CameraConfigManager.write(...)
    end

    //Loop
    always @(posedge parallel_clk) begin
        
    end
endmodule