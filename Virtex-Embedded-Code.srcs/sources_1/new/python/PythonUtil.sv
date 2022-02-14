`timescale 1ns / 1ps

/** PythonUtil -  */
`ifndef PythonUtil_DONE
`define PythonUtil_DONE

`include "../util/Constants.sv"
`include "../util/Math.sv"

//8-bit Kernel
typedef struct packed {
    logic [7:0] value; //threshold
    Vector pos; //(0, 0) to (79, 479)
    logic valid;
} Kernel;
localparam KERNEL_MAX_X = IMAGE_WIDTH / 8 - 1;

//Default SYNC Channel Codes (Frame Sync + Data Classification)
localparam PYTHON_SYNC_FRAME_START = 8'haa;
localparam PYTHON_SYNC_FRAME_END = 8'hca;
localparam PYTHON_SYNC_LINE_START = 8'h2a;
localparam PYTHON_SYNC_LINE_END = 8'h4a;
localparam PYTHON_SYNC_BLACK = 8'h05; //black pixels
localparam PYTHON_SYNC_IMAGE = 8'h0d; //valid pixels
localparam PYTHON_SYNC_CRC = 8'h16; //checksum
localparam PYTHON_SYNC_MAIN_WINDOW_ID = 8'h00;
localparam PYTHON_TRAINING_PATTERN = 8'he9; //training pattern for SYNC + DOUT

//SPI Commands
typedef struct packed {
    logic [8:0] address;
    logic readWrite; //1 for write
    logic [0:15] word;
} PythonSPICommand;
localparam PythonSPICommandEndIndex = $bits(PythonSPICommand) - 1;

localparam PythonSPICommand enableSequencer = '{192, 1, 16'h080D}; //master pipelined ZROT mode
localparam PythonSPICommand disableSequencer = '{192, 1, 16'h0800};

localparam PythonSPICommand checkPLLLockStatus = '{9'd24, 0, 0};

localparam logic [8:0] setBlackOffsetAddress = 128;
localparam logic [8:0] setAnalogGainAddress = 204;
localparam logic [8:0] setDigitalGainAddress = 205;
localparam logic [8:0] setExposureAddress = 201;

localparam PythonSPICommand enableClockManagement1 [9] = '{
    '{2, 1, 16'h0000},     // chip confirugre LVDS monochrome
    '{17, 1, 16'h210f},    // configure PLL
    '{20, 1, 16'h0000},    // configure internal clocking
    '{26, 1, 16'h1180},    // configure PLL lock detector
    '{27, 1, 16'hccbc},    // configure PLL lock detector
    '{32, 1, 16'h400C},
    '{16, 1, 16'h0003},    // PLL release soft reset
    '{8, 1, 16'h0090},     // reset PLL lock detect
    '{8, 1, 16'h0000}      // release PLL lock detect reset 
};

localparam PythonSPICommand enableClockManagement2 [3] = '{
    '{9, 1, 16'h0000},     // release clock generator soft reset
    '{32, 1, 16'h400E},
    '{34, 1, 16'h0001}     // enable logic clock
};

localparam PythonSPICommand requiredRegisterUpload [133] = '{
    // power and bias config
    '{41, 1, 16'h085f},
    '{42, 1, 16'h4110},
    '{43, 1, 16'h0008},
    '{65, 1, 16'h383b},
    '{66, 1, 16'h53c8},	// AFE_bias
    '{67, 1, 16'h0665},	// mux_bias
    '{69, 1, 16'h0088},	// ADC_bias
    '{68, 1, 16'h0085},
    '{70, 1, 16'h1111},
    '{72, 1, 16'h0010},
    
    // black offset config
    '{setBlackOffsetAddress, 1, {1'b0, 4'd8, 3'b0, 8'd8}}, //duplicated in DefaultVirtexConfig
    '{197, 1, 16'h0102},	// Black lines (2 black lines, 1 gated)
    '{129, 1, 16'h8001},	// 8-bit mode - auto_black cal
    
    // AEC config
    '{160, 1, 16'h0010},    // disable AEC
    '{169, 1, 16'h0800},	// AEC min gain configuration
    '{171, 1, 16'h1002},	// AEC max gain configuration
    '{250, 1, 16'h2081},	// AEC gain_stage_1 LUT - ZROT
    '{251, 1, 16'h0f0f},	// AEC gain_stage_2 LUT part 1
    '{252, 1, 16'h0f0f},	// AEC gain_stage_2 LUT part 2
    
    // sequencer config
    disableSequencer,
    '{193, 1, 16'h0000},	// XSM_delay (use if you want to force sequential mode instead of pipelined)
    '{194, 1, 16'h02e4},	// Integration control (ft_mode = 1)
    '{setExposureAddress, 1, 30000},	// Exposure_0 1 ms (following frames) //duplicated in DefaultVirtexConfig
    '{232, 1, 30000},	// Exposure_1 1 ms (current frame) //duplicated in DefaultVirtexConfig
    
    // fr_length & mult_timer config (Python 300}, ZROT
    //NOTE: find with "PYTHON Frame Rate Calculator V3.0" & "python300.ini"
    '{199, 1, 16'd2},	    // Mult_timer_0 (following frames)
    '{230, 1, 16'd2},	    // Mult_timer_1 (current frame)
    '{200, 1, 16'd41500},	// Fr_length_0 (following frames)
    '{231, 1, 16'd41500},	// Fr_length_1 (current frame)
    
    // gain config
    '{setAnalogGainAddress, 1, {2'b0, 1'b0, 8'd15, 5'd1}},	// Analog_gain_0 (following frames) //duplicated in DefaultVirtexConfig
    '{235, 1, {2'b0, 1'b0, 8'd15, 5'd1}},	// Analog_gain_1 (current frame) //duplicated in DefaultVirtexConfig
    '{setDigitalGainAddress, 1, 128},	// Digital_gain_0 (following frames) //duplicated in DefaultVirtexConfig
    '{236, 1, 128},	// Digital_gain_1 (current frame) //duplicated in DefaultVirtexConfig
    
    //////// program space ////////
    '{211, 1, 16'h0e49},   // no mux
    '{215, 1, 16'h111f},
    '{216, 1, 16'h7f00},
    '{219, 1, 16'h0020},
    '{224, 1, 16'h3e5e},

    //////// FOT program space ////////
    '{384, 1, 16'hC800},
    '{385, 1, 16'hFB1F},
    '{386, 1, 16'hFB1F},
    '{387, 1, 16'hFB12},
    '{388, 1, 16'hF903},
    '{389, 1, 16'hF802},
    '{390, 1, 16'hF30F},
    '{391, 1, 16'hF30F},
    '{392, 1, 16'hF30F},
    '{393, 1, 16'hF30A},
    '{394, 1, 16'hF101},
    '{395, 1, 16'hF00A},
    '{396, 1, 16'hF24B},
    '{397, 1, 16'hF226},
    '{398, 1, 16'hF001},
    '{399, 1, 16'hF402},
    '{400, 1, 16'hF001},
    '{401, 1, 16'hF402},
    '{402, 1, 16'hF001},
    '{403, 1, 16'hF401},
    '{404, 1, 16'hF007},
    '{405, 1, 16'hF20F},
    '{406, 1, 16'hF20F},
    '{407, 1, 16'hF202},
    '{408, 1, 16'hF006},
    '{409, 1, 16'hEC02},
    '{410, 1, 16'hE801},
    '{411, 1, 16'hEC02},
    '{412, 1, 16'hE801},
    '{413, 1, 16'hEC02},
    '{414, 1, 16'hC801},
    '{415, 1, 16'hC800},
    '{416, 1, 16'hC800},
    '{417, 1, 16'hCC02},
    '{418, 1, 16'hC801},
    '{419, 1, 16'hCC02},
    '{420, 1, 16'hC801},
    '{421, 1, 16'hCC02},
    '{422, 1, 16'hC805},
    '{423, 1, 16'hC800},

    //////// ROT program space - no mux - ZROT ////////
    '{220, 1, 16'h3a28},
    '{222, 1, 16'h624c},
    
    // Image
    '{424, 1, 16'h0030},	// 16'h28
    '{425, 1, 16'h207C},
    '{426, 1, 16'h2071},
    '{427, 1, 16'h0074},
    '{428, 1, 16'h107F},
    '{429, 1, 16'h1072},
    '{430, 1, 16'h1074},
    '{431, 1, 16'h0076},
    '{432, 1, 16'h0031},
    '{433, 1, 16'h21BB},
    '{434, 1, 16'h20B1},
    '{435, 1, 16'h20B1},
    '{436, 1, 16'h00B1},
    '{437, 1, 16'h10BF},
    '{438, 1, 16'h10B2},
    '{439, 1, 16'h10B4},
    '{440, 1, 16'h00B1},
    '{441, 1, 16'h0030},
    
    // Black
    '{442, 1, 16'h0030},	// 16'h3a
    '{443, 1, 16'h217B},
    '{444, 1, 16'h2072},
    '{445, 1, 16'h0074},
    '{446, 1, 16'h107F},
    '{447, 1, 16'h1072},
    '{448, 1, 16'h1074},
    '{449, 1, 16'h0076},
    '{450, 1, 16'h0031},
    '{451, 1, 16'h20BB},
    '{452, 1, 16'h20B1},
    '{453, 1, 16'h20B1},
    '{454, 1, 16'h00B1},
    '{455, 1, 16'h10BF},
    '{456, 1, 16'h10B2},
    '{457, 1, 16'h10B4},
    '{458, 1, 16'h00B1},
    '{459, 1, 16'h0030},
    
    // Gray
    '{460, 1, 16'h0030},	// 16'h4c
    '{461, 1, 16'h207C},
    '{462, 1, 16'h2071},
    '{463, 1, 16'h0074},
    '{464, 1, 16'h1073},
    '{465, 1, 16'h1072},
    '{466, 1, 16'h1072},
    '{467, 1, 16'h0076},
    '{468, 1, 16'h0031},
    '{469, 1, 16'h21BB},
    '{470, 1, 16'h20B1},
    '{471, 1, 16'h20B1},
    '{472, 1, 16'h00B1},
    '{473, 1, 16'h10BF},
    '{474, 1, 16'h10BF},
    '{475, 1, 16'h10B5},
    '{476, 1, 16'h00B1},
    '{477, 1, 16'h0030}
};

localparam PythonSPICommand softPowerUp [8] = '{
    '{32, 1, 16'h400F},	// Enable analog clock
    '{10, 1, 16'h0000},	// Release soft reset state
    '{64, 1, 16'h0001},	// Enable biasing block
    '{72, 1, 16'h0017},	// Enable charge pump
    '{40, 1, 16'h0003},	// Enable column multiplexer
    '{42, 1, 16'h4113},	// Configure image core
    '{48, 1, 16'h0001},	// Enable AFE
    '{112, 1, 16'h0007}	// Enable LVDS transmitters
};

localparam PythonSPICommand powerUpSequenceRegisterUpload [144] = {enableClockManagement2, requiredRegisterUpload, softPowerUp};

localparam PythonSPICommand softPowerDown [6:0] = '{
    '{112, 1, 16'h0000}, // Disable LVDS transmitters
    '{48, 1, 16'h0000},	 // Disable AFE
    '{32, 1, 16'h700E},	 // Disable analog clock
    '{40, 1, 16'h0000},	 // Disable column multiplexer
    '{72, 1, 16'h0010},	 // Disable charge pump
    '{64, 1, 16'h0000},	 // Disable biasing block
    '{10, 1, 16'h0999}	 // Soft reset
};

localparam PythonSPICommand enableDisableSequencer [2] = {disableSequencer, enableSequencer};

`endif