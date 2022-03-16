// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
// Date        : Tue Mar 15 21:52:02 2022
// Host        : RISC-IV running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/liams/Documents/GitHub/Virtex-Embedded-Code/Virtex-Embedded-Code.gen/sources_1/ip/fifo_python_to_blob/fifo_python_to_blob_stub.v
// Design      : fifo_python_to_blob
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tftg256-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_2_5,Vivado 2021.1" *)
module fifo_python_to_blob(wr_clk, rd_clk, din, wr_en, rd_en, dout, full, empty)
/* synthesis syn_black_box black_box_pad_pin="wr_clk,rd_clk,din[27:0],wr_en,rd_en,dout[27:0],full,empty" */;
  input wr_clk;
  input rd_clk;
  input [27:0]din;
  input wr_en;
  input rd_en;
  output [27:0]dout;
  output full;
  output empty;
endmodule
