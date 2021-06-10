//Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Command: generate_target bd_e616.bd
//Design : bd_e616
//Purpose: IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "bd_e616,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=bd_e616,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=4,numReposBlks=4,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=SBD,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "MIPICSI2Reader_mipi_csi2_rx_subsyst_0_0.hwdef" *) 
module bd_e616
   (cl_stopstate_intr,
    crc_status_intr,
    ctrl_core_en,
    ctrl_dis_in_prgs,
    dl0_stopstate_intr,
    dl1_stopstate_intr,
    dphy_clk_200M,
    ecc_status_intr,
    errsoths_intr,
    errsotsynchs_intr,
    frame_rcvd_pulse_out,
    linebuffer_full,
    mipi_phy_if_clk_hs_n,
    mipi_phy_if_clk_hs_p,
    mipi_phy_if_clk_lp_n,
    mipi_phy_if_clk_lp_p,
    mipi_phy_if_data_hs_n,
    mipi_phy_if_data_hs_p,
    mipi_phy_if_data_lp_n,
    mipi_phy_if_data_lp_p,
    rxbyteclkhs,
    system_rst_out,
    video_aclk,
    video_aresetn,
    video_out_tdata,
    video_out_tdest,
    video_out_tlast,
    video_out_tready,
    video_out_tuser,
    video_out_tvalid);
  output cl_stopstate_intr;
  output crc_status_intr;
  input ctrl_core_en;
  output ctrl_dis_in_prgs;
  output dl0_stopstate_intr;
  output dl1_stopstate_intr;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.DPHY_CLK_200M CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.DPHY_CLK_200M, CLK_DOMAIN /clk_wiz_0_clk_out1, FREQ_HZ 200000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) input dphy_clk_200M;
  output [1:0]ecc_status_intr;
  output errsoths_intr;
  output errsotsynchs_intr;
  output frame_rcvd_pulse_out;
  output linebuffer_full;
  (* X_INTERFACE_INFO = "xilinx.com:interface:mipi_phy:1.0 mipi_phy_if CLK_HS_N" *) input mipi_phy_if_clk_hs_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:mipi_phy:1.0 mipi_phy_if CLK_HS_P" *) input mipi_phy_if_clk_hs_p;
  (* X_INTERFACE_INFO = "xilinx.com:interface:mipi_phy:1.0 mipi_phy_if CLK_LP_N" *) input mipi_phy_if_clk_lp_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:mipi_phy:1.0 mipi_phy_if CLK_LP_P" *) input mipi_phy_if_clk_lp_p;
  (* X_INTERFACE_INFO = "xilinx.com:interface:mipi_phy:1.0 mipi_phy_if DATA_HS_N" *) input [1:0]mipi_phy_if_data_hs_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:mipi_phy:1.0 mipi_phy_if DATA_HS_P" *) input [1:0]mipi_phy_if_data_hs_p;
  (* X_INTERFACE_INFO = "xilinx.com:interface:mipi_phy:1.0 mipi_phy_if DATA_LP_N" *) input [1:0]mipi_phy_if_data_lp_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:mipi_phy:1.0 mipi_phy_if DATA_LP_P" *) input [1:0]mipi_phy_if_data_lp_p;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.RXBYTECLKHS CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.RXBYTECLKHS, CLK_DOMAIN bd_e616_phy_0_rxbyteclkhs, FREQ_HZ 100000000.0, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0" *) output rxbyteclkhs;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.SYSTEM_RST_OUT RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.SYSTEM_RST_OUT, INSERT_VIP 0, POLARITY ACTIVE_LOW" *) output system_rst_out;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.VIDEO_ACLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.VIDEO_ACLK, ASSOCIATED_BUSIF video_out, ASSOCIATED_RESET video_aresetn, CLK_DOMAIN MIPICSI2Reader_CLK, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.000" *) input video_aclk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.VIDEO_ARESETN RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.VIDEO_ARESETN, INSERT_VIP 0, POLARITY ACTIVE_LOW" *) input video_aresetn;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 video_out TDATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME video_out, CLK_DOMAIN MIPICSI2Reader_CLK, FREQ_HZ 100000000, HAS_TKEEP 0, HAS_TLAST 1, HAS_TREADY 1, HAS_TSTRB 0, INSERT_VIP 0, LAYERED_METADATA undef, PHASE 0.000, TDATA_NUM_BYTES 1, TDEST_WIDTH 10, TID_WIDTH 0, TUSER_WIDTH 1" *) output [7:0]video_out_tdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 video_out TDEST" *) output [9:0]video_out_tdest;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 video_out TLAST" *) output video_out_tlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 video_out TREADY" *) input video_out_tready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 video_out TUSER" *) output [0:0]video_out_tuser;
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 video_out TVALID" *) output video_out_tvalid;

  wire ctrl_core_en_1;
  wire dphy_clk_200M_1;
  wire mipi_phy_if_1_CLK_HS_N;
  wire mipi_phy_if_1_CLK_HS_P;
  wire mipi_phy_if_1_CLK_LP_N;
  wire mipi_phy_if_1_CLK_LP_P;
  wire [1:0]mipi_phy_if_1_DATA_HS_N;
  wire [1:0]mipi_phy_if_1_DATA_HS_P;
  wire [1:0]mipi_phy_if_1_DATA_LP_N;
  wire [1:0]mipi_phy_if_1_DATA_LP_P;
  wire phy_rx_mipi_ppi_if_CL_ENABLE;
  wire phy_rx_mipi_ppi_if_CL_RXULPSCLKNOT;
  wire phy_rx_mipi_ppi_if_CL_STOPSTATE;
  wire phy_rx_mipi_ppi_if_DL0_ENABLE;
  wire phy_rx_mipi_ppi_if_DL0_ERRCONTROL;
  wire phy_rx_mipi_ppi_if_DL0_ERRESC;
  wire phy_rx_mipi_ppi_if_DL0_ERRSOTHS;
  wire phy_rx_mipi_ppi_if_DL0_ERRSOTSYNCHS;
  wire phy_rx_mipi_ppi_if_DL0_RXACTIVEHS;
  wire [7:0]phy_rx_mipi_ppi_if_DL0_RXDATAHS;
  wire phy_rx_mipi_ppi_if_DL0_RXSYNCHS;
  wire phy_rx_mipi_ppi_if_DL0_RXULPSESC;
  wire phy_rx_mipi_ppi_if_DL0_RXVALIDHS;
  wire phy_rx_mipi_ppi_if_DL0_STOPSTATE;
  wire phy_rx_mipi_ppi_if_DL1_ENABLE;
  wire phy_rx_mipi_ppi_if_DL1_ERRCONTROL;
  wire phy_rx_mipi_ppi_if_DL1_ERRESC;
  wire phy_rx_mipi_ppi_if_DL1_ERRSOTHS;
  wire phy_rx_mipi_ppi_if_DL1_ERRSOTSYNCHS;
  wire phy_rx_mipi_ppi_if_DL1_RXACTIVEHS;
  wire [7:0]phy_rx_mipi_ppi_if_DL1_RXDATAHS;
  wire phy_rx_mipi_ppi_if_DL1_RXSYNCHS;
  wire phy_rx_mipi_ppi_if_DL1_RXULPSESC;
  wire phy_rx_mipi_ppi_if_DL1_RXVALIDHS;
  wire phy_rx_mipi_ppi_if_DL1_STOPSTATE;
  wire phy_rxbyteclkhs;
  wire phy_system_rst_out;
  wire [0:0]r_sync_peripheral_reset;
  wire rx_cl_stopstate_intr;
  wire rx_core_men_vfb;
  wire rx_crc_status_intr;
  wire rx_disable_in_progress;
  wire rx_dl0_stopstate_intr;
  wire rx_dl1_stopstate_intr;
  wire [1:0]rx_ecc_status_intr;
  wire rx_errsoths_intr;
  wire rx_errsotsynchs_intr;
  wire rx_frame_rcvd_pulse_out;
  wire rx_linebuffer_full;
  wire [31:0]rx_m_axis_TDATA;
  wire [3:0]rx_m_axis_TDEST;
  wire [3:0]rx_m_axis_TKEEP;
  wire rx_m_axis_TLAST;
  wire rx_m_axis_TREADY;
  wire [95:0]rx_m_axis_TUSER;
  wire rx_m_axis_TVALID;
  wire vfb_0_core_men_ack_vfb;
  wire [7:0]vfb_0_m_vfb_TDATA;
  wire [9:0]vfb_0_m_vfb_TDEST;
  wire vfb_0_m_vfb_TLAST;
  wire vfb_0_m_vfb_TREADY;
  wire [0:0]vfb_0_m_vfb_TUSER;
  wire vfb_0_m_vfb_TVALID;
  wire vfb_0_vfb_full;
  wire vfb_0_vfb_wc_full;
  wire video_aclk_1;
  wire video_aresetn_1;

  assign cl_stopstate_intr = rx_cl_stopstate_intr;
  assign crc_status_intr = rx_crc_status_intr;
  assign ctrl_core_en_1 = ctrl_core_en;
  assign ctrl_dis_in_prgs = rx_disable_in_progress;
  assign dl0_stopstate_intr = rx_dl0_stopstate_intr;
  assign dl1_stopstate_intr = rx_dl1_stopstate_intr;
  assign dphy_clk_200M_1 = dphy_clk_200M;
  assign ecc_status_intr[1:0] = rx_ecc_status_intr;
  assign errsoths_intr = rx_errsoths_intr;
  assign errsotsynchs_intr = rx_errsotsynchs_intr;
  assign frame_rcvd_pulse_out = rx_frame_rcvd_pulse_out;
  assign linebuffer_full = rx_linebuffer_full;
  assign mipi_phy_if_1_CLK_HS_N = mipi_phy_if_clk_hs_n;
  assign mipi_phy_if_1_CLK_HS_P = mipi_phy_if_clk_hs_p;
  assign mipi_phy_if_1_CLK_LP_N = mipi_phy_if_clk_lp_n;
  assign mipi_phy_if_1_CLK_LP_P = mipi_phy_if_clk_lp_p;
  assign mipi_phy_if_1_DATA_HS_N = mipi_phy_if_data_hs_n[1:0];
  assign mipi_phy_if_1_DATA_HS_P = mipi_phy_if_data_hs_p[1:0];
  assign mipi_phy_if_1_DATA_LP_N = mipi_phy_if_data_lp_n[1:0];
  assign mipi_phy_if_1_DATA_LP_P = mipi_phy_if_data_lp_p[1:0];
  assign rxbyteclkhs = phy_rxbyteclkhs;
  assign system_rst_out = phy_system_rst_out;
  assign vfb_0_m_vfb_TREADY = video_out_tready;
  assign video_aclk_1 = video_aclk;
  assign video_aresetn_1 = video_aresetn;
  assign video_out_tdata[7:0] = vfb_0_m_vfb_TDATA;
  assign video_out_tdest[9:0] = vfb_0_m_vfb_TDEST;
  assign video_out_tlast = vfb_0_m_vfb_TLAST;
  assign video_out_tuser[0] = vfb_0_m_vfb_TUSER;
  assign video_out_tvalid = vfb_0_m_vfb_TVALID;
  bd_e616_phy_0 phy
       (.cl_enable(phy_rx_mipi_ppi_if_CL_ENABLE),
        .cl_rxulpsclknot(phy_rx_mipi_ppi_if_CL_RXULPSCLKNOT),
        .cl_stopstate(phy_rx_mipi_ppi_if_CL_STOPSTATE),
        .clk_hs_rxn(mipi_phy_if_1_CLK_HS_N),
        .clk_hs_rxp(mipi_phy_if_1_CLK_HS_P),
        .clk_lp_rxn(mipi_phy_if_1_CLK_LP_N),
        .clk_lp_rxp(mipi_phy_if_1_CLK_LP_P),
        .core_clk(dphy_clk_200M_1),
        .core_rst(r_sync_peripheral_reset),
        .data_hs_rxn(mipi_phy_if_1_DATA_HS_N),
        .data_hs_rxp(mipi_phy_if_1_DATA_HS_P),
        .data_lp_rxn(mipi_phy_if_1_DATA_LP_N),
        .data_lp_rxp(mipi_phy_if_1_DATA_LP_P),
        .dl0_enable(phy_rx_mipi_ppi_if_DL0_ENABLE),
        .dl0_errcontrol(phy_rx_mipi_ppi_if_DL0_ERRCONTROL),
        .dl0_erresc(phy_rx_mipi_ppi_if_DL0_ERRESC),
        .dl0_errsoths(phy_rx_mipi_ppi_if_DL0_ERRSOTHS),
        .dl0_errsotsynchs(phy_rx_mipi_ppi_if_DL0_ERRSOTSYNCHS),
        .dl0_forcerxmode(1'b0),
        .dl0_rxactivehs(phy_rx_mipi_ppi_if_DL0_RXACTIVEHS),
        .dl0_rxdatahs(phy_rx_mipi_ppi_if_DL0_RXDATAHS),
        .dl0_rxsynchs(phy_rx_mipi_ppi_if_DL0_RXSYNCHS),
        .dl0_rxulpsesc(phy_rx_mipi_ppi_if_DL0_RXULPSESC),
        .dl0_rxvalidhs(phy_rx_mipi_ppi_if_DL0_RXVALIDHS),
        .dl0_stopstate(phy_rx_mipi_ppi_if_DL0_STOPSTATE),
        .dl1_enable(phy_rx_mipi_ppi_if_DL1_ENABLE),
        .dl1_errcontrol(phy_rx_mipi_ppi_if_DL1_ERRCONTROL),
        .dl1_erresc(phy_rx_mipi_ppi_if_DL1_ERRESC),
        .dl1_errsoths(phy_rx_mipi_ppi_if_DL1_ERRSOTHS),
        .dl1_errsotsynchs(phy_rx_mipi_ppi_if_DL1_ERRSOTSYNCHS),
        .dl1_forcerxmode(1'b0),
        .dl1_rxactivehs(phy_rx_mipi_ppi_if_DL1_RXACTIVEHS),
        .dl1_rxdatahs(phy_rx_mipi_ppi_if_DL1_RXDATAHS),
        .dl1_rxsynchs(phy_rx_mipi_ppi_if_DL1_RXSYNCHS),
        .dl1_rxulpsesc(phy_rx_mipi_ppi_if_DL1_RXULPSESC),
        .dl1_rxvalidhs(phy_rx_mipi_ppi_if_DL1_RXVALIDHS),
        .dl1_stopstate(phy_rx_mipi_ppi_if_DL1_STOPSTATE),
        .rxbyteclkhs(phy_rxbyteclkhs),
        .system_rst_out(phy_system_rst_out));
  bd_e616_r_sync_0 r_sync
       (.aux_reset_in(1'b1),
        .dcm_locked(1'b1),
        .ext_reset_in(video_aresetn_1),
        .mb_debug_sys_rst(1'b0),
        .peripheral_reset(r_sync_peripheral_reset),
        .slowest_sync_clk(dphy_clk_200M_1));
  bd_e616_rx_0 rx
       (.cl_enable(phy_rx_mipi_ppi_if_CL_ENABLE),
        .cl_rxulpsclknot(phy_rx_mipi_ppi_if_CL_RXULPSCLKNOT),
        .cl_stopstate(phy_rx_mipi_ppi_if_CL_STOPSTATE),
        .cl_stopstate_intr(rx_cl_stopstate_intr),
        .core_enable(ctrl_core_en_1),
        .core_men_ack_vfb(vfb_0_core_men_ack_vfb),
        .core_men_vfb(rx_core_men_vfb),
        .crc_status_intr(rx_crc_status_intr),
        .disable_in_progress(rx_disable_in_progress),
        .dl0_errcontrol(phy_rx_mipi_ppi_if_DL0_ERRCONTROL),
        .dl0_erresc(phy_rx_mipi_ppi_if_DL0_ERRESC),
        .dl0_errsoths(phy_rx_mipi_ppi_if_DL0_ERRSOTHS),
        .dl0_errsotsynchs(phy_rx_mipi_ppi_if_DL0_ERRSOTSYNCHS),
        .dl0_rxactivehs(phy_rx_mipi_ppi_if_DL0_RXACTIVEHS),
        .dl0_rxbyteclkhs(phy_rxbyteclkhs),
        .dl0_rxdatahs(phy_rx_mipi_ppi_if_DL0_RXDATAHS),
        .dl0_rxsynchs(phy_rx_mipi_ppi_if_DL0_RXSYNCHS),
        .dl0_rxulpmesc(phy_rx_mipi_ppi_if_DL0_RXULPSESC),
        .dl0_rxvalidhs(phy_rx_mipi_ppi_if_DL0_RXVALIDHS),
        .dl0_shutdown(phy_rx_mipi_ppi_if_DL0_ENABLE),
        .dl0_stopstate(phy_rx_mipi_ppi_if_DL0_STOPSTATE),
        .dl0_stopstate_intr(rx_dl0_stopstate_intr),
        .dl1_errcontrol(phy_rx_mipi_ppi_if_DL1_ERRCONTROL),
        .dl1_erresc(phy_rx_mipi_ppi_if_DL1_ERRESC),
        .dl1_errsoths(phy_rx_mipi_ppi_if_DL1_ERRSOTHS),
        .dl1_errsotsynchs(phy_rx_mipi_ppi_if_DL1_ERRSOTSYNCHS),
        .dl1_rxactivehs(phy_rx_mipi_ppi_if_DL1_RXACTIVEHS),
        .dl1_rxbyteclkhs(phy_rxbyteclkhs),
        .dl1_rxdatahs(phy_rx_mipi_ppi_if_DL1_RXDATAHS),
        .dl1_rxsynchs(phy_rx_mipi_ppi_if_DL1_RXSYNCHS),
        .dl1_rxulpmesc(phy_rx_mipi_ppi_if_DL1_RXULPSESC),
        .dl1_rxvalidhs(phy_rx_mipi_ppi_if_DL1_RXVALIDHS),
        .dl1_shutdown(phy_rx_mipi_ppi_if_DL1_ENABLE),
        .dl1_stopstate(phy_rx_mipi_ppi_if_DL1_STOPSTATE),
        .dl1_stopstate_intr(rx_dl1_stopstate_intr),
        .ecc_status_intr(rx_ecc_status_intr),
        .errsoths_intr(rx_errsoths_intr),
        .errsotsynchs_intr(rx_errsotsynchs_intr),
        .frame_rcvd_pulse_out(rx_frame_rcvd_pulse_out),
        .linebuffer_full(rx_linebuffer_full),
        .m_axis_aclk(video_aclk_1),
        .m_axis_aresetn(video_aresetn_1),
        .m_axis_tdata(rx_m_axis_TDATA),
        .m_axis_tdest(rx_m_axis_TDEST),
        .m_axis_tkeep(rx_m_axis_TKEEP),
        .m_axis_tlast(rx_m_axis_TLAST),
        .m_axis_tready(rx_m_axis_TREADY),
        .m_axis_tuser(rx_m_axis_TUSER),
        .m_axis_tvalid(rx_m_axis_TVALID),
        .vfb_full(vfb_0_vfb_full),
        .vfb_wc_full(vfb_0_vfb_wc_full),
        .video_aclk(video_aclk_1));
  bd_e616_vfb_0_0 vfb_0
       (.core_men_ack_vfb(vfb_0_core_men_ack_vfb),
        .core_men_vfb(rx_core_men_vfb),
        .s_axis_aclk(video_aclk_1),
        .s_axis_aresetn(video_aresetn_1),
        .s_axis_tdata(rx_m_axis_TDATA),
        .s_axis_tdest(rx_m_axis_TDEST),
        .s_axis_tkeep(rx_m_axis_TKEEP),
        .s_axis_tlast(rx_m_axis_TLAST),
        .s_axis_tready(rx_m_axis_TREADY),
        .s_axis_tuser(rx_m_axis_TUSER),
        .s_axis_tvalid(rx_m_axis_TVALID),
        .vfb_arstn(video_aresetn_1),
        .vfb_clk(video_aclk_1),
        .vfb_data(vfb_0_m_vfb_TDATA),
        .vfb_eol(vfb_0_m_vfb_TLAST),
        .vfb_full(vfb_0_vfb_full),
        .vfb_ready(vfb_0_m_vfb_TREADY),
        .vfb_sof(vfb_0_m_vfb_TUSER),
        .vfb_valid(vfb_0_m_vfb_TVALID),
        .vfb_vcdt(vfb_0_m_vfb_TDEST),
        .vfb_wc_full(vfb_0_vfb_wc_full));
endmodule
