// (c) Copyright 1995-2021 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: xilinx.com:ip:mipi_csi2_rx_subsystem:5.1
// IP Revision: 0

`timescale 1ns/1ps

(* DowngradeIPIdentifiedWarnings = "yes" *)
module MIPICSI2Reader_mipi_csi2_rx_subsyst_1_0 (
  dphy_clk_200M,
  rxbyteclkhs,
  system_rst_out,
  video_aclk,
  video_aresetn,
  ctrl_core_en,
  ctrl_dis_in_prgs,
  errsotsynchs_intr,
  errsoths_intr,
  cl_stopstate_intr,
  dl0_stopstate_intr,
  dl1_stopstate_intr,
  crc_status_intr,
  ecc_status_intr,
  linebuffer_full,
  frame_rcvd_pulse_out,
  video_out_tdata,
  video_out_tdest,
  video_out_tlast,
  video_out_tready,
  video_out_tuser,
  video_out_tvalid,
  mipi_phy_if_clk_hs_n,
  mipi_phy_if_clk_hs_p,
  mipi_phy_if_clk_lp_n,
  mipi_phy_if_clk_lp_p,
  mipi_phy_if_data_hs_n,
  mipi_phy_if_data_hs_p,
  mipi_phy_if_data_lp_n,
  mipi_phy_if_data_lp_p
);

(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.dphy_clk_200M, FREQ_HZ 200000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN /clk_wiz_0_clk_out1, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.dphy_clk_200M CLK" *)
input wire dphy_clk_200M;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.rxbyteclkhs, FREQ_HZ 100000000.0, FREQ_TOLERANCE_HZ 0, PHASE 0, CLK_DOMAIN bd_2647_phy_0_rxbyteclkhs, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.rxbyteclkhs CLK" *)
output wire rxbyteclkhs;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.system_rst_out, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.system_rst_out RST" *)
output wire system_rst_out;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.video_aclk, FREQ_HZ 200000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN /clk_wiz_0_clk_out1, ASSOCIATED_BUSIF video_out, ASSOCIATED_RESET video_aresetn, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.video_aclk CLK" *)
input wire video_aclk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.video_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.video_aresetn RST" *)
input wire video_aresetn;
input wire ctrl_core_en;
output wire ctrl_dis_in_prgs;
output wire errsotsynchs_intr;
output wire errsoths_intr;
output wire cl_stopstate_intr;
output wire dl0_stopstate_intr;
output wire dl1_stopstate_intr;
output wire crc_status_intr;
output wire [1 : 0] ecc_status_intr;
output wire linebuffer_full;
output wire frame_rcvd_pulse_out;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 video_out TDATA" *)
output wire [7 : 0] video_out_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 video_out TDEST" *)
output wire [9 : 0] video_out_tdest;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 video_out TLAST" *)
output wire video_out_tlast;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 video_out TREADY" *)
input wire video_out_tready;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 video_out TUSER" *)
output wire [63 : 0] video_out_tuser;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME video_out, TDATA_NUM_BYTES 1, TDEST_WIDTH 10, TID_WIDTH 0, TUSER_WIDTH 64, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 200000000, PHASE 0.0, CLK_DOMAIN /clk_wiz_0_clk_out1, LAYERED_METADATA undef, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 video_out TVALID" *)
output wire video_out_tvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:mipi_phy:1.0 mipi_phy_if CLK_HS_N" *)
input wire mipi_phy_if_clk_hs_n;
(* X_INTERFACE_INFO = "xilinx.com:interface:mipi_phy:1.0 mipi_phy_if CLK_HS_P" *)
input wire mipi_phy_if_clk_hs_p;
(* X_INTERFACE_INFO = "xilinx.com:interface:mipi_phy:1.0 mipi_phy_if CLK_LP_N" *)
input wire mipi_phy_if_clk_lp_n;
(* X_INTERFACE_INFO = "xilinx.com:interface:mipi_phy:1.0 mipi_phy_if CLK_LP_P" *)
input wire mipi_phy_if_clk_lp_p;
(* X_INTERFACE_INFO = "xilinx.com:interface:mipi_phy:1.0 mipi_phy_if DATA_HS_N" *)
input wire [1 : 0] mipi_phy_if_data_hs_n;
(* X_INTERFACE_INFO = "xilinx.com:interface:mipi_phy:1.0 mipi_phy_if DATA_HS_P" *)
input wire [1 : 0] mipi_phy_if_data_hs_p;
(* X_INTERFACE_INFO = "xilinx.com:interface:mipi_phy:1.0 mipi_phy_if DATA_LP_N" *)
input wire [1 : 0] mipi_phy_if_data_lp_n;
(* X_INTERFACE_INFO = "xilinx.com:interface:mipi_phy:1.0 mipi_phy_if DATA_LP_P" *)
input wire [1 : 0] mipi_phy_if_data_lp_p;

  bd_2647 inst (
    .dphy_clk_200M(dphy_clk_200M),
    .rxbyteclkhs(rxbyteclkhs),
    .system_rst_out(system_rst_out),
    .video_aclk(video_aclk),
    .video_aresetn(video_aresetn),
    .ctrl_core_en(ctrl_core_en),
    .ctrl_dis_in_prgs(ctrl_dis_in_prgs),
    .errsotsynchs_intr(errsotsynchs_intr),
    .errsoths_intr(errsoths_intr),
    .cl_stopstate_intr(cl_stopstate_intr),
    .dl0_stopstate_intr(dl0_stopstate_intr),
    .dl1_stopstate_intr(dl1_stopstate_intr),
    .crc_status_intr(crc_status_intr),
    .ecc_status_intr(ecc_status_intr),
    .linebuffer_full(linebuffer_full),
    .frame_rcvd_pulse_out(frame_rcvd_pulse_out),
    .video_out_tdata(video_out_tdata),
    .video_out_tdest(video_out_tdest),
    .video_out_tlast(video_out_tlast),
    .video_out_tready(video_out_tready),
    .video_out_tuser(video_out_tuser),
    .video_out_tvalid(video_out_tvalid),
    .mipi_phy_if_clk_hs_n(mipi_phy_if_clk_hs_n),
    .mipi_phy_if_clk_hs_p(mipi_phy_if_clk_hs_p),
    .mipi_phy_if_clk_lp_n(mipi_phy_if_clk_lp_n),
    .mipi_phy_if_clk_lp_p(mipi_phy_if_clk_lp_p),
    .mipi_phy_if_data_hs_n(mipi_phy_if_data_hs_n),
    .mipi_phy_if_data_hs_p(mipi_phy_if_data_hs_p),
    .mipi_phy_if_data_lp_n(mipi_phy_if_data_lp_n),
    .mipi_phy_if_data_lp_p(mipi_phy_if_data_lp_p)
  );
endmodule
