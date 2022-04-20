`timescale 1ns / 1ps

`define SIM 1

`include "../../sources_1/new/config/VirtexConfig.sv"
`include "../../sources_1/new/util/Math.sv"
`include "../../sources_1/new/vision/VisionUtil.sv"
`include "./Image.sv"

/* VisionTest

    */
module VisionTest;

    initial $display(" ###### STARTING VISION TEST ###### ");

    reg CLK288 = '0, CLK200 = '0;
    always #(500/288) CLK288 <= ~CLK288;
    always #(500/200) CLK200 <= ~CLK200;

    Run rleCurrentRun;
    Math::Vector2d10 rleKernelPos;
    wire [7:0] rleKernel = image[rleKernelPos.y * 80 + rleKernelPos.x];
    reg [2:0] rleKernelX;

    Run runFIFOIn = '0;
    reg runFIFOWrite = '0;
    Target target;

    int _wait = 255;

    VirtexConfig cfg = '{
        //camera params & python config
        mainConfig: '{ safetyEnabled:'1, flipVertical:'0, reserved:'0 },
        ledBrightness: 16'hFFFF,
        threshold: 128,
        blackOffset: '{0, 6, 6, 8},
        analogGain: '{0, 0, 15, 8},
        digitalGain: 16'h0080,
        exposure: 4000,
        multTimer: 20,
        frameLength: 41500,

        //target params
        targetMode: DUAL_UP,
        targetBlobXGapMin: 0,
        targetBlobXGapMax: 16'hFFFF,//30,
        targetBlobYGapMin: 0,
        targetBlobYGapMax: 16'hFFFF,//30,
        targetBoundAreaRatioMin: 0.25,
        targetBoundAreaRatioMax: 1.75,//100,
        targetAspectRatioMin: 0,//2,
        targetAspectRatioMax: 16'hFFFF,//4,
        targetBoundAreaMin: 12,
        targetBoundAreaMax: 16'hFFFF,//0xffff,
        targetBlobCountMin: 2,
        targetBlobCountMax: 16'hFFFF,
        targetCenterX: IMAGE_WIDTH / 2,
        targetCenterY: IMAGE_HEIGHT / 2,

        //blob params
        blobAspectRatioMin: 0,
        blobAspectRatioMax: 16'hFFFF,
        blobBoundAreaMin: 12,
        blobBoundAreaMax: 16'hFFFF,
        blobFullnessMin: 0,
        blobFullnessMax: 16'hFFFF,
        blobAnglesEnabled: '{ horizontal: 1, vertical: 1, forward: 1, backward: 1, reserved: 0 },
        
        //reserved for future use
        reserved31: 16'h0,
        reserved32: 16'h0,
        reserved33: 16'h0,
        reserved34: 16'h0,
        reserved35: 16'h0,
        reserved36: 16'h0,
        reserved37: 16'h0,
        reserved38: 16'h0,
        reserved39: 16'h0,
        reserved40: 16'h0,
        reserved41: 16'h0,
        reserved42: 16'h0,
        reserved43: 16'h0,
        reserved44: 16'h0,
        reserved45: 16'h0,
        reserved46: 16'h0,
        reserved47: 16'h0,
        reserved48: 16'h0,
        reserved49: 16'h0,
        reserved50: 16'h0,
        reserved51: 16'h0,
        reserved52: 16'h0,
        reserved53: 16'h0,
        reserved54: 16'h0,
        reserved55: 16'h0,
        reserved56: 16'h0,
        reserved57: 16'h0,
        reserved58: 16'h0,
        reserved59: 16'h0,
        reserved60: 16'h0,
        reserved61: 16'h0,
        reserved62: 16'h0,
        memValid: 16'h34
    };
    
    always_ff @(negedge CLK288) begin
        runFIFOWrite = 0;

        //Reset
        if (_wait != 0) begin
            _wait = _wait - 1;
            rleCurrentRun = '{length:0, line:0, black:~image[0][7]};
            rleKernelPos = '0;
            rleKernelX = '0;
            runFIFOIn = '0;
            runFIFOWrite = '0;
        end

        //Readout
        else if (rleKernelPos.y < 480) begin
            //New Run @ Color Change
            if (~rleKernel[7-rleKernelX] != rleCurrentRun.black) begin
                //end old run
                if (rleCurrentRun.length != 0) begin
                    runFIFOIn = rleCurrentRun;
                    runFIFOWrite = 1;
                end

                //start new run
                rleCurrentRun = '{
                    length: 1,
                    line: rleKernelPos.y,
                    black: ~rleKernel[7-rleKernelX]
                };
            end

            //Extend Run
            else begin
                rleCurrentRun.length = rleCurrentRun.length + 1;
            end

            //New Kernel
            if (rleKernelX == 7) begin
                //New Line
                if (rleKernelPos.x == 79) begin
                    //end old run
                    if (rleCurrentRun.length != 0) begin
                        runFIFOIn = rleCurrentRun;
                        runFIFOWrite = 1;
                    end

                    //start run
                    rleCurrentRun = '{
                        length: 0,
                        line: rleKernelPos.y+1,
                        black: ~image[(rleKernelPos.y + 1) * 80][7]
                    };

                    rleKernelPos = '{ x: 0, y: rleKernelPos.y + 1 };
                end
                else rleKernelPos.x = rleKernelPos.x + 1;
            end
            
            rleKernelX = rleKernelX + 1;
        end

        //Frame End -> Reset after 200us
        else _wait = 57600;
    end

    VisionProcessor VisionProcessor(
        .CLK288(CLK288),
        .CLK200(CLK200),
        .runFIFOIn(runFIFOIn),
        .runFIFOWrite(runFIFOWrite),
        .target(target),
        .virtexConfig(cfg),
        .OUT_OF_BLOB_MEM_FAULT(),
        .OUT_OF_RLE_MEM_FAULT(),
        .BLOB_PROCESSOR_SLOW_FAULT(),
        .RUN_FIFO_FULL_FAULT()
    );

endmodule