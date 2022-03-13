`timescale 1ns / 1ps
`include "../blob/BlobUtil.sv"
`include "../config/VirtexConfig.sv"
`include "PythonUtil.sv"
`include "../util/Fault.sv"

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
     - Buffers: LVDS -> Serial
     - SERDES: Serial -> Parallel
     - Process Loop: Parallel -> Frame Buffer & Blob Processor

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
    input wire sequencerEnabled,
    input wire VirtexConfig virtexConfig,
    output Kernel frameBufferWriteRequest,
    output wire Target target,
    output wire PYTHON_300_PLL_FAULT,
    output reg OUT_OF_BLOB_MEM_FAULT,
    output reg OUT_OF_RLE_MEM_FAULT,
    output reg BLOB_POINTER_DEPTH_FAULT,
    output reg BLOB_PROCESSOR_SLOW_FAULT,
    output reg [7:0] debug,
    output reg [7:0] wave
    );

    wire LVDS_CLK, CLK72, CLK180;
    wire isSequencerEnabled; //whether the sequencer is actually enabled (~2.6us delay from sequencerEnabled if training is done)
    wire isBooted; //whether the python is booted (required registgers are booted)
    wire LVDS_SYNC; //serial SYNC
    wire [3:0] LVDS_DOUT; //serial DOUTs
    wire [7:0] SYNC; //parallel SYNC
    wire [7:0] DOUT [3:0]; //parallel DOUTs
    wire [4:0] trainingDone; //whether SERDES lines are trained (active high, 5'b11111)
    reg kernelOdd; //whether the kernel x coordinate is odd (kernel is read out backwards)
    reg kernelPartion;
    Kernel kernel = 0; //the current kernel we are working on
    reg isInFrame; //whether the processor is in frame

    //Generate 72MHz Parallel Clock from 288MHz Input Clock
    BUFR #(.SIM_DEVICE("7SERIES"), .BUFR_DIVIDE("4")) CLK72_BUFR (
        .O(CLK72),
        .CE(1'b1),
        .CLR(1'b0),
        .I(LVDS_CLK)
    );

    //Generate 180MHz Blob Processor Clock
    clk_wiz_2 clk_wiz_2(
        .clk_in1(CLK),
        .clk_out1(CLK180)
    );

    //Blob Processor
    Kernel lastKernelR [1:0];
    always_ff @(posedge CLK180) begin
        //Cross clock domain w/ dff
        lastKernelR[1] <= lastKernelR[0];
    end
    BlobProcessor BlobProcessor(
        .CLK180(CLK180),
        .kernel(lastKernelR[1]),
        .target(target),
        .OUT_OF_BLOB_MEM_FAULT(OUT_OF_BLOB_MEM_FAULT),
        .OUT_OF_RLE_MEM_FAULT(OUT_OF_RLE_MEM_FAULT),
        .BLOB_POINTER_DEPTH_FAULT(BLOB_POINTER_DEPTH_FAULT),
        .BLOB_PROCESSOR_SLOW_FAULT(BLOB_PROCESSOR_SLOW_FAULT)
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
        .RESET_SENSOR(RESET_SENSOR),
        .sequencerEnabled(sequencerEnabled & trainingDone == 5'b11111), //only enable the sequencer once we trained ISERDES
        .isSequencerEnabled(isSequencerEnabled),
        .isBooted(isBooted),
        .PYTHON_300_PLL_FAULT(PYTHON_300_PLL_FAULT),
        .debug(),
        .wave()
    );

    //LVDS Input Buffers
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
    PythonISERDES SYNC_ISERDES(
        .SERIAL_CLK(LVDS_CLK),
        .SERIAL_DATA(LVDS_SYNC),
        .parallelClk(CLK72),
        .parallelData(SYNC),
        .reset(isBooted), //dont start training until required registers are uploaded
        .trainingDone(trainingDone[0])
    );
    PythonISERDES DOUT_0_ISERDES(
        .SERIAL_CLK(LVDS_CLK),
        .SERIAL_DATA(LVDS_DOUT[0]),
        .parallelClk(CLK72),
        .parallelData(DOUT[0]),
        .reset(isBooted),
        .trainingDone(trainingDone[1])
    );
    PythonISERDES DOUT_1_ISERDES (
        .SERIAL_CLK(LVDS_CLK),
        .SERIAL_DATA(LVDS_DOUT[1]),
        .parallelClk(CLK72),
        .parallelData(DOUT[1]),
        .reset(isBooted),
        .trainingDone(trainingDone[2])
    );
    PythonISERDES DOUT_2_ISERDES(
        .SERIAL_CLK(LVDS_CLK),
        .SERIAL_DATA(LVDS_DOUT[2]),
        .parallelClk(CLK72),
        .parallelData(DOUT[2]),
        .reset(isBooted),
        .trainingDone(trainingDone[3])
    );
    PythonISERDES DOUT_3_ISERDES(
        .SERIAL_CLK(LVDS_CLK),
        .SERIAL_DATA(LVDS_DOUT[3]),
        .parallelClk(CLK72),
        .parallelData(DOUT[3]),
        .reset(isBooted),
        .trainingDone(trainingDone[4])
    );

    initial debug = 8'b11111111;

    assign wave = DOUT[0];

    //Process Loop
    initial frameBufferWriteRequest = 0;
    always_ff @(posedge CLK72) begin
        if (trainingDone == 5'b11111 & isSequencerEnabled) begin
            if (SYNC == PYTHON_SYNC_FRAME_START) begin
                //Note: FS replaces LS
                isInFrame = 1;
                kernel.pos = '{x:0, y:0};
                kernelPartion = 0;
                kernelOdd = 0;
                processImageData();
            end

            else if (SYNC == PYTHON_SYNC_FRAME_END) begin
                debug <= 8'b10101010;
                isInFrame = 0;
                processImageData();
                //TODO resetting logic?
            end

            else if (SYNC == PYTHON_SYNC_LINE_START & isInFrame) begin
                //check if in frame to make sure its not a black pixel
                kernel.pos.x = 0;
                kernelPartion = 0;
                kernelOdd = 0;
                processImageData();
            end

            else if (SYNC == PYTHON_SYNC_LINE_END & isInFrame) begin
                kernel.pos.y = kernel.pos.y + 1;
                processImageData();
            end

            else if (SYNC == PYTHON_SYNC_MAIN_WINDOW_ID & isInFrame) begin
                processImageData();
            end

            else if (SYNC == PYTHON_SYNC_IMAGE & isInFrame) begin
                processImageData();
            end
        end
    end

    localparam THRESHOLD_TEMP = 8'd20;
    task processImageData();
        //load partion 2 of kernel (see page 40)
        if (kernelPartion) begin
            if (kernelOdd) begin
                //load backwards
                kernel.value = {
                    DOUT[3] > THRESHOLD_TEMP, //0
                    kernel.value[1],  //1
                    DOUT[2] > THRESHOLD_TEMP, //2
                    kernel.value[3],  //3
                    DOUT[1] > THRESHOLD_TEMP, //4
                    kernel.value[5],  //5
                    DOUT[0] > THRESHOLD_TEMP, //6
                    kernel.value[7]   //7
                };
            end
            else begin
                //load normally
                kernel.value = {
                    kernel.value[0],  //0
                    DOUT[0] > THRESHOLD_TEMP, //1
                    kernel.value[2],  //2
                    DOUT[1] > THRESHOLD_TEMP, //3
                    kernel.value[4],  //4
                    DOUT[2] > THRESHOLD_TEMP, //5
                    kernel.value[6],  //6
                    DOUT[3] > THRESHOLD_TEMP  //7
                };
            end
            
            //send kernel to blob processor
            lastKernelR[0] <= kernel;

            //send kernel to frame buffer
            frameBufferWriteRequest <= '{ value: kernel.value, pos: kernel.pos, valid: 1 };
            
            //prepare for next kernel
            kernel.pos.x <= kernel.pos.x + 1;
            kernelOdd <= ~kernelOdd;
        end

        //load partion 1 of kernel (see page 40)
        else begin
            if (kernelOdd) begin
                //load backwards
                kernel.value = {
                    kernel.value[0],  //0
                    DOUT[3] > THRESHOLD_TEMP, //1
                    kernel.value[2],  //2
                    DOUT[2] > THRESHOLD_TEMP, //3
                    kernel.value[4],  //4
                    DOUT[1] > THRESHOLD_TEMP, //5
                    kernel.value[6],  //6
                    DOUT[0] > THRESHOLD_TEMP  //7
                };
            end
            else begin
                //load normally
                kernel.value = {
                    DOUT[0] > THRESHOLD_TEMP, //0
                    kernel.value[1],  //1
                    DOUT[1] > THRESHOLD_TEMP, //2
                    kernel.value[3],  //3
                    DOUT[2] > THRESHOLD_TEMP, //4
                    kernel.value[5],  //5
                    DOUT[3] > THRESHOLD_TEMP, //6
                    kernel.value[7]   //7
                };
            end

            frameBufferWriteRequest.valid <= 0;
        end

        //swap kernel partion
        kernelPartion <= ~kernelPartion;
    endtask
endmodule