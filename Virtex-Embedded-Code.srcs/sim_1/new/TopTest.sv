`timescale 1ns / 1ps
import Util::*;

/* TopTest - 

    */
module TopTest;

    //100MHz clock
    reg CLK = 0;
    always #5 CLK <= !CLK;

    reg enabled = 0;
    reg targetBlobValid = 0;
    Blob targetBlob;
    reg hasCommunication = 0;
    VirtexConfig virtexConfig = DefaultVirtexConfig;
    reg saveConfig = 0;
    ImageFrame imageFrame;

    

    // AppManagerTest AppManagerTest(
    //     .CLK(CLK),
    //     .configuration(configuration),
    //     .saveConfig(saveConfig),
    //     .imageFrame(imageFrame)
    // );
    // RoboRIOManagerTest RoboRIOManagerTest(CLK);
    // ConfigManagerTest ConfigManagerTest(CLK);
    // FlashManagerTest FlashManagerTest(CLK);
    // LEDManagerTest LEDManagerTest(CLK);
    // CameraManagerTest CameraManagerTest(CLK);
  
endmodule
