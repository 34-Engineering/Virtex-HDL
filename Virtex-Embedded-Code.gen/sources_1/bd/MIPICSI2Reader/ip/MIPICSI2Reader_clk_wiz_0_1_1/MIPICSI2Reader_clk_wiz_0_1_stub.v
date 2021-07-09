// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Mon Jun 28 22:34:11 2021
// Host        : liams-desktop running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/liamsnow/Documents/GitHub/Virtex-Embedded-Code/Virtex-Embedded-Code.gen/sources_1/bd/MIPICSI2Reader/ip/MIPICSI2Reader_clk_wiz_0_1_1/MIPICSI2Reader_clk_wiz_0_1_stub.v
// Design      : MIPICSI2Reader_clk_wiz_0_1
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tftg256-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module MIPICSI2Reader_clk_wiz_0_1(clk_out1, clk_in1)
/* synthesis syn_black_box black_box_pad_pin="clk_out1,clk_in1" */;
  output clk_out1;
  input clk_in1;
endmodule
