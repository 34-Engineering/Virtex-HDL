// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Wed Jun  9 13:46:58 2021
// Host        : liams-desktop running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ bd_e616_vfb_0_0_sim_netlist.v
// Design      : bd_e616_vfb_0_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a50tcpg236-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* AXIS_TDATA_WIDTH = "32" *) (* AXIS_TDEST_WIDTH = "4" *) (* AXIS_TUSER_WIDTH = "96" *) 
(* C_HS_LINE_RATE = "800" *) (* DowngradeIPIdentifiedWarnings = "yes" *) (* VFB_4PXL_W = "32" *) 
(* VFB_BYPASS_WC = "0" *) (* VFB_DATA_TYPE = "42" *) (* VFB_DCONV_OWIDTH = "8" *) 
(* VFB_EN_VCX = "0" *) (* VFB_FIFO_DEPTH = "2048" *) (* VFB_FIFO_WIDTH = "32" *) 
(* VFB_FILTER_VC = "0" *) (* VFB_OP_DWIDTH = "8" *) (* VFB_OP_PIXELS = "1" *) 
(* VFB_PXL_W = "8" *) (* VFB_PXL_W_BB = "8" *) (* VFB_REQ_BUFFER = "0" *) 
(* VFB_REQ_REORDER = "0" *) (* VFB_TU_WIDTH = "1" *) (* VFB_VC = "0" *) 
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
  output [0:0]vfb_sof;
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
  wire [0:0]vfb_sof;
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
  (* VFB_TSB1_WIDTH = "0" *) 
  (* VFB_TSB2_WIDTH = "3" *) 
  (* VFB_TU_WIDTH = "1" *) 
  (* VFB_VC = "0" *) 
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_bd_e616_vfb_0_0_core inst
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
        .s_axis_tuser({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axis_tuser[69:64],1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axis_tuser[0]}),
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
(* VFB_TSB1_WIDTH = "0" *) (* VFB_TSB2_WIDTH = "3" *) (* VFB_TU_WIDTH = "1" *) 
(* VFB_VC = "0" *) 
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_bd_e616_vfb_0_0_core
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
  output [0:0]vfb_sof;
  output [9:0]vfb_vcdt;
  output [7:0]vfb_data;

  wire \<const0> ;
  wire \VFB_MIN.reorder_n_0 ;
  wire \VFB_MIN.reorder_n_3 ;
  wire \VFB_MIN.reorder_n_34 ;
  wire \VFB_MIN.reorder_n_35 ;
  wire mdt_tr;
  wire op_inf_n_10;
  wire op_inf_n_11;
  wire op_inf_n_32;
  wire op_inf_n_33;
  wire op_inf_n_34;
  wire op_inf_n_35;
  wire op_inf_n_36;
  wire op_inf_n_37;
  wire op_inf_n_38;
  wire op_inf_n_39;
  wire op_inf_n_40;
  wire op_inf_n_41;
  wire op_inf_n_42;
  wire op_inf_n_43;
  wire op_inf_n_44;
  wire op_inf_n_45;
  wire op_inf_n_46;
  wire op_inf_n_47;
  wire op_inf_n_48;
  wire op_inf_n_49;
  wire op_inf_n_50;
  wire op_inf_n_51;
  wire op_inf_n_52;
  wire op_inf_n_53;
  wire op_inf_n_54;
  wire op_inf_n_55;
  wire op_inf_n_9;
  wire [9:0]p_1_in;
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
  wire sband_tact021_out;
  wire [23:0]sband_td_r;
  wire sband_tk_r;
  wire sband_tl;
  wire sband_tl_r;
  wire [9:4]sband_ts;
  wire [3:0]sband_ts__0;
  wire [9:0]sband_ts_r;
  wire sband_tu;
  wire sband_tu_r;
  wire sdt_tr;
  wire sdt_tv;
  wire vfb_arstn;
  wire vfb_clk;
  wire [7:0]vfb_data;
  wire [7:0]vfb_data_0;
  wire vfb_eol;
  wire vfb_ready;
  wire [0:0]vfb_sof;
  wire vfb_valid;
  wire vfb_valid0__0;
  wire [9:0]vfb_vcdt;

  assign core_men_ack_vfb = \<const0> ;
  assign mdt_tv = \<const0> ;
  assign vfb_full = \<const0> ;
  assign vfb_tr = vfb_ready;
  assign vfb_tv = vfb_valid;
  assign vfb_wc_full = \<const0> ;
  GND GND
       (.G(\<const0> ));
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_vfb_v1_0_16_reorder \VFB_MIN.reorder 
       (.D(vfb_data_0),
        .E(sband_tk_r),
        .Q({op_inf_n_10,op_inf_n_11}),
        .\buf_data_reg[0][101]_0 (\VFB_MIN.reorder_n_0 ),
        .\buf_data_reg[0][103]_0 ({\VFB_MIN.reorder_n_34 ,\VFB_MIN.reorder_n_35 }),
        .\buf_data_reg[0][135]_0 (sband_td_r),
        .\buf_data_reg[0][4]_0 (\VFB_MIN.reorder_n_3 ),
        .\buf_data_reg[0][73]_0 (p_1_in),
        .\buf_data_reg[0][73]_1 ({sband_ts,sband_ts__0}),
        .\buf_data_reg[1][136]_0 ({s_axis_tlast,s_axis_tdata,s_axis_tkeep[3:1],s_axis_tuser[69:64],s_axis_tuser[0],s_axis_tdest}),
        .s_axis_aclk(s_axis_aclk),
        .s_axis_aresetn(s_axis_aresetn),
        .s_axis_tready(s_axis_tready),
        .s_axis_tvalid(s_axis_tvalid),
        .sband_tact0(sband_tact0),
        .sband_tact021_out(sband_tact021_out),
        .\sband_td_r_reg[15] ({op_inf_n_32,op_inf_n_33,op_inf_n_34,op_inf_n_35,op_inf_n_36,op_inf_n_37,op_inf_n_38,op_inf_n_39,op_inf_n_40,op_inf_n_41,op_inf_n_42,op_inf_n_43,op_inf_n_44,op_inf_n_45,op_inf_n_46,op_inf_n_47,op_inf_n_48,op_inf_n_49,op_inf_n_50,op_inf_n_51,op_inf_n_52,op_inf_n_53,op_inf_n_54,op_inf_n_55}),
        .\sband_tk_r_reg[2] (vfb_valid),
        .sband_tl(sband_tl),
        .sband_tl_r(sband_tl_r),
        .sband_tl_r_reg(op_inf_n_9),
        .sband_tl_r_reg_0(vfb_eol),
        .sband_tu(sband_tu),
        .sband_tu_r(sband_tu_r),
        .sdt_tr(sdt_tr),
        .sdt_tv(sdt_tv),
        .vfb_ready(vfb_ready),
        .vfb_valid0__0(vfb_valid0__0),
        .\vfb_vcdt_reg[9] (sband_ts_r));
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_vfb_v1_0_16_op_inf op_inf
       (.D({\VFB_MIN.reorder_n_34 ,\VFB_MIN.reorder_n_35 }),
        .E(sband_tk_r),
        .Q({op_inf_n_10,op_inf_n_11}),
        .mdt_tr(mdt_tr),
        .sband_tact0(sband_tact0),
        .sband_tact021_out(sband_tact021_out),
        .\sband_td_r_reg[23]_0 ({op_inf_n_32,op_inf_n_33,op_inf_n_34,op_inf_n_35,op_inf_n_36,op_inf_n_37,op_inf_n_38,op_inf_n_39,op_inf_n_40,op_inf_n_41,op_inf_n_42,op_inf_n_43,op_inf_n_44,op_inf_n_45,op_inf_n_46,op_inf_n_47,op_inf_n_48,op_inf_n_49,op_inf_n_50,op_inf_n_51,op_inf_n_52,op_inf_n_53,op_inf_n_54,op_inf_n_55}),
        .\sband_td_r_reg[23]_1 (sband_td_r),
        .sband_tl(sband_tl),
        .sband_tl_r(sband_tl_r),
        .\sband_ts_r_reg[9]_0 (sband_ts_r),
        .\sband_ts_r_reg[9]_1 ({sband_ts,sband_ts__0}),
        .sband_tu(sband_tu),
        .sband_tu_r(sband_tu_r),
        .sdt_tr(sdt_tr),
        .vfb_arstn(vfb_arstn),
        .vfb_clk(vfb_clk),
        .\vfb_cnt_reg[3]_0 (op_inf_n_9),
        .vfb_data(vfb_data),
        .\vfb_data_reg[7]_0 (vfb_data_0),
        .vfb_eol_reg_0(vfb_eol),
        .vfb_eol_reg_1(\VFB_MIN.reorder_n_0 ),
        .vfb_ready(vfb_ready),
        .\vfb_sof_reg[0]_0 (vfb_sof),
        .\vfb_sof_reg[0]_1 (\VFB_MIN.reorder_n_3 ),
        .vfb_valid0__0(vfb_valid0__0),
        .vfb_valid_reg_0(vfb_valid),
        .vfb_vcdt(vfb_vcdt),
        .\vfb_vcdt_reg[9]_0 (p_1_in));
