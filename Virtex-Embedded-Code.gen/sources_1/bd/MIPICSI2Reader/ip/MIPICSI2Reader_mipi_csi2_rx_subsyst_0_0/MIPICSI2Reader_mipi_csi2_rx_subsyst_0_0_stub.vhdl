-- Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
-- Date        : Wed Jun  9 13:47:43 2021
-- Host        : liams-desktop running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               c:/Users/liamsnow/Documents/GitHub/Virtex-Embedded-Code/Virtex-Embedded-Code.gen/sources_1/bd/MIPICSI2Reader/ip/MIPICSI2Reader_mipi_csi2_rx_subsyst_0_0/MIPICSI2Reader_mipi_csi2_rx_subsyst_0_0_stub.vhdl
-- Design      : MIPICSI2Reader_mipi_csi2_rx_subsyst_0_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a50tcpg236-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MIPICSI2Reader_mipi_csi2_rx_subsyst_0_0 is
  Port ( 
    dphy_clk_200M : in STD_LOGIC;
    rxbyteclkhs : out STD_LOGIC;
    system_rst_out : out STD_LOGIC;
    video_aclk : in STD_LOGIC;
    video_aresetn : in STD_LOGIC;
    ctrl_core_en : in STD_LOGIC;
    ctrl_dis_in_prgs : out STD_LOGIC;
    errsotsynchs_intr : out STD_LOGIC;
    errsoths_intr : out STD_LOGIC;
    cl_stopstate_intr : out STD_LOGIC;
    dl0_stopstate_intr : out STD_LOGIC;
    dl1_stopstate_intr : out STD_LOGIC;
    crc_status_intr : out STD_LOGIC;
    ecc_status_intr : out STD_LOGIC_VECTOR ( 1 downto 0 );
    linebuffer_full : out STD_LOGIC;
    frame_rcvd_pulse_out : out STD_LOGIC;
    video_out_tdata : out STD_LOGIC_VECTOR ( 7 downto 0 );
    video_out_tdest : out STD_LOGIC_VECTOR ( 9 downto 0 );
    video_out_tlast : out STD_LOGIC;
    video_out_tready : in STD_LOGIC;
    video_out_tuser : out STD_LOGIC_VECTOR ( 0 to 0 );
    video_out_tvalid : out STD_LOGIC;
    mipi_phy_if_clk_hs_n : in STD_LOGIC;
    mipi_phy_if_clk_hs_p : in STD_LOGIC;
    mipi_phy_if_clk_lp_n : in STD_LOGIC;
    mipi_phy_if_clk_lp_p : in STD_LOGIC;
    mipi_phy_if_data_hs_n : in STD_LOGIC_VECTOR ( 1 downto 0 );
    mipi_phy_if_data_hs_p : in STD_LOGIC_VECTOR ( 1 downto 0 );
    mipi_phy_if_data_lp_n : in STD_LOGIC_VECTOR ( 1 downto 0 );
    mipi_phy_if_data_lp_p : in STD_LOGIC_VECTOR ( 1 downto 0 )
  );

end MIPICSI2Reader_mipi_csi2_rx_subsyst_0_0;

architecture stub of MIPICSI2Reader_mipi_csi2_rx_subsyst_0_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "dphy_clk_200M,rxbyteclkhs,system_rst_out,video_aclk,video_aresetn,ctrl_core_en,ctrl_dis_in_prgs,errsotsynchs_intr,errsoths_intr,cl_stopstate_intr,dl0_stopstate_intr,dl1_stopstate_intr,crc_status_intr,ecc_status_intr[1:0],linebuffer_full,frame_rcvd_pulse_out,video_out_tdata[7:0],video_out_tdest[9:0],video_out_tlast,video_out_tready,video_out_tuser[0:0],video_out_tvalid,mipi_phy_if_clk_hs_n,mipi_phy_if_clk_hs_p,mipi_phy_if_clk_lp_n,mipi_phy_if_clk_lp_p,mipi_phy_if_data_hs_n[1:0],mipi_phy_if_data_hs_p[1:0],mipi_phy_if_data_lp_n[1:0],mipi_phy_if_data_lp_p[1:0]";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "bd_e616,Vivado 2020.2";
begin
end;
