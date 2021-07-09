//Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
//Date        : Mon Jun 28 22:33:31 2021
//Host        : liams-desktop running 64-bit major release  (build 9200)
//Command     : generate_target MIPICSI2Reader_wrapper.bd
//Design      : MIPICSI2Reader_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module MIPICSI2Reader_wrapper
   (CLK,
    CLK200,
    ENABLED,
    MC_HSN,
    MC_HSP,
    MC_LPN,
    MC_LPP,
    MD_HSN,
    MD_HSP,
    MD_LPN,
    MD_LPP,
    RESET,
    TDATA,
    TDEST,
    TLAST,
    TUSER,
    TVALID);
  input CLK;
  output CLK200;
  input ENABLED;
  input MC_HSN;
  input MC_HSP;
  input MC_LPN;
  input MC_LPP;
  input [1:0]MD_HSN;
  input [1:0]MD_HSP;
  input [1:0]MD_LPN;
  input [1:0]MD_LPP;
  input RESET;
  output [7:0]TDATA;
  output [9:0]TDEST;
  output TLAST;
  output [63:0]TUSER;
  output TVALID;

  wire CLK;
  wire CLK200;
  wire ENABLED;
  wire MC_HSN;
  wire MC_HSP;
  wire MC_LPN;
  wire MC_LPP;
  wire [1:0]MD_HSN;
  wire [1:0]MD_HSP;
  wire [1:0]MD_LPN;
  wire [1:0]MD_LPP;
  wire RESET;
  wire [7:0]TDATA;
  wire [9:0]TDEST;
  wire TLAST;
  wire [63:0]TUSER;
  wire TVALID;

  MIPICSI2Reader MIPICSI2Reader_i
       (.CLK(CLK),
        .CLK200(CLK200),
        .ENABLED(ENABLED),
        .MC_HSN(MC_HSN),
        .MC_HSP(MC_HSP),
        .MC_LPN(MC_LPN),
        .MC_LPP(MC_LPP),
        .MD_HSN(MD_HSN),
        .MD_HSP(MD_HSP),
        .MD_LPN(MD_LPN),
        .MD_LPP(MD_LPP),
        .RESET(RESET),
        .TDATA(TDATA),
        .TDEST(TDEST),
        .TLAST(TLAST),
        .TUSER(TUSER),
        .TVALID(TVALID));
endmodule
