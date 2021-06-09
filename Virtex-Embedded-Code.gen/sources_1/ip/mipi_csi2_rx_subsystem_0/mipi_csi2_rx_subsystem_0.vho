-- (c) Copyright 1995-2021 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
-- DO NOT MODIFY THIS FILE.

-- IP VLNV: xilinx.com:ip:mipi_csi2_rx_subsystem:5.1
-- IP Revision: 0

-- The following code must appear in the VHDL architecture header.

------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
COMPONENT mipi_csi2_rx_subsystem_0
  PORT (
    lite_aclk : IN STD_LOGIC;
    lite_aresetn : IN STD_LOGIC;
    dphy_clk_200M : IN STD_LOGIC;
    rxbyteclkhs : OUT STD_LOGIC;
    system_rst_out : OUT STD_LOGIC;
    csirxss_csi_irq : OUT STD_LOGIC;
    video_aclk : IN STD_LOGIC;
    video_aresetn : IN STD_LOGIC;
    csirxss_s_axi_araddr : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    csirxss_s_axi_arready : OUT STD_LOGIC;
    csirxss_s_axi_arvalid : IN STD_LOGIC;
    csirxss_s_axi_awaddr : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    csirxss_s_axi_awready : OUT STD_LOGIC;
    csirxss_s_axi_awvalid : IN STD_LOGIC;
    csirxss_s_axi_bready : IN STD_LOGIC;
    csirxss_s_axi_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    csirxss_s_axi_bvalid : OUT STD_LOGIC;
    csirxss_s_axi_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    csirxss_s_axi_rready : IN STD_LOGIC;
    csirxss_s_axi_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    csirxss_s_axi_rvalid : OUT STD_LOGIC;
    csirxss_s_axi_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    csirxss_s_axi_wready : OUT STD_LOGIC;
    csirxss_s_axi_wstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    csirxss_s_axi_wvalid : IN STD_LOGIC;
    video_out_tdata : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    video_out_tdest : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
    video_out_tlast : OUT STD_LOGIC;
    video_out_tready : IN STD_LOGIC;
    video_out_tuser : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    video_out_tvalid : OUT STD_LOGIC;
    mipi_phy_if_clk_hs_n : IN STD_LOGIC;
    mipi_phy_if_clk_hs_p : IN STD_LOGIC;
    mipi_phy_if_clk_lp_n : IN STD_LOGIC;
    mipi_phy_if_clk_lp_p : IN STD_LOGIC;
    mipi_phy_if_data_hs_n : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    mipi_phy_if_data_hs_p : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    mipi_phy_if_data_lp_n : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    mipi_phy_if_data_lp_p : IN STD_LOGIC_VECTOR(1 DOWNTO 0)
  );
END COMPONENT;
-- COMP_TAG_END ------ End COMPONENT Declaration ------------

-- The following code must appear in the VHDL architecture
-- body. Substitute your own instance name and net names.

------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
your_instance_name : mipi_csi2_rx_subsystem_0
  PORT MAP (
    lite_aclk => lite_aclk,
    lite_aresetn => lite_aresetn,
    dphy_clk_200M => dphy_clk_200M,
    rxbyteclkhs => rxbyteclkhs,
    system_rst_out => system_rst_out,
    csirxss_csi_irq => csirxss_csi_irq,
    video_aclk => video_aclk,
    video_aresetn => video_aresetn,
    csirxss_s_axi_araddr => csirxss_s_axi_araddr,
    csirxss_s_axi_arready => csirxss_s_axi_arready,
    csirxss_s_axi_arvalid => csirxss_s_axi_arvalid,
    csirxss_s_axi_awaddr => csirxss_s_axi_awaddr,
    csirxss_s_axi_awready => csirxss_s_axi_awready,
    csirxss_s_axi_awvalid => csirxss_s_axi_awvalid,
    csirxss_s_axi_bready => csirxss_s_axi_bready,
    csirxss_s_axi_bresp => csirxss_s_axi_bresp,
    csirxss_s_axi_bvalid => csirxss_s_axi_bvalid,
    csirxss_s_axi_rdata => csirxss_s_axi_rdata,
    csirxss_s_axi_rready => csirxss_s_axi_rready,
    csirxss_s_axi_rresp => csirxss_s_axi_rresp,
    csirxss_s_axi_rvalid => csirxss_s_axi_rvalid,
    csirxss_s_axi_wdata => csirxss_s_axi_wdata,
    csirxss_s_axi_wready => csirxss_s_axi_wready,
    csirxss_s_axi_wstrb => csirxss_s_axi_wstrb,
    csirxss_s_axi_wvalid => csirxss_s_axi_wvalid,
    video_out_tdata => video_out_tdata,
    video_out_tdest => video_out_tdest,
    video_out_tlast => video_out_tlast,
    video_out_tready => video_out_tready,
    video_out_tuser => video_out_tuser,
    video_out_tvalid => video_out_tvalid,
    mipi_phy_if_clk_hs_n => mipi_phy_if_clk_hs_n,
    mipi_phy_if_clk_hs_p => mipi_phy_if_clk_hs_p,
    mipi_phy_if_clk_lp_n => mipi_phy_if_clk_lp_n,
    mipi_phy_if_clk_lp_p => mipi_phy_if_clk_lp_p,
    mipi_phy_if_data_hs_n => mipi_phy_if_data_hs_n,
    mipi_phy_if_data_hs_p => mipi_phy_if_data_hs_p,
    mipi_phy_if_data_lp_n => mipi_phy_if_data_lp_n,
    mipi_phy_if_data_lp_p => mipi_phy_if_data_lp_p
  );
-- INST_TAG_END ------ End INSTANTIATION Template ---------

-- You must compile the wrapper file mipi_csi2_rx_subsystem_0.vhd when simulating
-- the core, mipi_csi2_rx_subsystem_0. When compiling the wrapper file, be sure to
-- reference the VHDL simulation library.

