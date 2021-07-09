// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Mon Jun 28 22:34:14 2021
// Host        : liams-desktop running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ bd_2647_vfb_0_0_sim_netlist.v
// Design      : bd_2647_vfb_0_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tftg256-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* AXIS_TDATA_WIDTH = "32" *) (* AXIS_TDEST_WIDTH = "4" *) (* AXIS_TUSER_WIDTH = "96" *) 
(* C_HS_LINE_RATE = "800" *) (* DowngradeIPIdentifiedWarnings = "yes" *) (* VFB_4PXL_W = "32" *) 
(* VFB_BYPASS_WC = "0" *) (* VFB_DATA_TYPE = "42" *) (* VFB_DCONV_OWIDTH = "8" *) 
(* VFB_EN_VCX = "0" *) (* VFB_FIFO_DEPTH = "2048" *) (* VFB_FIFO_WIDTH = "32" *) 
(* VFB_FILTER_VC = "0" *) (* VFB_OP_DWIDTH = "8" *) (* VFB_OP_PIXELS = "1" *) 
(* VFB_PXL_W = "8" *) (* VFB_PXL_W_BB = "8" *) (* VFB_REQ_BUFFER = "0" *) 
(* VFB_REQ_REORDER = "0" *) (* VFB_TU_WIDTH = "64" *) (* VFB_VC = "0" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
   (s_axis_aclk,
    s_axis_aresetn,
    s_axis_tready,
    s_axis_tvalid,
    s_axis_tlast,
    s_axis_tdata,
    s_axis_tkeep,
    s_axis_tuser,
    s_axis_tdest,
    mdt_tv,
    mdt_tr,
    sdt_tv,
    sdt_tr,
    vfb_tv,
    vfb_tr,
    vfb_arstn,
    vfb_clk,
    vfb_ready,
    core_men_vfb,
    vfb_full,
    vfb_wc_full,
    core_men_ack_vfb,
    vfb_valid,
    vfb_eol,
    vfb_sof,
    vfb_vcdt,
    vfb_data);
  input s_axis_aclk;
  input s_axis_aresetn;
  output s_axis_tready;
  input s_axis_tvalid;
  input s_axis_tlast;
  input [31:0]s_axis_tdata;
  input [3:0]s_axis_tkeep;
  input [95:0]s_axis_tuser;
  input [3:0]s_axis_tdest;
  output mdt_tv;
  output mdt_tr;
  output sdt_tv;
  output sdt_tr;
  output vfb_tv;
  output vfb_tr;
  input vfb_arstn;
  input vfb_clk;
  input vfb_ready;
  input core_men_vfb;
  output vfb_full;
  output vfb_wc_full;
  output core_men_ack_vfb;
  output vfb_valid;
  output vfb_eol;
  output [63:0]vfb_sof;
  output [9:0]vfb_vcdt;
  output [7:0]vfb_data;

  wire \<const0> ;
  wire \<const1> ;
  wire mdt_tr;
  wire s_axis_aclk;
  wire s_axis_aresetn;
  wire [31:0]s_axis_tdata;
  wire [3:0]s_axis_tdest;
  wire [3:0]s_axis_tkeep;
  wire s_axis_tlast;
  wire s_axis_tready;
  wire [95:0]s_axis_tuser;
  wire s_axis_tvalid;
  wire sdt_tr;
  wire sdt_tv;
  wire vfb_arstn;
  wire vfb_clk;
  wire [7:0]vfb_data;
  wire vfb_eol;
  wire vfb_ready;
  wire [63:0]vfb_sof;
  wire vfb_tr;
  wire vfb_tv;
  wire vfb_valid;
  wire [9:0]vfb_vcdt;
  wire NLW_inst_core_men_ack_vfb_UNCONNECTED;
  wire NLW_inst_mdt_tv_UNCONNECTED;
  wire NLW_inst_vfb_full_UNCONNECTED;
  wire NLW_inst_vfb_wc_full_UNCONNECTED;

  assign core_men_ack_vfb = \<const1> ;
  assign mdt_tv = \<const0> ;
  assign vfb_full = \<const0> ;
  assign vfb_wc_full = \<const0> ;
  GND GND
       (.G(\<const0> ));
  VCC VCC
       (.P(\<const1> ));
  (* AXIS_TDATA_WIDTH = "32" *) 
  (* AXIS_TDEST_WIDTH = "4" *) 
  (* AXIS_TUSER_WIDTH = "96" *) 
  (* C_HS_LINE_RATE = "800" *) 
  (* DowngradeIPIdentifiedWarnings = "yes" *) 
  (* VFB_4PXL_W = "32" *) 
  (* VFB_BYPASS_WC = "0" *) 
  (* VFB_DATA_TYPE = "42" *) 
  (* VFB_DCONV_OWIDTH = "8" *) 
  (* VFB_DCONV_TUW = "12" *) 
  (* VFB_EN_VCX = "0" *) 
  (* VFB_FIFO_DEPTH = "2048" *) 
  (* VFB_FIFO_WIDTH = "32" *) 
  (* VFB_FILTER_VC = "0" *) 
  (* VFB_OP_DWIDTH = "8" *) 
  (* VFB_OP_PIXELS = "1" *) 
  (* VFB_PXL_W = "8" *) 
  (* VFB_PXL_W_BB = "8" *) 
  (* VFB_REQ_BUFFER = "0" *) 
  (* VFB_REQ_REORDER = "0" *) 
  (* VFB_TSB0_WIDTH = "32" *) 
  (* VFB_TSB1_WIDTH = "32" *) 
  (* VFB_TSB2_WIDTH = "3" *) 
  (* VFB_TU_WIDTH = "64" *) 
  (* VFB_VC = "0" *) 
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_bd_2647_vfb_0_0_core inst
       (.core_men_ack_vfb(NLW_inst_core_men_ack_vfb_UNCONNECTED),
        .core_men_vfb(1'b0),
        .mdt_tr(mdt_tr),
        .mdt_tv(NLW_inst_mdt_tv_UNCONNECTED),
        .s_axis_aclk(s_axis_aclk),
        .s_axis_aresetn(s_axis_aresetn),
        .s_axis_tdata(s_axis_tdata),
        .s_axis_tdest(s_axis_tdest),
        .s_axis_tkeep({s_axis_tkeep[3:1],1'b0}),
        .s_axis_tlast(s_axis_tlast),
        .s_axis_tready(s_axis_tready),
        .s_axis_tuser({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axis_tuser[69:0]}),
        .s_axis_tvalid(s_axis_tvalid),
        .sdt_tr(sdt_tr),
        .sdt_tv(sdt_tv),
        .vfb_arstn(vfb_arstn),
        .vfb_clk(vfb_clk),
        .vfb_data(vfb_data),
        .vfb_eol(vfb_eol),
        .vfb_full(NLW_inst_vfb_full_UNCONNECTED),
        .vfb_ready(vfb_ready),
        .vfb_sof(vfb_sof),
        .vfb_tr(vfb_tr),
        .vfb_tv(vfb_tv),
        .vfb_valid(vfb_valid),
        .vfb_vcdt(vfb_vcdt),
        .vfb_wc_full(NLW_inst_vfb_wc_full_UNCONNECTED));
endmodule

(* AXIS_TDATA_WIDTH = "32" *) (* AXIS_TDEST_WIDTH = "4" *) (* AXIS_TUSER_WIDTH = "96" *) 
(* C_HS_LINE_RATE = "800" *) (* DowngradeIPIdentifiedWarnings = "yes" *) (* VFB_4PXL_W = "32" *) 
(* VFB_BYPASS_WC = "0" *) (* VFB_DATA_TYPE = "42" *) (* VFB_DCONV_OWIDTH = "8" *) 
(* VFB_DCONV_TUW = "12" *) (* VFB_EN_VCX = "0" *) (* VFB_FIFO_DEPTH = "2048" *) 
(* VFB_FIFO_WIDTH = "32" *) (* VFB_FILTER_VC = "0" *) (* VFB_OP_DWIDTH = "8" *) 
(* VFB_OP_PIXELS = "1" *) (* VFB_PXL_W = "8" *) (* VFB_PXL_W_BB = "8" *) 
(* VFB_REQ_BUFFER = "0" *) (* VFB_REQ_REORDER = "0" *) (* VFB_TSB0_WIDTH = "32" *) 
(* VFB_TSB1_WIDTH = "32" *) (* VFB_TSB2_WIDTH = "3" *) (* VFB_TU_WIDTH = "64" *) 
(* VFB_VC = "0" *) 
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_bd_2647_vfb_0_0_core
   (s_axis_aclk,
    s_axis_aresetn,
    s_axis_tready,
    s_axis_tvalid,
    s_axis_tlast,
    s_axis_tdata,
    s_axis_tkeep,
    s_axis_tuser,
    s_axis_tdest,
    mdt_tv,
    mdt_tr,
    sdt_tv,
    sdt_tr,
    vfb_tv,
    vfb_tr,
    vfb_arstn,
    vfb_clk,
    vfb_ready,
    core_men_vfb,
    vfb_full,
    vfb_wc_full,
    core_men_ack_vfb,
    vfb_valid,
    vfb_eol,
    vfb_sof,
    vfb_vcdt,
    vfb_data);
  input s_axis_aclk;
  input s_axis_aresetn;
  output s_axis_tready;
  input s_axis_tvalid;
  input s_axis_tlast;
  input [31:0]s_axis_tdata;
  input [3:0]s_axis_tkeep;
  input [95:0]s_axis_tuser;
  input [3:0]s_axis_tdest;
  output mdt_tv;
  output mdt_tr;
  output sdt_tv;
  output sdt_tr;
  output vfb_tv;
  output vfb_tr;
  input vfb_arstn;
  input vfb_clk;
  input vfb_ready;
  input core_men_vfb;
  output vfb_full;
  output vfb_wc_full;
  output core_men_ack_vfb;
  output vfb_valid;
  output vfb_eol;
  output [63:0]vfb_sof;
  output [9:0]vfb_vcdt;
  output [7:0]vfb_data;

  wire \<const0> ;
  wire \VFB_MIN.reorder_n_0 ;
  wire \VFB_MIN.reorder_n_10 ;
  wire \VFB_MIN.reorder_n_11 ;
  wire \VFB_MIN.reorder_n_12 ;
  wire \VFB_MIN.reorder_n_13 ;
  wire \VFB_MIN.reorder_n_14 ;
  wire \VFB_MIN.reorder_n_15 ;
  wire \VFB_MIN.reorder_n_16 ;
  wire \VFB_MIN.reorder_n_17 ;
  wire \VFB_MIN.reorder_n_18 ;
  wire \VFB_MIN.reorder_n_19 ;
  wire \VFB_MIN.reorder_n_20 ;
  wire \VFB_MIN.reorder_n_21 ;
  wire \VFB_MIN.reorder_n_22 ;
  wire \VFB_MIN.reorder_n_3 ;
  wire \VFB_MIN.reorder_n_5 ;
  wire \VFB_MIN.reorder_n_6 ;
  wire \VFB_MIN.reorder_n_7 ;
  wire \VFB_MIN.reorder_n_77 ;
  wire \VFB_MIN.reorder_n_78 ;
  wire \VFB_MIN.reorder_n_79 ;
  wire \VFB_MIN.reorder_n_8 ;
  wire \VFB_MIN.reorder_n_80 ;
  wire \VFB_MIN.reorder_n_81 ;
  wire \VFB_MIN.reorder_n_82 ;
  wire \VFB_MIN.reorder_n_83 ;
  wire \VFB_MIN.reorder_n_84 ;
  wire \VFB_MIN.reorder_n_85 ;
  wire \VFB_MIN.reorder_n_86 ;
  wire \VFB_MIN.reorder_n_87 ;
  wire \VFB_MIN.reorder_n_88 ;
  wire \VFB_MIN.reorder_n_89 ;
  wire \VFB_MIN.reorder_n_9 ;
  wire \VFB_MIN.reorder_n_90 ;
  wire \VFB_MIN.reorder_n_92 ;
  wire \VFB_MIN.reorder_n_98 ;
  wire \VFB_MIN.reorder_n_99 ;
  wire cur_dtype_udef;
  wire [15:0]frmnum;
  wire [15:0]linenum;
  wire mdt_tr;
  wire n_0_259;
  wire op_inf_n_10;
  wire op_inf_n_100;
  wire op_inf_n_101;
  wire op_inf_n_102;
  wire op_inf_n_103;
  wire op_inf_n_104;
  wire op_inf_n_105;
  wire op_inf_n_106;
  wire op_inf_n_107;
  wire op_inf_n_108;
  wire op_inf_n_109;
  wire op_inf_n_110;
  wire op_inf_n_111;
  wire op_inf_n_112;
  wire op_inf_n_113;
  wire op_inf_n_114;
  wire op_inf_n_115;
  wire op_inf_n_116;
  wire op_inf_n_117;
  wire op_inf_n_7;
  wire op_inf_n_9;
  wire op_inf_n_94;
  wire op_inf_n_95;
  wire op_inf_n_96;
  wire op_inf_n_97;
  wire op_inf_n_98;
  wire op_inf_n_99;
  wire p_0_in12_in;
  wire s_axis_aclk;
  wire s_axis_aresetn;
  wire [31:0]s_axis_tdata;
  wire [3:0]s_axis_tdest;
  wire [3:0]s_axis_tkeep;
  wire s_axis_tlast;
  wire s_axis_tready;
  wire [95:0]s_axis_tuser;
  wire s_axis_tvalid;
  wire sband_tact0;
  wire [23:0]sband_td_r;
  wire sband_tk_r;
  wire sband_tl;
  wire sband_tl_r;
  wire [9:4]sband_ts;
  wire [3:0]sband_ts__0;
  wire [9:0]sband_ts_r;
  wire sdt_tr;
  wire sdt_tv;
  wire vfb_arstn;
  wire vfb_clk;
  wire [7:0]vfb_data;
  wire vfb_eol;
  wire vfb_ready;
  wire [63:0]vfb_sof;
  wire vfb_sof015_out;
  wire vfb_sof119_out;
  wire vfb_valid;
  wire [9:0]vfb_vcdt;
  wire [15:0]wc;

  assign core_men_ack_vfb = \<const0> ;
  assign mdt_tv = \<const0> ;
  assign vfb_full = \<const0> ;
  assign vfb_tr = vfb_ready;
  assign vfb_tv = vfb_valid;
  assign vfb_wc_full = \<const0> ;
  GND GND
       (.G(\<const0> ));
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_vfb_v1_0_16_reorder \VFB_MIN.reorder 
       (.D({\VFB_MIN.reorder_n_5 ,\VFB_MIN.reorder_n_6 ,\VFB_MIN.reorder_n_7 ,\VFB_MIN.reorder_n_8 ,\VFB_MIN.reorder_n_9 ,\VFB_MIN.reorder_n_10 ,\VFB_MIN.reorder_n_11 ,\VFB_MIN.reorder_n_12 }),
        .E(sband_tk_r),
        .Q({op_inf_n_9,op_inf_n_10}),
        .\buf_data_reg[0][101]_0 (\VFB_MIN.reorder_n_0 ),
        .\buf_data_reg[0][103]_0 ({\VFB_MIN.reorder_n_98 ,\VFB_MIN.reorder_n_99 }),
        .\buf_data_reg[0][135]_0 (sband_td_r),
        .\buf_data_reg[0][73]_0 ({\VFB_MIN.reorder_n_13 ,\VFB_MIN.reorder_n_14 ,\VFB_MIN.reorder_n_15 ,\VFB_MIN.reorder_n_16 ,\VFB_MIN.reorder_n_17 ,\VFB_MIN.reorder_n_18 ,\VFB_MIN.reorder_n_19 ,\VFB_MIN.reorder_n_20 ,\VFB_MIN.reorder_n_21 ,\VFB_MIN.reorder_n_22 }),
        .\buf_data_reg[0][73]_1 ({sband_ts,wc,linenum,frmnum,\VFB_MIN.reorder_n_77 ,\VFB_MIN.reorder_n_78 ,\VFB_MIN.reorder_n_79 ,\VFB_MIN.reorder_n_80 ,\VFB_MIN.reorder_n_81 ,\VFB_MIN.reorder_n_82 ,\VFB_MIN.reorder_n_83 ,\VFB_MIN.reorder_n_84 ,\VFB_MIN.reorder_n_85 ,\VFB_MIN.reorder_n_86 ,\VFB_MIN.reorder_n_87 ,\VFB_MIN.reorder_n_88 ,\VFB_MIN.reorder_n_89 ,\VFB_MIN.reorder_n_90 ,p_0_in12_in,\VFB_MIN.reorder_n_92 ,sband_ts__0}),
        .\buf_data_reg[1][136]_0 ({s_axis_tlast,s_axis_tdata,s_axis_tkeep[3:1],s_axis_tuser[69:0],s_axis_tdest}),
        .cur_dtype_sink_reg_0(\VFB_MIN.reorder_n_3 ),
        .cur_dtype_udef(cur_dtype_udef),
        .s_axis_aclk(s_axis_aclk),
        .s_axis_aresetn(s_axis_aresetn),
        .s_axis_tready(s_axis_tready),
        .s_axis_tvalid(s_axis_tvalid),
        .sband_tact0(sband_tact0),
        .\sband_td_r_reg[15] ({op_inf_n_94,op_inf_n_95,op_inf_n_96,op_inf_n_97,op_inf_n_98,op_inf_n_99,op_inf_n_100,op_inf_n_101,op_inf_n_102,op_inf_n_103,op_inf_n_104,op_inf_n_105,op_inf_n_106,op_inf_n_107,op_inf_n_108,op_inf_n_109,op_inf_n_110,op_inf_n_111,op_inf_n_112,op_inf_n_113,op_inf_n_114,op_inf_n_115,op_inf_n_116,op_inf_n_117}),
        .\sband_tk_r_reg[2] (vfb_valid),
        .sband_tl(sband_tl),
        .sband_tl_r(sband_tl_r),
        .sband_tl_r_reg(op_inf_n_7),
        .sband_tl_r_reg_0(vfb_eol),
        .sdt_tv(sdt_tv),
        .vfb_ready(vfb_ready),
        .vfb_sof015_out(vfb_sof015_out),
        .vfb_sof119_out(vfb_sof119_out),
        .\vfb_vcdt_reg[9] (sband_ts_r));
  LUT1 #(
    .INIT(2'h1)) 
    i_259
       (.I0(vfb_arstn),
        .O(n_0_259));
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_vfb_v1_0_16_op_inf op_inf
       (.D({\VFB_MIN.reorder_n_98 ,\VFB_MIN.reorder_n_99 }),
        .E(sband_tk_r),
        .Q({op_inf_n_9,op_inf_n_10}),
        .cur_dtype_udef(cur_dtype_udef),
        .mdt_tr(mdt_tr),
        .sband_tact0(sband_tact0),
        .\sband_td_r_reg[23]_0 ({op_inf_n_94,op_inf_n_95,op_inf_n_96,op_inf_n_97,op_inf_n_98,op_inf_n_99,op_inf_n_100,op_inf_n_101,op_inf_n_102,op_inf_n_103,op_inf_n_104,op_inf_n_105,op_inf_n_106,op_inf_n_107,op_inf_n_108,op_inf_n_109,op_inf_n_110,op_inf_n_111,op_inf_n_112,op_inf_n_113,op_inf_n_114,op_inf_n_115,op_inf_n_116,op_inf_n_117}),
        .\sband_td_r_reg[23]_1 (sband_td_r),
        .sband_tl(sband_tl),
        .sband_tl_r(sband_tl_r),
        .\sband_ts_r_reg[9]_0 (sband_ts_r),
        .\sband_ts_r_reg[9]_1 ({sband_ts,wc,linenum,frmnum,\VFB_MIN.reorder_n_77 ,\VFB_MIN.reorder_n_78 ,\VFB_MIN.reorder_n_79 ,\VFB_MIN.reorder_n_80 ,\VFB_MIN.reorder_n_81 ,\VFB_MIN.reorder_n_82 ,\VFB_MIN.reorder_n_83 ,\VFB_MIN.reorder_n_84 ,\VFB_MIN.reorder_n_85 ,\VFB_MIN.reorder_n_86 ,\VFB_MIN.reorder_n_87 ,\VFB_MIN.reorder_n_88 ,\VFB_MIN.reorder_n_89 ,\VFB_MIN.reorder_n_90 ,p_0_in12_in,\VFB_MIN.reorder_n_92 ,sband_ts__0}),
        .\sband_tu_r_reg[0]_0 (\VFB_MIN.reorder_n_3 ),
        .sdt_tr(sdt_tr),
        .sdt_tv(sdt_tv),
        .vfb_arstn(vfb_arstn),
        .vfb_clk(vfb_clk),
        .\vfb_cnt_reg[3]_0 (op_inf_n_7),
        .vfb_data(vfb_data),
        .\vfb_data_reg[7]_0 ({\VFB_MIN.reorder_n_5 ,\VFB_MIN.reorder_n_6 ,\VFB_MIN.reorder_n_7 ,\VFB_MIN.reorder_n_8 ,\VFB_MIN.reorder_n_9 ,\VFB_MIN.reorder_n_10 ,\VFB_MIN.reorder_n_11 ,\VFB_MIN.reorder_n_12 }),
        .vfb_eol_reg_0(vfb_eol),
        .vfb_eol_reg_1(\VFB_MIN.reorder_n_0 ),
        .vfb_ready(vfb_ready),
        .vfb_sof(vfb_sof[63:1]),
        .vfb_sof015_out(vfb_sof015_out),
        .vfb_sof119_out(vfb_sof119_out),
        .\vfb_sof_reg[0]_0 (vfb_sof[0]),
        .vfb_valid_reg_0(vfb_valid),
        .vfb_vcdt(vfb_vcdt),
        .\vfb_vcdt_reg[9]_0 ({\VFB_MIN.reorder_n_13 ,\VFB_MIN.reorder_n_14 ,\VFB_MIN.reorder_n_15 ,\VFB_MIN.reorder_n_16 ,\VFB_MIN.reorder_n_17 ,\VFB_MIN.reorder_n_18 ,\VFB_MIN.reorder_n_19 ,\VFB_MIN.reorder_n_20 ,\VFB_MIN.reorder_n_21 ,\VFB_MIN.reorder_n_22 }));
endmodule

module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_vfb_v1_0_16_op_inf
   (sband_tl_r,
    vfb_eol_reg_0,
    vfb_valid_reg_0,
    \vfb_sof_reg[0]_0 ,
    vfb_sof015_out,
    sband_tact0,
    sdt_tr,
    \vfb_cnt_reg[3]_0 ,
    mdt_tr,
    Q,
    vfb_sof,
    \sband_ts_r_reg[9]_0 ,
    vfb_vcdt,
    \sband_td_r_reg[23]_0 ,
    vfb_data,
    vfb_sof119_out,
    sband_tl,
    vfb_clk,
    vfb_ready,
    vfb_arstn,
    \sband_tu_r_reg[0]_0 ,
    cur_dtype_udef,
    vfb_eol_reg_1,
    sdt_tv,
    \sband_ts_r_reg[9]_1 ,
    E,
    D,
    \vfb_vcdt_reg[9]_0 ,
    \sband_td_r_reg[23]_1 ,
    \vfb_data_reg[7]_0 );
  output sband_tl_r;
  output vfb_eol_reg_0;
  output vfb_valid_reg_0;
  output \vfb_sof_reg[0]_0 ;
  output vfb_sof015_out;
  output sband_tact0;
  output sdt_tr;
  output \vfb_cnt_reg[3]_0 ;
  output mdt_tr;
  output [1:0]Q;
  output [62:0]vfb_sof;
  output [9:0]\sband_ts_r_reg[9]_0 ;
  output [9:0]vfb_vcdt;
  output [23:0]\sband_td_r_reg[23]_0 ;
  output [7:0]vfb_data;
  input vfb_sof119_out;
  input sband_tl;
  input vfb_clk;
  input vfb_ready;
  input vfb_arstn;
  input \sband_tu_r_reg[0]_0 ;
  input cur_dtype_udef;
  input vfb_eol_reg_1;
  input sdt_tv;
  input [73:0]\sband_ts_r_reg[9]_1 ;
  input [0:0]E;
  input [1:0]D;
  input [9:0]\vfb_vcdt_reg[9]_0 ;
  input [23:0]\sband_td_r_reg[23]_1 ;
  input [7:0]\vfb_data_reg[7]_0 ;

  wire [1:0]D;
  wire [0:0]E;
  wire [1:0]Q;
  wire \TUSR0.vfb_sof[10]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[11]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[12]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[13]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[14]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[15]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[16]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[17]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[18]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[19]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[1]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[20]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[21]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[22]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[23]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[24]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[25]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[26]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[27]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[28]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[29]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[2]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[30]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[31]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[32]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[33]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[34]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[35]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[36]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[37]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[38]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[39]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[3]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[40]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[41]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[42]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[43]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[44]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[45]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[46]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[47]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[48]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[49]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[4]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[50]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[51]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[52]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[53]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[54]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[55]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[56]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[57]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[58]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[59]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[5]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[60]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[61]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[62]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[63]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[63]_i_2_n_0 ;
  wire \TUSR0.vfb_sof[63]_i_3_n_0 ;
  wire \TUSR0.vfb_sof[6]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[7]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[8]_i_1_n_0 ;
  wire \TUSR0.vfb_sof[9]_i_1_n_0 ;
  wire \VFB_MIN.reorder/s_axis_tready__1 ;
  wire [3:0]cnt_done0;
  wire cur_dtype_udef;
  wire mdt_tr;
  wire sband_tact;
  wire sband_tact0;
  wire sband_tact_i_1_n_0;
  wire [23:0]\sband_td_r_reg[23]_0 ;
  wire [23:0]\sband_td_r_reg[23]_1 ;
  wire sband_tl;
  wire sband_tl_r;
  wire [9:0]\sband_ts_r_reg[9]_0 ;
  wire [73:0]\sband_ts_r_reg[9]_1 ;
  wire [0:0]sband_tu;
  wire [0:0]sband_tu_r;
  wire \sband_tu_r_reg[0]_0 ;
  wire \sband_tu_r_reg_n_0_[10] ;
  wire \sband_tu_r_reg_n_0_[11] ;
  wire \sband_tu_r_reg_n_0_[12] ;
  wire \sband_tu_r_reg_n_0_[13] ;
  wire \sband_tu_r_reg_n_0_[14] ;
  wire \sband_tu_r_reg_n_0_[15] ;
  wire \sband_tu_r_reg_n_0_[16] ;
  wire \sband_tu_r_reg_n_0_[17] ;
  wire \sband_tu_r_reg_n_0_[18] ;
  wire \sband_tu_r_reg_n_0_[19] ;
  wire \sband_tu_r_reg_n_0_[1] ;
  wire \sband_tu_r_reg_n_0_[20] ;
  wire \sband_tu_r_reg_n_0_[21] ;
  wire \sband_tu_r_reg_n_0_[22] ;
  wire \sband_tu_r_reg_n_0_[23] ;
  wire \sband_tu_r_reg_n_0_[24] ;
  wire \sband_tu_r_reg_n_0_[25] ;
  wire \sband_tu_r_reg_n_0_[26] ;
  wire \sband_tu_r_reg_n_0_[27] ;
  wire \sband_tu_r_reg_n_0_[28] ;
  wire \sband_tu_r_reg_n_0_[29] ;
  wire \sband_tu_r_reg_n_0_[2] ;
  wire \sband_tu_r_reg_n_0_[30] ;
  wire \sband_tu_r_reg_n_0_[31] ;
  wire \sband_tu_r_reg_n_0_[32] ;
  wire \sband_tu_r_reg_n_0_[33] ;
  wire \sband_tu_r_reg_n_0_[34] ;
  wire \sband_tu_r_reg_n_0_[35] ;
  wire \sband_tu_r_reg_n_0_[36] ;
  wire \sband_tu_r_reg_n_0_[37] ;
  wire \sband_tu_r_reg_n_0_[38] ;
  wire \sband_tu_r_reg_n_0_[39] ;
  wire \sband_tu_r_reg_n_0_[3] ;
  wire \sband_tu_r_reg_n_0_[40] ;
  wire \sband_tu_r_reg_n_0_[41] ;
  wire \sband_tu_r_reg_n_0_[42] ;
  wire \sband_tu_r_reg_n_0_[43] ;
  wire \sband_tu_r_reg_n_0_[44] ;
  wire \sband_tu_r_reg_n_0_[45] ;
  wire \sband_tu_r_reg_n_0_[46] ;
  wire \sband_tu_r_reg_n_0_[47] ;
  wire \sband_tu_r_reg_n_0_[48] ;
  wire \sband_tu_r_reg_n_0_[49] ;
  wire \sband_tu_r_reg_n_0_[4] ;
  wire \sband_tu_r_reg_n_0_[50] ;
  wire \sband_tu_r_reg_n_0_[51] ;
  wire \sband_tu_r_reg_n_0_[52] ;
  wire \sband_tu_r_reg_n_0_[53] ;
  wire \sband_tu_r_reg_n_0_[54] ;
  wire \sband_tu_r_reg_n_0_[55] ;
  wire \sband_tu_r_reg_n_0_[56] ;
  wire \sband_tu_r_reg_n_0_[57] ;
  wire \sband_tu_r_reg_n_0_[58] ;
  wire \sband_tu_r_reg_n_0_[59] ;
  wire \sband_tu_r_reg_n_0_[5] ;
  wire \sband_tu_r_reg_n_0_[60] ;
  wire \sband_tu_r_reg_n_0_[61] ;
  wire \sband_tu_r_reg_n_0_[62] ;
  wire \sband_tu_r_reg_n_0_[63] ;
  wire \sband_tu_r_reg_n_0_[6] ;
  wire \sband_tu_r_reg_n_0_[7] ;
  wire \sband_tu_r_reg_n_0_[8] ;
  wire \sband_tu_r_reg_n_0_[9] ;
  wire sdt_tr;
  wire sdt_tv;
  wire vfb_arstn;
  wire vfb_clk;
  wire \vfb_cnt[3]_i_1_n_0 ;
  wire [3:0]vfb_cnt_reg;
  wire \vfb_cnt_reg[3]_0 ;
  wire [7:0]vfb_data;
  wire \vfb_data[7]_i_1_n_0 ;
  wire [7:0]\vfb_data_reg[7]_0 ;
  wire vfb_eol_i_1_n_0;
  wire vfb_eol_reg_0;
  wire vfb_eol_reg_1;
  wire vfb_ready;
  wire [62:0]vfb_sof;
  wire vfb_sof015_out;
  wire vfb_sof119_out;
  wire vfb_sof122_out;
  wire vfb_sof225_out;
  wire vfb_sof4_out;
  wire \vfb_sof[0]_i_1_n_0 ;
  wire \vfb_sof[0]_i_3_n_0 ;
  wire \vfb_sof[0]_i_4_n_0 ;
  wire \vfb_sof_reg[0]_0 ;
  wire vfb_tu0;
  wire vfb_tu0_i_1_n_0;
  wire vfb_valid_i_1_n_0;
  wire vfb_valid_reg_0;
  wire [9:0]vfb_vcdt;
  wire \vfb_vcdt[9]_i_1_n_0 ;
  wire [9:0]\vfb_vcdt_reg[9]_0 ;

  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[10]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[10] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [14]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[10]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[11]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[11] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [15]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[11]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[12]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[12] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [16]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[12]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[13]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[13] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [17]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[13]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[14]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[14] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [18]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[14]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[15]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[15] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [19]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[15]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[16]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[16] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [20]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[16]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[17]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[17] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [21]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[17]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[18]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[18] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [22]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[18]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[19]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[19] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [23]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[19]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[1]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[1] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [5]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[20]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[20] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [24]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[20]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[21]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[21] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [25]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[21]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[22]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[22] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [26]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[22]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[23]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[23] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [27]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[23]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[24]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[24] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [28]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[24]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[25]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[25] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [29]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[25]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[26]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[26] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [30]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[26]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[27]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[27] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [31]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[27]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[28]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[28] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [32]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[28]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[29]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[29] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [33]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[29]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[2]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[2] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [6]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[2]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[30]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[30] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [34]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[30]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[31]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[31] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [35]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[31]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[32]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[32] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [36]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[32]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[33]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[33] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [37]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[33]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[34]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[34] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [38]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[34]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[35]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[35] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [39]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[35]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[36]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[36] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [40]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[36]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[37]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[37] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [41]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[37]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[38]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[38] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [42]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[38]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[39]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[39] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [43]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[39]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[3]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[3] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [7]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[40]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[40] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [44]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[40]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[41]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[41] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [45]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[41]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[42]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[42] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [46]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[42]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[43]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[43] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [47]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[43]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[44]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[44] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [48]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[44]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[45]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[45] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [49]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[45]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[46]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[46] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [50]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[46]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[47]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[47] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [51]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[47]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[48]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[48] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [52]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[48]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[49]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[49] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [53]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[49]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[4]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[4] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [8]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[4]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[50]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[50] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [54]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[50]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[51]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[51] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [55]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[51]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[52]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[52] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [56]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[52]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[53]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[53] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [57]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[53]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[54]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[54] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [58]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[54]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[55]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[55] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [59]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[55]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[56]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[56] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [60]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[56]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[57]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[57] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [61]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[57]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[58]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[58] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [62]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[58]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[59]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[59] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [63]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[59]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[5]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[5] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [9]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[5]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[60]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[60] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [64]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[60]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[61]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[61] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [65]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[61]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[62]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[62] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [66]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[62]_i_1_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \TUSR0.vfb_sof[63]_i_1 
       (.I0(vfb_arstn),
        .O(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hF3F3F380FFFFFFFF)) 
    \TUSR0.vfb_sof[63]_i_2 
       (.I0(vfb_eol_reg_0),
        .I1(vfb_valid_reg_0),
        .I2(vfb_ready),
        .I3(vfb_sof015_out),
        .I4(vfb_sof119_out),
        .I5(vfb_arstn),
        .O(\TUSR0.vfb_sof[63]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[63]_i_3 
       (.I0(\sband_tu_r_reg_n_0_[63] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [67]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[63]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[6]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[6] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [10]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[6]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[7]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[7] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [11]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[8]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[8] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [12]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[8]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00E2E2E2E2E2E2E2)) 
    \TUSR0.vfb_sof[9]_i_1 
       (.I0(\sband_tu_r_reg_n_0_[9] ),
        .I1(vfb_sof119_out),
        .I2(\sband_ts_r_reg[9]_1 [13]),
        .I3(vfb_eol_reg_0),
        .I4(vfb_valid_reg_0),
        .I5(vfb_ready),
        .O(\TUSR0.vfb_sof[9]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[10] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[10]_i_1_n_0 ),
        .Q(vfb_sof[9]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[11] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[11]_i_1_n_0 ),
        .Q(vfb_sof[10]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[12] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[12]_i_1_n_0 ),
        .Q(vfb_sof[11]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[13] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[13]_i_1_n_0 ),
        .Q(vfb_sof[12]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[14] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[14]_i_1_n_0 ),
        .Q(vfb_sof[13]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[15] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[15]_i_1_n_0 ),
        .Q(vfb_sof[14]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[16] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[16]_i_1_n_0 ),
        .Q(vfb_sof[15]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[17] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[17]_i_1_n_0 ),
        .Q(vfb_sof[16]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[18] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[18]_i_1_n_0 ),
        .Q(vfb_sof[17]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[19] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[19]_i_1_n_0 ),
        .Q(vfb_sof[18]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[1] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[1]_i_1_n_0 ),
        .Q(vfb_sof[0]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[20] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[20]_i_1_n_0 ),
        .Q(vfb_sof[19]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[21] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[21]_i_1_n_0 ),
        .Q(vfb_sof[20]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[22] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[22]_i_1_n_0 ),
        .Q(vfb_sof[21]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[23] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[23]_i_1_n_0 ),
        .Q(vfb_sof[22]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[24] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[24]_i_1_n_0 ),
        .Q(vfb_sof[23]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[25] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[25]_i_1_n_0 ),
        .Q(vfb_sof[24]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[26] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[26]_i_1_n_0 ),
        .Q(vfb_sof[25]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[27] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[27]_i_1_n_0 ),
        .Q(vfb_sof[26]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[28] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[28]_i_1_n_0 ),
        .Q(vfb_sof[27]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[29] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[29]_i_1_n_0 ),
        .Q(vfb_sof[28]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[2] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[2]_i_1_n_0 ),
        .Q(vfb_sof[1]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[30] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[30]_i_1_n_0 ),
        .Q(vfb_sof[29]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[31] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[31]_i_1_n_0 ),
        .Q(vfb_sof[30]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[32] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[32]_i_1_n_0 ),
        .Q(vfb_sof[31]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[33] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[33]_i_1_n_0 ),
        .Q(vfb_sof[32]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[34] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[34]_i_1_n_0 ),
        .Q(vfb_sof[33]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[35] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[35]_i_1_n_0 ),
        .Q(vfb_sof[34]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[36] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[36]_i_1_n_0 ),
        .Q(vfb_sof[35]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[37] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[37]_i_1_n_0 ),
        .Q(vfb_sof[36]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[38] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[38]_i_1_n_0 ),
        .Q(vfb_sof[37]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[39] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[39]_i_1_n_0 ),
        .Q(vfb_sof[38]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[3] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[3]_i_1_n_0 ),
        .Q(vfb_sof[2]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[40] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[40]_i_1_n_0 ),
        .Q(vfb_sof[39]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[41] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[41]_i_1_n_0 ),
        .Q(vfb_sof[40]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[42] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[42]_i_1_n_0 ),
        .Q(vfb_sof[41]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[43] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[43]_i_1_n_0 ),
        .Q(vfb_sof[42]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[44] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[44]_i_1_n_0 ),
        .Q(vfb_sof[43]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[45] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[45]_i_1_n_0 ),
        .Q(vfb_sof[44]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[46] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[46]_i_1_n_0 ),
        .Q(vfb_sof[45]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[47] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[47]_i_1_n_0 ),
        .Q(vfb_sof[46]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[48] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[48]_i_1_n_0 ),
        .Q(vfb_sof[47]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[49] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[49]_i_1_n_0 ),
        .Q(vfb_sof[48]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[4] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[4]_i_1_n_0 ),
        .Q(vfb_sof[3]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[50] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[50]_i_1_n_0 ),
        .Q(vfb_sof[49]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[51] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[51]_i_1_n_0 ),
        .Q(vfb_sof[50]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[52] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[52]_i_1_n_0 ),
        .Q(vfb_sof[51]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[53] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[53]_i_1_n_0 ),
        .Q(vfb_sof[52]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[54] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[54]_i_1_n_0 ),
        .Q(vfb_sof[53]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[55] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[55]_i_1_n_0 ),
        .Q(vfb_sof[54]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[56] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[56]_i_1_n_0 ),
        .Q(vfb_sof[55]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[57] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[57]_i_1_n_0 ),
        .Q(vfb_sof[56]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[58] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[58]_i_1_n_0 ),
        .Q(vfb_sof[57]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[59] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[59]_i_1_n_0 ),
        .Q(vfb_sof[58]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[5] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[5]_i_1_n_0 ),
        .Q(vfb_sof[4]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[60] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[60]_i_1_n_0 ),
        .Q(vfb_sof[59]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[61] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[61]_i_1_n_0 ),
        .Q(vfb_sof[60]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[62] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[62]_i_1_n_0 ),
        .Q(vfb_sof[61]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[63] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[63]_i_3_n_0 ),
        .Q(vfb_sof[62]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[6] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[6]_i_1_n_0 ),
        .Q(vfb_sof[5]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[7] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[7]_i_1_n_0 ),
        .Q(vfb_sof[6]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[8] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[8]_i_1_n_0 ),
        .Q(vfb_sof[7]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \TUSR0.vfb_sof_reg[9] 
       (.C(vfb_clk),
        .CE(\TUSR0.vfb_sof[63]_i_2_n_0 ),
        .D(\TUSR0.vfb_sof[9]_i_1_n_0 ),
        .Q(vfb_sof[8]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT2 #(
    .INIT(4'hB)) 
    mdt_tr_INST_0
       (.I0(vfb_ready),
        .I1(vfb_valid_reg_0),
        .O(mdt_tr));
  LUT5 #(
    .INIT(32'hFF020000)) 
    sband_tact_i_1
       (.I0(sband_tact),
        .I1(vfb_sof122_out),
        .I2(sband_tact0),
        .I3(vfb_sof119_out),
        .I4(vfb_arstn),
        .O(sband_tact_i_1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT3 #(
    .INIT(8'h80)) 
    sband_tact_i_2
       (.I0(vfb_ready),
        .I1(vfb_valid_reg_0),
        .I2(vfb_eol_reg_0),
        .O(vfb_sof122_out));
  FDRE sband_tact_reg
       (.C(vfb_clk),
        .CE(1'b1),
        .D(sband_tact_i_1_n_0),
        .Q(sband_tact),
        .R(1'b0));
  FDRE \sband_td_r_reg[0] 
       (.C(vfb_clk),
        .CE(E),
        .D(\sband_td_r_reg[23]_1 [0]),
        .Q(\sband_td_r_reg[23]_0 [0]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_td_r_reg[10] 
       (.C(vfb_clk),
        .CE(E),
        .D(\sband_td_r_reg[23]_1 [10]),
        .Q(\sband_td_r_reg[23]_0 [10]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_td_r_reg[11] 
       (.C(vfb_clk),
        .CE(E),
        .D(\sband_td_r_reg[23]_1 [11]),
        .Q(\sband_td_r_reg[23]_0 [11]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_td_r_reg[12] 
       (.C(vfb_clk),
        .CE(E),
        .D(\sband_td_r_reg[23]_1 [12]),
        .Q(\sband_td_r_reg[23]_0 [12]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_td_r_reg[13] 
       (.C(vfb_clk),
        .CE(E),
        .D(\sband_td_r_reg[23]_1 [13]),
        .Q(\sband_td_r_reg[23]_0 [13]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_td_r_reg[14] 
       (.C(vfb_clk),
        .CE(E),
        .D(\sband_td_r_reg[23]_1 [14]),
        .Q(\sband_td_r_reg[23]_0 [14]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_td_r_reg[15] 
       (.C(vfb_clk),
        .CE(E),
        .D(\sband_td_r_reg[23]_1 [15]),
        .Q(\sband_td_r_reg[23]_0 [15]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_td_r_reg[16] 
       (.C(vfb_clk),
        .CE(E),
        .D(\sband_td_r_reg[23]_1 [16]),
        .Q(\sband_td_r_reg[23]_0 [16]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_td_r_reg[17] 
       (.C(vfb_clk),
        .CE(E),
        .D(\sband_td_r_reg[23]_1 [17]),
        .Q(\sband_td_r_reg[23]_0 [17]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_td_r_reg[18] 
       (.C(vfb_clk),
        .CE(E),
        .D(\sband_td_r_reg[23]_1 [18]),
        .Q(\sband_td_r_reg[23]_0 [18]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_td_r_reg[19] 
       (.C(vfb_clk),
        .CE(E),
        .D(\sband_td_r_reg[23]_1 [19]),
        .Q(\sband_td_r_reg[23]_0 [19]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_td_r_reg[1] 
       (.C(vfb_clk),
        .CE(E),
        .D(\sband_td_r_reg[23]_1 [1]),
        .Q(\sband_td_r_reg[23]_0 [1]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_td_r_reg[20] 
       (.C(vfb_clk),
        .CE(E),
        .D(\sband_td_r_reg[23]_1 [20]),
        .Q(\sband_td_r_reg[23]_0 [20]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_td_r_reg[21] 
       (.C(vfb_clk),
        .CE(E),
        .D(\sband_td_r_reg[23]_1 [21]),
        .Q(\sband_td_r_reg[23]_0 [21]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_td_r_reg[22] 
       (.C(vfb_clk),
        .CE(E),
        .D(\sband_td_r_reg[23]_1 [22]),
        .Q(\sband_td_r_reg[23]_0 [22]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_td_r_reg[23] 
       (.C(vfb_clk),
        .CE(E),
        .D(\sband_td_r_reg[23]_1 [23]),
        .Q(\sband_td_r_reg[23]_0 [23]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_td_r_reg[2] 
       (.C(vfb_clk),
        .CE(E),
        .D(\sband_td_r_reg[23]_1 [2]),
        .Q(\sband_td_r_reg[23]_0 [2]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_td_r_reg[3] 
       (.C(vfb_clk),
        .CE(E),
        .D(\sband_td_r_reg[23]_1 [3]),
        .Q(\sband_td_r_reg[23]_0 [3]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_td_r_reg[4] 
       (.C(vfb_clk),
        .CE(E),
        .D(\sband_td_r_reg[23]_1 [4]),
        .Q(\sband_td_r_reg[23]_0 [4]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_td_r_reg[5] 
       (.C(vfb_clk),
        .CE(E),
        .D(\sband_td_r_reg[23]_1 [5]),
        .Q(\sband_td_r_reg[23]_0 [5]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_td_r_reg[6] 
       (.C(vfb_clk),
        .CE(E),
        .D(\sband_td_r_reg[23]_1 [6]),
        .Q(\sband_td_r_reg[23]_0 [6]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_td_r_reg[7] 
       (.C(vfb_clk),
        .CE(E),
        .D(\sband_td_r_reg[23]_1 [7]),
        .Q(\sband_td_r_reg[23]_0 [7]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_td_r_reg[8] 
       (.C(vfb_clk),
        .CE(E),
        .D(\sband_td_r_reg[23]_1 [8]),
        .Q(\sband_td_r_reg[23]_0 [8]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_td_r_reg[9] 
       (.C(vfb_clk),
        .CE(E),
        .D(\sband_td_r_reg[23]_1 [9]),
        .Q(\sband_td_r_reg[23]_0 [9]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tk_r_reg[1] 
       (.C(vfb_clk),
        .CE(E),
        .D(D[0]),
        .Q(Q[0]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tk_r_reg[2] 
       (.C(vfb_clk),
        .CE(E),
        .D(D[1]),
        .Q(Q[1]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h10000000FFFFFFFF)) 
    sband_tl_r_i_3
       (.I0(vfb_cnt_reg[3]),
        .I1(vfb_cnt_reg[2]),
        .I2(vfb_cnt_reg[1]),
        .I3(vfb_cnt_reg[0]),
        .I4(vfb_ready),
        .I5(vfb_valid_reg_0),
        .O(\vfb_cnt_reg[3]_0 ));
  FDRE sband_tl_r_reg
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(sband_tl),
        .Q(sband_tl_r),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_ts_r_reg[0] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [0]),
        .Q(\sband_ts_r_reg[9]_0 [0]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_ts_r_reg[1] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [1]),
        .Q(\sband_ts_r_reg[9]_0 [1]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_ts_r_reg[2] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [2]),
        .Q(\sband_ts_r_reg[9]_0 [2]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_ts_r_reg[3] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [3]),
        .Q(\sband_ts_r_reg[9]_0 [3]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_ts_r_reg[4] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [68]),
        .Q(\sband_ts_r_reg[9]_0 [4]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_ts_r_reg[5] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [69]),
        .Q(\sband_ts_r_reg[9]_0 [5]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_ts_r_reg[6] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [70]),
        .Q(\sband_ts_r_reg[9]_0 [6]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_ts_r_reg[7] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [71]),
        .Q(\sband_ts_r_reg[9]_0 [7]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_ts_r_reg[8] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [72]),
        .Q(\sband_ts_r_reg[9]_0 [8]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_ts_r_reg[9] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [73]),
        .Q(\sband_ts_r_reg[9]_0 [9]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFF000D0000000000)) 
    \sband_tu_r[0]_i_1 
       (.I0(vfb_valid_reg_0),
        .I1(sband_tact0),
        .I2(vfb_eol_reg_0),
        .I3(\sband_ts_r_reg[9]_1 [4]),
        .I4(\sband_tu_r_reg[0]_0 ),
        .I5(sdt_tv),
        .O(sband_tu));
  FDRE \sband_tu_r_reg[0] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(sband_tu),
        .Q(sband_tu_r),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[10] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [14]),
        .Q(\sband_tu_r_reg_n_0_[10] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[11] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [15]),
        .Q(\sband_tu_r_reg_n_0_[11] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[12] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [16]),
        .Q(\sband_tu_r_reg_n_0_[12] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[13] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [17]),
        .Q(\sband_tu_r_reg_n_0_[13] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[14] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [18]),
        .Q(\sband_tu_r_reg_n_0_[14] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[15] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [19]),
        .Q(\sband_tu_r_reg_n_0_[15] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[16] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [20]),
        .Q(\sband_tu_r_reg_n_0_[16] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[17] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [21]),
        .Q(\sband_tu_r_reg_n_0_[17] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[18] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [22]),
        .Q(\sband_tu_r_reg_n_0_[18] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[19] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [23]),
        .Q(\sband_tu_r_reg_n_0_[19] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[1] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [5]),
        .Q(\sband_tu_r_reg_n_0_[1] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[20] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [24]),
        .Q(\sband_tu_r_reg_n_0_[20] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[21] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [25]),
        .Q(\sband_tu_r_reg_n_0_[21] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[22] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [26]),
        .Q(\sband_tu_r_reg_n_0_[22] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[23] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [27]),
        .Q(\sband_tu_r_reg_n_0_[23] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[24] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [28]),
        .Q(\sband_tu_r_reg_n_0_[24] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[25] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [29]),
        .Q(\sband_tu_r_reg_n_0_[25] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[26] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [30]),
        .Q(\sband_tu_r_reg_n_0_[26] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[27] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [31]),
        .Q(\sband_tu_r_reg_n_0_[27] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[28] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [32]),
        .Q(\sband_tu_r_reg_n_0_[28] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[29] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [33]),
        .Q(\sband_tu_r_reg_n_0_[29] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[2] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [6]),
        .Q(\sband_tu_r_reg_n_0_[2] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[30] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [34]),
        .Q(\sband_tu_r_reg_n_0_[30] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[31] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [35]),
        .Q(\sband_tu_r_reg_n_0_[31] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[32] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [36]),
        .Q(\sband_tu_r_reg_n_0_[32] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[33] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [37]),
        .Q(\sband_tu_r_reg_n_0_[33] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[34] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [38]),
        .Q(\sband_tu_r_reg_n_0_[34] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[35] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [39]),
        .Q(\sband_tu_r_reg_n_0_[35] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[36] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [40]),
        .Q(\sband_tu_r_reg_n_0_[36] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[37] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [41]),
        .Q(\sband_tu_r_reg_n_0_[37] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[38] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [42]),
        .Q(\sband_tu_r_reg_n_0_[38] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[39] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [43]),
        .Q(\sband_tu_r_reg_n_0_[39] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[3] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [7]),
        .Q(\sband_tu_r_reg_n_0_[3] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[40] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [44]),
        .Q(\sband_tu_r_reg_n_0_[40] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[41] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [45]),
        .Q(\sband_tu_r_reg_n_0_[41] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[42] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [46]),
        .Q(\sband_tu_r_reg_n_0_[42] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[43] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [47]),
        .Q(\sband_tu_r_reg_n_0_[43] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[44] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [48]),
        .Q(\sband_tu_r_reg_n_0_[44] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[45] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [49]),
        .Q(\sband_tu_r_reg_n_0_[45] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[46] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [50]),
        .Q(\sband_tu_r_reg_n_0_[46] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[47] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [51]),
        .Q(\sband_tu_r_reg_n_0_[47] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[48] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [52]),
        .Q(\sband_tu_r_reg_n_0_[48] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[49] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [53]),
        .Q(\sband_tu_r_reg_n_0_[49] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[4] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [8]),
        .Q(\sband_tu_r_reg_n_0_[4] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[50] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [54]),
        .Q(\sband_tu_r_reg_n_0_[50] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[51] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [55]),
        .Q(\sband_tu_r_reg_n_0_[51] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[52] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [56]),
        .Q(\sband_tu_r_reg_n_0_[52] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[53] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [57]),
        .Q(\sband_tu_r_reg_n_0_[53] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[54] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [58]),
        .Q(\sband_tu_r_reg_n_0_[54] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[55] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [59]),
        .Q(\sband_tu_r_reg_n_0_[55] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[56] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [60]),
        .Q(\sband_tu_r_reg_n_0_[56] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[57] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [61]),
        .Q(\sband_tu_r_reg_n_0_[57] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[58] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [62]),
        .Q(\sband_tu_r_reg_n_0_[58] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[59] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [63]),
        .Q(\sband_tu_r_reg_n_0_[59] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[5] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [9]),
        .Q(\sband_tu_r_reg_n_0_[5] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[60] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [64]),
        .Q(\sband_tu_r_reg_n_0_[60] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[61] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [65]),
        .Q(\sband_tu_r_reg_n_0_[61] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[62] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [66]),
        .Q(\sband_tu_r_reg_n_0_[62] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[63] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [67]),
        .Q(\sband_tu_r_reg_n_0_[63] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[6] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [10]),
        .Q(\sband_tu_r_reg_n_0_[6] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[7] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [11]),
        .Q(\sband_tu_r_reg_n_0_[7] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[8] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [12]),
        .Q(\sband_tu_r_reg_n_0_[8] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[9] 
       (.C(vfb_clk),
        .CE(vfb_sof119_out),
        .D(\sband_ts_r_reg[9]_1 [13]),
        .Q(\sband_tu_r_reg_n_0_[9] ),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
  LUT3 #(
    .INIT(8'h0D)) 
    sdt_tr_INST_0
       (.I0(vfb_valid_reg_0),
        .I1(sband_tact0),
        .I2(vfb_eol_reg_0),
        .O(sdt_tr));
  LUT6 #(
    .INIT(64'h0000000000008000)) 
    sdt_tr_INST_0_i_1
       (.I0(vfb_ready),
        .I1(vfb_valid_reg_0),
        .I2(vfb_cnt_reg[0]),
        .I3(vfb_cnt_reg[1]),
        .I4(vfb_cnt_reg[2]),
        .I5(vfb_cnt_reg[3]),
        .O(sband_tact0));
  LUT1 #(
    .INIT(2'h1)) 
    \vfb_cnt[0]_i_1 
       (.I0(vfb_cnt_reg[0]),
        .O(cnt_done0[0]));
  (* SOFT_HLUTNM = "soft_lutpair28" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \vfb_cnt[1]_i_1 
       (.I0(vfb_cnt_reg[0]),
        .I1(vfb_cnt_reg[1]),
        .O(cnt_done0[1]));
  (* SOFT_HLUTNM = "soft_lutpair28" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \vfb_cnt[2]_i_1 
       (.I0(vfb_cnt_reg[0]),
        .I1(vfb_cnt_reg[1]),
        .I2(vfb_cnt_reg[2]),
        .O(cnt_done0[2]));
  LUT5 #(
    .INIT(32'hEAAAFFFF)) 
    \vfb_cnt[3]_i_1 
       (.I0(sband_tact0),
        .I1(vfb_ready),
        .I2(vfb_valid_reg_0),
        .I3(vfb_eol_reg_0),
        .I4(vfb_arstn),
        .O(\vfb_cnt[3]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h8)) 
    \vfb_cnt[3]_i_2 
       (.I0(vfb_valid_reg_0),
        .I1(vfb_ready),
        .O(vfb_sof225_out));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT4 #(
    .INIT(16'h7F80)) 
    \vfb_cnt[3]_i_3 
       (.I0(vfb_cnt_reg[1]),
        .I1(vfb_cnt_reg[0]),
        .I2(vfb_cnt_reg[2]),
        .I3(vfb_cnt_reg[3]),
        .O(cnt_done0[3]));
  FDRE \vfb_cnt_reg[0] 
       (.C(vfb_clk),
        .CE(vfb_sof225_out),
        .D(cnt_done0[0]),
        .Q(vfb_cnt_reg[0]),
        .R(\vfb_cnt[3]_i_1_n_0 ));
  FDRE \vfb_cnt_reg[1] 
       (.C(vfb_clk),
        .CE(vfb_sof225_out),
        .D(cnt_done0[1]),
        .Q(vfb_cnt_reg[1]),
        .R(\vfb_cnt[3]_i_1_n_0 ));
  FDRE \vfb_cnt_reg[2] 
       (.C(vfb_clk),
        .CE(vfb_sof225_out),
        .D(cnt_done0[2]),
        .Q(vfb_cnt_reg[2]),
        .R(\vfb_cnt[3]_i_1_n_0 ));
  FDRE \vfb_cnt_reg[3] 
       (.C(vfb_clk),
        .CE(vfb_sof225_out),
        .D(cnt_done0[3]),
        .Q(vfb_cnt_reg[3]),
        .R(\vfb_cnt[3]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'h73)) 
    \vfb_data[7]_i_1 
       (.I0(vfb_eol_reg_0),
        .I1(vfb_valid_reg_0),
        .I2(vfb_ready),
        .O(\vfb_data[7]_i_1_n_0 ));
  FDRE \vfb_data_reg[0] 
       (.C(vfb_clk),
        .CE(\vfb_data[7]_i_1_n_0 ),
        .D(\vfb_data_reg[7]_0 [0]),
        .Q(vfb_data[0]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \vfb_data_reg[1] 
       (.C(vfb_clk),
        .CE(\vfb_data[7]_i_1_n_0 ),
        .D(\vfb_data_reg[7]_0 [1]),
        .Q(vfb_data[1]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \vfb_data_reg[2] 
       (.C(vfb_clk),
        .CE(\vfb_data[7]_i_1_n_0 ),
        .D(\vfb_data_reg[7]_0 [2]),
        .Q(vfb_data[2]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \vfb_data_reg[3] 
       (.C(vfb_clk),
        .CE(\vfb_data[7]_i_1_n_0 ),
        .D(\vfb_data_reg[7]_0 [3]),
        .Q(vfb_data[3]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \vfb_data_reg[4] 
       (.C(vfb_clk),
        .CE(\vfb_data[7]_i_1_n_0 ),
        .D(\vfb_data_reg[7]_0 [4]),
        .Q(vfb_data[4]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \vfb_data_reg[5] 
       (.C(vfb_clk),
        .CE(\vfb_data[7]_i_1_n_0 ),
        .D(\vfb_data_reg[7]_0 [5]),
        .Q(vfb_data[5]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \vfb_data_reg[6] 
       (.C(vfb_clk),
        .CE(\vfb_data[7]_i_1_n_0 ),
        .D(\vfb_data_reg[7]_0 [6]),
        .Q(vfb_data[6]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \vfb_data_reg[7] 
       (.C(vfb_clk),
        .CE(\vfb_data[7]_i_1_n_0 ),
        .D(\vfb_data_reg[7]_0 [7]),
        .Q(vfb_data[7]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT5 #(
    .INIT(32'h7B080000)) 
    vfb_eol_i_1
       (.I0(vfb_eol_reg_0),
        .I1(vfb_valid_reg_0),
        .I2(vfb_ready),
        .I3(vfb_eol_reg_1),
        .I4(vfb_arstn),
        .O(vfb_eol_i_1_n_0));
  FDRE vfb_eol_reg
       (.C(vfb_clk),
        .CE(1'b1),
        .D(vfb_eol_i_1_n_0),
        .Q(vfb_eol_reg_0),
        .R(1'b0));
  LUT4 #(
    .INIT(16'h00E2)) 
    \vfb_sof[0]_i_1 
       (.I0(\vfb_sof_reg[0]_0 ),
        .I1(vfb_sof4_out),
        .I2(\vfb_sof[0]_i_3_n_0 ),
        .I3(\vfb_sof[0]_i_4_n_0 ),
        .O(\vfb_sof[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT5 #(
    .INIT(32'hF0EEE0EE)) 
    \vfb_sof[0]_i_2 
       (.I0(vfb_sof119_out),
        .I1(vfb_sof015_out),
        .I2(vfb_ready),
        .I3(vfb_valid_reg_0),
        .I4(vfb_eol_reg_0),
        .O(vfb_sof4_out));
  LUT6 #(
    .INIT(64'h00000000E2222222)) 
    \vfb_sof[0]_i_3 
       (.I0(sband_tu_r),
        .I1(vfb_sof119_out),
        .I2(sdt_tv),
        .I3(\VFB_MIN.reorder/s_axis_tready__1 ),
        .I4(\sband_ts_r_reg[9]_1 [4]),
        .I5(vfb_sof122_out),
        .O(\vfb_sof[0]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h80F38080FFFFFFFF)) 
    \vfb_sof[0]_i_4 
       (.I0(\vfb_sof_reg[0]_0 ),
        .I1(vfb_valid_reg_0),
        .I2(vfb_ready),
        .I3(vfb_eol_reg_0),
        .I4(vfb_tu0),
        .I5(vfb_arstn),
        .O(\vfb_sof[0]_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
  LUT5 #(
    .INIT(32'hAAFBAAAA)) 
    \vfb_sof[0]_i_5 
       (.I0(\sband_tu_r_reg[0]_0 ),
        .I1(vfb_valid_reg_0),
        .I2(sband_tact0),
        .I3(vfb_eol_reg_0),
        .I4(cur_dtype_udef),
        .O(\VFB_MIN.reorder/s_axis_tready__1 ));
  FDRE \vfb_sof_reg[0] 
       (.C(vfb_clk),
        .CE(1'b1),
        .D(\vfb_sof[0]_i_1_n_0 ),
        .Q(\vfb_sof_reg[0]_0 ),
        .R(1'b0));
  LUT6 #(
    .INIT(64'h2AEA2AAA00000000)) 
    vfb_tu0_i_1
       (.I0(vfb_tu0),
        .I1(vfb_ready),
        .I2(vfb_valid_reg_0),
        .I3(vfb_eol_reg_0),
        .I4(\vfb_sof_reg[0]_0 ),
        .I5(vfb_arstn),
        .O(vfb_tu0_i_1_n_0));
  FDRE vfb_tu0_reg
       (.C(vfb_clk),
        .CE(1'b1),
        .D(vfb_tu0_i_1_n_0),
        .Q(vfb_tu0),
        .R(1'b0));
  LUT6 #(
    .INIT(64'h7F7F7F2200000000)) 
    vfb_valid_i_1
       (.I0(vfb_valid_reg_0),
        .I1(vfb_ready),
        .I2(vfb_eol_reg_0),
        .I3(vfb_sof119_out),
        .I4(vfb_sof015_out),
        .I5(vfb_arstn),
        .O(vfb_valid_i_1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT5 #(
    .INIT(32'hAAAAAA2A)) 
    vfb_valid_i_2
       (.I0(sband_tact),
        .I1(vfb_cnt_reg[0]),
        .I2(vfb_cnt_reg[1]),
        .I3(vfb_cnt_reg[2]),
        .I4(vfb_cnt_reg[3]),
        .O(vfb_sof015_out));
  FDRE vfb_valid_reg
       (.C(vfb_clk),
        .CE(1'b1),
        .D(vfb_valid_i_1_n_0),
        .Q(vfb_valid_reg_0),
        .R(1'b0));
  LUT4 #(
    .INIT(16'hDDD0)) 
    \vfb_vcdt[9]_i_1 
       (.I0(vfb_valid_reg_0),
        .I1(vfb_ready),
        .I2(sband_tact),
        .I3(vfb_sof119_out),
        .O(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \vfb_vcdt_reg[0] 
       (.C(vfb_clk),
        .CE(\vfb_vcdt[9]_i_1_n_0 ),
        .D(\vfb_vcdt_reg[9]_0 [0]),
        .Q(vfb_vcdt[0]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \vfb_vcdt_reg[1] 
       (.C(vfb_clk),
        .CE(\vfb_vcdt[9]_i_1_n_0 ),
        .D(\vfb_vcdt_reg[9]_0 [1]),
        .Q(vfb_vcdt[1]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \vfb_vcdt_reg[2] 
       (.C(vfb_clk),
        .CE(\vfb_vcdt[9]_i_1_n_0 ),
        .D(\vfb_vcdt_reg[9]_0 [2]),
        .Q(vfb_vcdt[2]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \vfb_vcdt_reg[3] 
       (.C(vfb_clk),
        .CE(\vfb_vcdt[9]_i_1_n_0 ),
        .D(\vfb_vcdt_reg[9]_0 [3]),
        .Q(vfb_vcdt[3]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \vfb_vcdt_reg[4] 
       (.C(vfb_clk),
        .CE(\vfb_vcdt[9]_i_1_n_0 ),
        .D(\vfb_vcdt_reg[9]_0 [4]),
        .Q(vfb_vcdt[4]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \vfb_vcdt_reg[5] 
       (.C(vfb_clk),
        .CE(\vfb_vcdt[9]_i_1_n_0 ),
        .D(\vfb_vcdt_reg[9]_0 [5]),
        .Q(vfb_vcdt[5]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \vfb_vcdt_reg[6] 
       (.C(vfb_clk),
        .CE(\vfb_vcdt[9]_i_1_n_0 ),
        .D(\vfb_vcdt_reg[9]_0 [6]),
        .Q(vfb_vcdt[6]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \vfb_vcdt_reg[7] 
       (.C(vfb_clk),
        .CE(\vfb_vcdt[9]_i_1_n_0 ),
        .D(\vfb_vcdt_reg[9]_0 [7]),
        .Q(vfb_vcdt[7]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \vfb_vcdt_reg[8] 
       (.C(vfb_clk),
        .CE(\vfb_vcdt[9]_i_1_n_0 ),
        .D(\vfb_vcdt_reg[9]_0 [8]),
        .Q(vfb_vcdt[8]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
  FDRE \vfb_vcdt_reg[9] 
       (.C(vfb_clk),
        .CE(\vfb_vcdt[9]_i_1_n_0 ),
        .D(\vfb_vcdt_reg[9]_0 [9]),
        .Q(vfb_vcdt[9]),
        .R(\TUSR0.vfb_sof[63]_i_1_n_0 ));
endmodule

module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_vfb_v1_0_16_reorder
   (\buf_data_reg[0][101]_0 ,
    sband_tl,
    vfb_sof119_out,
    cur_dtype_sink_reg_0,
    cur_dtype_udef,
    D,
    \buf_data_reg[0][73]_0 ,
    \buf_data_reg[0][73]_1 ,
    E,
    \buf_data_reg[0][103]_0 ,
    \buf_data_reg[0][135]_0 ,
    sdt_tv,
    s_axis_tready,
    s_axis_tvalid,
    vfb_sof015_out,
    Q,
    sband_tl_r,
    sband_tl_r_reg,
    sband_tl_r_reg_0,
    \sband_td_r_reg[15] ,
    \vfb_vcdt_reg[9] ,
    vfb_ready,
    \sband_tk_r_reg[2] ,
    sband_tact0,
    \buf_data_reg[1][136]_0 ,
    s_axis_aresetn,
    s_axis_aclk);
  output \buf_data_reg[0][101]_0 ;
  output sband_tl;
  output vfb_sof119_out;
  output cur_dtype_sink_reg_0;
  output cur_dtype_udef;
  output [7:0]D;
  output [9:0]\buf_data_reg[0][73]_0 ;
  output [73:0]\buf_data_reg[0][73]_1 ;
  output [0:0]E;
  output [1:0]\buf_data_reg[0][103]_0 ;
  output [23:0]\buf_data_reg[0][135]_0 ;
  output sdt_tv;
  output s_axis_tready;
  input s_axis_tvalid;
  input vfb_sof015_out;
  input [1:0]Q;
  input sband_tl_r;
  input sband_tl_r_reg;
  input sband_tl_r_reg_0;
  input [23:0]\sband_td_r_reg[15] ;
  input [9:0]\vfb_vcdt_reg[9] ;
  input vfb_ready;
  input \sband_tk_r_reg[2] ;
  input sband_tact0;
  input [109:0]\buf_data_reg[1][136]_0 ;
  input s_axis_aresetn;
  input s_axis_aclk;

  wire [7:0]D;
  wire [0:0]E;
  wire [1:0]Q;
  wire \buf_data[0][136]_i_1_n_0 ;
  wire \buf_data[1][136]_i_1_n_0 ;
  wire \buf_data[1][136]_i_2_n_0 ;
  wire \buf_data_reg[0][101]_0 ;
  wire [1:0]\buf_data_reg[0][103]_0 ;
  wire [23:0]\buf_data_reg[0][135]_0 ;
  wire [9:0]\buf_data_reg[0][73]_0 ;
  wire [73:0]\buf_data_reg[0][73]_1 ;
  wire [136:0]\buf_data_reg[1] ;
  wire [109:0]\buf_data_reg[1][136]_0 ;
  wire \buf_valid[0]_i_1_n_0 ;
  wire \buf_valid[1]_i_1_n_0 ;
  wire \buf_valid_reg_n_0_[0] ;
  wire cur_dtype_pxls1;
  wire cur_dtype_sink_i_1_n_0;
  wire cur_dtype_sink_i_3_n_0;
  wire cur_dtype_sink_reg_0;
  wire cur_dtype_udef;
  wire cur_dtype_udef_i_1_n_0;
  wire main_dtvc;
  wire p_0_in;
  wire [136:0]p_2_in;
  wire s_axis_aclk;
  wire s_axis_aresetn;
  wire [31:0]s_axis_tdata__0;
  wire s_axis_tlast;
  wire s_axis_tready;
  wire s_axis_tvalid;
  wire sban_dtvc;
  wire sband_tact0;
  wire [23:0]\sband_td_r_reg[15] ;
  wire [3:1]sband_tk;
  wire \sband_tk_r_reg[2] ;
  wire sband_tl;
  wire sband_tl_r;
  wire sband_tl_r_reg;
  wire sband_tl_r_reg_0;
  wire sdt_tv;
  wire vfb_ready;
  wire vfb_sof015_out;
  wire vfb_sof119_out;
  wire [9:0]\vfb_vcdt_reg[9] ;

  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][0]_i_1 
       (.I0(\buf_data_reg[1] [0]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [0]),
        .O(p_2_in[0]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][101]_i_1 
       (.I0(\buf_data_reg[1] [101]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [74]),
        .O(p_2_in[101]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][102]_i_1 
       (.I0(\buf_data_reg[1] [102]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [75]),
        .O(p_2_in[102]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][103]_i_1 
       (.I0(\buf_data_reg[1] [103]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [76]),
        .O(p_2_in[103]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][104]_i_1 
       (.I0(\buf_data_reg[1] [104]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [77]),
        .O(p_2_in[104]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][105]_i_1 
       (.I0(\buf_data_reg[1] [105]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [78]),
        .O(p_2_in[105]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][106]_i_1 
       (.I0(\buf_data_reg[1] [106]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [79]),
        .O(p_2_in[106]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][107]_i_1 
       (.I0(\buf_data_reg[1] [107]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [80]),
        .O(p_2_in[107]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][108]_i_1 
       (.I0(\buf_data_reg[1] [108]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [81]),
        .O(p_2_in[108]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][109]_i_1 
       (.I0(\buf_data_reg[1] [109]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [82]),
        .O(p_2_in[109]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][10]_i_1 
       (.I0(\buf_data_reg[1] [10]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [10]),
        .O(p_2_in[10]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][110]_i_1 
       (.I0(\buf_data_reg[1] [110]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [83]),
        .O(p_2_in[110]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][111]_i_1 
       (.I0(\buf_data_reg[1] [111]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [84]),
        .O(p_2_in[111]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][112]_i_1 
       (.I0(\buf_data_reg[1] [112]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [85]),
        .O(p_2_in[112]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][113]_i_1 
       (.I0(\buf_data_reg[1] [113]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [86]),
        .O(p_2_in[113]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][114]_i_1 
       (.I0(\buf_data_reg[1] [114]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [87]),
        .O(p_2_in[114]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][115]_i_1 
       (.I0(\buf_data_reg[1] [115]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [88]),
        .O(p_2_in[115]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][116]_i_1 
       (.I0(\buf_data_reg[1] [116]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [89]),
        .O(p_2_in[116]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][117]_i_1 
       (.I0(\buf_data_reg[1] [117]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [90]),
        .O(p_2_in[117]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][118]_i_1 
       (.I0(\buf_data_reg[1] [118]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [91]),
        .O(p_2_in[118]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][119]_i_1 
       (.I0(\buf_data_reg[1] [119]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [92]),
        .O(p_2_in[119]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][11]_i_1 
       (.I0(\buf_data_reg[1] [11]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [11]),
        .O(p_2_in[11]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][120]_i_1 
       (.I0(\buf_data_reg[1] [120]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [93]),
        .O(p_2_in[120]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][121]_i_1 
       (.I0(\buf_data_reg[1] [121]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [94]),
        .O(p_2_in[121]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][122]_i_1 
       (.I0(\buf_data_reg[1] [122]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [95]),
        .O(p_2_in[122]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][123]_i_1 
       (.I0(\buf_data_reg[1] [123]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [96]),
        .O(p_2_in[123]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][124]_i_1 
       (.I0(\buf_data_reg[1] [124]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [97]),
        .O(p_2_in[124]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][125]_i_1 
       (.I0(\buf_data_reg[1] [125]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [98]),
        .O(p_2_in[125]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][126]_i_1 
       (.I0(\buf_data_reg[1] [126]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [99]),
        .O(p_2_in[126]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][127]_i_1 
       (.I0(\buf_data_reg[1] [127]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [100]),
        .O(p_2_in[127]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][128]_i_1 
       (.I0(\buf_data_reg[1] [128]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [101]),
        .O(p_2_in[128]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][129]_i_1 
       (.I0(\buf_data_reg[1] [129]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [102]),
        .O(p_2_in[129]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][12]_i_1 
       (.I0(\buf_data_reg[1] [12]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [12]),
        .O(p_2_in[12]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][130]_i_1 
       (.I0(\buf_data_reg[1] [130]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [103]),
        .O(p_2_in[130]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][131]_i_1 
       (.I0(\buf_data_reg[1] [131]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [104]),
        .O(p_2_in[131]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][132]_i_1 
       (.I0(\buf_data_reg[1] [132]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [105]),
        .O(p_2_in[132]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][133]_i_1 
       (.I0(\buf_data_reg[1] [133]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [106]),
        .O(p_2_in[133]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][134]_i_1 
       (.I0(\buf_data_reg[1] [134]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [107]),
        .O(p_2_in[134]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][135]_i_1 
       (.I0(\buf_data_reg[1] [135]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [108]),
        .O(p_2_in[135]));
  LUT4 #(
    .INIT(16'hA8B8)) 
    \buf_data[0][136]_i_1 
       (.I0(cur_dtype_pxls1),
        .I1(p_0_in),
        .I2(s_axis_tvalid),
        .I3(\buf_valid_reg_n_0_[0] ),
        .O(\buf_data[0][136]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][136]_i_2 
       (.I0(\buf_data_reg[1] [136]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [109]),
        .O(p_2_in[136]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][13]_i_1 
       (.I0(\buf_data_reg[1] [13]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [13]),
        .O(p_2_in[13]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][14]_i_1 
       (.I0(\buf_data_reg[1] [14]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [14]),
        .O(p_2_in[14]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][15]_i_1 
       (.I0(\buf_data_reg[1] [15]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [15]),
        .O(p_2_in[15]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][16]_i_1 
       (.I0(\buf_data_reg[1] [16]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [16]),
        .O(p_2_in[16]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][17]_i_1 
       (.I0(\buf_data_reg[1] [17]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [17]),
        .O(p_2_in[17]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][18]_i_1 
       (.I0(\buf_data_reg[1] [18]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [18]),
        .O(p_2_in[18]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][19]_i_1 
       (.I0(\buf_data_reg[1] [19]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [19]),
        .O(p_2_in[19]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][1]_i_1 
       (.I0(\buf_data_reg[1] [1]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [1]),
        .O(p_2_in[1]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][20]_i_1 
       (.I0(\buf_data_reg[1] [20]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [20]),
        .O(p_2_in[20]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][21]_i_1 
       (.I0(\buf_data_reg[1] [21]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [21]),
        .O(p_2_in[21]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][22]_i_1 
       (.I0(\buf_data_reg[1] [22]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [22]),
        .O(p_2_in[22]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][23]_i_1 
       (.I0(\buf_data_reg[1] [23]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [23]),
        .O(p_2_in[23]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][24]_i_1 
       (.I0(\buf_data_reg[1] [24]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [24]),
        .O(p_2_in[24]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][25]_i_1 
       (.I0(\buf_data_reg[1] [25]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [25]),
        .O(p_2_in[25]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][26]_i_1 
       (.I0(\buf_data_reg[1] [26]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [26]),
        .O(p_2_in[26]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][27]_i_1 
       (.I0(\buf_data_reg[1] [27]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [27]),
        .O(p_2_in[27]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][28]_i_1 
       (.I0(\buf_data_reg[1] [28]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [28]),
        .O(p_2_in[28]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][29]_i_1 
       (.I0(\buf_data_reg[1] [29]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [29]),
        .O(p_2_in[29]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][2]_i_1 
       (.I0(\buf_data_reg[1] [2]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [2]),
        .O(p_2_in[2]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][30]_i_1 
       (.I0(\buf_data_reg[1] [30]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [30]),
        .O(p_2_in[30]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][31]_i_1 
       (.I0(\buf_data_reg[1] [31]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [31]),
        .O(p_2_in[31]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][32]_i_1 
       (.I0(\buf_data_reg[1] [32]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [32]),
        .O(p_2_in[32]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][33]_i_1 
       (.I0(\buf_data_reg[1] [33]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [33]),
        .O(p_2_in[33]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][34]_i_1 
       (.I0(\buf_data_reg[1] [34]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [34]),
        .O(p_2_in[34]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][35]_i_1 
       (.I0(\buf_data_reg[1] [35]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [35]),
        .O(p_2_in[35]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][36]_i_1 
       (.I0(\buf_data_reg[1] [36]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [36]),
        .O(p_2_in[36]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][37]_i_1 
       (.I0(\buf_data_reg[1] [37]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [37]),
        .O(p_2_in[37]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][38]_i_1 
       (.I0(\buf_data_reg[1] [38]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [38]),
        .O(p_2_in[38]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][39]_i_1 
       (.I0(\buf_data_reg[1] [39]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [39]),
        .O(p_2_in[39]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][3]_i_1 
       (.I0(\buf_data_reg[1] [3]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [3]),
        .O(p_2_in[3]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][40]_i_1 
       (.I0(\buf_data_reg[1] [40]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [40]),
        .O(p_2_in[40]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][41]_i_1 
       (.I0(\buf_data_reg[1] [41]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [41]),
        .O(p_2_in[41]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][42]_i_1 
       (.I0(\buf_data_reg[1] [42]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [42]),
        .O(p_2_in[42]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][43]_i_1 
       (.I0(\buf_data_reg[1] [43]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [43]),
        .O(p_2_in[43]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][44]_i_1 
       (.I0(\buf_data_reg[1] [44]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [44]),
        .O(p_2_in[44]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][45]_i_1 
       (.I0(\buf_data_reg[1] [45]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [45]),
        .O(p_2_in[45]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][46]_i_1 
       (.I0(\buf_data_reg[1] [46]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [46]),
        .O(p_2_in[46]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][47]_i_1 
       (.I0(\buf_data_reg[1] [47]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [47]),
        .O(p_2_in[47]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][48]_i_1 
       (.I0(\buf_data_reg[1] [48]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [48]),
        .O(p_2_in[48]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][49]_i_1 
       (.I0(\buf_data_reg[1] [49]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [49]),
        .O(p_2_in[49]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][4]_i_1 
       (.I0(\buf_data_reg[1] [4]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [4]),
        .O(p_2_in[4]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][50]_i_1 
       (.I0(\buf_data_reg[1] [50]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [50]),
        .O(p_2_in[50]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][51]_i_1 
       (.I0(\buf_data_reg[1] [51]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [51]),
        .O(p_2_in[51]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][52]_i_1 
       (.I0(\buf_data_reg[1] [52]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [52]),
        .O(p_2_in[52]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][53]_i_1 
       (.I0(\buf_data_reg[1] [53]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [53]),
        .O(p_2_in[53]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][54]_i_1 
       (.I0(\buf_data_reg[1] [54]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [54]),
        .O(p_2_in[54]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][55]_i_1 
       (.I0(\buf_data_reg[1] [55]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [55]),
        .O(p_2_in[55]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][56]_i_1 
       (.I0(\buf_data_reg[1] [56]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [56]),
        .O(p_2_in[56]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][57]_i_1 
       (.I0(\buf_data_reg[1] [57]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [57]),
        .O(p_2_in[57]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][58]_i_1 
       (.I0(\buf_data_reg[1] [58]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [58]),
        .O(p_2_in[58]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][59]_i_1 
       (.I0(\buf_data_reg[1] [59]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [59]),
        .O(p_2_in[59]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][5]_i_1 
       (.I0(\buf_data_reg[1] [5]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [5]),
        .O(p_2_in[5]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][60]_i_1 
       (.I0(\buf_data_reg[1] [60]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [60]),
        .O(p_2_in[60]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][61]_i_1 
       (.I0(\buf_data_reg[1] [61]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [61]),
        .O(p_2_in[61]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][62]_i_1 
       (.I0(\buf_data_reg[1] [62]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [62]),
        .O(p_2_in[62]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][63]_i_1 
       (.I0(\buf_data_reg[1] [63]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [63]),
        .O(p_2_in[63]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][64]_i_1 
       (.I0(\buf_data_reg[1] [64]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [64]),
        .O(p_2_in[64]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][65]_i_1 
       (.I0(\buf_data_reg[1] [65]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [65]),
        .O(p_2_in[65]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][66]_i_1 
       (.I0(\buf_data_reg[1] [66]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [66]),
        .O(p_2_in[66]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][67]_i_1 
       (.I0(\buf_data_reg[1] [67]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [67]),
        .O(p_2_in[67]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][68]_i_1 
       (.I0(\buf_data_reg[1] [68]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [68]),
        .O(p_2_in[68]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][69]_i_1 
       (.I0(\buf_data_reg[1] [69]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [69]),
        .O(p_2_in[69]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][6]_i_1 
       (.I0(\buf_data_reg[1] [6]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [6]),
        .O(p_2_in[6]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][70]_i_1 
       (.I0(\buf_data_reg[1] [70]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [70]),
        .O(p_2_in[70]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][71]_i_1 
       (.I0(\buf_data_reg[1] [71]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [71]),
        .O(p_2_in[71]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][72]_i_1 
       (.I0(\buf_data_reg[1] [72]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [72]),
        .O(p_2_in[72]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][73]_i_1 
       (.I0(\buf_data_reg[1] [73]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [73]),
        .O(p_2_in[73]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][7]_i_1 
       (.I0(\buf_data_reg[1] [7]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [7]),
        .O(p_2_in[7]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][8]_i_1 
       (.I0(\buf_data_reg[1] [8]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [8]),
        .O(p_2_in[8]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][9]_i_1 
       (.I0(\buf_data_reg[1] [9]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [9]),
        .O(p_2_in[9]));
  LUT1 #(
    .INIT(2'h1)) 
    \buf_data[1][136]_i_1 
       (.I0(s_axis_aresetn),
        .O(\buf_data[1][136]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h0040)) 
    \buf_data[1][136]_i_2 
       (.I0(p_0_in),
        .I1(s_axis_tvalid),
        .I2(\buf_valid_reg_n_0_[0] ),
        .I3(cur_dtype_pxls1),
        .O(\buf_data[1][136]_i_2_n_0 ));
  FDRE \buf_data_reg[0][0] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[0]),
        .Q(\buf_data_reg[0][73]_1 [0]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][101] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[101]),
        .Q(sband_tk[1]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][102] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[102]),
        .Q(sband_tk[2]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][103] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[103]),
        .Q(sband_tk[3]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][104] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[104]),
        .Q(s_axis_tdata__0[0]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][105] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[105]),
        .Q(s_axis_tdata__0[1]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][106] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[106]),
        .Q(s_axis_tdata__0[2]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][107] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[107]),
        .Q(s_axis_tdata__0[3]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][108] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[108]),
        .Q(s_axis_tdata__0[4]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][109] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[109]),
        .Q(s_axis_tdata__0[5]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][10] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[10]),
        .Q(\buf_data_reg[0][73]_1 [10]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][110] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[110]),
        .Q(s_axis_tdata__0[6]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][111] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[111]),
        .Q(s_axis_tdata__0[7]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][112] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[112]),
        .Q(s_axis_tdata__0[8]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][113] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[113]),
        .Q(s_axis_tdata__0[9]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][114] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[114]),
        .Q(s_axis_tdata__0[10]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][115] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[115]),
        .Q(s_axis_tdata__0[11]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][116] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[116]),
        .Q(s_axis_tdata__0[12]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][117] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[117]),
        .Q(s_axis_tdata__0[13]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][118] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[118]),
        .Q(s_axis_tdata__0[14]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][119] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[119]),
        .Q(s_axis_tdata__0[15]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][11] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[11]),
        .Q(\buf_data_reg[0][73]_1 [11]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][120] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[120]),
        .Q(s_axis_tdata__0[16]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][121] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[121]),
        .Q(s_axis_tdata__0[17]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][122] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[122]),
        .Q(s_axis_tdata__0[18]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][123] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[123]),
        .Q(s_axis_tdata__0[19]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][124] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[124]),
        .Q(s_axis_tdata__0[20]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][125] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[125]),
        .Q(s_axis_tdata__0[21]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][126] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[126]),
        .Q(s_axis_tdata__0[22]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][127] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[127]),
        .Q(s_axis_tdata__0[23]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][128] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[128]),
        .Q(s_axis_tdata__0[24]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][129] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[129]),
        .Q(s_axis_tdata__0[25]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][12] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[12]),
        .Q(\buf_data_reg[0][73]_1 [12]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][130] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[130]),
        .Q(s_axis_tdata__0[26]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][131] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[131]),
        .Q(s_axis_tdata__0[27]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][132] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[132]),
        .Q(s_axis_tdata__0[28]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][133] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[133]),
        .Q(s_axis_tdata__0[29]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][134] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[134]),
        .Q(s_axis_tdata__0[30]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][135] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[135]),
        .Q(s_axis_tdata__0[31]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][136] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[136]),
        .Q(s_axis_tlast),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][13] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[13]),
        .Q(\buf_data_reg[0][73]_1 [13]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][14] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[14]),
        .Q(\buf_data_reg[0][73]_1 [14]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][15] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[15]),
        .Q(\buf_data_reg[0][73]_1 [15]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][16] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[16]),
        .Q(\buf_data_reg[0][73]_1 [16]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][17] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[17]),
        .Q(\buf_data_reg[0][73]_1 [17]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][18] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[18]),
        .Q(\buf_data_reg[0][73]_1 [18]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][19] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[19]),
        .Q(\buf_data_reg[0][73]_1 [19]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][1] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[1]),
        .Q(\buf_data_reg[0][73]_1 [1]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][20] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[20]),
        .Q(\buf_data_reg[0][73]_1 [20]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][21] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[21]),
        .Q(\buf_data_reg[0][73]_1 [21]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][22] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[22]),
        .Q(\buf_data_reg[0][73]_1 [22]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][23] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[23]),
        .Q(\buf_data_reg[0][73]_1 [23]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][24] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[24]),
        .Q(\buf_data_reg[0][73]_1 [24]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][25] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[25]),
        .Q(\buf_data_reg[0][73]_1 [25]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][26] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[26]),
        .Q(\buf_data_reg[0][73]_1 [26]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][27] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[27]),
        .Q(\buf_data_reg[0][73]_1 [27]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][28] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[28]),
        .Q(\buf_data_reg[0][73]_1 [28]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][29] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[29]),
        .Q(\buf_data_reg[0][73]_1 [29]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][2] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[2]),
        .Q(\buf_data_reg[0][73]_1 [2]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][30] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[30]),
        .Q(\buf_data_reg[0][73]_1 [30]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][31] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[31]),
        .Q(\buf_data_reg[0][73]_1 [31]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][32] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[32]),
        .Q(\buf_data_reg[0][73]_1 [32]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][33] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[33]),
        .Q(\buf_data_reg[0][73]_1 [33]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][34] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[34]),
        .Q(\buf_data_reg[0][73]_1 [34]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][35] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[35]),
        .Q(\buf_data_reg[0][73]_1 [35]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][36] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[36]),
        .Q(\buf_data_reg[0][73]_1 [36]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][37] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[37]),
        .Q(\buf_data_reg[0][73]_1 [37]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][38] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[38]),
        .Q(\buf_data_reg[0][73]_1 [38]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][39] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[39]),
        .Q(\buf_data_reg[0][73]_1 [39]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][3] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[3]),
        .Q(\buf_data_reg[0][73]_1 [3]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][40] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[40]),
        .Q(\buf_data_reg[0][73]_1 [40]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][41] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[41]),
        .Q(\buf_data_reg[0][73]_1 [41]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][42] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[42]),
        .Q(\buf_data_reg[0][73]_1 [42]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][43] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[43]),
        .Q(\buf_data_reg[0][73]_1 [43]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][44] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[44]),
        .Q(\buf_data_reg[0][73]_1 [44]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][45] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[45]),
        .Q(\buf_data_reg[0][73]_1 [45]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][46] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[46]),
        .Q(\buf_data_reg[0][73]_1 [46]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][47] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[47]),
        .Q(\buf_data_reg[0][73]_1 [47]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][48] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[48]),
        .Q(\buf_data_reg[0][73]_1 [48]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][49] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[49]),
        .Q(\buf_data_reg[0][73]_1 [49]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][4] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[4]),
        .Q(\buf_data_reg[0][73]_1 [4]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][50] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[50]),
        .Q(\buf_data_reg[0][73]_1 [50]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][51] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[51]),
        .Q(\buf_data_reg[0][73]_1 [51]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][52] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[52]),
        .Q(\buf_data_reg[0][73]_1 [52]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][53] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[53]),
        .Q(\buf_data_reg[0][73]_1 [53]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][54] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[54]),
        .Q(\buf_data_reg[0][73]_1 [54]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][55] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[55]),
        .Q(\buf_data_reg[0][73]_1 [55]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][56] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[56]),
        .Q(\buf_data_reg[0][73]_1 [56]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][57] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[57]),
        .Q(\buf_data_reg[0][73]_1 [57]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][58] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[58]),
        .Q(\buf_data_reg[0][73]_1 [58]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][59] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[59]),
        .Q(\buf_data_reg[0][73]_1 [59]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][5] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[5]),
        .Q(\buf_data_reg[0][73]_1 [5]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][60] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[60]),
        .Q(\buf_data_reg[0][73]_1 [60]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][61] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[61]),
        .Q(\buf_data_reg[0][73]_1 [61]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][62] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[62]),
        .Q(\buf_data_reg[0][73]_1 [62]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][63] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[63]),
        .Q(\buf_data_reg[0][73]_1 [63]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][64] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[64]),
        .Q(\buf_data_reg[0][73]_1 [64]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][65] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[65]),
        .Q(\buf_data_reg[0][73]_1 [65]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][66] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[66]),
        .Q(\buf_data_reg[0][73]_1 [66]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][67] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[67]),
        .Q(\buf_data_reg[0][73]_1 [67]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][68] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[68]),
        .Q(\buf_data_reg[0][73]_1 [68]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][69] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[69]),
        .Q(\buf_data_reg[0][73]_1 [69]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][6] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[6]),
        .Q(\buf_data_reg[0][73]_1 [6]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][70] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[70]),
        .Q(\buf_data_reg[0][73]_1 [70]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][71] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[71]),
        .Q(\buf_data_reg[0][73]_1 [71]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][72] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[72]),
        .Q(\buf_data_reg[0][73]_1 [72]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][73] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[73]),
        .Q(\buf_data_reg[0][73]_1 [73]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][7] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[7]),
        .Q(\buf_data_reg[0][73]_1 [7]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][8] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[8]),
        .Q(\buf_data_reg[0][73]_1 [8]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][9] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[9]),
        .Q(\buf_data_reg[0][73]_1 [9]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][0] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [0]),
        .Q(\buf_data_reg[1] [0]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][101] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [74]),
        .Q(\buf_data_reg[1] [101]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][102] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [75]),
        .Q(\buf_data_reg[1] [102]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][103] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [76]),
        .Q(\buf_data_reg[1] [103]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][104] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [77]),
        .Q(\buf_data_reg[1] [104]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][105] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [78]),
        .Q(\buf_data_reg[1] [105]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][106] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [79]),
        .Q(\buf_data_reg[1] [106]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][107] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [80]),
        .Q(\buf_data_reg[1] [107]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][108] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [81]),
        .Q(\buf_data_reg[1] [108]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][109] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [82]),
        .Q(\buf_data_reg[1] [109]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][10] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [10]),
        .Q(\buf_data_reg[1] [10]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][110] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [83]),
        .Q(\buf_data_reg[1] [110]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][111] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [84]),
        .Q(\buf_data_reg[1] [111]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][112] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [85]),
        .Q(\buf_data_reg[1] [112]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][113] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [86]),
        .Q(\buf_data_reg[1] [113]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][114] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [87]),
        .Q(\buf_data_reg[1] [114]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][115] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [88]),
        .Q(\buf_data_reg[1] [115]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][116] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [89]),
        .Q(\buf_data_reg[1] [116]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][117] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [90]),
        .Q(\buf_data_reg[1] [117]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][118] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [91]),
        .Q(\buf_data_reg[1] [118]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][119] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [92]),
        .Q(\buf_data_reg[1] [119]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][11] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [11]),
        .Q(\buf_data_reg[1] [11]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][120] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [93]),
        .Q(\buf_data_reg[1] [120]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][121] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [94]),
        .Q(\buf_data_reg[1] [121]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][122] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [95]),
        .Q(\buf_data_reg[1] [122]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][123] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [96]),
        .Q(\buf_data_reg[1] [123]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][124] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [97]),
        .Q(\buf_data_reg[1] [124]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][125] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [98]),
        .Q(\buf_data_reg[1] [125]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][126] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [99]),
        .Q(\buf_data_reg[1] [126]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][127] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [100]),
        .Q(\buf_data_reg[1] [127]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][128] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [101]),
        .Q(\buf_data_reg[1] [128]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][129] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [102]),
        .Q(\buf_data_reg[1] [129]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][12] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [12]),
        .Q(\buf_data_reg[1] [12]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][130] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [103]),
        .Q(\buf_data_reg[1] [130]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][131] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [104]),
        .Q(\buf_data_reg[1] [131]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][132] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [105]),
        .Q(\buf_data_reg[1] [132]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][133] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [106]),
        .Q(\buf_data_reg[1] [133]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][134] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [107]),
        .Q(\buf_data_reg[1] [134]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][135] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [108]),
        .Q(\buf_data_reg[1] [135]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][136] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [109]),
        .Q(\buf_data_reg[1] [136]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][13] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [13]),
        .Q(\buf_data_reg[1] [13]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][14] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [14]),
        .Q(\buf_data_reg[1] [14]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][15] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [15]),
        .Q(\buf_data_reg[1] [15]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][16] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [16]),
        .Q(\buf_data_reg[1] [16]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][17] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [17]),
        .Q(\buf_data_reg[1] [17]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][18] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [18]),
        .Q(\buf_data_reg[1] [18]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][19] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [19]),
        .Q(\buf_data_reg[1] [19]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][1] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [1]),
        .Q(\buf_data_reg[1] [1]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][20] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [20]),
        .Q(\buf_data_reg[1] [20]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][21] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [21]),
        .Q(\buf_data_reg[1] [21]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][22] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [22]),
        .Q(\buf_data_reg[1] [22]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][23] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [23]),
        .Q(\buf_data_reg[1] [23]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][24] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [24]),
        .Q(\buf_data_reg[1] [24]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][25] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [25]),
        .Q(\buf_data_reg[1] [25]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][26] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [26]),
        .Q(\buf_data_reg[1] [26]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][27] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [27]),
        .Q(\buf_data_reg[1] [27]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][28] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [28]),
        .Q(\buf_data_reg[1] [28]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][29] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [29]),
        .Q(\buf_data_reg[1] [29]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][2] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [2]),
        .Q(\buf_data_reg[1] [2]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][30] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [30]),
        .Q(\buf_data_reg[1] [30]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][31] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [31]),
        .Q(\buf_data_reg[1] [31]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][32] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [32]),
        .Q(\buf_data_reg[1] [32]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][33] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [33]),
        .Q(\buf_data_reg[1] [33]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][34] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [34]),
        .Q(\buf_data_reg[1] [34]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][35] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [35]),
        .Q(\buf_data_reg[1] [35]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][36] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [36]),
        .Q(\buf_data_reg[1] [36]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][37] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [37]),
        .Q(\buf_data_reg[1] [37]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][38] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [38]),
        .Q(\buf_data_reg[1] [38]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][39] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [39]),
        .Q(\buf_data_reg[1] [39]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][3] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [3]),
        .Q(\buf_data_reg[1] [3]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][40] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [40]),
        .Q(\buf_data_reg[1] [40]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][41] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [41]),
        .Q(\buf_data_reg[1] [41]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][42] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [42]),
        .Q(\buf_data_reg[1] [42]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][43] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [43]),
        .Q(\buf_data_reg[1] [43]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][44] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [44]),
        .Q(\buf_data_reg[1] [44]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][45] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [45]),
        .Q(\buf_data_reg[1] [45]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][46] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [46]),
        .Q(\buf_data_reg[1] [46]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][47] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [47]),
        .Q(\buf_data_reg[1] [47]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][48] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [48]),
        .Q(\buf_data_reg[1] [48]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][49] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [49]),
        .Q(\buf_data_reg[1] [49]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][4] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [4]),
        .Q(\buf_data_reg[1] [4]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][50] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [50]),
        .Q(\buf_data_reg[1] [50]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][51] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [51]),
        .Q(\buf_data_reg[1] [51]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][52] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [52]),
        .Q(\buf_data_reg[1] [52]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][53] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [53]),
        .Q(\buf_data_reg[1] [53]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][54] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [54]),
        .Q(\buf_data_reg[1] [54]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][55] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [55]),
        .Q(\buf_data_reg[1] [55]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][56] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [56]),
        .Q(\buf_data_reg[1] [56]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][57] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [57]),
        .Q(\buf_data_reg[1] [57]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][58] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [58]),
        .Q(\buf_data_reg[1] [58]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][59] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [59]),
        .Q(\buf_data_reg[1] [59]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][5] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [5]),
        .Q(\buf_data_reg[1] [5]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][60] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [60]),
        .Q(\buf_data_reg[1] [60]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][61] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [61]),
        .Q(\buf_data_reg[1] [61]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][62] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [62]),
        .Q(\buf_data_reg[1] [62]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][63] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [63]),
        .Q(\buf_data_reg[1] [63]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][64] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [64]),
        .Q(\buf_data_reg[1] [64]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][65] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [65]),
        .Q(\buf_data_reg[1] [65]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][66] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [66]),
        .Q(\buf_data_reg[1] [66]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][67] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [67]),
        .Q(\buf_data_reg[1] [67]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][68] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [68]),
        .Q(\buf_data_reg[1] [68]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][69] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [69]),
        .Q(\buf_data_reg[1] [69]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][6] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [6]),
        .Q(\buf_data_reg[1] [6]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][70] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [70]),
        .Q(\buf_data_reg[1] [70]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][71] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [71]),
        .Q(\buf_data_reg[1] [71]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][72] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [72]),
        .Q(\buf_data_reg[1] [72]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][73] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [73]),
        .Q(\buf_data_reg[1] [73]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][7] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [7]),
        .Q(\buf_data_reg[1] [7]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][8] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [8]),
        .Q(\buf_data_reg[1] [8]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][9] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [9]),
        .Q(\buf_data_reg[1] [9]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'hFCAE0000)) 
    \buf_valid[0]_i_1 
       (.I0(\buf_valid_reg_n_0_[0] ),
        .I1(s_axis_tvalid),
        .I2(p_0_in),
        .I3(cur_dtype_pxls1),
        .I4(s_axis_aresetn),
        .O(\buf_valid[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h00EA0000)) 
    \buf_valid[1]_i_1 
       (.I0(p_0_in),
        .I1(s_axis_tvalid),
        .I2(\buf_valid_reg_n_0_[0] ),
        .I3(cur_dtype_pxls1),
        .I4(s_axis_aresetn),
        .O(\buf_valid[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFF202200000000)) 
    \buf_valid[1]_i_2 
       (.I0(cur_dtype_udef),
        .I1(sband_tl_r_reg_0),
        .I2(sband_tact0),
        .I3(\sband_tk_r_reg[2] ),
        .I4(cur_dtype_sink_reg_0),
        .I5(\buf_valid_reg_n_0_[0] ),
        .O(cur_dtype_pxls1));
  FDRE \buf_valid_reg[0] 
       (.C(s_axis_aclk),
        .CE(1'b1),
        .D(\buf_valid[0]_i_1_n_0 ),
        .Q(\buf_valid_reg_n_0_[0] ),
        .R(1'b0));
  FDRE \buf_valid_reg[1] 
       (.C(s_axis_aclk),
        .CE(1'b1),
        .D(\buf_valid[1]_i_1_n_0 ),
        .Q(p_0_in),
        .R(1'b0));
  LUT5 #(
    .INIT(32'h0000AABA)) 
    cur_dtype_sink_i_1
       (.I0(cur_dtype_sink_reg_0),
        .I1(main_dtvc),
        .I2(\buf_valid_reg_n_0_[0] ),
        .I3(sban_dtvc),
        .I4(cur_dtype_sink_i_3_n_0),
        .O(cur_dtype_sink_i_1_n_0));
  LUT6 #(
    .INIT(64'h0100000000000000)) 
    cur_dtype_sink_i_2
       (.I0(\buf_data_reg[0][73]_1 [72]),
        .I1(\buf_data_reg[0][73]_1 [68]),
        .I2(\buf_data_reg[0][73]_1 [70]),
        .I3(\buf_data_reg[0][73]_1 [73]),
        .I4(\buf_data_reg[0][73]_1 [69]),
        .I5(\buf_data_reg[0][73]_1 [71]),
        .O(main_dtvc));
  LUT3 #(
    .INIT(8'h8F)) 
    cur_dtype_sink_i_3
       (.I0(cur_dtype_pxls1),
        .I1(s_axis_tlast),
        .I2(s_axis_aresetn),
        .O(cur_dtype_sink_i_3_n_0));
  FDRE cur_dtype_sink_reg
       (.C(s_axis_aclk),
        .CE(1'b1),
        .D(cur_dtype_sink_i_1_n_0),
        .Q(cur_dtype_sink_reg_0),
        .R(1'b0));
  LUT6 #(
    .INIT(64'h0000EA00EA00EA00)) 
    cur_dtype_udef_i_1
       (.I0(cur_dtype_udef),
        .I1(\buf_valid_reg_n_0_[0] ),
        .I2(sban_dtvc),
        .I3(s_axis_aresetn),
        .I4(s_axis_tlast),
        .I5(cur_dtype_pxls1),
        .O(cur_dtype_udef_i_1_n_0));
  FDRE cur_dtype_udef_reg
       (.C(s_axis_aclk),
        .CE(1'b1),
        .D(cur_dtype_udef_i_1_n_0),
        .Q(cur_dtype_udef),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT1 #(
    .INIT(2'h1)) 
    s_axis_tready_INST_0
       (.I0(p_0_in),
        .O(s_axis_tready));
  LUT3 #(
    .INIT(8'hB8)) 
    \sband_td_r[0]_i_1 
       (.I0(s_axis_tdata__0[8]),
        .I1(vfb_sof119_out),
        .I2(\sband_td_r_reg[15] [8]),
        .O(\buf_data_reg[0][135]_0 [0]));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sband_td_r[10]_i_1 
       (.I0(s_axis_tdata__0[18]),
        .I1(vfb_sof119_out),
        .I2(\sband_td_r_reg[15] [18]),
        .O(\buf_data_reg[0][135]_0 [10]));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sband_td_r[11]_i_1 
       (.I0(s_axis_tdata__0[19]),
        .I1(vfb_sof119_out),
        .I2(\sband_td_r_reg[15] [19]),
        .O(\buf_data_reg[0][135]_0 [11]));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sband_td_r[12]_i_1 
       (.I0(s_axis_tdata__0[20]),
        .I1(vfb_sof119_out),
        .I2(\sband_td_r_reg[15] [20]),
        .O(\buf_data_reg[0][135]_0 [12]));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sband_td_r[13]_i_1 
       (.I0(s_axis_tdata__0[21]),
        .I1(vfb_sof119_out),
        .I2(\sband_td_r_reg[15] [21]),
        .O(\buf_data_reg[0][135]_0 [13]));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sband_td_r[14]_i_1 
       (.I0(s_axis_tdata__0[22]),
        .I1(vfb_sof119_out),
        .I2(\sband_td_r_reg[15] [22]),
        .O(\buf_data_reg[0][135]_0 [14]));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sband_td_r[15]_i_1 
       (.I0(s_axis_tdata__0[23]),
        .I1(vfb_sof119_out),
        .I2(\sband_td_r_reg[15] [23]),
        .O(\buf_data_reg[0][135]_0 [15]));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \sband_td_r[16]_i_1 
       (.I0(vfb_sof119_out),
        .I1(s_axis_tdata__0[24]),
        .O(\buf_data_reg[0][135]_0 [16]));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \sband_td_r[17]_i_1 
       (.I0(vfb_sof119_out),
        .I1(s_axis_tdata__0[25]),
        .O(\buf_data_reg[0][135]_0 [17]));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \sband_td_r[18]_i_1 
       (.I0(vfb_sof119_out),
        .I1(s_axis_tdata__0[26]),
        .O(\buf_data_reg[0][135]_0 [18]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \sband_td_r[19]_i_1 
       (.I0(vfb_sof119_out),
        .I1(s_axis_tdata__0[27]),
        .O(\buf_data_reg[0][135]_0 [19]));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sband_td_r[1]_i_1 
       (.I0(s_axis_tdata__0[9]),
        .I1(vfb_sof119_out),
        .I2(\sband_td_r_reg[15] [9]),
        .O(\buf_data_reg[0][135]_0 [1]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \sband_td_r[20]_i_1 
       (.I0(vfb_sof119_out),
        .I1(s_axis_tdata__0[28]),
        .O(\buf_data_reg[0][135]_0 [20]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \sband_td_r[21]_i_1 
       (.I0(vfb_sof119_out),
        .I1(s_axis_tdata__0[29]),
        .O(\buf_data_reg[0][135]_0 [21]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \sband_td_r[22]_i_1 
       (.I0(vfb_sof119_out),
        .I1(s_axis_tdata__0[30]),
        .O(\buf_data_reg[0][135]_0 [22]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \sband_td_r[23]_i_1 
       (.I0(vfb_sof119_out),
        .I1(s_axis_tdata__0[31]),
        .O(\buf_data_reg[0][135]_0 [23]));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sband_td_r[2]_i_1 
       (.I0(s_axis_tdata__0[10]),
        .I1(vfb_sof119_out),
        .I2(\sband_td_r_reg[15] [10]),
        .O(\buf_data_reg[0][135]_0 [2]));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sband_td_r[3]_i_1 
       (.I0(s_axis_tdata__0[11]),
        .I1(vfb_sof119_out),
        .I2(\sband_td_r_reg[15] [11]),
        .O(\buf_data_reg[0][135]_0 [3]));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sband_td_r[4]_i_1 
       (.I0(s_axis_tdata__0[12]),
        .I1(vfb_sof119_out),
        .I2(\sband_td_r_reg[15] [12]),
        .O(\buf_data_reg[0][135]_0 [4]));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sband_td_r[5]_i_1 
       (.I0(s_axis_tdata__0[13]),
        .I1(vfb_sof119_out),
        .I2(\sband_td_r_reg[15] [13]),
        .O(\buf_data_reg[0][135]_0 [5]));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sband_td_r[6]_i_1 
       (.I0(s_axis_tdata__0[14]),
        .I1(vfb_sof119_out),
        .I2(\sband_td_r_reg[15] [14]),
        .O(\buf_data_reg[0][135]_0 [6]));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sband_td_r[7]_i_1 
       (.I0(s_axis_tdata__0[15]),
        .I1(vfb_sof119_out),
        .I2(\sband_td_r_reg[15] [15]),
        .O(\buf_data_reg[0][135]_0 [7]));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sband_td_r[8]_i_1 
       (.I0(s_axis_tdata__0[16]),
        .I1(vfb_sof119_out),
        .I2(\sband_td_r_reg[15] [16]),
        .O(\buf_data_reg[0][135]_0 [8]));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sband_td_r[9]_i_1 
       (.I0(s_axis_tdata__0[17]),
        .I1(vfb_sof119_out),
        .I2(\sband_td_r_reg[15] [17]),
        .O(\buf_data_reg[0][135]_0 [9]));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sband_tk_r[1]_i_1 
       (.I0(sband_tk[2]),
        .I1(vfb_sof119_out),
        .I2(Q[1]),
        .O(\buf_data_reg[0][103]_0 [0]));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT3 #(
    .INIT(8'hEA)) 
    \sband_tk_r[2]_i_1 
       (.I0(vfb_sof119_out),
        .I1(vfb_ready),
        .I2(\sband_tk_r_reg[2] ),
        .O(E));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \sband_tk_r[2]_i_2 
       (.I0(vfb_sof119_out),
        .I1(sband_tk[3]),
        .O(\buf_data_reg[0][103]_0 [1]));
  LUT6 #(
    .INIT(64'h0080000000800080)) 
    sband_tl_r_i_1
       (.I0(cur_dtype_udef),
        .I1(\buf_valid_reg_n_0_[0] ),
        .I2(sban_dtvc),
        .I3(sband_tl_r_reg_0),
        .I4(sband_tact0),
        .I5(\sband_tk_r_reg[2] ),
        .O(vfb_sof119_out));
  LUT6 #(
    .INIT(64'h8080888080808080)) 
    sband_tl_r_i_2
       (.I0(s_axis_tlast),
        .I1(\buf_valid_reg_n_0_[0] ),
        .I2(cur_dtype_sink_reg_0),
        .I3(sband_tl_r_reg),
        .I4(sband_tl_r_reg_0),
        .I5(cur_dtype_udef),
        .O(sband_tl));
  LUT3 #(
    .INIT(8'h80)) 
    sdt_tv_INST_0
       (.I0(sban_dtvc),
        .I1(\buf_valid_reg_n_0_[0] ),
        .I2(cur_dtype_udef),
        .O(sdt_tv));
  LUT6 #(
    .INIT(64'h5050505000000080)) 
    sdt_tv_INST_0_i_1
       (.I0(\buf_data_reg[0][73]_1 [71]),
        .I1(\buf_data_reg[0][73]_1 [69]),
        .I2(\buf_data_reg[0][73]_1 [73]),
        .I3(\buf_data_reg[0][73]_1 [70]),
        .I4(\buf_data_reg[0][73]_1 [68]),
        .I5(\buf_data_reg[0][73]_1 [72]),
        .O(sban_dtvc));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'hB888)) 
    \vfb_data[0]_i_1 
       (.I0(s_axis_tdata__0[0]),
        .I1(vfb_sof119_out),
        .I2(vfb_sof015_out),
        .I3(\sband_td_r_reg[15] [0]),
        .O(D[0]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT4 #(
    .INIT(16'hB888)) 
    \vfb_data[1]_i_1 
       (.I0(s_axis_tdata__0[1]),
        .I1(vfb_sof119_out),
        .I2(vfb_sof015_out),
        .I3(\sband_td_r_reg[15] [1]),
        .O(D[1]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT4 #(
    .INIT(16'hB888)) 
    \vfb_data[2]_i_1 
       (.I0(s_axis_tdata__0[2]),
        .I1(vfb_sof119_out),
        .I2(vfb_sof015_out),
        .I3(\sband_td_r_reg[15] [2]),
        .O(D[2]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT4 #(
    .INIT(16'hB888)) 
    \vfb_data[3]_i_1 
       (.I0(s_axis_tdata__0[3]),
        .I1(vfb_sof119_out),
        .I2(vfb_sof015_out),
        .I3(\sband_td_r_reg[15] [3]),
        .O(D[3]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT4 #(
    .INIT(16'hB888)) 
    \vfb_data[4]_i_1 
       (.I0(s_axis_tdata__0[4]),
        .I1(vfb_sof119_out),
        .I2(vfb_sof015_out),
        .I3(\sband_td_r_reg[15] [4]),
        .O(D[4]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT4 #(
    .INIT(16'hB888)) 
    \vfb_data[5]_i_1 
       (.I0(s_axis_tdata__0[5]),
        .I1(vfb_sof119_out),
        .I2(vfb_sof015_out),
        .I3(\sband_td_r_reg[15] [5]),
        .O(D[5]));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT4 #(
    .INIT(16'hB888)) 
    \vfb_data[6]_i_1 
       (.I0(s_axis_tdata__0[6]),
        .I1(vfb_sof119_out),
        .I2(vfb_sof015_out),
        .I3(\sband_td_r_reg[15] [6]),
        .O(D[6]));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT4 #(
    .INIT(16'hB888)) 
    \vfb_data[7]_i_2 
       (.I0(s_axis_tdata__0[7]),
        .I1(vfb_sof119_out),
        .I2(vfb_sof015_out),
        .I3(\sband_td_r_reg[15] [7]),
        .O(D[7]));
  LUT6 #(
    .INIT(64'h20202F2020202020)) 
    vfb_eol_i_2
       (.I0(sband_tl),
        .I1(sband_tk[1]),
        .I2(vfb_sof119_out),
        .I3(vfb_sof015_out),
        .I4(Q[0]),
        .I5(sband_tl_r),
        .O(\buf_data_reg[0][101]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \vfb_vcdt[0]_i_1 
       (.I0(\buf_data_reg[0][73]_1 [0]),
        .I1(vfb_sof119_out),
        .I2(\vfb_vcdt_reg[9] [0]),
        .O(\buf_data_reg[0][73]_0 [0]));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \vfb_vcdt[1]_i_1 
       (.I0(\buf_data_reg[0][73]_1 [1]),
        .I1(vfb_sof119_out),
        .I2(\vfb_vcdt_reg[9] [1]),
        .O(\buf_data_reg[0][73]_0 [1]));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \vfb_vcdt[2]_i_1 
       (.I0(\buf_data_reg[0][73]_1 [2]),
        .I1(vfb_sof119_out),
        .I2(\vfb_vcdt_reg[9] [2]),
        .O(\buf_data_reg[0][73]_0 [2]));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \vfb_vcdt[3]_i_1 
       (.I0(\buf_data_reg[0][73]_1 [3]),
        .I1(vfb_sof119_out),
        .I2(\vfb_vcdt_reg[9] [3]),
        .O(\buf_data_reg[0][73]_0 [3]));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \vfb_vcdt[4]_i_1 
       (.I0(\buf_data_reg[0][73]_1 [68]),
        .I1(vfb_sof119_out),
        .I2(\vfb_vcdt_reg[9] [4]),
        .O(\buf_data_reg[0][73]_0 [4]));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \vfb_vcdt[5]_i_1 
       (.I0(\buf_data_reg[0][73]_1 [69]),
        .I1(vfb_sof119_out),
        .I2(\vfb_vcdt_reg[9] [5]),
        .O(\buf_data_reg[0][73]_0 [5]));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \vfb_vcdt[6]_i_1 
       (.I0(\buf_data_reg[0][73]_1 [70]),
        .I1(vfb_sof119_out),
        .I2(\vfb_vcdt_reg[9] [6]),
        .O(\buf_data_reg[0][73]_0 [6]));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \vfb_vcdt[7]_i_1 
       (.I0(\buf_data_reg[0][73]_1 [71]),
        .I1(vfb_sof119_out),
        .I2(\vfb_vcdt_reg[9] [7]),
        .O(\buf_data_reg[0][73]_0 [7]));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \vfb_vcdt[8]_i_1 
       (.I0(\buf_data_reg[0][73]_1 [72]),
        .I1(vfb_sof119_out),
        .I2(\vfb_vcdt_reg[9] [8]),
        .O(\buf_data_reg[0][73]_0 [8]));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \vfb_vcdt[9]_i_2 
       (.I0(\buf_data_reg[0][73]_1 [73]),
        .I1(vfb_sof119_out),
        .I2(\vfb_vcdt_reg[9] [9]),
        .O(\buf_data_reg[0][73]_0 [9]));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
