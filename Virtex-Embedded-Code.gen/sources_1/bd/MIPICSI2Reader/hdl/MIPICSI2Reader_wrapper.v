//Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
//Date        : Wed Jun  9 14:33:34 2021
//Host        : liams-desktop running 64-bit major release  (build 9200)
//Command     : generate_target MIPICSI2Reader_wrapper.bd
//Design      : MIPICSI2Reader_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module MIPICSI2Reader_wrapper
   (CLK,
    ENABLED,
    FID,
    MCLK_N,
    MCLK_P,
    MD_N,
    MD_P,
    OUT_ACTIVE_VIDEO,
    OUT_DATA,
    OUT_HBLANK,
    OUT_HSYNC,
    OUT_OVERFLOW,
    OUT_UNDERFLOW,
    OUT_VBLANK,
    OUT_VSYNC,
    RESET);
  input CLK;
  input ENABLED;
  input FID;
  input MCLK_N;
  input MCLK_P;
  input [1:0]MD_N;
  input [1:0]MD_P;
  output OUT_ACTIVE_VIDEO;
  output [7:0]OUT_DATA;
  output OUT_HBLANK;
  output OUT_HSYNC;
  output OUT_OVERFLOW;
  output OUT_UNDERFLOW;
  output OUT_VBLANK;
  output OUT_VSYNC;
  input RESET;

  wire CLK;
  wire ENABLED;
  wire FID;
  wire MCLK_N;
  wire MCLK_P;
  wire [1:0]MD_N;
  wire [1:0]MD_P;
  wire OUT_ACTIVE_VIDEO;
  wire [7:0]OUT_DATA;
  wire OUT_HBLANK;
  wire OUT_HSYNC;
  wire OUT_OVERFLOW;
  wire OUT_UNDERFLOW;
  wire OUT_VBLANK;
  wire OUT_VSYNC;
  wire RESET;

  MIPICSI2Reader MIPICSI2Reader_i
       (.CLK(CLK),
        .ENABLED(ENABLED),
        .FID(FID),
        .MCLK_N(MCLK_N),
        .MCLK_P(MCLK_P),
        .MD_N(MD_N),
        .MD_P(MD_P),
        .OUT_ACTIVE_VIDEO(OUT_ACTIVE_VIDEO),
        .OUT_DATA(OUT_DATA),
        .OUT_HBLANK(OUT_HBLANK),
        .OUT_HSYNC(OUT_HSYNC),
        .OUT_OVERFLOW(OUT_OVERFLOW),
        .OUT_UNDERFLOW(OUT_UNDERFLOW),
        .OUT_VBLANK(OUT_VBLANK),
        .OUT_VSYNC(OUT_VSYNC),
        .RESET(RESET));
endmodule
