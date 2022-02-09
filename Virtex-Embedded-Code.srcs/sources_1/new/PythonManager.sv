`timescale 1ns / 1ps
`include "Util.sv"
`include "PythonManagerParams.sv"

/* PythonManager - Manages the Python 300 Image Sensor
    Python 300 Docs: https://www.onsemi.com/pdf/datasheet/noip1sn1300a-d.pdf
    
    PythonSPIManager manages the SPI interface with the image sensor

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

    Flow:
     - LVDS Lines -> IBUFGDS -> ISERDES -> Parallel Data (SYNC & DOUT[3:0])

    */
module PythonManager(
    input wire CLK,
    input wire LVDS_CLK_P, LVDS_CLK_N, LVDS_SYNC_P, LVDS_SYNC_N,
    input wire [3:0] LVDS_DOUT_P, LVDS_DOUT_N,
    output wire SPI_CS, SPI_MOSI, SPI_CLK,
    input wire SPI_MISO,
    output wire [2:0] TRIGGER,
    input wire [1:0] MONITOR,
    output wire RESET_SENSOR, //active low
    input wire enabled,
    input wire VirtexConfig virtexConfig,
    output FrameBufferWriteRequest frameBufferWriteRequest,
    output wire Blob targetBlob,
    output wire Fault fault
    );

    assign RESET_SENSOR = 1;

    //Generate 72MHz Parallel Clock from 288MHz Input Clock
    wire LVDS_CLK, CLK72;
    BUFR #(.SIM_DEVICE("7SERIES"), .BUFR_DIVIDE("4")) CLK72_BUFR (
        .O(CLK72),
        .CE(1'b1),
        .CLR(1'b0),
        .I(LVDS_CLK)
    );

    //Generate 400MHz Global Clock
    // wire CLK400;
    // clk_wiz_2 clk_wiz_2(
    //     .clk_in1(CLK),
    //     .clk_out1(CLK400)
    // );

    //Blob Processor
    reg lastKernelValidR [2:0];
    Vector lastKernelPosR [2:0];
    reg [7:0] lastKernelR [2:0];
    always @(posedge CLK) begin
        //Cross clock domain w/ 2x dff
        //r0 @ 72MHz -> r1 @ 400MHz (metastable) -> r2 @ 400MHz (stable)
        lastKernelValidR[1] <= lastKernelValidR[0];
        lastKernelValidR[2] <= lastKernelValidR[1];
        lastKernelPosR[1] <= lastKernelPosR[0];
        lastKernelPosR[2] <= lastKernelPosR[1];
        lastKernelR[1] <= lastKernelR[0];
        lastKernelR[2] <= lastKernelR[1];
    end
    BlobProcessor BlobProcessor(
        .CLK(CLK),
        .kernelValid(lastKernelValidR[2]),
        .kernelPos(lastKernelPosR[2]),
        .kernel(lastKernelR[2]),
        .targetBlob(targetBlob)
    );

    //Python SPI Manager
    PythonSPIManager PythonSPIManager(
        .CLK(CLK),
        .SPI_CS(SPI_CS),
        .SPI_MOSI(SPI_MOSI),
        .SPI_MISO(SPI_MISO),
        .SPI_CLK(SPI_CLK),
        .TRIGGER(TRIGGER),
        .MONITOR(MONITOR),
        .sequencerEnabled(enabled),
        .fault(fault)
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
    wire [4:0] trainingDone;
    PythonISERDES SYNC_ISERDES(
        .SERIAL_CLK(LVDS_CLK),
        .SERIAL_DATA(LVDS_SYNC),
        .parallelClk(CLK72),
        .parallelData(SYNC),
        .reset(1'b1),
        .trainingPattern(TR),
        .trainingDone(trainingDone[0])
    );
    PythonISERDES DOUT_0_ISERDES(
        .SERIAL_CLK(LVDS_CLK),
        .SERIAL_DATA(LVDS_DOUT[0]),
        .parallelClk(CLK72),
        .parallelData(DOUT[0]),
        .reset(1'b1),
        .trainingPattern(TR),
        .trainingDone(trainingDone[1])
    );
    PythonISERDES DOUT_1_ISERDES(
        .SERIAL_CLK(LVDS_CLK),
        .SERIAL_DATA(LVDS_DOUT[1]),
        .parallelClk(CLK72),
        .parallelData(DOUT[1]),
        .reset(1'b1),
        .trainingPattern(TR),
        .trainingDone(trainingDone[2])
    );
    PythonISERDES DOUT_2_ISERDES(
        .SERIAL_CLK(LVDS_CLK),
        .SERIAL_DATA(LVDS_DOUT[2]),
        .parallelClk(CLK72),
        .parallelData(DOUT[2]),
        .reset(1'b1),
        .trainingPattern(TR),
        .trainingDone(trainingDone[3])
    );
    PythonISERDES DOUT_3_ISERDES(
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
        if (SYNC == PYTHON_SYNC_FRAME_START) begin
            //Note: FS replaces LS
            isInFrame <= 1;
            kernelPos.y <= 0;
            kernelPos.x <= 0;
            kernelPartion <= 0;
            kernelOdd <= 0;
            processImageData();
        end

        else if (SYNC == PYTHON_SYNC_FRAME_END) begin
            isInFrame <= 0;
            processImageData();
        end

        else if (SYNC == PYTHON_SYNC_LINE_START & isInFrame) begin
            //check if in frame to make sure its not a black pixel
            kernelPos.x <= 0;
            kernelPartion <= 0;
            kernelOdd <= 0;
            processImageData();
        end

        else if (SYNC == PYTHON_SYNC_LINE_END & isInFrame) begin
            processImageData();
        end

        else if (SYNC == PYTHON_SYNC_MAIN_WINDOW_ID & isInFrame) begin
            processImageData();
        end

        // else if (SYNC == BL) begin
            //TODO do we want black level checking?
        // end

        else if (SYNC == PYTHON_SYNC_IMAGE) begin
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
            
            lastKernelPosR[0] <= kernelPos;
            lastKernelR[0] <= kernel;
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
        lastKernelValidR[0] <= kernelPartion;
        frameBufferWriteRequest.valid <= kernelPartion;
    endtask
endmodule