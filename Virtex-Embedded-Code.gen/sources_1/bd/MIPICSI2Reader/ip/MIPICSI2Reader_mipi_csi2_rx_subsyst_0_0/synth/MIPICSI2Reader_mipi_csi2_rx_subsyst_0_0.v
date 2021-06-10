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

(* X_CORE_INFO = "bd_e616,Vivado 2020.2" *)
(* CHECK_LICENSE_TYPE = "MIPICSI2Reader_mipi_csi2_rx_subsyst_0_0,bd_e616,{}" *)
(* CORE_GENERATION_INFO = "MIPICSI2Reader_mipi_csi2_rx_subsyst_0_0,bd_e616,{x_ipProduct=Vivado 2020.2,x_ipVendor=xilinx.com,x_ipLibrary=ip,x_ipName=mipi_csi2_rx_subsystem,x_ipVersion=5.1,x_ipCoreRevision=0,x_ipLanguage=VERILOG,x_ipSimLanguage=VERILOG,C_EXDESBOARD_VERSION=xilinx.com_vck190_part0_2.0,C_INT_QOR_CHECK=0,C_LPRX_DISABLE_EXTPORT=0,C_OOC_VID_CLK=6.666,C_CLK_IO_SWAP=false,C_DL0_IO_SWAP=false,C_DL1_IO_SWAP=false,C_DL2_IO_SWAP=false,C_DL3_IO_SWAP=false,C_CLK_LP_IO_SWAP=false,C_DL0_LP_IO_SWAP=false,C_DL1_LP_IO_SWAP=f\
alse,C_DL2_LP_IO_SWAP=false,C_DL3_LP_IO_SWAP=false,VFB_TU_WIDTH=1,C_IDLY_GROUP_NAME=mipi_csi2rx_idly_group,C_EN_EXDESIGNS=false,C_EXDES_BOARD=SP701,C_EXDES_FMC=LI-IMX274MIPI-FMC V1.0 Single Sensor,C_EXDES_CONFIG=MIPI_Video_Pipe_Camera_to_Display,C_CSI2RX_DBG=0,C_MIPI_SLV_INT=0,C_CSI_OPT1_REGS=false,C_CSI_EN_CRC=true,C_CSI_EN_ACTIVELANES=false,DPHY_PRESET=CSI2RX_XLNX,C_STRETCH_LINE_RATE=3500,C_DPHY_MODE=SLAVE,C_EN_BG0_PIN0=false,C_EN_BG0_PIN6=false,C_EN_BG1_PIN0=false,C_EN_BG1_PIN6=false,C_EN_BG2\
_PIN0=false,C_EN_BG2_PIN6=false,C_EN_BG3_PIN0=false,C_EN_BG3_PIN6=false,CMN_PXL_FORMAT=RAW8,CMN_NUM_LANES=2,C_EN_7S_LINERATE_CHECK=false,C_DPHY_LANES=2,YUV420_BUF_DPTH=128,C_EN_CSI_V2_0=true,C_EN_VCX=false,CMN_VC=All,CMN_NUM_PIXELS=1,CMN_INC_IIC=false,CMN_INC_VFB=true,CMN_PROJ_FAMILY=0,CMN_FIFO_RD_EN_CNTRL=true,C_HS_LINE_RATE=800,DPY_LINE_RATE=800,DPY_EN_REG_IF=false,CSI_EMB_NON_IMG=false,CSI_BUF_DEPTH=2048,AXIS_TDATA_WIDTH=32,AXIS_TUSER_WIDTH=96,AXIS_TDEST_WIDTH=4,HP_IO_BANK_SELECTION=64,CLK_LA\
NE_IO_LOC=None,DATA_LANE0_IO_LOC=None,DATA_LANE1_IO_LOC=None,DATA_LANE2_IO_LOC=None,DATA_LANE3_IO_LOC=None,DATA_LANE0_BYTE=All_Byte,DATA_LANE1_BYTE=All_Byte,DATA_LANE2_BYTE=All_Byte,DATA_LANE3_BYTE=All_Byte,CLK_LANE_IO_LOC_NAME=None,DATA_LANE0_IO_LOC_NAME=None,DATA_LANE1_IO_LOC_NAME=None,DATA_LANE2_IO_LOC_NAME=None,DATA_LANE3_IO_LOC_NAME=None,SupportLevel=1,C_CLK_LANE_IO_POSITION=0,C_DATA_LANE0_IO_POSITION=2,C_DATA_LANE1_IO_POSITION=4,C_DATA_LANE2_IO_POSITION=6,C_DATA_LANE3_IO_POSITION=8,C_IS_7S\
ERIES=true,C_IS_VERSAL=false,C_EN_CNTS_BYTE_CLK=false,C_RCVE_DESKEW_SEQ=false,C_RCVE_ALT_DESKEW_SEQ=false,C_CAL_MODE=NONE,C_IDLY_TAP=1,C_EN_EXT_TAP=false,C_EN_CLK300M=false,C_SHARE_IDLYCTRL=false,C_FIFO_RD_EN_CONTROL=true,C_HS_SETTLE_NS=147,C_EN_TIMEOUT_REGS=false,C_HS_TIMEOUT=65541,C_ESC_TIMEOUT=25600,C_INIT=100000,C_CSI_FILTER_USERDATATYPE=false,USE_BOARD_FLOW=false,DPHYRX_BOARD_INTERFACE=Custom,CSI_CONTROLLER_REG_IF=false,Component_Name=MIPICSI2Reader_mipi_csi2_rx_subsyst_0_0}" *)
(* DowngradeIPIdentifiedWarnings = "yes" *)
module MIPICSI2Reader_mipi_csi2_rx_subsyst_0_0 (
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
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.rxbyteclkhs, FREQ_HZ 100000000.0, FREQ_TOLERANCE_HZ 0, PHASE 0, CLK_DOMAIN bd_e616_phy_0_rxbyteclkhs, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.rxbyteclkhs CLK" *)
output wire rxbyteclkhs;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.system_rst_out, POLARITY ACTIVE_LOW, INSERT_VIP 0" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.system_rst_out RST" *)
output wire system_rst_out;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.video_aclk, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.000, CLK_DOMAIN MIPICSI2Reader_CLK, ASSOCIATED_BUSIF video_out, ASSOCIATED_RESET video_aresetn, INSERT_VIP 0" *)
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
output wire [0 : 0] video_out_tuser;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME video_out, TDATA_NUM_BYTES 1, TDEST_WIDTH 10, TID_WIDTH 0, TUSER_WIDTH 1, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 1, FREQ_HZ 100000000, PHASE 0.000, CLK_DOMAIN MIPICSI2Reader_CLK, LAYERED_METADATA undef, INSERT_VIP 0" *)
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

  bd_e616 inst (
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
