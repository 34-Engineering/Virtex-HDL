// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Mon Jun 28 22:34:25 2021
// Host        : liams-desktop running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ bd_2647_rx_0_stub.v
// Design      : bd_2647_rx_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tftg256-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "mipi_csi2_rx_ctrl_v1_0_8_top,Vivado 2020.2" *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(cl_stopstate, cl_enable, cl_rxulpsclknot, 
  vfb_full, vfb_wc_full, core_men_ack_vfb, core_men_vfb, dl0_rxbyteclkhs, dl0_rxdatahs, 
  dl0_rxvalidhs, dl0_rxactivehs, dl0_rxsynchs, dl0_stopstate, dl0_shutdown, dl0_rxulpmesc, 
  dl0_errsoths, dl0_errsotsynchs, dl0_erresc, dl0_errcontrol, dl1_rxbyteclkhs, dl1_rxdatahs, 
  dl1_rxvalidhs, dl1_rxactivehs, dl1_rxsynchs, dl1_stopstate, dl1_shutdown, dl1_rxulpmesc, 
  dl1_errsoths, dl1_errsotsynchs, dl1_erresc, dl1_errcontrol, video_aclk, m_axis_aclk, 
  m_axis_aresetn, m_axis_tready, m_axis_tvalid, m_axis_tlast, m_axis_tdata, m_axis_tkeep, 
  m_axis_tuser, m_axis_tdest, core_enable, disable_in_progress, ecc_status_intr, 
  crc_status_intr, errsotsynchs_intr, errsoths_intr, frame_rcvd_pulse_out, linebuffer_full, 
  cl_stopstate_intr, dl0_stopstate_intr, dl1_stopstate_intr)
/* synthesis syn_black_box black_box_pad_pin="cl_stopstate,cl_enable,cl_rxulpsclknot,vfb_full,vfb_wc_full,core_men_ack_vfb,core_men_vfb,dl0_rxbyteclkhs,dl0_rxdatahs[7:0],dl0_rxvalidhs,dl0_rxactivehs,dl0_rxsynchs,dl0_stopstate,dl0_shutdown,dl0_rxulpmesc,dl0_errsoths,dl0_errsotsynchs,dl0_erresc,dl0_errcontrol,dl1_rxbyteclkhs,dl1_rxdatahs[7:0],dl1_rxvalidhs,dl1_rxactivehs,dl1_rxsynchs,dl1_stopstate,dl1_shutdown,dl1_rxulpmesc,dl1_errsoths,dl1_errsotsynchs,dl1_erresc,dl1_errcontrol,video_aclk,m_axis_aclk,m_axis_aresetn,m_axis_tready,m_axis_tvalid,m_axis_tlast,m_axis_tdata[31:0],m_axis_tkeep[3:0],m_axis_tuser[95:0],m_axis_tdest[3:0],core_enable,disable_in_progress,ecc_status_intr[1:0],crc_status_intr,errsotsynchs_intr,errsoths_intr,frame_rcvd_pulse_out,linebuffer_full,cl_stopstate_intr,dl0_stopstate_intr,dl1_stopstate_intr" */;
  input cl_stopstate;
  output cl_enable;
  input cl_rxulpsclknot;
  input vfb_full;
  input vfb_wc_full;
  input core_men_ack_vfb;
  output core_men_vfb;
  input dl0_rxbyteclkhs;
  input [7:0]dl0_rxdatahs;
  input dl0_rxvalidhs;
  input dl0_rxactivehs;
  input dl0_rxsynchs;
  input dl0_stopstate;
  output dl0_shutdown;
  input dl0_rxulpmesc;
  input dl0_errsoths;
  input dl0_errsotsynchs;
  input dl0_erresc;
  input dl0_errcontrol;
  input dl1_rxbyteclkhs;
  input [7:0]dl1_rxdatahs;
  input dl1_rxvalidhs;
  input dl1_rxactivehs;
  input dl1_rxsynchs;
  input dl1_stopstate;
  output dl1_shutdown;
  input dl1_rxulpmesc;
  input dl1_errsoths;
  input dl1_errsotsynchs;
  input dl1_erresc;
  input dl1_errcontrol;
  input video_aclk;
  input m_axis_aclk;
  input m_axis_aresetn;
  input m_axis_tready;
  output m_axis_tvalid;
  output m_axis_tlast;
  output [31:0]m_axis_tdata;
  output [3:0]m_axis_tkeep;
  output [95:0]m_axis_tuser;
  output [3:0]m_axis_tdest;
  input core_enable;
  output disable_in_progress;
  output [1:0]ecc_status_intr;
  output crc_status_intr;
  output errsotsynchs_intr;
  output errsoths_intr;
  output frame_rcvd_pulse_out;
  output linebuffer_full;
  output cl_stopstate_intr;
  output dl0_stopstate_intr;
  output dl1_stopstate_intr;
endmodule
