`timescale 1ns / 1ps
`include "Util.sv"
`include "CameraManagerParams.sv"

/* CameraManager - Manages the Python 300 Image Sensor
    Python 300 Docs: https://www.onsemi.com/pdf/datasheet/noip1sn1300a-d.pdf
    
    CameraSPIManager manages the SPI interface with the image sensor

    Setup:
     - P/N: NOIP1FN0300A−QTI/QDI (monochrome, infrared-optimized)
        - 4 LVDS data lanes (DOUT) + SYNC + CLK
        - 1/4" Optical Format (4.8µm x 4.8µm pixels)
        - Resolution: 640 x 480 (672 x 512 readable pixels, 16 pixels not exposed)
        - ~34% quantum efficiency @ 850nm
        - 815 Frames per Second w/ ZROT
     - Configured in 8-bit mode w/ a 72MHz PLL input (output clock is 288MHz)

    Kernel: 8x1 section of pixels
     - kernels are output on the data channels in which 2 pixels are output on each channel
     - kernel (0, 0) is in the bottom left looking head on at the image sensor
     - in even kernels DOUT[0] sends pixels 0 and 1 (left to right), etc. in odd kernels this is reversed

    Frame Sequence:
     - Training (idle)
     - Black Lines
        - SYNC: "LS", ["BL"] x ?, "LE", "CRC"
        - DOUT: black pixels             CRC value
     - Training (ROT)
     - [Image Data + Training (ROT)] x ?
        - SYNC: "FS", "ID", ["IMG"] x ?, "LE", "ID", "CRC"
        - DOUT: pixels                                CRC value
     - Frame End
        - SYNC: "FE"
        - DATA: ?
     - Training (idle)

    CRC (per channel): x^8 + x^6 + x^3 + x^2 + 1

    Black Lines: default 2

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
    output wire [2:0] TRIGGER,
    input wire [1:0] MONITOR,
    output wire reset, //active low?
    input wire enabled,
    input wire VirtexConfig virtexConfig,
    output FrameBufferWriteRequest frameBufferWriteRequest,
    output wire Blob targetBlob
    );

    //Generate 72MHz (288 * 2 / 8) Parallel Clock from 288MHz Input Clock
    wire LVDS_CLK, CLK72;
    BUFR #(.SIM_DEVICE("7SERIES"), .BUFR_DIVIDE("4")) CLK72_BUFR (
        .O(CLK72),
        .CE(1'b1),
        .CLR(1'b0),
        .I(LVDS_CLK)
    );
    // clk_wiz_2 clk_wiz_2(
    //     .clk_in1(LVDS_CLK),
    //     .clk_out1(CLK72)
    // );

    //Blob Processor
    reg lastKernelValid;
    Vector lastKernelPos; //(0, 0) to (79, 479)
    reg [7:0] lastKernel;
    reg endFrame = 0;
    BlobProcessor BlobProcessor(
        .CLK72(CLK72),
        .kernelValid(lastKernelValid),
        .kernelPos(lastKernelPos),
        .kernel(lastKernel),
        .endFrame(endFrame),
        .targetBlob(targetBlob)
    );

    //Camera SPI Manager
    CameraSPIManager CameraSPIManager(
        .CLK(CLK),
        .SPI_CS(SPI_CS),
        .SPI_MOSI(SPI_MOSI),
        .SPI_MISO(SPI_MISO),
        .SPI_CLK(SPI_CLK),
        .TRIGGER(TRIGGER),
        .MONITOR(MONITOR),
        .reset(reset),
        .sequencerEnabled(enabled)
    );

    //LVDS Input Buffers
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

    //ISERDES (288 MHz DDR; 576 Mb/s per line)
    wire [7:0] SYNC;
    wire [7:0] DOUT [3:0];
    wire [4:0] trainingDone; //check w/ trainingDone == 0

    CameraISERDES SYNC_ISERDES(
        .SERIAL_CLK(LVDS_CLK),
        .SERIAL_DATA(LVDS_SYNC),
        .parallelClk(CLK72),
        .parallelData(SYNC),
        .reset(1'b1),
        .trainingPattern(TR),
        .trainingDone(trainingDone[0])
    );
    CameraISERDES DOUT_0_ISERDES(
        .SERIAL_CLK(LVDS_CLK),
        .SERIAL_DATA(LVDS_DOUT[0]),
        .parallelClk(CLK72),
        .parallelData(DOUT[0]),
        .reset(1'b1),
        .trainingPattern(TR),
        .trainingDone(trainingDone[1])
    );
    CameraISERDES DOUT_1_ISERDES(
        .SERIAL_CLK(LVDS_CLK),
        .SERIAL_DATA(LVDS_DOUT[1]),
        .parallelClk(CLK72),
        .parallelData(DOUT[1]),
        .reset(1'b1),
        .trainingPattern(TR),
        .trainingDone(trainingDone[2])
    );
    CameraISERDES DOUT_2_ISERDES(
        .SERIAL_CLK(LVDS_CLK),
        .SERIAL_DATA(LVDS_DOUT[2]),
        .parallelClk(CLK72),
        .parallelData(DOUT[2]),
        .reset(1'b1),
        .trainingPattern(TR),
        .trainingDone(trainingDone[3])
    );
    CameraISERDES DOUT_3_ISERDES(
        .SERIAL_CLK(LVDS_CLK),
        .SERIAL_DATA(LVDS_DOUT[3]),
        .parallelClk(CLK72),
        .parallelData(DOUT[3]),
        .reset(1'b1),
        .trainingPattern(TR),
        .trainingDone(trainingDone[4])
    );

    //Loop
    reg kernelOdd;
    reg kernelPartion; //whether we are the start or end of kernel
    Vector kernelPos; //(0, 0) to (79, 479)
    reg [7:0] kernel;
    reg isInFrame;
    always @(posedge CLK72) begin
        if (SYNC == FS) begin
            //Note: FS replaces LS
            endFrame <= 0;
            isInFrame <= 1;
            kernelPos.y <= 0;
            kernelPos.x <= 0;
            kernelPartion <= 0;
            kernelOdd <= 0;
            processImageData();
        end

        else if (SYNC == FE) begin
            endFrame <= 1;
            isInFrame <= 0;
            processImageData();
        end

        else if (SYNC == LS & isInFrame) begin
            //check if in frame to make sure its not a black pixel
            kernelPos.x <= 0;
            kernelPartion <= 0;
            kernelOdd <= 0;
            processImageData();
        end

        else if (SYNC == LE & isInFrame) begin
            processImageData();
        end

        else if (SYNC == WN & isInFrame) begin
            processImageData();
        end

        // else if (SYNC == BL) begin
            //TODO do we want black level checking?
        // end

        else if (SYNC == IMG) begin
            processImageData();
        end

        // else if (SYNC == CRC) begin
            //TODO add CRC checking
        // end
    end

    task processImageData();
        //load partion 2 of kernel (see page 40)
        if (kernelPartion) begin
            if (kernelOdd) begin
                //load backwards
                kernel[0] <= DOUT[3] > virtexConfig.threshold;
                kernel[2] <= DOUT[2] > virtexConfig.threshold;
                kernel[4] <= DOUT[1] > virtexConfig.threshold;
                kernel[6] <= DOUT[0] > virtexConfig.threshold;
            end
            else begin
                //load normally
                kernel[1] <= DOUT[0] > virtexConfig.threshold;
                kernel[3] <= DOUT[1] > virtexConfig.threshold;
                kernel[5] <= DOUT[2] > virtexConfig.threshold;
                kernel[7] <= DOUT[3] > virtexConfig.threshold;
            end
            
            lastKernelPos <= kernelPos;
            lastKernel <= kernel;
            kernelPos.x <= kernelPos.x + 1;
            frameBufferWriteRequest <= '{kernelPos, kernel, 1};
        end

        //load partion 1 of kernel (see page 40)
        else if (kernelOdd) begin
            //load backwards
            kernel[1] <= DOUT[3] > virtexConfig.threshold;
            kernel[3] <= DOUT[2] > virtexConfig.threshold;
            kernel[5] <= DOUT[1] > virtexConfig.threshold;
            kernel[7] <= DOUT[0] > virtexConfig.threshold;
        end
        else begin
            //load normally
            kernel[0] <= DOUT[0] > virtexConfig.threshold;
            kernel[2] <= DOUT[1] > virtexConfig.threshold;
            kernel[4] <= DOUT[2] > virtexConfig.threshold;
            kernel[6] <= DOUT[3] > virtexConfig.threshold;
        end

        kernelOdd <= ~kernelOdd;
        kernelPartion <= ~kernelPartion;
        lastKernelValid <= kernelPartion;
        frameBufferWriteRequest.valid <= kernelPartion;
    endtask
endmodule