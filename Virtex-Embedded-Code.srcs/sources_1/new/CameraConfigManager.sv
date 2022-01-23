`timescale 1ns / 1ps

/* CameraConfigManager - manages register upload & enabling/disabling the sequencer over SPI to the Python 300
    Python 300 Docs: https://www.onsemi.com/pdf/datasheet/noip1sn1300a-d.pdf
    
    Power Up Sequence
     - Enable Clock Management 1 & 2 (initialized the sensor for operation)
        - to transition from 1 to 2 you loop until DevRead16(0, 24) != 0 // check PLL lock status
     - Required Register Upload (sets values of registers for power control and misc. functions)
     - Soft Power Up (turns on biases etc; internal power control)
     - Set imaging mode
       - CDS + ZROT...Pipelined Master

    Power Down Sequence TODO How can we do this/should we do this?
     - Disable Sequencer
     - Soft Power Down
     - Disable Clock Management

    10MHz
    9-bit address, 16-bit words
    10th bit = r/w
    MSB first
    Some registers can only be changed while the sequencer is disabled

    
     */
module CameraConfigManager(
    input wire CLK,
    output wire SPI_CS, //active low
    output wire SPI_MOSI,
    input wire SPI_MISO,
    output wire SPI_CLK,
    output wire TRIGGER,
    input wire MONITOR,
    output wire reset, //active low
    input wire sequencerEnabled
    );

    reg [25:0] writeData;
    reg writeDataValid;
    wire writeQueueEmpty;
    wire [7:0] readData;
    wire readDataValid;
    //TODO SPIMaster SPI();
    task write(logic [8:0] address, logic [15:0] word);
        writeData = {address, 1'b1, word};
        writeDataValid = 1;
        writeDataValid = 0;
    endtask
    task read(logic [8:0] address);
        writeData = {address, 1'b0};
        writeDataValid = 1;
        writeDataValid = 0;
    endtask

    //Power Up Sequence
    reg poweredUpSequenceStage = 0;
    initial begin
        enableClockManagement1();
        read(9'd24); //TODO is this hex?
    end
    always @ (posedge CLK) begin //TODO SPI CLK
        //check PLL lock status
        if (!poweredUpSequenceStage & readDataValid & readData != 0) begin
            enableClockManagement2();
            requiredRegisterUpload();
            softPowerUp();
            setImagineMode();
            poweredUpSequenceStage <= 1;
        end
    end

    //Enable/Disable Sequencer
    reg waitingToEnableSequencer = 0;
    always @ (posedge sequencerEnabled or negedge sequencerEnabled) begin
        if (sequencerEnabled & poweredUpSequenceStage) begin
            //see note about poweredUpSequenceStage below
            //enable sequencer
            write(192, 16'h080D);
        end
        else if (sequencerEnabled) begin
            //trying to enable the sequencer, but power up has not finished
            //so enable it when we can
            waitingToEnableSequencer <= 1;
        end
        else begin
            //disable sequencer
            write(192, 16'h0800);
        end
    end
    always @ (posedge CLK) begin
        //if waiting to enable sequencer & power up has finished
        /*Note: even tho poweredUpSequenceStage = 1 doesnt mean power up has finished, this
          will be added to end of the write queue (behind all the power up commands) so
          it will occur as intentended */
        if (waitingToEnableSequencer & poweredUpSequenceStage) begin
            //enable sequencer
            write(192, 16'h080D);
            waitingToEnableSequencer <= 0;
        end
    end

    //TODO reorganize into array or ?
    task enableClockManagement1();
        write(2, 16'h0000);     // chip confirugre LVDS monochrome
        write(17, 16'h210f);    // configure PLL
        write(20, 16'h0000);    // configure internal clocking
        write(26, 16'h1180);    // configure PLL lock detector
        write(27, 16'hccbc);    // configure PLL lock detector
        write(32, 16'h400C);
        write(16, 16'h0003);    // PLL release soft reset
        write(8, 16'h0090);     // reset PLL lock detect
        write(8, 16'h0000);     // release PLL lock detect reset 
    endtask

    task enableClockManagement2();
        write(9, 16'h0000);     // release clock generator soft reset
        write(32, 16'h400E);
        write(34, 16'h0001);    // enable logic clock
    endtask

    task requiredRegisterUpload();
        // power and bias config
        write(41, 16'h085f);
        write(42, 16'h4110);
        write(43, 16'h0008);
        write(65, 16'h383b);
        write(66, 16'h53c8);	// AFE_bias
        write(67, 16'h0665);	// mux_bias
        write(69, 16'h0088);	// ADC_bias
        write(68, 16'h0085);
        write(70, 16'h1111);
        write(72, 16'h0010);
        
        // black offset config
        write(128, 16'h3608);	// Black_offset
        write(197, 16'h0103);	// Black lines (3 black lines, 1 gated);
        write(129, 16'h8001);	// 8-bit mode - auto_black cal
        
        // auto exposure control config
        write(169, 16'h0800);	// AEC min gain configuration
        write(171, 16'h1002);	// AEC max gain configuration
        write(250, 16'h2081);	// AEC gain_stage_1 LUT - ZROT
        write(251, 16'h0f0f);	// AEC gain_stage_2 LUT part 1
        write(252, 16'h0f0f);	// AEC gain_stage_2 LUT part 2
        write(192, 16'h080c);	// Enable signal on monitor pins - ZROT
        
        // sequencer config
        write(192, 16'h080c);	// Enable signal on monitor pins - ZROT
        write(193, 16'h0000);	// XSM_delay
        write(194, 16'h02e4);	// Integration control
        write(201, 16'h0064);	// Exposure_0 1 ms
        write(232, 16'h0064);	// Exposure_1 1 ms
        
        // fr_length & mult_timer config (Python 300); ZROT
        write(199, 16'h02c9);	// Mult_timer_0
        write(230, 16'h02c9);	// Mult_timer_1
        write(200, 16'h0074);	// Fr_length_0
        write(231, 16'h0074);	// Fr_length_1
        
        // gain config
        write(204, 16'h01e1);	// ZROT - Analog_gain_0 ([12:5]: AFE_gain // [4:0]: MUX_gain);
        write(235, 16'h01e1);	// ZROT - Analog_gain_1 ([12:5]: AFE_gain // [4:0]: MUX_gain);
        write(205, 16'h0080);	// Digital_gain_0
        write(236, 16'h0080);	// Digital_gain_1
        
        //////// program space ////////
        write(211, 16'h0e49);   // no mux
        write(215, 16'h111f);
        write(216, 16'h7f00);
        write(219, 16'h0020);
        write(224, 16'h3e5e);

        //////// FOT program space ////////
        write(384, 16'hC800);
        write(385, 16'hFB1F);
        write(386, 16'hFB1F);
        write(387, 16'hFB12);
        write(388, 16'hF903);
        write(389, 16'hF802);
        write(390, 16'hF30F);
        write(391, 16'hF30F);
        write(392, 16'hF30F);
        write(393, 16'hF30A);
        write(394, 16'hF101);
        write(395, 16'hF00A);
        write(396, 16'hF24B);
        write(397, 16'hF226);
        write(398, 16'hF001);
        write(399, 16'hF402);
        write(400, 16'hF001);
        write(401, 16'hF402);
        write(402, 16'hF001);
        write(403, 16'hF401);
        write(404, 16'hF007);
        write(405, 16'hF20F);
        write(406, 16'hF20F);
        write(407, 16'hF202);
        write(408, 16'hF006);
        write(409, 16'hEC02);
        write(410, 16'hE801);
        write(411, 16'hEC02);
        write(412, 16'hE801);
        write(413, 16'hEC02);
        write(414, 16'hC801);
        write(415, 16'hC800);
        write(416, 16'hC800);
        write(417, 16'hCC02);
        write(418, 16'hC801);
        write(419, 16'hCC02);
        write(420, 16'hC801);
        write(421, 16'hCC02);
        write(422, 16'hC805);
        write(423, 16'hC800);

        //////// ROT program space - no mux - ZROT ////////
        write(220, 16'h3a28);
        write(222, 16'h624c);
        
        // Image
        write(424, 16'h0030);	// 16'h28
        write(425, 16'h207C);
        write(426, 16'h2071);
        write(427, 16'h0074);
        write(428, 16'h107F);
        write(429, 16'h1072);
        write(430, 16'h1074);
        write(431, 16'h0076);
        write(432, 16'h0031);
        write(433, 16'h21BB);
        write(434, 16'h20B1);
        write(435, 16'h20B1);
        write(436, 16'h00B1);
        write(437, 16'h10BF);
        write(438, 16'h10B2);
        write(439, 16'h10B4);
        write(440, 16'h00B1);
        write(441, 16'h0030);
        
        // Black
        write(442, 16'h0030);	// 16'h3a
        write(443, 16'h217B);
        write(444, 16'h2072);
        write(445, 16'h0074);
        write(446, 16'h107F);
        write(447, 16'h1072);
        write(448, 16'h1074);
        write(449, 16'h0076);
        write(450, 16'h0031);
        write(451, 16'h20BB);
        write(452, 16'h20B1);
        write(453, 16'h20B1);
        write(454, 16'h00B1);
        write(455, 16'h10BF);
        write(456, 16'h10B2);
        write(457, 16'h10B4);
        write(458, 16'h00B1);
        write(459, 16'h0030);
        
        // Gray
        write(460, 16'h0030);	// 16'h4c
        write(461, 16'h207C);
        write(462, 16'h2071);
        write(463, 16'h0074);
        write(464, 16'h1073);
        write(465, 16'h1072);
        write(466, 16'h1072);
        write(467, 16'h0076);
        write(468, 16'h0031);
        write(469, 16'h21BB);
        write(470, 16'h20B1);
        write(471, 16'h20B1);
        write(472, 16'h00B1);
        write(473, 16'h10BF);
        write(474, 16'h10BF);
        write(475, 16'h10B5);
        write(476, 16'h00B1);
        write(477, 16'h0030);
    endtask

    task softPowerUp();
        write(32, 16'h400F);	// Enable analog clock
        write(10, 16'h0000);	// Release soft reset state
        write(64, 16'h0001);	// Enable biasing block
        write(72, 16'h0017);	// Enable charge pump
        write(40, 16'h0003);	// Enable column multiplexer
        write(42, 16'h4113);	// Configure image core
        write(48, 16'h0001);	// Enable AFE
        write(112, 16'h0007);	// Enable LVDS transmitters
    endtask

    task softPowerDown();
        write(112, 16'h0000);	// Disable LVDS transmitters
        write(48, 16'h0000);	// Disable AFE
        write(32, 16'h700E);	// Disable analog clock
        write(40, 16'h0000);	// Disable column multiplexer
        write(72, 16'h0010);	// Disable charge pump
        write(64, 16'h0000);	// Disable biasing block
        write(10, 16'h0999);	// Soft reset
    endtask

    task setImagineMode();
        //TODO configure master pipelined
    endtask
endmodule