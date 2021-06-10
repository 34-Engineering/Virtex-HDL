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


// IP VLNV: xilinx.com:ip:mipi_csi2_rx_ctrl:1.0
// IP Revision: 8

(* X_CORE_INFO = "mipi_csi2_rx_ctrl_v1_0_8_top,Vivado 2020.2" *)
(* CHECK_LICENSE_TYPE = "bd_e616_rx_0,mipi_csi2_rx_ctrl_v1_0_8_top,{}" *)
(* CORE_GENERATION_INFO = "bd_e616_rx_0,mipi_csi2_rx_ctrl_v1_0_8_top,{x_ipProduct=Vivado 2020.2,x_ipVendor=xilinx.com,x_ipLibrary=ip,x_ipName=mipi_csi2_rx_ctrl,x_ipVersion=1.0,x_ipCoreRevision=8,x_ipLanguage=VERILOG,x_ipSimLanguage=VERILOG,C_HS_LINE_RATE=800,C_RCVE_DESKEW_SEQ=false,C_FAMILY=artix7,CMN_INC_VFB=true,C_S_AXI_ADDR_WIDTH=8,C_S_AXI_DATA_WIDTH=32,C_CSI_OPT1_REGS=0,C_CSI_OPT2_CRC=0,C_CSI_OPT3_FIXEDLANES=1,CSI_LANES=2,CSI_OFFLOAD_NONIMAGE=0,CSI_EN_VC_SUPPORT=1,CSI_FIXED_VC=0,C_CSI_FILTER_USERDATATYPE=0,C_EN_VCX=fa\
lse,C_EN_CSI_V2_0=true,CSI_VC_OFF_0=1,CSI_VC_OFF_1=2,CSI_VC_OFF_2=3,CSI_VC_OFF_3=4,CSI_VC_OFF_4=5,CSI_VC_OFF_5=6,CSI_VC_OFF_6=7,CSI_VC_OFF_7=8,CSI_VC_OFF_8=9,CSI_VC_OFF_9=10,CSI_VC_OFF_10=11,CSI_VC_OFF_11=12,CSI_VC_OFF_12=13,CSI_VC_OFF_13=14,CSI_VC_OFF_14=15,CSI_INV_SHUTDOWN=1,C_MIPI_SLV_INT=0,C_CSI2RX_DBG=0,AXIS_FIFO_DCNT_WIDTH=11,C_DISABLE_LITE=1,AXIS_FIFO_DEPTH=2048,AXIS_TDATA_WIDTH=32,AXIS_TUSER_WIDTH=96,AXIS_TDEST_WIDTH=4}" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module bd_e616_rx_0 (
  cl_stopstate,
  cl_enable,
  cl_rxulpsclknot,
  vfb_full,
  vfb_wc_full,
  core_men_ack_vfb,
  core_men_vfb,
  dl0_rxbyteclkhs,
  dl0_rxdatahs,
  dl0_rxvalidhs,
  dl0_rxactivehs,
  dl0_rxsynchs,
  dl0_stopstate,
  dl0_shutdown,
  dl0_rxulpmesc,
  dl0_errsoths,
  dl0_errsotsynchs,
  dl0_erresc,
  dl0_errcontrol,
  dl1_rxbyteclkhs,
  dl1_rxdatahs,
  dl1_rxvalidhs,
  dl1_rxactivehs,
  dl1_rxsynchs,
  dl1_stopstate,
  dl1_shutdown,
  dl1_rxulpmesc,
  dl1_errsoths,
  dl1_errsotsynchs,
  dl1_erresc,
  dl1_errcontrol,
  video_aclk,
  m_axis_aclk,
  m_axis_aresetn,
  m_axis_tready,
  m_axis_tvalid,
  m_axis_tlast,
  m_axis_tdata,
  m_axis_tkeep,
  m_axis_tuser,
  m_axis_tdest,
  core_enable,
  disable_in_progress,
  ecc_status_intr,
  crc_status_intr,
  errsotsynchs_intr,
  errsoths_intr,
  frame_rcvd_pulse_out,
  linebuffer_full,
  cl_stopstate_intr,
  dl0_stopstate_intr,
  dl1_stopstate_intr
);

(* X_INTERFACE_INFO = "xilinx.com:interface:rx_mipi_ppi_if:1.0 rx_mipi_ppi_if CL_STOPSTATE" *)
input wire cl_stopstate;
(* X_INTERFACE_INFO = "xilinx.com:interface:rx_mipi_ppi_if:1.0 rx_mipi_ppi_if CL_ENABLE" *)
output wire cl_enable;
(* X_INTERFACE_INFO = "xilinx.com:interface:rx_mipi_ppi_if:1.0 rx_mipi_ppi_if CL_RXULPSCLKNOT" *)
input wire cl_rxulpsclknot;
input wire vfb_full;
input wire vfb_wc_full;
input wire core_men_ack_vfb;
output wire core_men_vfb;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME dl0_rxbyteclkhs, FREQ_HZ 100000000.0, FREQ_TOLERANCE_HZ 0, PHASE 0, CLK_DOMAIN bd_e616_phy_0_rxbyteclkhs, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 dl0_rxbyteclkhs CLK" *)
input wire dl0_rxbyteclkhs;
(* X_INTERFACE_INFO = "xilinx.com:interface:rx_mipi_ppi_if:1.0 rx_mipi_ppi_if DL0_RXDATAHS" *)
input wire [7 : 0] dl0_rxdatahs;
(* X_INTERFACE_INFO = "xilinx.com:interface:rx_mipi_ppi_if:1.0 rx_mipi_ppi_if DL0_RXVALIDHS" *)
input wire dl0_rxvalidhs;
(* X_INTERFACE_INFO = "xilinx.com:interface:rx_mipi_ppi_if:1.0 rx_mipi_ppi_if DL0_RXACTIVEHS" *)
input wire dl0_rxactivehs;
(* X_INTERFACE_INFO = "xilinx.com:interface:rx_mipi_ppi_if:1.0 rx_mipi_ppi_if DL0_RXSYNCHS" *)
input wire dl0_rxsynchs;
(* X_INTERFACE_INFO = "xilinx.com:interface:rx_mipi_ppi_if:1.0 rx_mipi_ppi_if DL0_STOPSTATE" *)
input wire dl0_stopstate;
(* X_INTERFACE_INFO = "xilinx.com:interface:rx_mipi_ppi_if:1.0 rx_mipi_ppi_if DL0_ENABLE" *)
output wire dl0_shutdown;
(* X_INTERFACE_INFO = "xilinx.com:interface:rx_mipi_ppi_if:1.0 rx_mipi_ppi_if DL0_RXULPSESC" *)
input wire dl0_rxulpmesc;
(* X_INTERFACE_INFO = "xilinx.com:interface:rx_mipi_ppi_if:1.0 rx_mipi_ppi_if DL0_ERRSOTHS" *)
input wire dl0_errsoths;
(* X_INTERFACE_INFO = "xilinx.com:interface:rx_mipi_ppi_if:1.0 rx_mipi_ppi_if DL0_ERRSOTSYNCHS" *)
input wire dl0_errsotsynchs;
(* X_INTERFACE_INFO = "xilinx.com:interface:rx_mipi_ppi_if:1.0 rx_mipi_ppi_if DL0_ERRESC" *)
input wire dl0_erresc;
(* X_INTERFACE_INFO = "xilinx.com:interface:rx_mipi_ppi_if:1.0 rx_mipi_ppi_if DL0_ERRCONTROL" *)
input wire dl0_errcontrol;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME dl1_rxbyteclkhs, FREQ_HZ 100000000.0, FREQ_TOLERANCE_HZ 0, PHASE 0, CLK_DOMAIN bd_e616_phy_0_rxbyteclkhs, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 dl1_rxbyteclkhs CLK" *)
input wire dl1_rxbyteclkhs;
(* X_INTERFACE_INFO = "xilinx.com:interface:rx_mipi_ppi_if:1.0 rx_mipi_ppi_if DL1_RXDATAHS" *)
input wire [7 : 0] dl1_rxdatahs;
(* X_INTERFACE_INFO = "xilinx.com:interface:rx_mipi_ppi_if:1.0 rx_mipi_ppi_if DL1_RXVALIDHS" *)
input wire dl1_rxvalidhs;
(* X_INTERFACE_INFO = "xilinx.com:interface:rx_mipi_ppi_if:1.0 rx_mipi_ppi_if DL1_RXACTIVEHS" *)
input wire dl1_rxactivehs;
(* X_INTERFACE_INFO = "xilinx.com:interface:rx_mipi_ppi_if:1.0 rx_mipi_ppi_if DL1_RXSYNCHS" *)
input wire dl1_rxsynchs;
(* X_INTERFACE_INFO = "xilinx.com:interface:rx_mipi_ppi_if:1.0 rx_mipi_ppi_if DL1_STOPSTATE" *)
input wire dl1_stopstate;
(* X_INTERFACE_INFO = "xilinx.com:interface:rx_mipi_ppi_if:1.0 rx_mipi_ppi_if DL1_ENABLE" *)
output wire dl1_shutdown;
(* X_INTERFACE_INFO = "xilinx.com:interface:rx_mipi_ppi_if:1.0 rx_mipi_ppi_if DL1_RXULPSESC" *)
input wire dl1_rxulpmesc;
(* X_INTERFACE_INFO = "xilinx.com:interface:rx_mipi_ppi_if:1.0 rx_mipi_ppi_if DL1_ERRSOTHS" *)
input wire dl1_errsoths;
(* X_INTERFACE_INFO = "xilinx.com:interface:rx_mipi_ppi_if:1.0 rx_mipi_ppi_if DL1_ERRSOTSYNCHS" *)
input wire dl1_errsotsynchs;
(* X_INTERFACE_INFO = "xilinx.com:interface:rx_mipi_ppi_if:1.0 rx_mipi_ppi_if DL1_ERRESC" *)
input wire dl1_erresc;
(* X_INTERFACE_INFO = "xilinx.com:interface:rx_mipi_ppi_if:1.0 rx_mipi_ppi_if DL1_ERRCONTROL" *)
input wire dl1_errcontrol;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME m_axis_eni_signal_clock, ASSOCIATED_BUSIF m_axis_eni, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.000, CLK_DOMAIN MIPICSI2Reader_CLK, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 m_axis_eni_signal_clock CLK" *)
input wire video_aclk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME m_axis_signal_clock, ASSOCIATED_BUSIF m_axis, ASSOCIATED_RESET m_axis_aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.000, CLK_DOMAIN MIPICSI2Reader_CLK, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 m_axis_signal_clock CLK" *)
input wire m_axis_aclk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME m_axis_signal_reset, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 m_axis_signal_reset RST" *)
input wire m_axis_aresetn;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TREADY" *)
input wire m_axis_tready;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TVALID" *)
output wire m_axis_tvalid;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TLAST" *)
output wire m_axis_tlast;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TDATA" *)
output wire [31 : 0] m_axis_tdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TKEEP" *)
output wire [3 : 0] m_axis_tkeep;
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TUSER" *)
output wire [95 : 0] m_axis_tuser;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME m_axis, TDATA_NUM_BYTES 4, TDEST_WIDTH 4, TID_WIDTH 0, TUSER_WIDTH 96, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 1, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.000, CLK_DOMAIN MIPICSI2Reader_CLK, LAYERED_METADATA undef, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 m_axis TDEST" *)
output wire [3 : 0] m_axis_tdest;
input wire core_enable;
output wire disable_in_progress;
output wire [1 : 0] ecc_status_intr;
output wire crc_status_intr;
output wire errsotsynchs_intr;
output wire errsoths_intr;
output wire frame_rcvd_pulse_out;
output wire linebuffer_full;
output wire cl_stopstate_intr;
output wire dl0_stopstate_intr;
output wire dl1_stopstate_intr;

  mipi_csi2_rx_ctrl_v1_0_8_top #(
    .C_HS_LINE_RATE(800),
    .C_RCVE_DESKEW_SEQ("false"),
    .C_FAMILY("artix7"),
    .CMN_INC_VFB("true"),
    .C_S_AXI_ADDR_WIDTH(8),
    .C_S_AXI_DATA_WIDTH(32),
    .C_CSI_OPT1_REGS(0),
    .C_CSI_OPT2_CRC(0),
    .C_CSI_OPT3_FIXEDLANES(1),
    .CSI_LANES(2),
    .CSI_OFFLOAD_NONIMAGE(0),
    .CSI_EN_VC_SUPPORT(1),
    .CSI_FIXED_VC(0),
    .C_CSI_FILTER_USERDATATYPE(0),
    .C_EN_VCX("false"),
    .C_EN_CSI_V2_0("true"),
    .CSI_VC_OFF_0(1),
    .CSI_VC_OFF_1(2),
    .CSI_VC_OFF_2(3),
    .CSI_VC_OFF_3(4),
    .CSI_VC_OFF_4(5),
    .CSI_VC_OFF_5(6),
    .CSI_VC_OFF_6(7),
    .CSI_VC_OFF_7(8),
    .CSI_VC_OFF_8(9),
    .CSI_VC_OFF_9(10),
    .CSI_VC_OFF_10(11),
    .CSI_VC_OFF_11(12),
    .CSI_VC_OFF_12(13),
    .CSI_VC_OFF_13(14),
    .CSI_VC_OFF_14(15),
    .CSI_INV_SHUTDOWN(1),
    .C_MIPI_SLV_INT(0),
    .C_CSI2RX_DBG(0),
    .AXIS_FIFO_DCNT_WIDTH(11),
    .C_DISABLE_LITE(1),
    .AXIS_FIFO_DEPTH(2048),
    .AXIS_TDATA_WIDTH(32),
    .AXIS_TUSER_WIDTH(96),
    .AXIS_TDEST_WIDTH(4)
  ) inst (
    .s_axi_aclk(1'B0),
    .s_axi_aresetn(1'B0),
    .s_axi_awaddr(8'B0),
    .s_axi_awvalid(1'B0),
    .s_axi_awready(),
    .s_axi_wdata(32'B0),
    .s_axi_wstrb(4'B0),
    .s_axi_wvalid(1'B0),
    .s_axi_wready(),
    .s_axi_bresp(),
    .s_axi_bvalid(),
    .s_axi_bready(1'B0),
    .s_axi_araddr(8'B0),
    .s_axi_arvalid(1'B0),
    .s_axi_arready(),
    .s_axi_rdata(),
    .s_axi_rresp(),
    .s_axi_rvalid(),
    .s_axi_rready(1'B0),
    .cl_stopstate(cl_stopstate),
    .cl_enable(cl_enable),
    .cl_rxulpsclknot(cl_rxulpsclknot),
    .vfb_full(vfb_full),
    .vfb_wc_full(vfb_wc_full),
    .core_men_ack_vfb(core_men_ack_vfb),
    .core_men_vfb(core_men_vfb),
    .dl0_rxbyteclkhs(dl0_rxbyteclkhs),
    .dl0_rxdatahs(dl0_rxdatahs),
    .dl0_rxvalidhs(dl0_rxvalidhs),
    .dl0_rxactivehs(dl0_rxactivehs),
    .dl0_rxsynchs(dl0_rxsynchs),
    .dl0_stopstate(dl0_stopstate),
    .dl0_shutdown(dl0_shutdown),
    .dl0_rxulpmesc(dl0_rxulpmesc),
    .dl0_errsoths(dl0_errsoths),
    .dl0_errsotsynchs(dl0_errsotsynchs),
    .dl0_erresc(dl0_erresc),
    .dl0_errcontrol(dl0_errcontrol),
    .dl0_rxskewcalhs(1'B0),
    .dl1_rxbyteclkhs(dl1_rxbyteclkhs),
    .dl1_rxdatahs(dl1_rxdatahs),
    .dl1_rxvalidhs(dl1_rxvalidhs),
    .dl1_rxactivehs(dl1_rxactivehs),
    .dl1_rxsynchs(dl1_rxsynchs),
    .dl1_stopstate(dl1_stopstate),
    .dl1_shutdown(dl1_shutdown),
    .dl1_rxulpmesc(dl1_rxulpmesc),
    .dl1_errsoths(dl1_errsoths),
    .dl1_errsotsynchs(dl1_errsotsynchs),
    .dl1_erresc(dl1_erresc),
    .dl1_errcontrol(dl1_errcontrol),
    .dl1_rxskewcalhs(1'B0),
    .dl2_rxbyteclkhs(1'B0),
    .dl2_rxdatahs(8'B0),
    .dl2_rxvalidhs(1'B0),
    .dl2_rxactivehs(1'B0),
    .dl2_rxsynchs(1'B0),
    .dl2_stopstate(1'B1),
    .dl2_shutdown(),
    .dl2_rxulpmesc(1'B0),
    .dl2_errsoths(1'B0),
    .dl2_errsotsynchs(1'B0),
    .dl2_erresc(1'B0),
    .dl2_errcontrol(1'B0),
    .dl2_rxskewcalhs(1'B0),
    .dl3_rxbyteclkhs(1'B0),
    .dl3_rxdatahs(8'B0),
    .dl3_rxvalidhs(1'B0),
    .dl3_rxactivehs(1'B0),
    .dl3_rxsynchs(1'B0),
    .dl3_stopstate(1'B1),
    .dl3_shutdown(),
    .dl3_rxulpmesc(1'B0),
    .dl3_errsoths(1'B0),
    .dl3_errsotsynchs(1'B0),
    .dl3_erresc(1'B0),
    .dl3_errcontrol(1'B0),
    .dl3_rxskewcalhs(1'B0),
    .video_aclk(video_aclk),
    .m_axis_aclk(m_axis_aclk),
    .m_axis_aresetn(m_axis_aresetn),
    .m_axis_tready(m_axis_tready),
    .m_axis_tvalid(m_axis_tvalid),
    .m_axis_tlast(m_axis_tlast),
    .m_axis_tdata(m_axis_tdata),
    .m_axis_tkeep(m_axis_tkeep),
    .m_axis_tuser(m_axis_tuser),
    .m_axis_tdest(m_axis_tdest),
    .m_axis_eni_tready(1'B0),
    .m_axis_eni_tvalid(),
    .m_axis_eni_tlast(),
    .m_axis_eni_tdata(),
    .m_axis_eni_tkeep(),
    .m_axis_eni_tuser(),
    .m_axis_eni_tdest(),
    .mdt_tv(1'B0),
    .mdt_tr(1'B0),
    .sdt_tv(1'B0),
    .sdt_tr(1'B0),
    .vfb_tv(1'B0),
    .vfb_tr(1'B0),
    .core_enable(core_enable),
    .disable_in_progress(disable_in_progress),
    .ecc_status_intr(ecc_status_intr),
    .crc_status_intr(crc_status_intr),
    .errsotsynchs_intr(errsotsynchs_intr),
    .errsoths_intr(errsoths_intr),
    .frame_rcvd_pulse_out(frame_rcvd_pulse_out),
    .linebuffer_full(linebuffer_full),
    .cl_stopstate_intr(cl_stopstate_intr),
    .dl0_stopstate_intr(dl0_stopstate_intr),
    .dl1_stopstate_intr(dl1_stopstate_intr),
    .dl2_stopstate_intr(),
    .dl3_stopstate_intr(),
    .interrupt()
  );
endmodule
