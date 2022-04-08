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
     - Process Loop: Parallel -> Frame Buffer (raw kernels) & Blob Processor (runs)

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
    output reg BLOB_PROCESSOR_SLOW_FAULT,
    output reg RUN_FIFO_FULL_FAULT,
    output reg [7:0] debug
    );

    wire CLK288, CLK72;
    wire isSequencerEnabled; //whether the sequencer is actually enabled (~2.6us delay from sequencerEnabled if training is done)
    wire isBooted; //whether the python is booted (required registgers are booted)
    wire SYNC_SERIAL;
    wire [3:0] DOUT_SERIAL;
    wire [7:0] SYNC; //parallel SYNC
    wire [7:0] DOUT [3:0]; //parallel DOUTs
    wire [4:0] trainingDone; //whether SERDES lines are trained (active high, 5'b11111)

    //Blob Processor
    Run runFIFOIn;
    reg runFIFOWrite;
    (* keep_hierarchy = "yes" *) BlobProcessor BlobProcessor(
        .CLK288(CLK288),
        .CLK200(CLK200),
        .runFIFOIn(runFIFOIn),
        .runFIFOWrite(runFIFOWrite),
        .target(target),
        .virtexConfig(virtexConfig),
        .OUT_OF_BLOB_MEM_FAULT(OUT_OF_BLOB_MEM_FAULT),
        .OUT_OF_RLE_MEM_FAULT(OUT_OF_RLE_MEM_FAULT),
        .BLOB_PROCESSOR_SLOW_FAULT(BLOB_PROCESSOR_SLOW_FAULT),
        .RUN_FIFO_FULL_FAULT(RUN_FIFO_FULL_FAULT)
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
        .debug(debug)
    );

    //LVDS Input Buffers
    IBUFGDS #(.DIFF_TERM("TRUE"),.IBUF_LOW_PWR("FALSE"),.IOSTANDARD("LVDS_25"))
    LVDS_CLK_IBUF   (.O(CLK288    ),.I(LVDS_CLK_P    ),.IB(LVDS_CLK_N     ));
    IBUFDS  #(.DIFF_TERM("TRUE"),.IBUF_LOW_PWR("FALSE"),.IOSTANDARD("LVDS_25"))
    LVDS_SYNC_IBUF  (.O(SYNC_SERIAL   ),.I(LVDS_SYNC_P   ),.IB(LVDS_SYNC_N    ));
    IBUFDS  #(.DIFF_TERM("TRUE"),.IBUF_LOW_PWR("FALSE"),.IOSTANDARD("LVDS_25"))
    LVDS_DOUT0_IBUF (.O(DOUT_SERIAL[0]),.I(LVDS_DOUT_P[0]),.IB(LVDS_DOUT_N[0]));
    IBUFDS  #(.DIFF_TERM("TRUE"),.IBUF_LOW_PWR("FALSE"),.IOSTANDARD("LVDS_25"))
    LVDS_DOUT1_IBUF (.O(DOUT_SERIAL[1]),.I(LVDS_DOUT_P[1]),.IB(LVDS_DOUT_N[1]));
    IBUFDS  #(.DIFF_TERM("TRUE"),.IBUF_LOW_PWR("FALSE"),.IOSTANDARD("LVDS_25"))
    LVDS_DOUT2_IBUF (.O(DOUT_SERIAL[2]),.I(LVDS_DOUT_P[2]),.IB(LVDS_DOUT_N[2]));
    IBUFDS  #(.DIFF_TERM("TRUE"),.IBUF_LOW_PWR("FALSE"),.IOSTANDARD("LVDS_25"))
    LVDS_DOUT3_IBUF (.O(DOUT_SERIAL[3]),.I(LVDS_DOUT_P[3]),.IB(LVDS_DOUT_N[3]));

    //ISERDES (288 MHz DDR; 576 Mb/s per line)
    wire SERDES_RESET = ~isBooted; //active high
    PythonISERDES SYNC_ISERDES(
        .SERIAL_CLK(CLK288),
        .SERIAL_DATA(SYNC_SERIAL),
        .PARALLEL_CLK(CLK72),
        .PARALLEL_DATA(SYNC),
        .RESET(SERDES_RESET), 
        .trainingDone(trainingDone[0])
    );
    PythonISERDES DOUT_0_ISERDES(
        .SERIAL_CLK(CLK288),
        .SERIAL_DATA(DOUT_SERIAL[0]),
        .PARALLEL_CLK(CLK72),
        .PARALLEL_DATA(DOUT[0]),
        .RESET(SERDES_RESET),
        .trainingDone(trainingDone[1])
    );
    PythonISERDES DOUT_1_ISERDES (
        .SERIAL_CLK(CLK288),
        .SERIAL_DATA(DOUT_SERIAL[1]),
        .PARALLEL_CLK(CLK72),
        .PARALLEL_DATA(DOUT[1]),
        .RESET(SERDES_RESET),
        .trainingDone(trainingDone[2])
    );
    PythonISERDES DOUT_2_ISERDES(
        .SERIAL_CLK(CLK288),
        .SERIAL_DATA(DOUT_SERIAL[2]),
        .PARALLEL_CLK(CLK72),
        .PARALLEL_DATA(DOUT[2]),
        .RESET(SERDES_RESET),
        .trainingDone(trainingDone[3])
    );
    PythonISERDES DOUT_3_ISERDES(
        .SERIAL_CLK(CLK288),
        .SERIAL_DATA(DOUT_SERIAL[3]),
        .PARALLEL_CLK(CLK72),
        .PARALLEL_DATA(DOUT[3]),
        .RESET(SERDES_RESET),
        .trainingDone(trainingDone[4])
    );

    //Python State (SYNC -> State)
    Math::Vector2d10 kernelPos = '0;
    reg inFrame = 0;
    reg kernelDone = 0;
    reg kernelOdd = 0;
    reg [7:0] lastSYNC = 0;
    always_ff @(posedge CLK72) begin
        if (trainingDone == 5'b11111 | isSequencerEnabled) begin
            if (lastSYNC == PYTHON_SYNC_FRAME_END) begin
                inFrame <= 0;
                kernelDone <= 0;
            end

            if (SYNC == PYTHON_SYNC_FRAME_START) begin
                inFrame <= 1;
                kernelPos <= 0;
                kernelOdd <= 0;
                kernelDone <= 0;
            end

            if (inFrame & SYNC == PYTHON_SYNC_LINE_START) begin
                kernelPos <= '{ x: 0, y: kernelPos.y + 1 };
                kernelOdd <= 0;
                kernelDone <= 0;
            end

            if (inFrame & (SYNC == PYTHON_SYNC_IMAGE | SYNC == PYTHON_SYNC_MAIN_WINDOW_ID | SYNC == PYTHON_SYNC_FRAME_END | SYNC == PYTHON_SYNC_LINE_END)) begin
                if (kernelDone) begin
                    kernelPos.x <= kernelPos.x + 1;
                end
                
                kernelOdd <= kernelOdd ^ kernelDone;
                kernelDone <= ~kernelDone;
            end

            lastSYNC <= SYNC;
        end
    end

    //Kernel Loading (DOUT -> Kernels (unflipped))
    reg [7:0] kernelUnflipped [7:0];
    always_ff @(posedge CLK72) kernelUnflipped = {kernelUnflipped[3:0], DOUT};

    //Kernel Unflipping
    localparam [3:0] PYTHON_KERNEL_MASK [7:0] = '{3,7,2,6,1,5,0,4};
    reg [7:0] kernel [7:0];
    always_comb for (int i = 0; i < 8; i++) kernel[i] = kernelUnflipped[PYTHON_KERNEL_MASK[kernelOdd ? (7-i) : i]];

    //Run Length Encoding (Kernels -> Runs)
    localparam THRESHOLD_TEMP = 8'd20;
    Run rleCurrentRun = '0;
    reg [7:0] rleKernel;
    reg [7:0] kernelThreshold;
    always_comb for (int i = 0; i < 8; i++) kernelThreshold[i] = kernel[i] > THRESHOLD_TEMP;
    Math::Vector2d10 rleKernelPos = '0;
    reg [2:0] rleKernelX;
    reg rleInKernel = '0;
    reg lastKernelDone;
    always_ff @(negedge CLK288) begin //kernels are output @ 36MHz so we can process each pixel @ (36*8)MHz
        runFIFOWrite <= 0;
        
        //Process each Pixel in Kernel
        if (rleInKernel) begin
            //New Run @ Color Change
            if (rleKernel[rleKernelX] != rleCurrentRun.black) begin
                //end old run
                if (rleCurrentRun.length != 0) begin
                    runFIFOIn <= rleCurrentRun;
                    runFIFOWrite <= 1;
                end

                //start new run
                rleCurrentRun <= '{
                    length: 1,
                    line: rleKernelPos.y,
                    black: rleKernel[rleKernelX]
                };
            end

            //Extend Run
            else begin
                rleCurrentRun.length <= rleCurrentRun.length + 1;
            end

            //End Kernel
            if (rleKernelX == 6) rleInKernel <= 0;

            //Move to Next Pixel
            rleKernelX <= rleKernelX + 1;
        end

        //New Kernel
        if (kernelDone & ~lastKernelDone) begin
            rleKernel <= kernelThreshold;
            rleKernelPos <= kernelPos;
            rleKernelX <= 0;
            rleInKernel <= 1;

            //New Line
            if (kernelPos.y != rleKernelPos.y) begin
                //end old run
                if (rleCurrentRun.length != 0) begin
                    runFIFOIn <= rleCurrentRun;
                    runFIFOWrite <= 1;
                end

                //start run
                rleCurrentRun <= '{
                    length: 0,
                    line: kernelPos.y,
                    black: ~kernel[7]
                };
            end
        end
        lastKernelDone <= 1;
    end

    //Kernel Clock Crossing w/ FIFO (72MHz (not MRCC) -> 100MHZ (MRCC))
    Kernel8x1x4 frameBufferFIFOIn, frameBufferFIFOOut;
    reg frameBufferFIFOWrite = 0, frameBufferFIFORead = 0;
    wire frameBufferFIFOFull, frameBufferFIFOEmpty;
    reg [7:0] [3:0] kernel4; //convert 8-bit -> 4-bit
    always_comb for (int i = 0; i < 8; i++) kernel4[i] = kernel[i][7:4];
    assign frameBufferFIFOIn = '{
        value: kernel4,
        pos: kernelPos
    };
    always_ff @(negedge CLK72) frameBufferFIFOWrite <= kernelDone;
    fifo_python_stream frameBufferWriteFIFO (
        .full(frameBufferFull),
        .din(frameBufferFIFOIn),
        .wr_en(frameBufferFIFOWrite),
        .wr_clk(CLK72),
        .empty(frameBufferFIFOEmpty),
        .dout(frameBufferFIFOOut),
        .rd_en(frameBufferFIFORead),
        .rd_clk(CLK100)
    );
    
    //Frame Buffer Writing (PythonManager -> AppManager)
    initial frameBufferWriteEnable = 0;
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
        .I(CLK288),
        .O(CLK72),
        .CE(1'b1),
        .CLR(1'b0)
    );
endmodule