endmodule

module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_vfb_v1_0_16_op_inf
   (sband_tl_r,
    sband_tu_r,
    vfb_eol_reg_0,
    vfb_valid_reg_0,
    \vfb_sof_reg[0]_0 ,
    mdt_tr,
    vfb_valid0__0,
    sband_tact021_out,
    sdt_tr,
    \vfb_cnt_reg[3]_0 ,
    Q,
    \sband_ts_r_reg[9]_0 ,
    vfb_vcdt,
    \sband_td_r_reg[23]_0 ,
    vfb_data,
    sband_tact0,
    sband_tl,
    vfb_clk,
    sband_tu,
    \vfb_sof_reg[0]_1 ,
    vfb_ready,
    vfb_arstn,
    vfb_eol_reg_1,
    E,
    D,
    \sband_ts_r_reg[9]_1 ,
    \vfb_vcdt_reg[9]_0 ,
    \sband_td_r_reg[23]_1 ,
    \vfb_data_reg[7]_0 );
  output sband_tl_r;
  output sband_tu_r;
  output vfb_eol_reg_0;
  output vfb_valid_reg_0;
  output \vfb_sof_reg[0]_0 ;
  output mdt_tr;
  output vfb_valid0__0;
  output sband_tact021_out;
  output sdt_tr;
  output \vfb_cnt_reg[3]_0 ;
  output [1:0]Q;
  output [9:0]\sband_ts_r_reg[9]_0 ;
  output [9:0]vfb_vcdt;
  output [23:0]\sband_td_r_reg[23]_0 ;
  output [7:0]vfb_data;
  input sband_tact0;
  input sband_tl;
  input vfb_clk;
  input sband_tu;
  input \vfb_sof_reg[0]_1 ;
  input vfb_ready;
  input vfb_arstn;
  input vfb_eol_reg_1;
  input [0:0]E;
  input [1:0]D;
  input [9:0]\sband_ts_r_reg[9]_1 ;
  input [9:0]\vfb_vcdt_reg[9]_0 ;
  input [23:0]\sband_td_r_reg[23]_1 ;
  input [7:0]\vfb_data_reg[7]_0 ;

  wire [1:0]D;
  wire [0:0]E;
  wire [1:0]Q;
  wire [3:0]cnt_done0;
  wire mdt_tr;
  wire sband_tact;
  wire sband_tact0;
  wire sband_tact021_out;
  wire sband_tact1__0;
  wire sband_tact_i_1_n_0;
  wire sband_tact_i_2_n_0;
  wire [23:0]\sband_td_r_reg[23]_0 ;
  wire [23:0]\sband_td_r_reg[23]_1 ;
  wire sband_tl;
  wire sband_tl_r;
  wire sband_tr2;
  wire [9:0]\sband_ts_r_reg[9]_0 ;
  wire [9:0]\sband_ts_r_reg[9]_1 ;
  wire sband_tu;
  wire sband_tu_r;
  wire sdt_tr;
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
  wire vfb_sof7_in;
  wire \vfb_sof[0]_i_1_n_0 ;
  wire \vfb_sof[0]_i_5_n_0 ;
  wire \vfb_sof_reg[0]_0 ;
  wire \vfb_sof_reg[0]_1 ;
  wire vfb_tu0;
  wire vfb_tu0_i_1_n_0;
  wire vfb_valid0__0;
  wire vfb_valid_i_1_n_0;
  wire vfb_valid_reg_0;
  wire [9:0]vfb_vcdt;
  wire \vfb_vcdt[9]_i_1_n_0 ;
  wire \vfb_vcdt[9]_i_2_n_0 ;
  wire [9:0]\vfb_vcdt_reg[9]_0 ;

  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT2 #(
    .INIT(4'hB)) 
    mdt_tr_INST_0
       (.I0(vfb_ready),
        .I1(vfb_valid_reg_0),
        .O(mdt_tr));
  LUT4 #(
    .INIT(16'hF200)) 
    sband_tact_i_1
       (.I0(sband_tact),
        .I1(sband_tact_i_2_n_0),
        .I2(sband_tact0),
        .I3(vfb_arstn),
        .O(sband_tact_i_1_n_0));
  LUT6 #(
    .INIT(64'hABAAAAAA00000000)) 
    sband_tact_i_2
       (.I0(vfb_eol_reg_0),
        .I1(vfb_cnt_reg[3]),
        .I2(vfb_cnt_reg[2]),
        .I3(vfb_cnt_reg[1]),
        .I4(vfb_cnt_reg[0]),
        .I5(sband_tr2),
        .O(sband_tact_i_2_n_0));
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
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \sband_td_r_reg[10] 
       (.C(vfb_clk),
        .CE(E),
        .D(\sband_td_r_reg[23]_1 [10]),
        .Q(\sband_td_r_reg[23]_0 [10]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \sband_td_r_reg[11] 
       (.C(vfb_clk),
        .CE(E),
        .D(\sband_td_r_reg[23]_1 [11]),
        .Q(\sband_td_r_reg[23]_0 [11]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \sband_td_r_reg[12] 
       (.C(vfb_clk),
        .CE(E),
        .D(\sband_td_r_reg[23]_1 [12]),
        .Q(\sband_td_r_reg[23]_0 [12]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \sband_td_r_reg[13] 
       (.C(vfb_clk),
        .CE(E),
        .D(\sband_td_r_reg[23]_1 [13]),
        .Q(\sband_td_r_reg[23]_0 [13]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \sband_td_r_reg[14] 
       (.C(vfb_clk),
        .CE(E),
        .D(\sband_td_r_reg[23]_1 [14]),
        .Q(\sband_td_r_reg[23]_0 [14]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \sband_td_r_reg[15] 
       (.C(vfb_clk),
        .CE(E),
        .D(\sband_td_r_reg[23]_1 [15]),
        .Q(\sband_td_r_reg[23]_0 [15]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \sband_td_r_reg[16] 
       (.C(vfb_clk),
        .CE(E),
        .D(\sband_td_r_reg[23]_1 [16]),
        .Q(\sband_td_r_reg[23]_0 [16]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \sband_td_r_reg[17] 
       (.C(vfb_clk),
        .CE(E),
        .D(\sband_td_r_reg[23]_1 [17]),
        .Q(\sband_td_r_reg[23]_0 [17]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \sband_td_r_reg[18] 
       (.C(vfb_clk),
        .CE(E),
        .D(\sband_td_r_reg[23]_1 [18]),
        .Q(\sband_td_r_reg[23]_0 [18]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \sband_td_r_reg[19] 
       (.C(vfb_clk),
        .CE(E),
        .D(\sband_td_r_reg[23]_1 [19]),
        .Q(\sband_td_r_reg[23]_0 [19]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \sband_td_r_reg[1] 
       (.C(vfb_clk),
        .CE(E),
        .D(\sband_td_r_reg[23]_1 [1]),
        .Q(\sband_td_r_reg[23]_0 [1]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \sband_td_r_reg[20] 
       (.C(vfb_clk),
        .CE(E),
        .D(\sband_td_r_reg[23]_1 [20]),
        .Q(\sband_td_r_reg[23]_0 [20]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \sband_td_r_reg[21] 
       (.C(vfb_clk),
        .CE(E),
        .D(\sband_td_r_reg[23]_1 [21]),
        .Q(\sband_td_r_reg[23]_0 [21]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \sband_td_r_reg[22] 
       (.C(vfb_clk),
        .CE(E),
        .D(\sband_td_r_reg[23]_1 [22]),
        .Q(\sband_td_r_reg[23]_0 [22]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \sband_td_r_reg[23] 
       (.C(vfb_clk),
        .CE(E),
        .D(\sband_td_r_reg[23]_1 [23]),
        .Q(\sband_td_r_reg[23]_0 [23]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \sband_td_r_reg[2] 
       (.C(vfb_clk),
        .CE(E),
        .D(\sband_td_r_reg[23]_1 [2]),
        .Q(\sband_td_r_reg[23]_0 [2]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \sband_td_r_reg[3] 
       (.C(vfb_clk),
        .CE(E),
        .D(\sband_td_r_reg[23]_1 [3]),
        .Q(\sband_td_r_reg[23]_0 [3]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \sband_td_r_reg[4] 
       (.C(vfb_clk),
        .CE(E),
        .D(\sband_td_r_reg[23]_1 [4]),
        .Q(\sband_td_r_reg[23]_0 [4]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \sband_td_r_reg[5] 
       (.C(vfb_clk),
        .CE(E),
        .D(\sband_td_r_reg[23]_1 [5]),
        .Q(\sband_td_r_reg[23]_0 [5]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \sband_td_r_reg[6] 
       (.C(vfb_clk),
        .CE(E),
        .D(\sband_td_r_reg[23]_1 [6]),
        .Q(\sband_td_r_reg[23]_0 [6]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \sband_td_r_reg[7] 
       (.C(vfb_clk),
        .CE(E),
        .D(\sband_td_r_reg[23]_1 [7]),
        .Q(\sband_td_r_reg[23]_0 [7]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \sband_td_r_reg[8] 
       (.C(vfb_clk),
        .CE(E),
        .D(\sband_td_r_reg[23]_1 [8]),
        .Q(\sband_td_r_reg[23]_0 [8]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \sband_td_r_reg[9] 
       (.C(vfb_clk),
        .CE(E),
        .D(\sband_td_r_reg[23]_1 [9]),
        .Q(\sband_td_r_reg[23]_0 [9]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \sband_tk_r_reg[1] 
       (.C(vfb_clk),
        .CE(E),
        .D(D[0]),
        .Q(Q[0]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \sband_tk_r_reg[2] 
       (.C(vfb_clk),
        .CE(E),
        .D(D[1]),
        .Q(Q[1]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
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
        .CE(sband_tact0),
        .D(sband_tl),
        .Q(sband_tl_r),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \sband_ts_r_reg[0] 
       (.C(vfb_clk),
        .CE(sband_tact0),
        .D(\sband_ts_r_reg[9]_1 [0]),
        .Q(\sband_ts_r_reg[9]_0 [0]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \sband_ts_r_reg[1] 
       (.C(vfb_clk),
        .CE(sband_tact0),
        .D(\sband_ts_r_reg[9]_1 [1]),
        .Q(\sband_ts_r_reg[9]_0 [1]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \sband_ts_r_reg[2] 
       (.C(vfb_clk),
        .CE(sband_tact0),
        .D(\sband_ts_r_reg[9]_1 [2]),
        .Q(\sband_ts_r_reg[9]_0 [2]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \sband_ts_r_reg[3] 
       (.C(vfb_clk),
        .CE(sband_tact0),
        .D(\sband_ts_r_reg[9]_1 [3]),
        .Q(\sband_ts_r_reg[9]_0 [3]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \sband_ts_r_reg[4] 
       (.C(vfb_clk),
        .CE(sband_tact0),
        .D(\sband_ts_r_reg[9]_1 [4]),
        .Q(\sband_ts_r_reg[9]_0 [4]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \sband_ts_r_reg[5] 
       (.C(vfb_clk),
        .CE(sband_tact0),
        .D(\sband_ts_r_reg[9]_1 [5]),
        .Q(\sband_ts_r_reg[9]_0 [5]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \sband_ts_r_reg[6] 
       (.C(vfb_clk),
        .CE(sband_tact0),
        .D(\sband_ts_r_reg[9]_1 [6]),
        .Q(\sband_ts_r_reg[9]_0 [6]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \sband_ts_r_reg[7] 
       (.C(vfb_clk),
        .CE(sband_tact0),
        .D(\sband_ts_r_reg[9]_1 [7]),
        .Q(\sband_ts_r_reg[9]_0 [7]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \sband_ts_r_reg[8] 
       (.C(vfb_clk),
        .CE(sband_tact0),
        .D(\sband_ts_r_reg[9]_1 [8]),
        .Q(\sband_ts_r_reg[9]_0 [8]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \sband_ts_r_reg[9] 
       (.C(vfb_clk),
        .CE(sband_tact0),
        .D(\sband_ts_r_reg[9]_1 [9]),
        .Q(\sband_ts_r_reg[9]_0 [9]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \sband_tu_r_reg[0] 
       (.C(vfb_clk),
        .CE(sband_tact0),
        .D(sband_tu),
        .Q(sband_tu_r),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT3 #(
    .INIT(8'h0D)) 
    sdt_tr_INST_0
       (.I0(vfb_valid_reg_0),
        .I1(sband_tact021_out),
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
        .O(sband_tact021_out));
  LUT1 #(
    .INIT(2'h1)) 
    \vfb_cnt[0]_i_1 
       (.I0(vfb_cnt_reg[0]),
        .O(cnt_done0[0]));
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \vfb_cnt[1]_i_1 
       (.I0(vfb_cnt_reg[0]),
        .I1(vfb_cnt_reg[1]),
        .O(cnt_done0[1]));
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
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
       (.I0(sband_tact021_out),
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
        .O(sband_tr2));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
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
        .CE(sband_tr2),
        .D(cnt_done0[0]),
        .Q(vfb_cnt_reg[0]),
        .R(\vfb_cnt[3]_i_1_n_0 ));
  FDRE \vfb_cnt_reg[1] 
       (.C(vfb_clk),
        .CE(sband_tr2),
        .D(cnt_done0[1]),
        .Q(vfb_cnt_reg[1]),
        .R(\vfb_cnt[3]_i_1_n_0 ));
  FDRE \vfb_cnt_reg[2] 
       (.C(vfb_clk),
        .CE(sband_tr2),
        .D(cnt_done0[2]),
        .Q(vfb_cnt_reg[2]),
        .R(\vfb_cnt[3]_i_1_n_0 ));
  FDRE \vfb_cnt_reg[3] 
       (.C(vfb_clk),
        .CE(sband_tr2),
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
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \vfb_data_reg[1] 
       (.C(vfb_clk),
        .CE(\vfb_data[7]_i_1_n_0 ),
        .D(\vfb_data_reg[7]_0 [1]),
        .Q(vfb_data[1]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \vfb_data_reg[2] 
       (.C(vfb_clk),
        .CE(\vfb_data[7]_i_1_n_0 ),
        .D(\vfb_data_reg[7]_0 [2]),
        .Q(vfb_data[2]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \vfb_data_reg[3] 
       (.C(vfb_clk),
        .CE(\vfb_data[7]_i_1_n_0 ),
        .D(\vfb_data_reg[7]_0 [3]),
        .Q(vfb_data[3]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \vfb_data_reg[4] 
       (.C(vfb_clk),
        .CE(\vfb_data[7]_i_1_n_0 ),
        .D(\vfb_data_reg[7]_0 [4]),
        .Q(vfb_data[4]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \vfb_data_reg[5] 
       (.C(vfb_clk),
        .CE(\vfb_data[7]_i_1_n_0 ),
        .D(\vfb_data_reg[7]_0 [5]),
        .Q(vfb_data[5]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \vfb_data_reg[6] 
       (.C(vfb_clk),
        .CE(\vfb_data[7]_i_1_n_0 ),
        .D(\vfb_data_reg[7]_0 [6]),
        .Q(vfb_data[6]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \vfb_data_reg[7] 
       (.C(vfb_clk),
        .CE(\vfb_data[7]_i_1_n_0 ),
        .D(\vfb_data_reg[7]_0 [7]),
        .Q(vfb_data[7]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
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
  LUT6 #(
    .INIT(64'h0000000032AA02AA)) 
    \vfb_sof[0]_i_1 
       (.I0(\vfb_sof_reg[0]_0 ),
        .I1(sband_tact1__0),
        .I2(vfb_sof7_in),
        .I3(mdt_tr),
        .I4(\vfb_sof_reg[0]_1 ),
        .I5(\vfb_sof[0]_i_5_n_0 ),
        .O(\vfb_sof[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT3 #(
    .INIT(8'h80)) 
    \vfb_sof[0]_i_2 
       (.I0(vfb_ready),
        .I1(vfb_valid_reg_0),
        .I2(vfb_eol_reg_0),
        .O(sband_tact1__0));
  LUT6 #(
    .INIT(64'hFEFFFFFFAAAAAAAA)) 
    \vfb_sof[0]_i_3 
       (.I0(sband_tact0),
        .I1(vfb_cnt_reg[3]),
        .I2(vfb_cnt_reg[2]),
        .I3(vfb_cnt_reg[1]),
        .I4(vfb_cnt_reg[0]),
        .I5(sband_tact),
        .O(vfb_sof7_in));
  LUT6 #(
    .INIT(64'h80F38080FFFFFFFF)) 
    \vfb_sof[0]_i_5 
       (.I0(\vfb_sof_reg[0]_0 ),
        .I1(vfb_valid_reg_0),
        .I2(vfb_ready),
        .I3(vfb_eol_reg_0),
        .I4(vfb_tu0),
        .I5(vfb_arstn),
        .O(\vfb_sof[0]_i_5_n_0 ));
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
        .I3(sband_tact0),
        .I4(vfb_valid0__0),
        .I5(vfb_arstn),
        .O(vfb_valid_i_1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT5 #(
    .INIT(32'hAAAAAA2A)) 
    vfb_valid_i_2
       (.I0(sband_tact),
        .I1(vfb_cnt_reg[0]),
        .I2(vfb_cnt_reg[1]),
        .I3(vfb_cnt_reg[2]),
        .I4(vfb_cnt_reg[3]),
        .O(vfb_valid0__0));
  FDRE vfb_valid_reg
       (.C(vfb_clk),
        .CE(1'b1),
        .D(vfb_valid_i_1_n_0),
        .Q(vfb_valid_reg_0),
        .R(1'b0));
  LUT1 #(
    .INIT(2'h1)) 
    \vfb_vcdt[9]_i_1 
       (.I0(vfb_arstn),
        .O(\vfb_vcdt[9]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hDDD0)) 
    \vfb_vcdt[9]_i_2 
       (.I0(vfb_valid_reg_0),
        .I1(vfb_ready),
        .I2(sband_tact),
        .I3(sband_tact0),
        .O(\vfb_vcdt[9]_i_2_n_0 ));
  FDRE \vfb_vcdt_reg[0] 
       (.C(vfb_clk),
        .CE(\vfb_vcdt[9]_i_2_n_0 ),
        .D(\vfb_vcdt_reg[9]_0 [0]),
        .Q(vfb_vcdt[0]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \vfb_vcdt_reg[1] 
       (.C(vfb_clk),
        .CE(\vfb_vcdt[9]_i_2_n_0 ),
        .D(\vfb_vcdt_reg[9]_0 [1]),
        .Q(vfb_vcdt[1]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \vfb_vcdt_reg[2] 
       (.C(vfb_clk),
        .CE(\vfb_vcdt[9]_i_2_n_0 ),
        .D(\vfb_vcdt_reg[9]_0 [2]),
        .Q(vfb_vcdt[2]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \vfb_vcdt_reg[3] 
       (.C(vfb_clk),
        .CE(\vfb_vcdt[9]_i_2_n_0 ),
        .D(\vfb_vcdt_reg[9]_0 [3]),
        .Q(vfb_vcdt[3]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \vfb_vcdt_reg[4] 
       (.C(vfb_clk),
        .CE(\vfb_vcdt[9]_i_2_n_0 ),
        .D(\vfb_vcdt_reg[9]_0 [4]),
        .Q(vfb_vcdt[4]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \vfb_vcdt_reg[5] 
       (.C(vfb_clk),
        .CE(\vfb_vcdt[9]_i_2_n_0 ),
        .D(\vfb_vcdt_reg[9]_0 [5]),
        .Q(vfb_vcdt[5]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \vfb_vcdt_reg[6] 
       (.C(vfb_clk),
        .CE(\vfb_vcdt[9]_i_2_n_0 ),
        .D(\vfb_vcdt_reg[9]_0 [6]),
        .Q(vfb_vcdt[6]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \vfb_vcdt_reg[7] 
       (.C(vfb_clk),
        .CE(\vfb_vcdt[9]_i_2_n_0 ),
        .D(\vfb_vcdt_reg[9]_0 [7]),
        .Q(vfb_vcdt[7]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \vfb_vcdt_reg[8] 
       (.C(vfb_clk),
        .CE(\vfb_vcdt[9]_i_2_n_0 ),
        .D(\vfb_vcdt_reg[9]_0 [8]),
        .Q(vfb_vcdt[8]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
  FDRE \vfb_vcdt_reg[9] 
       (.C(vfb_clk),
        .CE(\vfb_vcdt[9]_i_2_n_0 ),
        .D(\vfb_vcdt_reg[9]_0 [9]),
        .Q(vfb_vcdt[9]),
        .R(\vfb_vcdt[9]_i_1_n_0 ));
endmodule

module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_vfb_v1_0_16_reorder
   (\buf_data_reg[0][101]_0 ,
    sband_tl,
    sband_tact0,
    \buf_data_reg[0][4]_0 ,
    sdt_tv,
    D,
    \buf_data_reg[0][73]_0 ,
    \buf_data_reg[0][73]_1 ,
    E,
    \buf_data_reg[0][103]_0 ,
    \buf_data_reg[0][135]_0 ,
    s_axis_tready,
    sband_tu,
    s_axis_tvalid,
    vfb_valid0__0,
    Q,
    sband_tl_r,
    sband_tl_r_reg,
    sband_tl_r_reg_0,
    sdt_tr,
    sband_tu_r,
    \sband_td_r_reg[15] ,
    \vfb_vcdt_reg[9] ,
    vfb_ready,
    \sband_tk_r_reg[2] ,
    sband_tact021_out,
    \buf_data_reg[1][136]_0 ,
    s_axis_aresetn,
    s_axis_aclk);
  output \buf_data_reg[0][101]_0 ;
  output sband_tl;
  output sband_tact0;
  output \buf_data_reg[0][4]_0 ;
  output sdt_tv;
  output [7:0]D;
  output [9:0]\buf_data_reg[0][73]_0 ;
  output [9:0]\buf_data_reg[0][73]_1 ;
  output [0:0]E;
  output [1:0]\buf_data_reg[0][103]_0 ;
  output [23:0]\buf_data_reg[0][135]_0 ;
  output s_axis_tready;
  output sband_tu;
  input s_axis_tvalid;
  input vfb_valid0__0;
  input [1:0]Q;
  input sband_tl_r;
  input sband_tl_r_reg;
  input sband_tl_r_reg_0;
  input sdt_tr;
  input sband_tu_r;
  input [23:0]\sband_td_r_reg[15] ;
  input [9:0]\vfb_vcdt_reg[9] ;
  input vfb_ready;
  input \sband_tk_r_reg[2] ;
  input sband_tact021_out;
  input [46:0]\buf_data_reg[1][136]_0 ;
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
  wire \buf_data_reg[0][4]_0 ;
  wire [9:0]\buf_data_reg[0][73]_0 ;
  wire [9:0]\buf_data_reg[0][73]_1 ;
  wire [136:0]\buf_data_reg[1] ;
  wire [46:0]\buf_data_reg[1][136]_0 ;
  wire \buf_data_reg_n_0_[0][4] ;
  wire \buf_valid[0]_i_1_n_0 ;
  wire \buf_valid[1]_i_1_n_0 ;
  wire \buf_valid_reg_n_0_[0] ;
  wire cur_dtype_pxls1;
  wire cur_dtype_sink_i_1_n_0;
  wire cur_dtype_sink_i_3_n_0;
  wire cur_dtype_sink_reg_n_0;
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
  wire sband_tact021_out;
  wire [23:0]\sband_td_r_reg[15] ;
  wire [3:1]sband_tk;
  wire \sband_tk_r_reg[2] ;
  wire sband_tl;
  wire sband_tl_r;
  wire sband_tl_r_reg;
  wire sband_tl_r_reg_0;
  wire sband_tu;
  wire sband_tu_r;
  wire sdt_tr;
  wire sdt_tv;
  wire vfb_ready;
  wire vfb_valid0__0;
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
        .I3(\buf_data_reg[1][136]_0 [11]),
        .O(p_2_in[101]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][102]_i_1 
       (.I0(\buf_data_reg[1] [102]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [12]),
        .O(p_2_in[102]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][103]_i_1 
       (.I0(\buf_data_reg[1] [103]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [13]),
        .O(p_2_in[103]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][104]_i_1 
       (.I0(\buf_data_reg[1] [104]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [14]),
        .O(p_2_in[104]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][105]_i_1 
       (.I0(\buf_data_reg[1] [105]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [15]),
        .O(p_2_in[105]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][106]_i_1 
       (.I0(\buf_data_reg[1] [106]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [16]),
        .O(p_2_in[106]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][107]_i_1 
       (.I0(\buf_data_reg[1] [107]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [17]),
        .O(p_2_in[107]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][108]_i_1 
       (.I0(\buf_data_reg[1] [108]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [18]),
        .O(p_2_in[108]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][109]_i_1 
       (.I0(\buf_data_reg[1] [109]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [19]),
        .O(p_2_in[109]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][110]_i_1 
       (.I0(\buf_data_reg[1] [110]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [20]),
        .O(p_2_in[110]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][111]_i_1 
       (.I0(\buf_data_reg[1] [111]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [21]),
        .O(p_2_in[111]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][112]_i_1 
       (.I0(\buf_data_reg[1] [112]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [22]),
        .O(p_2_in[112]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][113]_i_1 
       (.I0(\buf_data_reg[1] [113]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [23]),
        .O(p_2_in[113]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][114]_i_1 
       (.I0(\buf_data_reg[1] [114]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [24]),
        .O(p_2_in[114]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][115]_i_1 
       (.I0(\buf_data_reg[1] [115]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [25]),
        .O(p_2_in[115]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][116]_i_1 
       (.I0(\buf_data_reg[1] [116]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [26]),
        .O(p_2_in[116]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][117]_i_1 
       (.I0(\buf_data_reg[1] [117]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [27]),
        .O(p_2_in[117]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][118]_i_1 
       (.I0(\buf_data_reg[1] [118]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [28]),
        .O(p_2_in[118]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][119]_i_1 
       (.I0(\buf_data_reg[1] [119]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [29]),
        .O(p_2_in[119]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][120]_i_1 
       (.I0(\buf_data_reg[1] [120]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [30]),
        .O(p_2_in[120]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][121]_i_1 
       (.I0(\buf_data_reg[1] [121]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [31]),
        .O(p_2_in[121]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][122]_i_1 
       (.I0(\buf_data_reg[1] [122]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [32]),
        .O(p_2_in[122]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][123]_i_1 
       (.I0(\buf_data_reg[1] [123]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [33]),
        .O(p_2_in[123]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][124]_i_1 
       (.I0(\buf_data_reg[1] [124]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [34]),
        .O(p_2_in[124]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][125]_i_1 
       (.I0(\buf_data_reg[1] [125]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [35]),
        .O(p_2_in[125]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][126]_i_1 
       (.I0(\buf_data_reg[1] [126]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [36]),
        .O(p_2_in[126]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][127]_i_1 
       (.I0(\buf_data_reg[1] [127]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [37]),
        .O(p_2_in[127]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][128]_i_1 
       (.I0(\buf_data_reg[1] [128]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [38]),
        .O(p_2_in[128]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][129]_i_1 
       (.I0(\buf_data_reg[1] [129]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [39]),
        .O(p_2_in[129]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][130]_i_1 
       (.I0(\buf_data_reg[1] [130]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [40]),
        .O(p_2_in[130]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][131]_i_1 
       (.I0(\buf_data_reg[1] [131]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [41]),
        .O(p_2_in[131]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][132]_i_1 
       (.I0(\buf_data_reg[1] [132]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [42]),
        .O(p_2_in[132]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][133]_i_1 
       (.I0(\buf_data_reg[1] [133]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [43]),
        .O(p_2_in[133]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][134]_i_1 
       (.I0(\buf_data_reg[1] [134]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [44]),
        .O(p_2_in[134]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][135]_i_1 
       (.I0(\buf_data_reg[1] [135]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [45]),
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
        .I3(\buf_data_reg[1][136]_0 [46]),
        .O(p_2_in[136]));
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
    \buf_data[0][2]_i_1 
       (.I0(\buf_data_reg[1] [2]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [2]),
        .O(p_2_in[2]));
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
    \buf_data[0][4]_i_1 
       (.I0(\buf_data_reg[1] [4]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [4]),
        .O(p_2_in[4]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][68]_i_1 
       (.I0(\buf_data_reg[1] [68]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [5]),
        .O(p_2_in[68]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][69]_i_1 
       (.I0(\buf_data_reg[1] [69]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [6]),
        .O(p_2_in[69]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][70]_i_1 
       (.I0(\buf_data_reg[1] [70]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [7]),
        .O(p_2_in[70]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][71]_i_1 
       (.I0(\buf_data_reg[1] [71]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [8]),
        .O(p_2_in[71]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][72]_i_1 
       (.I0(\buf_data_reg[1] [72]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [9]),
        .O(p_2_in[72]));
  LUT4 #(
    .INIT(16'hBF80)) 
    \buf_data[0][73]_i_1 
       (.I0(\buf_data_reg[1] [73]),
        .I1(p_0_in),
        .I2(cur_dtype_pxls1),
        .I3(\buf_data_reg[1][136]_0 [10]),
        .O(p_2_in[73]));
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
  FDRE \buf_data_reg[0][1] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[1]),
        .Q(\buf_data_reg[0][73]_1 [1]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][2] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[2]),
        .Q(\buf_data_reg[0][73]_1 [2]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][3] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[3]),
        .Q(\buf_data_reg[0][73]_1 [3]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][4] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[4]),
        .Q(\buf_data_reg_n_0_[0][4] ),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][68] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[68]),
        .Q(\buf_data_reg[0][73]_1 [4]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][69] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[69]),
        .Q(\buf_data_reg[0][73]_1 [5]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][70] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[70]),
        .Q(\buf_data_reg[0][73]_1 [6]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][71] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[71]),
        .Q(\buf_data_reg[0][73]_1 [7]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][72] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[72]),
        .Q(\buf_data_reg[0][73]_1 [8]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[0][73] 
       (.C(s_axis_aclk),
        .CE(\buf_data[0][136]_i_1_n_0 ),
        .D(p_2_in[73]),
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
        .D(\buf_data_reg[1][136]_0 [11]),
        .Q(\buf_data_reg[1] [101]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][102] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [12]),
        .Q(\buf_data_reg[1] [102]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][103] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [13]),
        .Q(\buf_data_reg[1] [103]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][104] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [14]),
        .Q(\buf_data_reg[1] [104]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][105] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [15]),
        .Q(\buf_data_reg[1] [105]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][106] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [16]),
        .Q(\buf_data_reg[1] [106]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][107] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [17]),
        .Q(\buf_data_reg[1] [107]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][108] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [18]),
        .Q(\buf_data_reg[1] [108]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][109] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [19]),
        .Q(\buf_data_reg[1] [109]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][110] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [20]),
        .Q(\buf_data_reg[1] [110]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][111] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [21]),
        .Q(\buf_data_reg[1] [111]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][112] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [22]),
        .Q(\buf_data_reg[1] [112]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][113] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [23]),
        .Q(\buf_data_reg[1] [113]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][114] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [24]),
        .Q(\buf_data_reg[1] [114]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][115] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [25]),
        .Q(\buf_data_reg[1] [115]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][116] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [26]),
        .Q(\buf_data_reg[1] [116]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][117] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [27]),
        .Q(\buf_data_reg[1] [117]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][118] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [28]),
        .Q(\buf_data_reg[1] [118]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][119] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [29]),
        .Q(\buf_data_reg[1] [119]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][120] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [30]),
        .Q(\buf_data_reg[1] [120]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][121] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [31]),
        .Q(\buf_data_reg[1] [121]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][122] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [32]),
        .Q(\buf_data_reg[1] [122]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][123] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [33]),
        .Q(\buf_data_reg[1] [123]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][124] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [34]),
        .Q(\buf_data_reg[1] [124]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][125] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [35]),
        .Q(\buf_data_reg[1] [125]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][126] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [36]),
        .Q(\buf_data_reg[1] [126]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][127] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [37]),
        .Q(\buf_data_reg[1] [127]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][128] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [38]),
        .Q(\buf_data_reg[1] [128]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][129] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [39]),
        .Q(\buf_data_reg[1] [129]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][130] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [40]),
        .Q(\buf_data_reg[1] [130]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][131] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [41]),
        .Q(\buf_data_reg[1] [131]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][132] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [42]),
        .Q(\buf_data_reg[1] [132]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][133] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [43]),
        .Q(\buf_data_reg[1] [133]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][134] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [44]),
        .Q(\buf_data_reg[1] [134]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][135] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [45]),
        .Q(\buf_data_reg[1] [135]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][136] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [46]),
        .Q(\buf_data_reg[1] [136]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][1] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [1]),
        .Q(\buf_data_reg[1] [1]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][2] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [2]),
        .Q(\buf_data_reg[1] [2]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][3] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [3]),
        .Q(\buf_data_reg[1] [3]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][4] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [4]),
        .Q(\buf_data_reg[1] [4]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][68] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [5]),
        .Q(\buf_data_reg[1] [68]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][69] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [6]),
        .Q(\buf_data_reg[1] [69]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][70] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [7]),
        .Q(\buf_data_reg[1] [70]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][71] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [8]),
        .Q(\buf_data_reg[1] [71]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][72] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [9]),
        .Q(\buf_data_reg[1] [72]),
        .R(\buf_data[1][136]_i_1_n_0 ));
  FDRE \buf_data_reg[1][73] 
       (.C(s_axis_aclk),
        .CE(\buf_data[1][136]_i_2_n_0 ),
        .D(\buf_data_reg[1][136]_0 [10]),
        .Q(\buf_data_reg[1] [73]),
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
        .I2(sband_tact021_out),
        .I3(\sband_tk_r_reg[2] ),
        .I4(cur_dtype_sink_reg_n_0),
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
       (.I0(cur_dtype_sink_reg_n_0),
        .I1(main_dtvc),
        .I2(\buf_valid_reg_n_0_[0] ),
        .I3(sban_dtvc),
        .I4(cur_dtype_sink_i_3_n_0),
        .O(cur_dtype_sink_i_1_n_0));
  LUT6 #(
    .INIT(64'h0100000000000000)) 
    cur_dtype_sink_i_2
       (.I0(\buf_data_reg[0][73]_1 [8]),
        .I1(\buf_data_reg[0][73]_1 [4]),
        .I2(\buf_data_reg[0][73]_1 [6]),
        .I3(\buf_data_reg[0][73]_1 [9]),
        .I4(\buf_data_reg[0][73]_1 [5]),
        .I5(\buf_data_reg[0][73]_1 [7]),
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
        .Q(cur_dtype_sink_reg_n_0),
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
        .I1(sband_tact0),
        .I2(\sband_td_r_reg[15] [8]),
        .O(\buf_data_reg[0][135]_0 [0]));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sband_td_r[10]_i_1 
       (.I0(s_axis_tdata__0[18]),
        .I1(sband_tact0),
        .I2(\sband_td_r_reg[15] [18]),
        .O(\buf_data_reg[0][135]_0 [10]));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sband_td_r[11]_i_1 
       (.I0(s_axis_tdata__0[19]),
        .I1(sband_tact0),
        .I2(\sband_td_r_reg[15] [19]),
        .O(\buf_data_reg[0][135]_0 [11]));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sband_td_r[12]_i_1 
       (.I0(s_axis_tdata__0[20]),
        .I1(sband_tact0),
        .I2(\sband_td_r_reg[15] [20]),
        .O(\buf_data_reg[0][135]_0 [12]));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sband_td_r[13]_i_1 
       (.I0(s_axis_tdata__0[21]),
        .I1(sband_tact0),
        .I2(\sband_td_r_reg[15] [21]),
        .O(\buf_data_reg[0][135]_0 [13]));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sband_td_r[14]_i_1 
       (.I0(s_axis_tdata__0[22]),
        .I1(sband_tact0),
        .I2(\sband_td_r_reg[15] [22]),
        .O(\buf_data_reg[0][135]_0 [14]));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sband_td_r[15]_i_1 
       (.I0(s_axis_tdata__0[23]),
        .I1(sband_tact0),
        .I2(\sband_td_r_reg[15] [23]),
        .O(\buf_data_reg[0][135]_0 [15]));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \sband_td_r[16]_i_1 
       (.I0(sband_tact0),
        .I1(s_axis_tdata__0[24]),
        .O(\buf_data_reg[0][135]_0 [16]));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \sband_td_r[17]_i_1 
       (.I0(sband_tact0),
        .I1(s_axis_tdata__0[25]),
        .O(\buf_data_reg[0][135]_0 [17]));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \sband_td_r[18]_i_1 
       (.I0(sband_tact0),
        .I1(s_axis_tdata__0[26]),
        .O(\buf_data_reg[0][135]_0 [18]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \sband_td_r[19]_i_1 
       (.I0(sband_tact0),
        .I1(s_axis_tdata__0[27]),
        .O(\buf_data_reg[0][135]_0 [19]));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sband_td_r[1]_i_1 
       (.I0(s_axis_tdata__0[9]),
        .I1(sband_tact0),
        .I2(\sband_td_r_reg[15] [9]),
        .O(\buf_data_reg[0][135]_0 [1]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \sband_td_r[20]_i_1 
       (.I0(sband_tact0),
        .I1(s_axis_tdata__0[28]),
        .O(\buf_data_reg[0][135]_0 [20]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \sband_td_r[21]_i_1 
       (.I0(sband_tact0),
        .I1(s_axis_tdata__0[29]),
        .O(\buf_data_reg[0][135]_0 [21]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \sband_td_r[22]_i_1 
       (.I0(sband_tact0),
        .I1(s_axis_tdata__0[30]),
        .O(\buf_data_reg[0][135]_0 [22]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \sband_td_r[23]_i_1 
       (.I0(sband_tact0),
        .I1(s_axis_tdata__0[31]),
        .O(\buf_data_reg[0][135]_0 [23]));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sband_td_r[2]_i_1 
       (.I0(s_axis_tdata__0[10]),
        .I1(sband_tact0),
        .I2(\sband_td_r_reg[15] [10]),
        .O(\buf_data_reg[0][135]_0 [2]));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sband_td_r[3]_i_1 
       (.I0(s_axis_tdata__0[11]),
        .I1(sband_tact0),
        .I2(\sband_td_r_reg[15] [11]),
        .O(\buf_data_reg[0][135]_0 [3]));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sband_td_r[4]_i_1 
       (.I0(s_axis_tdata__0[12]),
        .I1(sband_tact0),
        .I2(\sband_td_r_reg[15] [12]),
        .O(\buf_data_reg[0][135]_0 [4]));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sband_td_r[5]_i_1 
       (.I0(s_axis_tdata__0[13]),
        .I1(sband_tact0),
        .I2(\sband_td_r_reg[15] [13]),
        .O(\buf_data_reg[0][135]_0 [5]));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sband_td_r[6]_i_1 
       (.I0(s_axis_tdata__0[14]),
        .I1(sband_tact0),
        .I2(\sband_td_r_reg[15] [14]),
        .O(\buf_data_reg[0][135]_0 [6]));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sband_td_r[7]_i_1 
       (.I0(s_axis_tdata__0[15]),
        .I1(sband_tact0),
        .I2(\sband_td_r_reg[15] [15]),
        .O(\buf_data_reg[0][135]_0 [7]));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sband_td_r[8]_i_1 
       (.I0(s_axis_tdata__0[16]),
        .I1(sband_tact0),
        .I2(\sband_td_r_reg[15] [16]),
        .O(\buf_data_reg[0][135]_0 [8]));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sband_td_r[9]_i_1 
       (.I0(s_axis_tdata__0[17]),
        .I1(sband_tact0),
        .I2(\sband_td_r_reg[15] [17]),
        .O(\buf_data_reg[0][135]_0 [9]));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \sband_tk_r[1]_i_1 
       (.I0(sband_tk[2]),
        .I1(sband_tact0),
        .I2(Q[1]),
        .O(\buf_data_reg[0][103]_0 [0]));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT3 #(
    .INIT(8'hEA)) 
    \sband_tk_r[2]_i_1 
       (.I0(sband_tact0),
        .I1(vfb_ready),
        .I2(\sband_tk_r_reg[2] ),
        .O(E));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \sband_tk_r[2]_i_2 
       (.I0(sband_tact0),
        .I1(sband_tk[3]),
        .O(\buf_data_reg[0][103]_0 [1]));
  LUT6 #(
    .INIT(64'h0080000000800080)) 
    sband_tl_r_i_1
       (.I0(cur_dtype_udef),
        .I1(\buf_valid_reg_n_0_[0] ),
        .I2(sban_dtvc),
        .I3(sband_tl_r_reg_0),
        .I4(sband_tact021_out),
        .I5(\sband_tk_r_reg[2] ),
        .O(sband_tact0));
  LUT6 #(
    .INIT(64'h8080888080808080)) 
    sband_tl_r_i_2
       (.I0(s_axis_tlast),
        .I1(\buf_valid_reg_n_0_[0] ),
        .I2(cur_dtype_sink_reg_n_0),
        .I3(sband_tl_r_reg),
        .I4(sband_tl_r_reg_0),
        .I5(cur_dtype_udef),
        .O(sband_tl));
  LUT4 #(
    .INIT(16'hA800)) 
    \sband_tu_r[0]_i_1 
       (.I0(\buf_data_reg_n_0_[0][4] ),
        .I1(cur_dtype_sink_reg_n_0),
        .I2(sdt_tr),
        .I3(sdt_tv),
        .O(sband_tu));
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
       (.I0(\buf_data_reg[0][73]_1 [7]),
        .I1(\buf_data_reg[0][73]_1 [5]),
        .I2(\buf_data_reg[0][73]_1 [9]),
        .I3(\buf_data_reg[0][73]_1 [6]),
        .I4(\buf_data_reg[0][73]_1 [4]),
        .I5(\buf_data_reg[0][73]_1 [8]),
        .O(sban_dtvc));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT4 #(
    .INIT(16'hB888)) 
    \vfb_data[0]_i_1 
       (.I0(s_axis_tdata__0[0]),
        .I1(sband_tact0),
        .I2(vfb_valid0__0),
        .I3(\sband_td_r_reg[15] [0]),
        .O(D[0]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT4 #(
    .INIT(16'hB888)) 
    \vfb_data[1]_i_1 
       (.I0(s_axis_tdata__0[1]),
        .I1(sband_tact0),
        .I2(vfb_valid0__0),
        .I3(\sband_td_r_reg[15] [1]),
        .O(D[1]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT4 #(
    .INIT(16'hB888)) 
    \vfb_data[2]_i_1 
       (.I0(s_axis_tdata__0[2]),
        .I1(sband_tact0),
        .I2(vfb_valid0__0),
        .I3(\sband_td_r_reg[15] [2]),
        .O(D[2]));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT4 #(
    .INIT(16'hB888)) 
    \vfb_data[3]_i_1 
       (.I0(s_axis_tdata__0[3]),
        .I1(sband_tact0),
        .I2(vfb_valid0__0),
        .I3(\sband_td_r_reg[15] [3]),
        .O(D[3]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT4 #(
    .INIT(16'hB888)) 
    \vfb_data[4]_i_1 
       (.I0(s_axis_tdata__0[4]),
        .I1(sband_tact0),
        .I2(vfb_valid0__0),
        .I3(\sband_td_r_reg[15] [4]),
        .O(D[4]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT4 #(
    .INIT(16'hB888)) 
    \vfb_data[5]_i_1 
       (.I0(s_axis_tdata__0[5]),
        .I1(sband_tact0),
        .I2(vfb_valid0__0),
        .I3(\sband_td_r_reg[15] [5]),
        .O(D[5]));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT4 #(
    .INIT(16'hB888)) 
    \vfb_data[6]_i_1 
       (.I0(s_axis_tdata__0[6]),
        .I1(sband_tact0),
        .I2(vfb_valid0__0),
        .I3(\sband_td_r_reg[15] [6]),
        .O(D[6]));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT4 #(
    .INIT(16'hB888)) 
    \vfb_data[7]_i_2 
       (.I0(s_axis_tdata__0[7]),
        .I1(sband_tact0),
        .I2(vfb_valid0__0),
        .I3(\sband_td_r_reg[15] [7]),
        .O(D[7]));
  LUT6 #(
    .INIT(64'h20202F2020202020)) 
    vfb_eol_i_2
       (.I0(sband_tl),
        .I1(sband_tk[1]),
        .I2(sband_tact0),
        .I3(vfb_valid0__0),
        .I4(Q[0]),
        .I5(sband_tl_r),
        .O(\buf_data_reg[0][101]_0 ));
  LUT6 #(
    .INIT(64'hA8FFFFFFA8000000)) 
    \vfb_sof[0]_i_4 
       (.I0(\buf_data_reg_n_0_[0][4] ),
        .I1(cur_dtype_sink_reg_n_0),
        .I2(cur_dtype_udef),
        .I3(sdt_tv),
        .I4(sdt_tr),
        .I5(sband_tu_r),
        .O(\buf_data_reg[0][4]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \vfb_vcdt[0]_i_1 
       (.I0(\buf_data_reg[0][73]_1 [0]),
        .I1(sband_tact0),
        .I2(\vfb_vcdt_reg[9] [0]),
        .O(\buf_data_reg[0][73]_0 [0]));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \vfb_vcdt[1]_i_1 
       (.I0(\buf_data_reg[0][73]_1 [1]),
        .I1(sband_tact0),
        .I2(\vfb_vcdt_reg[9] [1]),
        .O(\buf_data_reg[0][73]_0 [1]));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \vfb_vcdt[2]_i_1 
       (.I0(\buf_data_reg[0][73]_1 [2]),
        .I1(sband_tact0),
        .I2(\vfb_vcdt_reg[9] [2]),
        .O(\buf_data_reg[0][73]_0 [2]));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \vfb_vcdt[3]_i_1 
       (.I0(\buf_data_reg[0][73]_1 [3]),
        .I1(sband_tact0),
        .I2(\vfb_vcdt_reg[9] [3]),
        .O(\buf_data_reg[0][73]_0 [3]));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \vfb_vcdt[4]_i_1 
       (.I0(\buf_data_reg[0][73]_1 [4]),
        .I1(sband_tact0),
        .I2(\vfb_vcdt_reg[9] [4]),
        .O(\buf_data_reg[0][73]_0 [4]));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \vfb_vcdt[5]_i_1 
       (.I0(\buf_data_reg[0][73]_1 [5]),
        .I1(sband_tact0),
        .I2(\vfb_vcdt_reg[9] [5]),
        .O(\buf_data_reg[0][73]_0 [5]));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \vfb_vcdt[6]_i_1 
       (.I0(\buf_data_reg[0][73]_1 [6]),
        .I1(sband_tact0),
        .I2(\vfb_vcdt_reg[9] [6]),
        .O(\buf_data_reg[0][73]_0 [6]));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \vfb_vcdt[7]_i_1 
       (.I0(\buf_data_reg[0][73]_1 [7]),
        .I1(sband_tact0),
        .I2(\vfb_vcdt_reg[9] [7]),
        .O(\buf_data_reg[0][73]_0 [7]));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \vfb_vcdt[8]_i_1 
       (.I0(\buf_data_reg[0][73]_1 [8]),
        .I1(sband_tact0),
        .I2(\vfb_vcdt_reg[9] [8]),
        .O(\buf_data_reg[0][73]_0 [8]));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \vfb_vcdt[9]_i_3 
       (.I0(\buf_data_reg[0][73]_1 [9]),
        .I1(sband_tact0),
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
