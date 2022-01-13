`timescale 1ns / 1ps
import Util::*;

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
    output wire RESET,
    input VirtexConfig virtexConfig,
    output OutputFrame outputFrame
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
    wire CLK36;
    clk_wiz_2 clk_wiz_2(
        .clk_in1(CLK),
        .clk_out1(CLK36)
    );

    //ISERDES
    wire [9:0] SYNC;
    wire [9:0] DOUT [3:0];
    ISERDES SYNC_ISERDES(
        .SERIAL_CLK(LVDS_CLK),
        .SERIAL_DATA(LVDS_SYNC),
        .CLK36(CLK36),
        .PARALLEL_DATA(SYNC),
        .RESET(1'b1)
    );
    ISERDES DOUT_0_ISERDES(
        .SERIAL_CLK(LVDS_CLK),
        .SERIAL_DATA(LVDS_SYNC),
        .CLK36(CLK36),
        .PARALLEL_DATA(DOUT[0]),
        .RESET(1'b1)
    );
    ISERDES DOUT_1_ISERDES(
        .SERIAL_CLK(LVDS_CLK),
        .SERIAL_DATA(LVDS_SYNC),
        .CLK36(CLK36),
        .PARALLEL_DATA(DOUT[1]),
        .RESET(1'b1)
    );
    ISERDES DOUT_2_ISERDES(
        .SERIAL_CLK(LVDS_CLK),
        .SERIAL_DATA(LVDS_SYNC),
        .CLK36(CLK36),
        .PARALLEL_DATA(DOUT[2]),
        .RESET(1'b1)
    );
    ISERDES DOUT_3_ISERDES(
        .SERIAL_CLK(LVDS_CLK),
        .SERIAL_DATA(LVDS_SYNC),
        .CLK36(CLK36),
        .PARALLEL_DATA(DOUT[3]),
        .RESET(1'b1)
    );

    //Blob Processor
    bit kernelValid;
    Vector kernelPos;
    bit [3:0] kernel;
    bit endFrame;
    Blob outputBlob;
    BlobProcessor blobProcessor(
        .CLK36(CLK36),
        .kernelValid(kernelValid),
        .kernelPos(kernelPos),
        .kernel(kernel),
        .endFrame(endFrame),
        .outputBlob(outputBlob)
    );

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

    //Loop
    bit [9:0] x = 0;
    bit [9:0] y = 0;
    always @(posedge CLK36) begin
        foreach (DOUT[i]) begin
            kernel[i] = DOUT[i] > 500;
        end

        if (x + 4 > 640) begin
            if (y > 479) begin
                //end frame
                y = 0;
                x = 0;
                endFrame = 0;
            end
            else begin
                //end line
                y = y + 1;
                x = 0;
            end
        end
        else begin
            //next kernel
            x = x + 4;
        end
    end
endmodule