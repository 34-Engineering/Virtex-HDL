// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
// Date        : Mon Mar  7 22:41:55 2022
// Host        : RISC-IV running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/liams/Documents/GitHub/Virtex-Embedded-Code/Virtex-Embedded-Code.gen/sources_1/ip/blk_mem_blobs/blk_mem_blobs_stub.v
// Design      : blk_mem_blobs
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tftg256-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2021.1" *)
module blk_mem_blobs(clka, wea, addra, dina, douta, clkb, web, addrb, dinb, 
  doutb)
/* synthesis syn_black_box black_box_pad_pin="clka,wea[0:0],addra[10:0],dina[143:0],douta[143:0],clkb,web[0:0],addrb[10:0],dinb[143:0],doutb[143:0]" */;
  input clka;
  input [0:0]wea;
  input [10:0]addra;
  input [143:0]dina;
  output [143:0]douta;
  input clkb;
  input [0:0]web;
  input [10:0]addrb;
  input [143:0]dinb;
  output [143:0]doutb;
endmodule
