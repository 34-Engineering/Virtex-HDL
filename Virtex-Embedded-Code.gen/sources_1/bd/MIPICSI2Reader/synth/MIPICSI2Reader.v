//Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
//Date        : Mon Jun 28 22:33:31 2021
//Host        : liams-desktop running 64-bit major release  (build 9200)
//Command     : generate_target MIPICSI2Reader.bd
//Design      : MIPICSI2Reader
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "MIPICSI2Reader,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=MIPICSI2Reader,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=2,numReposBlks=2,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "MIPICSI2Reader.hwdef" *) 
module MIPICSI2Reader
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
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK, ASSOCIATED_RESET RESET, CLK_DOMAIN MIPICSI2Reader_CLK, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.000" *) input CLK;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK200 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK200, CLK_DOMAIN /clk_wiz_0_clk_out1, FREQ_HZ 200000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.0" *) output CLK200;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.ENABLED DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.ENABLED, LAYERED_METADATA undef" *) input ENABLED;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.MC_HSN CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.MC_HSN, CLK_DOMAIN MIPICSI2Reader_MC_HSN, FREQ_HZ 800000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.000" *) input MC_HSN;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.MC_HSP CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.MC_HSP, CLK_DOMAIN MIPICSI2Reader_MC_HSP, FREQ_HZ 800000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.000" *) input MC_HSP;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.MC_LPN CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.MC_LPN, CLK_DOMAIN MIPICSI2Reader_MC_LPN, FREQ_HZ 800000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.000" *) input MC_LPN;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.MC_LPP CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.MC_LPP, CLK_DOMAIN MIPICSI2Reader_MC_LPP, FREQ_HZ 800000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.000" *) input MC_LPP;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.MD_HSN DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.MD_HSN, LAYERED_METADATA undef" *) input [1:0]MD_HSN;
  input [1:0]MD_HSP;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.MD_LPN DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.MD_LPN, LAYERED_METADATA undef" *) input [1:0]MD_LPN;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.MD_LPP DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.MD_LPP, LAYERED_METADATA undef" *) input [1:0]MD_LPP;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.RESET RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.RESET, INSERT_VIP 0, POLARITY ACTIVE_LOW" *) input RESET;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.TDATA DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.TDATA, LAYERED_METADATA undef" *) output [7:0]TDATA;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.TDEST DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.TDEST, LAYERED_METADATA undef" *) output [9:0]TDEST;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.TLAST DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.TLAST, LAYERED_METADATA undef" *) output TLAST;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.TUSER DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.TUSER, LAYERED_METADATA undef" *) output [63:0]TUSER;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.TVALID DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.TVALID, LAYERED_METADATA undef" *) output TVALID;

  wire CLK_1;
  wire ENABLED_1;
  wire MC_HSN_1;
  wire MC_HSP_1;
  wire MC_LPN_1;
  wire MC_LPP_1;
  wire [1:0]MD_HSN_1;
  wire [1:0]MD_HSP_1;
  wire [1:0]MD_LPN_1;
  wire [1:0]MD_LPP_1;
  wire RESET_1;
  wire clk_wiz_0_clk_out1;
  wire [7:0]mipi_csi2_rx_subsyst_1_video_out_tdata;
  wire [9:0]mipi_csi2_rx_subsyst_1_video_out_tdest;
  wire mipi_csi2_rx_subsyst_1_video_out_tlast;
  wire [63:0]mipi_csi2_rx_subsyst_1_video_out_tuser;
  wire mipi_csi2_rx_subsyst_1_video_out_tvalid;

  assign CLK200 = clk_wiz_0_clk_out1;
  assign CLK_1 = CLK;
  assign ENABLED_1 = ENABLED;
  assign MC_HSN_1 = MC_HSN;
  assign MC_HSP_1 = MC_HSP;
  assign MC_LPN_1 = MC_LPN;
  assign MC_LPP_1 = MC_LPP;
  assign MD_HSN_1 = MD_HSN[1:0];
  assign MD_HSP_1 = MD_HSP[1:0];
  assign MD_LPN_1 = MD_LPN[1:0];
  assign MD_LPP_1 = MD_LPP[1:0];
  assign RESET_1 = RESET;
  assign TDATA[7:0] = mipi_csi2_rx_subsyst_1_video_out_tdata;
  assign TDEST[9:0] = mipi_csi2_rx_subsyst_1_video_out_tdest;
  assign TLAST = mipi_csi2_rx_subsyst_1_video_out_tlast;
  assign TUSER[63:0] = mipi_csi2_rx_subsyst_1_video_out_tuser;
  assign TVALID = mipi_csi2_rx_subsyst_1_video_out_tvalid;
  MIPICSI2Reader_clk_wiz_0_1 clk_wiz_0
       (.clk_in1(CLK_1),
        .clk_out1(clk_wiz_0_clk_out1));
  MIPICSI2Reader_mipi_csi2_rx_subsyst_1_0 mipi_csi2_rx_subsyst_1
       (.ctrl_core_en(ENABLED_1),
        .dphy_clk_200M(clk_wiz_0_clk_out1),
        .mipi_phy_if_clk_hs_n(MC_HSN_1),
        .mipi_phy_if_clk_hs_p(MC_HSP_1),
        .mipi_phy_if_clk_lp_n(MC_LPN_1),
        .mipi_phy_if_clk_lp_p(MC_LPP_1),
        .mipi_phy_if_data_hs_n(MD_HSN_1),
        .mipi_phy_if_data_hs_p(MD_HSP_1),
        .mipi_phy_if_data_lp_n(MD_LPN_1),
        .mipi_phy_if_data_lp_p(MD_LPP_1),
        .video_aclk(clk_wiz_0_clk_out1),
        .video_aresetn(RESET_1),
        .video_out_tdata(mipi_csi2_rx_subsyst_1_video_out_tdata),
        .video_out_tdest(mipi_csi2_rx_subsyst_1_video_out_tdest),
        .video_out_tlast(mipi_csi2_rx_subsyst_1_video_out_tlast),
        .video_out_tready(ENABLED_1),
        .video_out_tuser(mipi_csi2_rx_subsyst_1_video_out_tuser),
        .video_out_tvalid(mipi_csi2_rx_subsyst_1_video_out_tvalid));
endmodule
