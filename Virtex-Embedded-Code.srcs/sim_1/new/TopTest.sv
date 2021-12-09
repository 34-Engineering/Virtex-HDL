`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 34 Engineering
// Engineer: Liam Snow
// 
// Create Date: 12/6/2021
// Module Name: TopTest
// Project Name: Virtex
// 
//////////////////////////////////////////////////////////////////////////////////

module TopTest;

  //100MHz clock
  reg CLK = 0;
  always #5 CLK <= !CLK;
  
  AppManagerTest AppManagerTest(CLK);
  RoboRIOManagerTest RoboRIOManagerTest(CLK);
  ConfigManagerTest ConfigManagerTest(CLK);
  FlashManagerTest FlashManagerTest(CLK);
  LEDManagerTest LEDManagerTest(CLK);
  CameraManagerTest CameraManagerTest(CLK);
  
endmodule
