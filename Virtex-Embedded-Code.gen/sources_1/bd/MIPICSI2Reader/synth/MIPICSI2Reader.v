//Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
//Date        : Wed Jun  9 14:33:34 2021
//Host        : liams-desktop running 64-bit major release  (build 9200)
//Command     : generate_target MIPICSI2Reader.bd
//Design      : MIPICSI2Reader
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "MIPICSI2Reader,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=MIPICSI2Reader,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=3,numReposBlks=3,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "MIPICSI2Reader.hwdef" *) 
module MIPICSI2Reader
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
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK, ASSOCIATED_RESET RESET, CLK_DOMAIN MIPICSI2Reader_CLK, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, INSERT_VIP 0, PHASE 0.000" *) input CLK;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.ENABLED DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.ENABLED, LAYERED_METADATA undef" *) input ENABLED;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.FID DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.FID, LAYERED_METADATA undef" *) input FID;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.MCLK_N DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.MCLK_N, LAYERED_METADATA undef" *) input MCLK_N;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.MCLK_P DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.MCLK_P, LAYERED_METADATA undef" *) input MCLK_P;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.MD_N DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.MD_N, LAYERED_METADATA undef" *) input [1:0]MD_N;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.MD_P DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.MD_P, LAYERED_METADATA undef" *) input [1:0]MD_P;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.OUT_ACTIVE_VIDEO DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.OUT_ACTIVE_VIDEO, LAYERED_METADATA undef" *) output OUT_ACTIVE_VIDEO;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.OUT_DATA DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.OUT_DATA, LAYERED_METADATA undef" *) output [7:0]OUT_DATA;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.OUT_HBLANK DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.OUT_HBLANK, LAYERED_METADATA undef" *) output OUT_HBLANK;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.OUT_HSYNC DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.OUT_HSYNC, LAYERED_METADATA undef" *) output OUT_HSYNC;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.OUT_OVERFLOW DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.OUT_OVERFLOW, LAYERED_METADATA undef" *) output OUT_OVERFLOW;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.OUT_UNDERFLOW DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.OUT_UNDERFLOW, LAYERED_METADATA undef" *) output OUT_UNDERFLOW;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.OUT_VBLANK DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.OUT_VBLANK, LAYERED_METADATA undef" *) output OUT_VBLANK;
  (* X_INTERFACE_INFO = "xilinx.com:signal:data:1.0 DATA.OUT_VSYNC DATA" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME DATA.OUT_VSYNC, LAYERED_METADATA undef" *) output OUT_VSYNC;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.RESET RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.RESET, INSERT_VIP 0, POLARITY ACTIVE_LOW" *) input RESET;

  wire CLK_1;
  wire ENABLED_1;
  wire FID_1;
  wire MCLK_N_1;
  wire MCLK_P_1;
  wire [1:0]MD_N_1;
  wire [1:0]MD_P_1;
  wire RESET_1;
  wire clk_wiz_0_clk_out1;
  wire [7:0]mipi_csi2_rx_subsyst_0_video_out_TDATA;
  wire mipi_csi2_rx_subsyst_0_video_out_TLAST;
  wire mipi_csi2_rx_subsyst_0_video_out_TREADY;
  wire [0:0]mipi_csi2_rx_subsyst_0_video_out_TUSER;
  wire mipi_csi2_rx_subsyst_0_video_out_TVALID;
  wire v_axi4s_vid_out_0_overflow;
  wire v_axi4s_vid_out_0_underflow;
  wire v_axi4s_vid_out_0_vid_active_video;
  wire [7:0]v_axi4s_vid_out_0_vid_data;
  wire v_axi4s_vid_out_0_vid_hblank;
  wire v_axi4s_vid_out_0_vid_hsync;
  wire v_axi4s_vid_out_0_vid_vblank;
  wire v_axi4s_vid_out_0_vid_vsync;

  assign CLK_1 = CLK;
  assign ENABLED_1 = ENABLED;
  assign FID_1 = FID;
  assign MCLK_N_1 = MCLK_N;
  assign MCLK_P_1 = MCLK_P;
  assign MD_N_1 = MD_N[1:0];
  assign MD_P_1 = MD_P[1:0];
  assign OUT_ACTIVE_VIDEO = v_axi4s_vid_out_0_vid_active_video;
  assign OUT_DATA[7:0] = v_axi4s_vid_out_0_vid_data;
  assign OUT_HBLANK = v_axi4s_vid_out_0_vid_hblank;
  assign OUT_HSYNC = v_axi4s_vid_out_0_vid_hsync;
  assign OUT_OVERFLOW = v_axi4s_vid_out_0_overflow;
  assign OUT_UNDERFLOW = v_axi4s_vid_out_0_underflow;
  assign OUT_VBLANK = v_axi4s_vid_out_0_vid_vblank;
  assign OUT_VSYNC = v_axi4s_vid_out_0_vid_vsync;
  assign RESET_1 = RESET;
  MIPICSI2Reader_clk_wiz_0_0 clk_wiz_0
       (.clk_in1(CLK_1),
        .clk_out1(clk_wiz_0_clk_out1));
  MIPICSI2Reader_mipi_csi2_rx_subsyst_0_0 mipi_csi2_rx_subsyst_0
       (.ctrl_core_en(ENABLED_1),
        .dphy_clk_200M(clk_wiz_0_clk_out1),
        .mipi_phy_if_clk_hs_n(1'b0),
        .mipi_phy_if_clk_hs_p(1'b0),
        .mipi_phy_if_clk_lp_n(MCLK_N_1),
        .mipi_phy_if_clk_lp_p(MCLK_P_1),
        .mipi_phy_if_data_hs_n({1'b0,1'b0}),
        .mipi_phy_if_data_hs_p({1'b0,1'b0}),
        .mipi_phy_if_data_lp_n(MD_N_1),
        .mipi_phy_if_data_lp_p(MD_P_1),
        .video_aclk(CLK_1),
        .video_aresetn(RESET_1),
        .video_out_tdata(mipi_csi2_rx_subsyst_0_video_out_TDATA),
        .video_out_tlast(mipi_csi2_rx_subsyst_0_video_out_TLAST),
        .video_out_tready(mipi_csi2_rx_subsyst_0_video_out_TREADY),
        .video_out_tuser(mipi_csi2_rx_subsyst_0_video_out_TUSER),
        .video_out_tvalid(mipi_csi2_rx_subsyst_0_video_out_TVALID));
  MIPICSI2Reader_v_axi4s_vid_out_0_0 v_axi4s_vid_out_0
       (.aclk(CLK_1),
        .aclken(ENABLED_1),
        .aresetn(RESET_1),
        .fid(FID_1),
        .overflow(v_axi4s_vid_out_0_overflow),
        .s_axis_video_tdata(mipi_csi2_rx_subsyst_0_video_out_TDATA),
        .s_axis_video_tlast(mipi_csi2_rx_subsyst_0_video_out_TLAST),
        .s_axis_video_tready(mipi_csi2_rx_subsyst_0_video_out_TREADY),
        .s_axis_video_tuser(mipi_csi2_rx_subsyst_0_video_out_TUSER),
        .s_axis_video_tvalid(mipi_csi2_rx_subsyst_0_video_out_TVALID),
        .underflow(v_axi4s_vid_out_0_underflow),
        .vid_active_video(v_axi4s_vid_out_0_vid_active_video),
        .vid_data(v_axi4s_vid_out_0_vid_data),
        .vid_hblank(v_axi4s_vid_out_0_vid_hblank),
        .vid_hsync(v_axi4s_vid_out_0_vid_hsync),
        .vid_io_out_ce(ENABLED_1),
        .vid_vblank(v_axi4s_vid_out_0_vid_vblank),
        .vid_vsync(v_axi4s_vid_out_0_vid_vsync),
        .vtg_active_video(1'b0),
        .vtg_field_id(1'b0),
        .vtg_hblank(1'b0),
        .vtg_hsync(1'b0),
        .vtg_vblank(1'b0),
        .vtg_vsync(1'b0));
endmodule
