`timescale 1ns / 1ps

/** CameraManagerParams - 

*/
package CameraManagerParams;

    //Default SYNC Channel Codes (Frame Sync + Data Classification)
    localparam FS = 8'haa; //frame start
    localparam FE = 8'hca; //frame end
    localparam LS = 8'h2a; //line start
    localparam LE = 8'h4a; //line end
    localparam BL = 8'h05; //black pixels
    localparam IMG = 8'h0d; //valid pixels
    localparam CRC = 8'h16; //checksum
    localparam TR = 8'he9; //training pattern for SYNC + DOUT
    localparam WN = 8'h00; //main window ID


    //SPI Commands
    typedef struct packed {
        logic [8:0] address;
        logic [0:15] word;
    } SPIWriteCommand;

    localparam SPIWriteCommandEndIndex = $bits(SPIWriteCommand) - 1;

    localparam SPIWriteCommand enableClockManagement1 [9] = '{
        '{2, 16'h0000}, // chip confirugre LVDS monochrome
        '{17, 16'h210f},    // configure PLL
        '{20, 16'h0000},    // configure internal clocking
        '{26, 16'h1180},    // configure PLL lock detector
        '{27, 16'hccbc},    // configure PLL lock detector
        '{32, 16'h400C},
        '{16, 16'h0003},    // PLL release soft reset
        '{8, 16'h0090},     // reset PLL lock detect
        '{8, 16'h0000}     // release PLL lock detect reset 
    };

    localparam SPIWriteCommand enableClockManagement2 [3] = '{
        '{9, 16'h0000},     // release clock generator soft reset
        '{32, 16'h400E},
        '{34, 16'h0001}    // enable logic clock
    };

    localparam SPIWriteCommand requiredRegisterUpload [133] = '{
        // power and bias config
        '{41, 16'h085f},
        '{42, 16'h4110},
        '{43, 16'h0008},
        '{65, 16'h383b},
        '{66, 16'h53c8},	// AFE_bias
        '{67, 16'h0665},	// mux_bias
        '{69, 16'h0088},	// ADC_bias
        '{68, 16'h0085},
        '{70, 16'h1111},
        '{72, 16'h0010},
        
        // black offset config
        '{128, 16'h3608},	// Black_offset
        '{197, 16'h0103},	// Black lines (3 black lines, 1 gated},
        '{129, 16'h8001},	// 8-bit mode - auto_black cal
        
        // auto exposure control config
        '{169, 16'h0800},	// AEC min gain configuration
        '{171, 16'h1002},	// AEC max gain configuration
        '{250, 16'h2081},	// AEC gain_stage_1 LUT - ZROT
        '{251, 16'h0f0f},	// AEC gain_stage_2 LUT part 1
        '{252, 16'h0f0f},	// AEC gain_stage_2 LUT part 2
        '{192, 16'h080c},	// Enable signal on monitor pins - ZROT
        
        // sequencer config
        '{192, 16'h080c},	// Enable signal on monitor pins - ZROT
        '{193, 16'h0000},	// XSM_delay
        '{194, 16'h02e4},	// Integration control
        '{201, 16'h0064},	// Exposure_0 1 ms
        '{232, 16'h0064},	// Exposure_1 1 ms
        
        // fr_length & mult_timer config (Python 300}, ZROT
        '{199, 16'h02c9},	// Mult_timer_0
        '{230, 16'h02c9},	// Mult_timer_1
        '{200, 16'h0074},	// Fr_length_0
        '{231, 16'h0074},	// Fr_length_1
        
        // gain config
        '{204, 16'h01e1},	// ZROT - Analog_gain_0 ([12:5]: AFE_gain // [4:0]: MUX_gain},
        '{235, 16'h01e1},	// ZROT - Analog_gain_1 ([12:5]: AFE_gain // [4:0]: MUX_gain},
        '{205, 16'h0080},	// Digital_gain_0
        '{236, 16'h0080},	// Digital_gain_1
        
        //////// program space ////////
        '{211, 16'h0e49},   // no mux
        '{215, 16'h111f},
        '{216, 16'h7f00},
        '{219, 16'h0020},
        '{224, 16'h3e5e},

        //////// FOT program space ////////
        '{384, 16'hC800},
        '{385, 16'hFB1F},
        '{386, 16'hFB1F},
        '{387, 16'hFB12},
        '{388, 16'hF903},
        '{389, 16'hF802},
        '{390, 16'hF30F},
        '{391, 16'hF30F},
        '{392, 16'hF30F},
        '{393, 16'hF30A},
        '{394, 16'hF101},
        '{395, 16'hF00A},
        '{396, 16'hF24B},
        '{397, 16'hF226},
        '{398, 16'hF001},
        '{399, 16'hF402},
        '{400, 16'hF001},
        '{401, 16'hF402},
        '{402, 16'hF001},
        '{403, 16'hF401},
        '{404, 16'hF007},
        '{405, 16'hF20F},
        '{406, 16'hF20F},
        '{407, 16'hF202},
        '{408, 16'hF006},
        '{409, 16'hEC02},
        '{410, 16'hE801},
        '{411, 16'hEC02},
        '{412, 16'hE801},
        '{413, 16'hEC02},
        '{414, 16'hC801},
        '{415, 16'hC800},
        '{416, 16'hC800},
        '{417, 16'hCC02},
        '{418, 16'hC801},
        '{419, 16'hCC02},
        '{420, 16'hC801},
        '{421, 16'hCC02},
        '{422, 16'hC805},
        '{423, 16'hC800},

        //////// ROT program space - no mux - ZROT ////////
        '{220, 16'h3a28},
        '{222, 16'h624c},
        
        // Image
        '{424, 16'h0030},	// 16'h28
        '{425, 16'h207C},
        '{426, 16'h2071},
        '{427, 16'h0074},
        '{428, 16'h107F},
        '{429, 16'h1072},
        '{430, 16'h1074},
        '{431, 16'h0076},
        '{432, 16'h0031},
        '{433, 16'h21BB},
        '{434, 16'h20B1},
        '{435, 16'h20B1},
        '{436, 16'h00B1},
        '{437, 16'h10BF},
        '{438, 16'h10B2},
        '{439, 16'h10B4},
        '{440, 16'h00B1},
        '{441, 16'h0030},
        
        // Black
        '{442, 16'h0030},	// 16'h3a
        '{443, 16'h217B},
        '{444, 16'h2072},
        '{445, 16'h0074},
        '{446, 16'h107F},
        '{447, 16'h1072},
        '{448, 16'h1074},
        '{449, 16'h0076},
        '{450, 16'h0031},
        '{451, 16'h20BB},
        '{452, 16'h20B1},
        '{453, 16'h20B1},
        '{454, 16'h00B1},
        '{455, 16'h10BF},
        '{456, 16'h10B2},
        '{457, 16'h10B4},
        '{458, 16'h00B1},
        '{459, 16'h0030},
        
        // Gray
        '{460, 16'h0030},	// 16'h4c
        '{461, 16'h207C},
        '{462, 16'h2071},
        '{463, 16'h0074},
        '{464, 16'h1073},
        '{465, 16'h1072},
        '{466, 16'h1072},
        '{467, 16'h0076},
        '{468, 16'h0031},
        '{469, 16'h21BB},
        '{470, 16'h20B1},
        '{471, 16'h20B1},
        '{472, 16'h00B1},
        '{473, 16'h10BF},
        '{474, 16'h10BF},
        '{475, 16'h10B5},
        '{476, 16'h00B1},
        '{477, 16'h0030}
    };

    localparam SPIWriteCommand softPowerUp [8] = '{
        '{32, 16'h400F},	// Enable analog clock
        '{10, 16'h0000},	// Release soft reset state
        '{64, 16'h0001},	// Enable biasing block
        '{72, 16'h0017},	// Enable charge pump
        '{40, 16'h0003},	// Enable column multiplexer
        '{42, 16'h4113},	// Configure image core
        '{48, 16'h0001},	// Enable AFE
        '{112, 16'h0007}	// Enable LVDS transmitters
    };

    localparam SPIWriteCommand powerUpSequenceRegisterUpload [144] = {enableClockManagement2, requiredRegisterUpload, softPowerUp};

    localparam SPIWriteCommand softPowerDown [6:0] = '{
        '{112, 16'h0000},	// Disable LVDS transmitters
        '{48, 16'h0000},	// Disable AFE
        '{32, 16'h700E},	// Disable analog clock
        '{40, 16'h0000},	// Disable column multiplexer
        '{72, 16'h0010},	// Disable charge pump
        '{64, 16'h0000},	// Disable biasing block
        '{10, 16'h0999}	// Soft reset
    };

    localparam SPIWriteCommand enableSequencer = '{192, 16'h080D}; //master pipelined ZROT mode

    localparam SPIWriteCommand disableSequencer = '{192, 16'h0800};

    localparam SPIWriteCommand enableDisableSequencer [2] = {disableSequencer, enableSequencer};

    localparam checkPLLLockStatus = 9'd24;
endpackage