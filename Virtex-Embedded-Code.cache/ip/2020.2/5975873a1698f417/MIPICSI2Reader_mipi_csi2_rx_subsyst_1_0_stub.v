// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Mon Jun 28 22:34:58 2021
// Host        : liams-desktop running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ MIPICSI2Reader_mipi_csi2_rx_subsyst_1_0_stub.v
// Design      : MIPICSI2Reader_mipi_csi2_rx_subsyst_1_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tftg256-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "bd_2647,Vivado 2020.2" *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(dphy_clk_200M, rxbyteclkhs, system_rst_out, 
  video_aclk, video_aresetn, ctrl_core_en, ctrl_dis_in_prgs, errsotsynchs_intr, 
  errsoths_intr, cl_stopstate_intr, dl0_stopstate_intr, dl1_stopstate_intr, 
  crc_status_intr, ecc_status_intr, linebuffer_full, frame_rcvd_pulse_out, video_out_tdata, 
  video_out_tdest, video_out_tlast, video_out_tready, video_out_tuser, video_out_tvalid, 
  mipi_phy_if_clk_hs_n, mipi_phy_if_clk_hs_p, mipi_phy_if_clk_lp_n, mipi_phy_if_clk_lp_p, 
  mipi_phy_if_data_hs_n, mipi_phy_if_data_hs_p, mipi_phy_if_data_lp_n, 
  mipi_phy_if_data_lp_p)
/* synthesis syn_black_box black_box_pad_pin="dphy_clk_200M,rxbyteclkhs,system_rst_out,video_aclk,video_aresetn,ctrl_core_en,ctrl_dis_in_prgs,errsotsynchs_intr,errsoths_intr,cl_stopstate_intr,dl0_stopstate_intr,dl1_stopstate_intr,crc_status_intr,ecc_status_intr[1:0],linebuffer_full,frame_rcvd_pulse_out,video_out_tdata[7:0],video_out_tdest[9:0],video_out_tlast,video_out_tready,video_out_tuser[63:0],video_out_tvalid,mipi_phy_if_clk_hs_n,mipi_phy_if_clk_hs_p,mipi_phy_if_clk_lp_n,mipi_phy_if_clk_lp_p,mipi_phy_if_data_hs_n[1:0],mipi_phy_if_data_hs_p[1:0],mipi_phy_if_data_lp_n[1:0],mipi_phy_if_data_lp_p[1:0]" */;
  input dphy_clk_200M;
  output rxbyteclkhs;
  output system_rst_out;
  input video_aclk;
  input video_aresetn;
  input ctrl_core_en;
  output ctrl_dis_in_prgs;
  output errsotsynchs_intr;
  output errsoths_intr;
  output cl_stopstate_intr;
  output dl0_stopstate_intr;
  output dl1_stopstate_intr;
  output crc_status_intr;
  output [1:0]ecc_status_intr;
  output linebuffer_full;
  output frame_rcvd_pulse_out;
  output [7:0]video_out_tdata;
  output [9:0]video_out_tdest;
  output video_out_tlast;
  input video_out_tready;
  output [63:0]video_out_tuser;
  output video_out_tvalid;
  input mipi_phy_if_clk_hs_n;
  input mipi_phy_if_clk_hs_p;
  input mipi_phy_if_clk_lp_n;
  input mipi_phy_if_clk_lp_p;
  input [1:0]mipi_phy_if_data_hs_n;
  input [1:0]mipi_phy_if_data_hs_p;
  input [1:0]mipi_phy_if_data_lp_n;
  input [1:0]mipi_phy_if_data_lp_p;
endmodule
