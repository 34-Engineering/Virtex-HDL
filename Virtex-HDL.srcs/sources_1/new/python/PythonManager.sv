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
    input wire CLK200, CLK100, CLK10,
    input wire LVDS_CLK_P, LVDS_CLK_N, LVDS_SYNC_P, LVDS_SYNC_N,
    input wire [3:0] LVDS_DOUT_P, LVDS_DOUT_N,
    output wire SPI_CS, SPI_MOSI, SPI_CLK,
    input wire SPI_MISO,
    output wire [2:0] TRIGGER,
    input wire [1:0] MONITOR,
    output wire RESET_SENSOR, //active low
    input wire sequencerEnabled,
    input VirtexConfig virtexConfig,
    output reg [15:0] frameBufferWriteAddr,
    output reg [31:0] frameBufferWriteIn,
    output reg frameBufferWriteEnable,
    output wire Target target,
    output wire PYTHON_300_PLL_FAULT,
    output reg OUT_OF_BLOB_MEM_FAULT,
    output reg OUT_OF_RLE_MEM_FAULT,
    output reg BLOB_POINTER_DEPTH_FAULT,
    output reg BLOB_PROCESSOR_SLOW_FAULT,
    output reg [7:0] debug,
    output reg [7:0] wave
    );

    wire LVDS_CLK, CLK72;
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
    logic [7:0] [3:0] kernelMonoValue = 0;
    reg isInFrame; //whether the processor is in frame

    //Blob Processor
    Kernel lastKernelR [1:0];
    always_ff @(posedge CLK200) begin
        //Cross clock domain w/ dff
        lastKernelR[1] <= lastKernelR[0];
    end
    BlobProcessor BlobProcessor(
        .CLK200(CLK200),
        .kernel(lastKernelR[1]),
        .target(target),
        .OUT_OF_BLOB_MEM_FAULT(OUT_OF_BLOB_MEM_FAULT),
        .OUT_OF_RLE_MEM_FAULT(OUT_OF_RLE_MEM_FAULT),
        .BLOB_POINTER_DEPTH_FAULT(BLOB_POINTER_DEPTH_FAULT),
        .BLOB_PROCESSOR_SLOW_FAULT(BLOB_PROCESSOR_SLOW_FAULT)
    );

    //Python SPI Manager
    wire shouldEnableSequencer = sequencerEnabled & trainingDone == 5'b11111; //only enable once SERDES is ready
    PythonSPIManager PythonSPIManager(
        .CLK100(CLK100),
        .CLK10(CLK10),
        .SPI_CS(SPI_CS),
        .SPI_MOSI(SPI_MOSI),
        .SPI_MISO(SPI_MISO),
        .SPI_CLK(SPI_CLK),
        .TRIGGER(TRIGGER),
        .MONITOR(MONITOR),
        .RESET_SENSOR(RESET_SENSOR),
        .sequencerEnabled(shouldEnableSequencer),
        .isSequencerEnabled(isSequencerEnabled),
        .isBooted(isBooted),
        .virtexConfig(virtexConfig),
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
    wire SERDES_RESET = ~isBooted; //active high, dont start training until required registers are uploaded
    PythonISERDES SYNC_ISERDES(
        .SERIAL_CLK(LVDS_CLK),
        .SERIAL_DATA(LVDS_SYNC),
        .PARALLEL_CLK(CLK72),
        .PARALLEL_DATA(SYNC),
        .RESET(SERDES_RESET), 
        .trainingDone(trainingDone[0])
    );
    PythonISERDES DOUT_0_ISERDES(
        .SERIAL_CLK(LVDS_CLK),
        .SERIAL_DATA(LVDS_DOUT[0]),
        .PARALLEL_CLK(CLK72),
        .PARALLEL_DATA(DOUT[0]),
        .RESET(SERDES_RESET),
        .trainingDone(trainingDone[1])
    );
    PythonISERDES DOUT_1_ISERDES (
        .SERIAL_CLK(LVDS_CLK),
        .SERIAL_DATA(LVDS_DOUT[1]),
        .PARALLEL_CLK(CLK72),
        .PARALLEL_DATA(DOUT[1]),
        .RESET(SERDES_RESET),
        .trainingDone(trainingDone[2])
    );
    PythonISERDES DOUT_2_ISERDES(
        .SERIAL_CLK(LVDS_CLK),
        .SERIAL_DATA(LVDS_DOUT[2]),
        .PARALLEL_CLK(CLK72),
        .PARALLEL_DATA(DOUT[2]),
        .RESET(SERDES_RESET),
        .trainingDone(trainingDone[3])
    );
    PythonISERDES DOUT_3_ISERDES(
        .SERIAL_CLK(LVDS_CLK),
        .SERIAL_DATA(LVDS_DOUT[3]),
        .PARALLEL_CLK(CLK72),
        .PARALLEL_DATA(DOUT[3]),
        .RESET(SERDES_RESET),
        .trainingDone(trainingDone[4])
    );

    //Process Loop
    KernelMono frameBufferFIFOIn = 0;
    reg frameBufferFIFOWrite = 0;
    wire frameBufferFIFOFull;

    // Vector pos = 0;
    always_ff @(posedge CLK72) begin
        // if (pos.y < 480 & ~frameBufferFIFOFull & ~frameBufferFIFOWrite) begin
        //     frameBufferFIFOIn = '{ value: 32'hFFFFFFFF, pos: pos };
        //     frameBufferFIFOWrite = 1;
        //     if (pos.x < 79) begin
        //         pos.x <= pos.x + 1;
        //     end
        //     else pos <= '{ x: 0, y: pos.y + 1 };
        // end
        // else frameBufferFIFOWrite <= 0;

        frameBufferFIFOWrite <= 0;

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
    localparam DOUT_SEL_H = 7;
    task processImageData();
        //load partion 2 of kernel (see page 40)
        if (kernelPartion) begin
            if (kernelOdd) begin
                //load backwards
                kernel.value   [0] = DOUT[3] > THRESHOLD_TEMP;
                kernel.value   [2] = DOUT[2] > THRESHOLD_TEMP;
                kernel.value   [4] = DOUT[1] > THRESHOLD_TEMP;
                kernel.value   [6] = DOUT[0] > THRESHOLD_TEMP;
                kernelMonoValue[0] = DOUT[3][DOUT_SEL_H -: 4];
                kernelMonoValue[2] = DOUT[2][DOUT_SEL_H -: 4];
                kernelMonoValue[4] = DOUT[1][DOUT_SEL_H -: 4];
                kernelMonoValue[6] = DOUT[0][DOUT_SEL_H -: 4];
            end
            else begin
                //load normally
                kernel.value   [1] = DOUT[0] > THRESHOLD_TEMP;
                kernel.value   [3] = DOUT[1] > THRESHOLD_TEMP;
                kernel.value   [5] = DOUT[2] > THRESHOLD_TEMP;
                kernel.value   [7] = DOUT[3] > THRESHOLD_TEMP;
                kernelMonoValue[1] = DOUT[0][DOUT_SEL_H -: 4];
                kernelMonoValue[3] = DOUT[1][DOUT_SEL_H -: 4];
                kernelMonoValue[5] = DOUT[2][DOUT_SEL_H -: 4];
                kernelMonoValue[7] = DOUT[3][DOUT_SEL_H -: 4];
            end
            
            //send kernel to blob processor
            lastKernelR[0] <= kernel;

            //send kernel to frame buffer
            frameBufferFIFOIn <= '{ value: kernelMonoValue, pos: kernel.pos };
            frameBufferFIFOWrite <= 1;
            
            //prepare for next kernel
            kernel.pos.x <= kernel.pos.x + 1;
            kernelOdd <= ~kernelOdd;
        end

        //load partion 1 of kernel (see page 40)
        else if (kernelOdd) begin
            //load backwards
            kernel.value   [1] <= DOUT[3] > THRESHOLD_TEMP;
            kernel.value   [3] <= DOUT[2] > THRESHOLD_TEMP;
            kernel.value   [5] <= DOUT[1] > THRESHOLD_TEMP;
            kernel.value   [7] <= DOUT[0] > THRESHOLD_TEMP;
            kernelMonoValue[1] <= DOUT[3][DOUT_SEL_H -: 4];
            kernelMonoValue[3] <= DOUT[2][DOUT_SEL_H -: 4];
            kernelMonoValue[5] <= DOUT[1][DOUT_SEL_H -: 4];
            kernelMonoValue[7] <= DOUT[0][DOUT_SEL_H -: 4];
        end
        else begin
            //load normally
            kernel.value   [0] <= DOUT[0] > THRESHOLD_TEMP;
            kernel.value   [2] <= DOUT[1] > THRESHOLD_TEMP;
            kernel.value   [4] <= DOUT[2] > THRESHOLD_TEMP;
            kernel.value   [6] <= DOUT[3] > THRESHOLD_TEMP;
            kernelMonoValue[0] <= DOUT[0][DOUT_SEL_H -: 4];
            kernelMonoValue[2] <= DOUT[1][DOUT_SEL_H -: 4];
            kernelMonoValue[4] <= DOUT[2][DOUT_SEL_H -: 4];
            kernelMonoValue[6] <= DOUT[3][DOUT_SEL_H -: 4];
        end

        //swap kernel partion
        kernelPartion <= ~kernelPartion;
    endtask

    //Frame Buffer Writing & Clock Crossing with FIFO
    KernelMono frameBufferFIFOOut;
    reg frameBufferFIFORead = 0;
    wire frameBufferFIFOEmpty;
    wire CLK72Inv = ~CLK72;
    initial frameBufferWriteEnable = 0;
    fifo_python_stream frameBufferWriteFIFO (
        .full(frameBufferFull),
        .din(frameBufferFIFOIn),
        .wr_en(frameBufferFIFOWrite),
        .wr_clk(CLK72Inv),
        .empty(frameBufferFIFOEmpty),
        .dout(frameBufferFIFOOut),
        .rd_en(frameBufferFIFORead),
        .rd_clk(CLK100)
    );
    always_ff @(negedge CLK100) begin
        //Write Kernel to Frame Buffer
        if (frameBufferFIFORead) begin
            frameBufferWriteAddr <= (frameBufferFIFOOut.pos.y * 80) + frameBufferFIFOOut.pos.x;
            frameBufferWriteIn <= frameBufferFIFOOut.value;
            frameBufferWriteEnable <= 1;
        end
        else frameBufferWriteEnable <= 0;

        //Read FIFO
        frameBufferFIFORead <= ~frameBufferFIFOEmpty;
    end

    //72MHz Clock Generator (from 288MHz signal)
    BUFR #(.SIM_DEVICE("7SERIES"), .BUFR_DIVIDE("4")) CLK72_BUFR (
        .I(LVDS_CLK),
        .O(CLK72),
        .CE(1'b1),
        .CLR(1'b0)
    );
endmodule