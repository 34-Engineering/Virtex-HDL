-- Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
-- Date        : Wed Jun  9 13:46:58 2021
-- Host        : liams-desktop running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim
--               c:/Users/liamsnow/Documents/GitHub/Virtex-Embedded-Code/Virtex-Embedded-Code.gen/sources_1/bd/MIPICSI2Reader/ip/MIPICSI2Reader_mipi_csi2_rx_subsyst_0_0/bd_0/ip/ip_3/bd_e616_vfb_0_0_sim_netlist.vhdl
-- Design      : bd_e616_vfb_0_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7a50tcpg236-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity bd_e616_vfb_0_0_vfb_v1_0_16_op_inf is
  port (
    sband_tl_r : out STD_LOGIC;
    sband_tu_r : out STD_LOGIC;
    vfb_eol_reg_0 : out STD_LOGIC;
    vfb_valid_reg_0 : out STD_LOGIC;
    \vfb_sof_reg[0]_0\ : out STD_LOGIC;
    mdt_tr : out STD_LOGIC;
    \vfb_valid0__0\ : out STD_LOGIC;
    sband_tact021_out : out STD_LOGIC;
    sdt_tr : out STD_LOGIC;
    \vfb_cnt_reg[3]_0\ : out STD_LOGIC;
    Q : out STD_LOGIC_VECTOR ( 1 downto 0 );
    \sband_ts_r_reg[9]_0\ : out STD_LOGIC_VECTOR ( 9 downto 0 );
    vfb_vcdt : out STD_LOGIC_VECTOR ( 9 downto 0 );
    \sband_td_r_reg[23]_0\ : out STD_LOGIC_VECTOR ( 23 downto 0 );
    vfb_data : out STD_LOGIC_VECTOR ( 7 downto 0 );
    sband_tact0 : in STD_LOGIC;
    sband_tl : in STD_LOGIC;
    vfb_clk : in STD_LOGIC;
    sband_tu : in STD_LOGIC;
    \vfb_sof_reg[0]_1\ : in STD_LOGIC;
    vfb_ready : in STD_LOGIC;
    vfb_arstn : in STD_LOGIC;
    vfb_eol_reg_1 : in STD_LOGIC;
    E : in STD_LOGIC_VECTOR ( 0 to 0 );
    D : in STD_LOGIC_VECTOR ( 1 downto 0 );
    \sband_ts_r_reg[9]_1\ : in STD_LOGIC_VECTOR ( 9 downto 0 );
    \vfb_vcdt_reg[9]_0\ : in STD_LOGIC_VECTOR ( 9 downto 0 );
    \sband_td_r_reg[23]_1\ : in STD_LOGIC_VECTOR ( 23 downto 0 );
    \vfb_data_reg[7]_0\ : in STD_LOGIC_VECTOR ( 7 downto 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of bd_e616_vfb_0_0_vfb_v1_0_16_op_inf : entity is "vfb_v1_0_16_op_inf";
end bd_e616_vfb_0_0_vfb_v1_0_16_op_inf;

architecture STRUCTURE of bd_e616_vfb_0_0_vfb_v1_0_16_op_inf is
  signal cnt_done0 : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \^mdt_tr\ : STD_LOGIC;
  signal sband_tact : STD_LOGIC;
  signal \^sband_tact021_out\ : STD_LOGIC;
  signal \sband_tact1__0\ : STD_LOGIC;
  signal sband_tact_i_1_n_0 : STD_LOGIC;
  signal sband_tact_i_2_n_0 : STD_LOGIC;
  signal sband_tr2 : STD_LOGIC;
  signal \vfb_cnt[3]_i_1_n_0\ : STD_LOGIC;
  signal vfb_cnt_reg : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \vfb_data[7]_i_1_n_0\ : STD_LOGIC;
  signal vfb_eol_i_1_n_0 : STD_LOGIC;
  signal \^vfb_eol_reg_0\ : STD_LOGIC;
  signal vfb_sof7_in : STD_LOGIC;
  signal \vfb_sof[0]_i_1_n_0\ : STD_LOGIC;
  signal \vfb_sof[0]_i_5_n_0\ : STD_LOGIC;
  signal \^vfb_sof_reg[0]_0\ : STD_LOGIC;
  signal vfb_tu0 : STD_LOGIC;
  signal vfb_tu0_i_1_n_0 : STD_LOGIC;
  signal \^vfb_valid0__0\ : STD_LOGIC;
  signal vfb_valid_i_1_n_0 : STD_LOGIC;
  signal \^vfb_valid_reg_0\ : STD_LOGIC;
  signal \vfb_vcdt[9]_i_1_n_0\ : STD_LOGIC;
  signal \vfb_vcdt[9]_i_2_n_0\ : STD_LOGIC;
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of mdt_tr_INST_0 : label is "soft_lutpair26";
  attribute SOFT_HLUTNM of sdt_tr_INST_0 : label is "soft_lutpair26";
  attribute SOFT_HLUTNM of \vfb_cnt[1]_i_1\ : label is "soft_lutpair27";
  attribute SOFT_HLUTNM of \vfb_cnt[2]_i_1\ : label is "soft_lutpair27";
  attribute SOFT_HLUTNM of \vfb_cnt[3]_i_3\ : label is "soft_lutpair25";
  attribute SOFT_HLUTNM of vfb_eol_i_1 : label is "soft_lutpair24";
  attribute SOFT_HLUTNM of \vfb_sof[0]_i_2\ : label is "soft_lutpair24";
  attribute SOFT_HLUTNM of vfb_valid_i_2 : label is "soft_lutpair25";
begin
  mdt_tr <= \^mdt_tr\;
  sband_tact021_out <= \^sband_tact021_out\;
  vfb_eol_reg_0 <= \^vfb_eol_reg_0\;
  \vfb_sof_reg[0]_0\ <= \^vfb_sof_reg[0]_0\;
  \vfb_valid0__0\ <= \^vfb_valid0__0\;
  vfb_valid_reg_0 <= \^vfb_valid_reg_0\;
mdt_tr_INST_0: unisim.vcomponents.LUT2
    generic map(
      INIT => X"B"
    )
        port map (
      I0 => vfb_ready,
      I1 => \^vfb_valid_reg_0\,
      O => \^mdt_tr\
    );
sband_tact_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F200"
    )
        port map (
      I0 => sband_tact,
      I1 => sband_tact_i_2_n_0,
      I2 => sband_tact0,
      I3 => vfb_arstn,
      O => sband_tact_i_1_n_0
    );
sband_tact_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"ABAAAAAA00000000"
    )
        port map (
      I0 => \^vfb_eol_reg_0\,
      I1 => vfb_cnt_reg(3),
      I2 => vfb_cnt_reg(2),
      I3 => vfb_cnt_reg(1),
      I4 => vfb_cnt_reg(0),
      I5 => sband_tr2,
      O => sband_tact_i_2_n_0
    );
sband_tact_reg: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => '1',
      D => sband_tact_i_1_n_0,
      Q => sband_tact,
      R => '0'
    );
\sband_td_r_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => E(0),
      D => \sband_td_r_reg[23]_1\(0),
      Q => \sband_td_r_reg[23]_0\(0),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\sband_td_r_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => E(0),
      D => \sband_td_r_reg[23]_1\(10),
      Q => \sband_td_r_reg[23]_0\(10),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\sband_td_r_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => E(0),
      D => \sband_td_r_reg[23]_1\(11),
      Q => \sband_td_r_reg[23]_0\(11),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\sband_td_r_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => E(0),
      D => \sband_td_r_reg[23]_1\(12),
      Q => \sband_td_r_reg[23]_0\(12),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\sband_td_r_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => E(0),
      D => \sband_td_r_reg[23]_1\(13),
      Q => \sband_td_r_reg[23]_0\(13),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\sband_td_r_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => E(0),
      D => \sband_td_r_reg[23]_1\(14),
      Q => \sband_td_r_reg[23]_0\(14),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\sband_td_r_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => E(0),
      D => \sband_td_r_reg[23]_1\(15),
      Q => \sband_td_r_reg[23]_0\(15),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\sband_td_r_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => E(0),
      D => \sband_td_r_reg[23]_1\(16),
      Q => \sband_td_r_reg[23]_0\(16),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\sband_td_r_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => E(0),
      D => \sband_td_r_reg[23]_1\(17),
      Q => \sband_td_r_reg[23]_0\(17),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\sband_td_r_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => E(0),
      D => \sband_td_r_reg[23]_1\(18),
      Q => \sband_td_r_reg[23]_0\(18),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\sband_td_r_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => E(0),
      D => \sband_td_r_reg[23]_1\(19),
      Q => \sband_td_r_reg[23]_0\(19),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\sband_td_r_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => E(0),
      D => \sband_td_r_reg[23]_1\(1),
      Q => \sband_td_r_reg[23]_0\(1),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\sband_td_r_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => E(0),
      D => \sband_td_r_reg[23]_1\(20),
      Q => \sband_td_r_reg[23]_0\(20),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\sband_td_r_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => E(0),
      D => \sband_td_r_reg[23]_1\(21),
      Q => \sband_td_r_reg[23]_0\(21),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\sband_td_r_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => E(0),
      D => \sband_td_r_reg[23]_1\(22),
      Q => \sband_td_r_reg[23]_0\(22),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\sband_td_r_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => E(0),
      D => \sband_td_r_reg[23]_1\(23),
      Q => \sband_td_r_reg[23]_0\(23),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\sband_td_r_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => E(0),
      D => \sband_td_r_reg[23]_1\(2),
      Q => \sband_td_r_reg[23]_0\(2),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\sband_td_r_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => E(0),
      D => \sband_td_r_reg[23]_1\(3),
      Q => \sband_td_r_reg[23]_0\(3),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\sband_td_r_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => E(0),
      D => \sband_td_r_reg[23]_1\(4),
      Q => \sband_td_r_reg[23]_0\(4),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\sband_td_r_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => E(0),
      D => \sband_td_r_reg[23]_1\(5),
      Q => \sband_td_r_reg[23]_0\(5),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\sband_td_r_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => E(0),
      D => \sband_td_r_reg[23]_1\(6),
      Q => \sband_td_r_reg[23]_0\(6),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\sband_td_r_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => E(0),
      D => \sband_td_r_reg[23]_1\(7),
      Q => \sband_td_r_reg[23]_0\(7),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\sband_td_r_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => E(0),
      D => \sband_td_r_reg[23]_1\(8),
      Q => \sband_td_r_reg[23]_0\(8),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\sband_td_r_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => E(0),
      D => \sband_td_r_reg[23]_1\(9),
      Q => \sband_td_r_reg[23]_0\(9),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\sband_tk_r_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => E(0),
      D => D(0),
      Q => Q(0),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\sband_tk_r_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => E(0),
      D => D(1),
      Q => Q(1),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
sband_tl_r_i_3: unisim.vcomponents.LUT6
    generic map(
      INIT => X"10000000FFFFFFFF"
    )
        port map (
      I0 => vfb_cnt_reg(3),
      I1 => vfb_cnt_reg(2),
      I2 => vfb_cnt_reg(1),
      I3 => vfb_cnt_reg(0),
      I4 => vfb_ready,
      I5 => \^vfb_valid_reg_0\,
      O => \vfb_cnt_reg[3]_0\
    );
sband_tl_r_reg: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => sband_tact0,
      D => sband_tl,
      Q => sband_tl_r,
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\sband_ts_r_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => sband_tact0,
      D => \sband_ts_r_reg[9]_1\(0),
      Q => \sband_ts_r_reg[9]_0\(0),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\sband_ts_r_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => sband_tact0,
      D => \sband_ts_r_reg[9]_1\(1),
      Q => \sband_ts_r_reg[9]_0\(1),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\sband_ts_r_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => sband_tact0,
      D => \sband_ts_r_reg[9]_1\(2),
      Q => \sband_ts_r_reg[9]_0\(2),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\sband_ts_r_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => sband_tact0,
      D => \sband_ts_r_reg[9]_1\(3),
      Q => \sband_ts_r_reg[9]_0\(3),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\sband_ts_r_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => sband_tact0,
      D => \sband_ts_r_reg[9]_1\(4),
      Q => \sband_ts_r_reg[9]_0\(4),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\sband_ts_r_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => sband_tact0,
      D => \sband_ts_r_reg[9]_1\(5),
      Q => \sband_ts_r_reg[9]_0\(5),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\sband_ts_r_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => sband_tact0,
      D => \sband_ts_r_reg[9]_1\(6),
      Q => \sband_ts_r_reg[9]_0\(6),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\sband_ts_r_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => sband_tact0,
      D => \sband_ts_r_reg[9]_1\(7),
      Q => \sband_ts_r_reg[9]_0\(7),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\sband_ts_r_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => sband_tact0,
      D => \sband_ts_r_reg[9]_1\(8),
      Q => \sband_ts_r_reg[9]_0\(8),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\sband_ts_r_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => sband_tact0,
      D => \sband_ts_r_reg[9]_1\(9),
      Q => \sband_ts_r_reg[9]_0\(9),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\sband_tu_r_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => sband_tact0,
      D => sband_tu,
      Q => sband_tu_r,
      R => \vfb_vcdt[9]_i_1_n_0\
    );
sdt_tr_INST_0: unisim.vcomponents.LUT3
    generic map(
      INIT => X"0D"
    )
        port map (
      I0 => \^vfb_valid_reg_0\,
      I1 => \^sband_tact021_out\,
      I2 => \^vfb_eol_reg_0\,
      O => sdt_tr
    );
sdt_tr_INST_0_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000008000"
    )
        port map (
      I0 => vfb_ready,
      I1 => \^vfb_valid_reg_0\,
      I2 => vfb_cnt_reg(0),
      I3 => vfb_cnt_reg(1),
      I4 => vfb_cnt_reg(2),
      I5 => vfb_cnt_reg(3),
      O => \^sband_tact021_out\
    );
\vfb_cnt[0]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => vfb_cnt_reg(0),
      O => cnt_done0(0)
    );
\vfb_cnt[1]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => vfb_cnt_reg(0),
      I1 => vfb_cnt_reg(1),
      O => cnt_done0(1)
    );
\vfb_cnt[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"78"
    )
        port map (
      I0 => vfb_cnt_reg(0),
      I1 => vfb_cnt_reg(1),
      I2 => vfb_cnt_reg(2),
      O => cnt_done0(2)
    );
\vfb_cnt[3]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"EAAAFFFF"
    )
        port map (
      I0 => \^sband_tact021_out\,
      I1 => vfb_ready,
      I2 => \^vfb_valid_reg_0\,
      I3 => \^vfb_eol_reg_0\,
      I4 => vfb_arstn,
      O => \vfb_cnt[3]_i_1_n_0\
    );
\vfb_cnt[3]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \^vfb_valid_reg_0\,
      I1 => vfb_ready,
      O => sband_tr2
    );
\vfb_cnt[3]_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7F80"
    )
        port map (
      I0 => vfb_cnt_reg(1),
      I1 => vfb_cnt_reg(0),
      I2 => vfb_cnt_reg(2),
      I3 => vfb_cnt_reg(3),
      O => cnt_done0(3)
    );
\vfb_cnt_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => sband_tr2,
      D => cnt_done0(0),
      Q => vfb_cnt_reg(0),
      R => \vfb_cnt[3]_i_1_n_0\
    );
\vfb_cnt_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => sband_tr2,
      D => cnt_done0(1),
      Q => vfb_cnt_reg(1),
      R => \vfb_cnt[3]_i_1_n_0\
    );
\vfb_cnt_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => sband_tr2,
      D => cnt_done0(2),
      Q => vfb_cnt_reg(2),
      R => \vfb_cnt[3]_i_1_n_0\
    );
\vfb_cnt_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => sband_tr2,
      D => cnt_done0(3),
      Q => vfb_cnt_reg(3),
      R => \vfb_cnt[3]_i_1_n_0\
    );
\vfb_data[7]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"73"
    )
        port map (
      I0 => \^vfb_eol_reg_0\,
      I1 => \^vfb_valid_reg_0\,
      I2 => vfb_ready,
      O => \vfb_data[7]_i_1_n_0\
    );
\vfb_data_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => \vfb_data[7]_i_1_n_0\,
      D => \vfb_data_reg[7]_0\(0),
      Q => vfb_data(0),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\vfb_data_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => \vfb_data[7]_i_1_n_0\,
      D => \vfb_data_reg[7]_0\(1),
      Q => vfb_data(1),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\vfb_data_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => \vfb_data[7]_i_1_n_0\,
      D => \vfb_data_reg[7]_0\(2),
      Q => vfb_data(2),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\vfb_data_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => \vfb_data[7]_i_1_n_0\,
      D => \vfb_data_reg[7]_0\(3),
      Q => vfb_data(3),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\vfb_data_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => \vfb_data[7]_i_1_n_0\,
      D => \vfb_data_reg[7]_0\(4),
      Q => vfb_data(4),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\vfb_data_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => \vfb_data[7]_i_1_n_0\,
      D => \vfb_data_reg[7]_0\(5),
      Q => vfb_data(5),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\vfb_data_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => \vfb_data[7]_i_1_n_0\,
      D => \vfb_data_reg[7]_0\(6),
      Q => vfb_data(6),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\vfb_data_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => \vfb_data[7]_i_1_n_0\,
      D => \vfb_data_reg[7]_0\(7),
      Q => vfb_data(7),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
vfb_eol_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"7B080000"
    )
        port map (
      I0 => \^vfb_eol_reg_0\,
      I1 => \^vfb_valid_reg_0\,
      I2 => vfb_ready,
      I3 => vfb_eol_reg_1,
      I4 => vfb_arstn,
      O => vfb_eol_i_1_n_0
    );
vfb_eol_reg: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => '1',
      D => vfb_eol_i_1_n_0,
      Q => \^vfb_eol_reg_0\,
      R => '0'
    );
\vfb_sof[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000032AA02AA"
    )
        port map (
      I0 => \^vfb_sof_reg[0]_0\,
      I1 => \sband_tact1__0\,
      I2 => vfb_sof7_in,
      I3 => \^mdt_tr\,
      I4 => \vfb_sof_reg[0]_1\,
      I5 => \vfb_sof[0]_i_5_n_0\,
      O => \vfb_sof[0]_i_1_n_0\
    );
\vfb_sof[0]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => vfb_ready,
      I1 => \^vfb_valid_reg_0\,
      I2 => \^vfb_eol_reg_0\,
      O => \sband_tact1__0\
    );
\vfb_sof[0]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FEFFFFFFAAAAAAAA"
    )
        port map (
      I0 => sband_tact0,
      I1 => vfb_cnt_reg(3),
      I2 => vfb_cnt_reg(2),
      I3 => vfb_cnt_reg(1),
      I4 => vfb_cnt_reg(0),
      I5 => sband_tact,
      O => vfb_sof7_in
    );
\vfb_sof[0]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"80F38080FFFFFFFF"
    )
        port map (
      I0 => \^vfb_sof_reg[0]_0\,
      I1 => \^vfb_valid_reg_0\,
      I2 => vfb_ready,
      I3 => \^vfb_eol_reg_0\,
      I4 => vfb_tu0,
      I5 => vfb_arstn,
      O => \vfb_sof[0]_i_5_n_0\
    );
\vfb_sof_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => '1',
      D => \vfb_sof[0]_i_1_n_0\,
      Q => \^vfb_sof_reg[0]_0\,
      R => '0'
    );
vfb_tu0_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"2AEA2AAA00000000"
    )
        port map (
      I0 => vfb_tu0,
      I1 => vfb_ready,
      I2 => \^vfb_valid_reg_0\,
      I3 => \^vfb_eol_reg_0\,
      I4 => \^vfb_sof_reg[0]_0\,
      I5 => vfb_arstn,
      O => vfb_tu0_i_1_n_0
    );
vfb_tu0_reg: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => '1',
      D => vfb_tu0_i_1_n_0,
      Q => vfb_tu0,
      R => '0'
    );
vfb_valid_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"7F7F7F2200000000"
    )
        port map (
      I0 => \^vfb_valid_reg_0\,
      I1 => vfb_ready,
      I2 => \^vfb_eol_reg_0\,
      I3 => sband_tact0,
      I4 => \^vfb_valid0__0\,
      I5 => vfb_arstn,
      O => vfb_valid_i_1_n_0
    );
vfb_valid_i_2: unisim.vcomponents.LUT5
    generic map(
      INIT => X"AAAAAA2A"
    )
        port map (
      I0 => sband_tact,
      I1 => vfb_cnt_reg(0),
      I2 => vfb_cnt_reg(1),
      I3 => vfb_cnt_reg(2),
      I4 => vfb_cnt_reg(3),
      O => \^vfb_valid0__0\
    );
vfb_valid_reg: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => '1',
      D => vfb_valid_i_1_n_0,
      Q => \^vfb_valid_reg_0\,
      R => '0'
    );
\vfb_vcdt[9]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => vfb_arstn,
      O => \vfb_vcdt[9]_i_1_n_0\
    );
\vfb_vcdt[9]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"DDD0"
    )
        port map (
      I0 => \^vfb_valid_reg_0\,
      I1 => vfb_ready,
      I2 => sband_tact,
      I3 => sband_tact0,
      O => \vfb_vcdt[9]_i_2_n_0\
    );
\vfb_vcdt_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => \vfb_vcdt[9]_i_2_n_0\,
      D => \vfb_vcdt_reg[9]_0\(0),
      Q => vfb_vcdt(0),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\vfb_vcdt_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => \vfb_vcdt[9]_i_2_n_0\,
      D => \vfb_vcdt_reg[9]_0\(1),
      Q => vfb_vcdt(1),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\vfb_vcdt_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => \vfb_vcdt[9]_i_2_n_0\,
      D => \vfb_vcdt_reg[9]_0\(2),
      Q => vfb_vcdt(2),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\vfb_vcdt_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => \vfb_vcdt[9]_i_2_n_0\,
      D => \vfb_vcdt_reg[9]_0\(3),
      Q => vfb_vcdt(3),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\vfb_vcdt_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => \vfb_vcdt[9]_i_2_n_0\,
      D => \vfb_vcdt_reg[9]_0\(4),
      Q => vfb_vcdt(4),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\vfb_vcdt_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => \vfb_vcdt[9]_i_2_n_0\,
      D => \vfb_vcdt_reg[9]_0\(5),
      Q => vfb_vcdt(5),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\vfb_vcdt_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => \vfb_vcdt[9]_i_2_n_0\,
      D => \vfb_vcdt_reg[9]_0\(6),
      Q => vfb_vcdt(6),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\vfb_vcdt_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => \vfb_vcdt[9]_i_2_n_0\,
      D => \vfb_vcdt_reg[9]_0\(7),
      Q => vfb_vcdt(7),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\vfb_vcdt_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => \vfb_vcdt[9]_i_2_n_0\,
      D => \vfb_vcdt_reg[9]_0\(8),
      Q => vfb_vcdt(8),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
\vfb_vcdt_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => vfb_clk,
      CE => \vfb_vcdt[9]_i_2_n_0\,
      D => \vfb_vcdt_reg[9]_0\(9),
      Q => vfb_vcdt(9),
      R => \vfb_vcdt[9]_i_1_n_0\
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity bd_e616_vfb_0_0_vfb_v1_0_16_reorder is
  port (
    \buf_data_reg[0][101]_0\ : out STD_LOGIC;
    sband_tl : out STD_LOGIC;
    sband_tact0 : out STD_LOGIC;
    \buf_data_reg[0][4]_0\ : out STD_LOGIC;
    sdt_tv : out STD_LOGIC;
    D : out STD_LOGIC_VECTOR ( 7 downto 0 );
    \buf_data_reg[0][73]_0\ : out STD_LOGIC_VECTOR ( 9 downto 0 );
    \buf_data_reg[0][73]_1\ : out STD_LOGIC_VECTOR ( 9 downto 0 );
    E : out STD_LOGIC_VECTOR ( 0 to 0 );
    \buf_data_reg[0][103]_0\ : out STD_LOGIC_VECTOR ( 1 downto 0 );
    \buf_data_reg[0][135]_0\ : out STD_LOGIC_VECTOR ( 23 downto 0 );
    s_axis_tready : out STD_LOGIC;
    sband_tu : out STD_LOGIC;
    s_axis_tvalid : in STD_LOGIC;
    \vfb_valid0__0\ : in STD_LOGIC;
    Q : in STD_LOGIC_VECTOR ( 1 downto 0 );
    sband_tl_r : in STD_LOGIC;
    sband_tl_r_reg : in STD_LOGIC;
    sband_tl_r_reg_0 : in STD_LOGIC;
    sdt_tr : in STD_LOGIC;
    sband_tu_r : in STD_LOGIC;
    \sband_td_r_reg[15]\ : in STD_LOGIC_VECTOR ( 23 downto 0 );
    \vfb_vcdt_reg[9]\ : in STD_LOGIC_VECTOR ( 9 downto 0 );
    vfb_ready : in STD_LOGIC;
    \sband_tk_r_reg[2]\ : in STD_LOGIC;
    sband_tact021_out : in STD_LOGIC;
    \buf_data_reg[1][136]_0\ : in STD_LOGIC_VECTOR ( 46 downto 0 );
    s_axis_aresetn : in STD_LOGIC;
    s_axis_aclk : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of bd_e616_vfb_0_0_vfb_v1_0_16_reorder : entity is "vfb_v1_0_16_reorder";
end bd_e616_vfb_0_0_vfb_v1_0_16_reorder;

architecture STRUCTURE of bd_e616_vfb_0_0_vfb_v1_0_16_reorder is
  signal \buf_data[0][136]_i_1_n_0\ : STD_LOGIC;
  signal \buf_data[1][136]_i_1_n_0\ : STD_LOGIC;
  signal \buf_data[1][136]_i_2_n_0\ : STD_LOGIC;
  signal \^buf_data_reg[0][73]_1\ : STD_LOGIC_VECTOR ( 9 downto 0 );
  signal \buf_data_reg[1]\ : STD_LOGIC_VECTOR ( 136 downto 0 );
  signal \buf_data_reg_n_0_[0][4]\ : STD_LOGIC;
  signal \buf_valid[0]_i_1_n_0\ : STD_LOGIC;
  signal \buf_valid[1]_i_1_n_0\ : STD_LOGIC;
  signal \buf_valid_reg_n_0_[0]\ : STD_LOGIC;
  signal cur_dtype_pxls1 : STD_LOGIC;
  signal cur_dtype_sink_i_1_n_0 : STD_LOGIC;
  signal cur_dtype_sink_i_3_n_0 : STD_LOGIC;
  signal cur_dtype_sink_reg_n_0 : STD_LOGIC;
  signal cur_dtype_udef : STD_LOGIC;
  signal cur_dtype_udef_i_1_n_0 : STD_LOGIC;
  signal main_dtvc : STD_LOGIC;
  signal p_0_in : STD_LOGIC;
  signal p_2_in : STD_LOGIC_VECTOR ( 136 downto 0 );
  signal \s_axis_tdata__0\ : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal s_axis_tlast : STD_LOGIC;
  signal sban_dtvc : STD_LOGIC;
  signal \^sband_tact0\ : STD_LOGIC;
  signal sband_tk : STD_LOGIC_VECTOR ( 3 downto 1 );
  signal \^sband_tl\ : STD_LOGIC;
  signal \^sdt_tv\ : STD_LOGIC;
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \buf_data[0][0]_i_1\ : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of \buf_valid[0]_i_1\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \buf_valid[1]_i_1\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of s_axis_tready_INST_0 : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of \sband_td_r[10]_i_1\ : label is "soft_lutpair19";
  attribute SOFT_HLUTNM of \sband_td_r[11]_i_1\ : label is "soft_lutpair18";
  attribute SOFT_HLUTNM of \sband_td_r[12]_i_1\ : label is "soft_lutpair18";
  attribute SOFT_HLUTNM of \sband_td_r[13]_i_1\ : label is "soft_lutpair17";
  attribute SOFT_HLUTNM of \sband_td_r[14]_i_1\ : label is "soft_lutpair17";
  attribute SOFT_HLUTNM of \sband_td_r[15]_i_1\ : label is "soft_lutpair16";
  attribute SOFT_HLUTNM of \sband_td_r[16]_i_1\ : label is "soft_lutpair16";
  attribute SOFT_HLUTNM of \sband_td_r[17]_i_1\ : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of \sband_td_r[18]_i_1\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \sband_td_r[19]_i_1\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \sband_td_r[1]_i_1\ : label is "soft_lutpair23";
  attribute SOFT_HLUTNM of \sband_td_r[20]_i_1\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \sband_td_r[21]_i_1\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \sband_td_r[22]_i_1\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \sband_td_r[23]_i_1\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \sband_td_r[2]_i_1\ : label is "soft_lutpair23";
  attribute SOFT_HLUTNM of \sband_td_r[3]_i_1\ : label is "soft_lutpair22";
  attribute SOFT_HLUTNM of \sband_td_r[4]_i_1\ : label is "soft_lutpair22";
  attribute SOFT_HLUTNM of \sband_td_r[5]_i_1\ : label is "soft_lutpair21";
  attribute SOFT_HLUTNM of \sband_td_r[6]_i_1\ : label is "soft_lutpair21";
  attribute SOFT_HLUTNM of \sband_td_r[7]_i_1\ : label is "soft_lutpair20";
  attribute SOFT_HLUTNM of \sband_td_r[8]_i_1\ : label is "soft_lutpair20";
  attribute SOFT_HLUTNM of \sband_td_r[9]_i_1\ : label is "soft_lutpair19";
  attribute SOFT_HLUTNM of \sband_tk_r[1]_i_1\ : label is "soft_lutpair15";
  attribute SOFT_HLUTNM of \sband_tk_r[2]_i_1\ : label is "soft_lutpair10";
  attribute SOFT_HLUTNM of \sband_tk_r[2]_i_2\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \vfb_data[0]_i_1\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \vfb_data[1]_i_1\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \vfb_data[2]_i_1\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \vfb_data[3]_i_1\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \vfb_data[4]_i_1\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \vfb_data[5]_i_1\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \vfb_data[6]_i_1\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \vfb_data[7]_i_2\ : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of \vfb_vcdt[0]_i_1\ : label is "soft_lutpair10";
  attribute SOFT_HLUTNM of \vfb_vcdt[1]_i_1\ : label is "soft_lutpair11";
  attribute SOFT_HLUTNM of \vfb_vcdt[2]_i_1\ : label is "soft_lutpair11";
  attribute SOFT_HLUTNM of \vfb_vcdt[3]_i_1\ : label is "soft_lutpair12";
  attribute SOFT_HLUTNM of \vfb_vcdt[4]_i_1\ : label is "soft_lutpair12";
  attribute SOFT_HLUTNM of \vfb_vcdt[5]_i_1\ : label is "soft_lutpair13";
  attribute SOFT_HLUTNM of \vfb_vcdt[6]_i_1\ : label is "soft_lutpair13";
  attribute SOFT_HLUTNM of \vfb_vcdt[7]_i_1\ : label is "soft_lutpair14";
  attribute SOFT_HLUTNM of \vfb_vcdt[8]_i_1\ : label is "soft_lutpair14";
  attribute SOFT_HLUTNM of \vfb_vcdt[9]_i_3\ : label is "soft_lutpair15";
begin
  \buf_data_reg[0][73]_1\(9 downto 0) <= \^buf_data_reg[0][73]_1\(9 downto 0);
  sband_tact0 <= \^sband_tact0\;
  sband_tl <= \^sband_tl\;
  sdt_tv <= \^sdt_tv\;
\buf_data[0][0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \buf_data_reg[1]\(0),
      I1 => p_0_in,
      I2 => cur_dtype_pxls1,
      I3 => \buf_data_reg[1][136]_0\(0),
      O => p_2_in(0)
    );
\buf_data[0][101]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \buf_data_reg[1]\(101),
      I1 => p_0_in,
      I2 => cur_dtype_pxls1,
      I3 => \buf_data_reg[1][136]_0\(11),
      O => p_2_in(101)
    );
\buf_data[0][102]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \buf_data_reg[1]\(102),
      I1 => p_0_in,
      I2 => cur_dtype_pxls1,
      I3 => \buf_data_reg[1][136]_0\(12),
      O => p_2_in(102)
    );
\buf_data[0][103]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \buf_data_reg[1]\(103),
      I1 => p_0_in,
      I2 => cur_dtype_pxls1,
      I3 => \buf_data_reg[1][136]_0\(13),
      O => p_2_in(103)
    );
\buf_data[0][104]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \buf_data_reg[1]\(104),
      I1 => p_0_in,
      I2 => cur_dtype_pxls1,
      I3 => \buf_data_reg[1][136]_0\(14),
      O => p_2_in(104)
    );
\buf_data[0][105]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \buf_data_reg[1]\(105),
      I1 => p_0_in,
      I2 => cur_dtype_pxls1,
      I3 => \buf_data_reg[1][136]_0\(15),
      O => p_2_in(105)
    );
\buf_data[0][106]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \buf_data_reg[1]\(106),
      I1 => p_0_in,
      I2 => cur_dtype_pxls1,
      I3 => \buf_data_reg[1][136]_0\(16),
      O => p_2_in(106)
    );
\buf_data[0][107]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \buf_data_reg[1]\(107),
      I1 => p_0_in,
      I2 => cur_dtype_pxls1,
      I3 => \buf_data_reg[1][136]_0\(17),
      O => p_2_in(107)
    );
\buf_data[0][108]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \buf_data_reg[1]\(108),
      I1 => p_0_in,
      I2 => cur_dtype_pxls1,
      I3 => \buf_data_reg[1][136]_0\(18),
      O => p_2_in(108)
    );
\buf_data[0][109]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \buf_data_reg[1]\(109),
      I1 => p_0_in,
      I2 => cur_dtype_pxls1,
      I3 => \buf_data_reg[1][136]_0\(19),
      O => p_2_in(109)
    );
\buf_data[0][110]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \buf_data_reg[1]\(110),
      I1 => p_0_in,
      I2 => cur_dtype_pxls1,
      I3 => \buf_data_reg[1][136]_0\(20),
      O => p_2_in(110)
    );
\buf_data[0][111]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \buf_data_reg[1]\(111),
      I1 => p_0_in,
      I2 => cur_dtype_pxls1,
      I3 => \buf_data_reg[1][136]_0\(21),
      O => p_2_in(111)
    );
\buf_data[0][112]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \buf_data_reg[1]\(112),
      I1 => p_0_in,
      I2 => cur_dtype_pxls1,
      I3 => \buf_data_reg[1][136]_0\(22),
      O => p_2_in(112)
    );
\buf_data[0][113]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \buf_data_reg[1]\(113),
      I1 => p_0_in,
      I2 => cur_dtype_pxls1,
      I3 => \buf_data_reg[1][136]_0\(23),
      O => p_2_in(113)
    );
\buf_data[0][114]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \buf_data_reg[1]\(114),
      I1 => p_0_in,
      I2 => cur_dtype_pxls1,
      I3 => \buf_data_reg[1][136]_0\(24),
      O => p_2_in(114)
    );
\buf_data[0][115]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \buf_data_reg[1]\(115),
      I1 => p_0_in,
      I2 => cur_dtype_pxls1,
      I3 => \buf_data_reg[1][136]_0\(25),
      O => p_2_in(115)
    );
\buf_data[0][116]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \buf_data_reg[1]\(116),
      I1 => p_0_in,
      I2 => cur_dtype_pxls1,
      I3 => \buf_data_reg[1][136]_0\(26),
      O => p_2_in(116)
    );
\buf_data[0][117]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \buf_data_reg[1]\(117),
      I1 => p_0_in,
      I2 => cur_dtype_pxls1,
      I3 => \buf_data_reg[1][136]_0\(27),
      O => p_2_in(117)
    );
\buf_data[0][118]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \buf_data_reg[1]\(118),
      I1 => p_0_in,
      I2 => cur_dtype_pxls1,
      I3 => \buf_data_reg[1][136]_0\(28),
      O => p_2_in(118)
    );
\buf_data[0][119]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \buf_data_reg[1]\(119),
      I1 => p_0_in,
      I2 => cur_dtype_pxls1,
      I3 => \buf_data_reg[1][136]_0\(29),
      O => p_2_in(119)
    );
\buf_data[0][120]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \buf_data_reg[1]\(120),
      I1 => p_0_in,
      I2 => cur_dtype_pxls1,
      I3 => \buf_data_reg[1][136]_0\(30),
      O => p_2_in(120)
    );
\buf_data[0][121]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \buf_data_reg[1]\(121),
      I1 => p_0_in,
      I2 => cur_dtype_pxls1,
      I3 => \buf_data_reg[1][136]_0\(31),
      O => p_2_in(121)
    );
\buf_data[0][122]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \buf_data_reg[1]\(122),
      I1 => p_0_in,
      I2 => cur_dtype_pxls1,
      I3 => \buf_data_reg[1][136]_0\(32),
      O => p_2_in(122)
    );
\buf_data[0][123]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \buf_data_reg[1]\(123),
      I1 => p_0_in,
      I2 => cur_dtype_pxls1,
      I3 => \buf_data_reg[1][136]_0\(33),
      O => p_2_in(123)
    );
\buf_data[0][124]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \buf_data_reg[1]\(124),
      I1 => p_0_in,
      I2 => cur_dtype_pxls1,
      I3 => \buf_data_reg[1][136]_0\(34),
      O => p_2_in(124)
    );
\buf_data[0][125]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \buf_data_reg[1]\(125),
      I1 => p_0_in,
      I2 => cur_dtype_pxls1,
      I3 => \buf_data_reg[1][136]_0\(35),
      O => p_2_in(125)
    );
\buf_data[0][126]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \buf_data_reg[1]\(126),
      I1 => p_0_in,
      I2 => cur_dtype_pxls1,
      I3 => \buf_data_reg[1][136]_0\(36),
      O => p_2_in(126)
    );
\buf_data[0][127]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \buf_data_reg[1]\(127),
      I1 => p_0_in,
      I2 => cur_dtype_pxls1,
      I3 => \buf_data_reg[1][136]_0\(37),
      O => p_2_in(127)
    );
\buf_data[0][128]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \buf_data_reg[1]\(128),
      I1 => p_0_in,
      I2 => cur_dtype_pxls1,
      I3 => \buf_data_reg[1][136]_0\(38),
      O => p_2_in(128)
    );
\buf_data[0][129]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \buf_data_reg[1]\(129),
      I1 => p_0_in,
      I2 => cur_dtype_pxls1,
      I3 => \buf_data_reg[1][136]_0\(39),
      O => p_2_in(129)
    );
\buf_data[0][130]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \buf_data_reg[1]\(130),
      I1 => p_0_in,
      I2 => cur_dtype_pxls1,
      I3 => \buf_data_reg[1][136]_0\(40),
      O => p_2_in(130)
    );
\buf_data[0][131]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \buf_data_reg[1]\(131),
      I1 => p_0_in,
      I2 => cur_dtype_pxls1,
      I3 => \buf_data_reg[1][136]_0\(41),
      O => p_2_in(131)
    );
\buf_data[0][132]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \buf_data_reg[1]\(132),
      I1 => p_0_in,
      I2 => cur_dtype_pxls1,
      I3 => \buf_data_reg[1][136]_0\(42),
      O => p_2_in(132)
    );
\buf_data[0][133]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \buf_data_reg[1]\(133),
      I1 => p_0_in,
      I2 => cur_dtype_pxls1,
      I3 => \buf_data_reg[1][136]_0\(43),
      O => p_2_in(133)
    );
\buf_data[0][134]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \buf_data_reg[1]\(134),
      I1 => p_0_in,
      I2 => cur_dtype_pxls1,
      I3 => \buf_data_reg[1][136]_0\(44),
      O => p_2_in(134)
    );
\buf_data[0][135]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \buf_data_reg[1]\(135),
      I1 => p_0_in,
      I2 => cur_dtype_pxls1,
      I3 => \buf_data_reg[1][136]_0\(45),
      O => p_2_in(135)
    );
\buf_data[0][136]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"A8B8"
    )
        port map (
      I0 => cur_dtype_pxls1,
      I1 => p_0_in,
      I2 => s_axis_tvalid,
      I3 => \buf_valid_reg_n_0_[0]\,
      O => \buf_data[0][136]_i_1_n_0\
    );
\buf_data[0][136]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \buf_data_reg[1]\(136),
      I1 => p_0_in,
      I2 => cur_dtype_pxls1,
      I3 => \buf_data_reg[1][136]_0\(46),
      O => p_2_in(136)
    );
\buf_data[0][1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \buf_data_reg[1]\(1),
      I1 => p_0_in,
      I2 => cur_dtype_pxls1,
      I3 => \buf_data_reg[1][136]_0\(1),
      O => p_2_in(1)
    );
\buf_data[0][2]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \buf_data_reg[1]\(2),
      I1 => p_0_in,
      I2 => cur_dtype_pxls1,
      I3 => \buf_data_reg[1][136]_0\(2),
      O => p_2_in(2)
    );
\buf_data[0][3]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \buf_data_reg[1]\(3),
      I1 => p_0_in,
      I2 => cur_dtype_pxls1,
      I3 => \buf_data_reg[1][136]_0\(3),
      O => p_2_in(3)
    );
\buf_data[0][4]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \buf_data_reg[1]\(4),
      I1 => p_0_in,
      I2 => cur_dtype_pxls1,
      I3 => \buf_data_reg[1][136]_0\(4),
      O => p_2_in(4)
    );
\buf_data[0][68]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \buf_data_reg[1]\(68),
      I1 => p_0_in,
      I2 => cur_dtype_pxls1,
      I3 => \buf_data_reg[1][136]_0\(5),
      O => p_2_in(68)
    );
\buf_data[0][69]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \buf_data_reg[1]\(69),
      I1 => p_0_in,
      I2 => cur_dtype_pxls1,
      I3 => \buf_data_reg[1][136]_0\(6),
      O => p_2_in(69)
    );
\buf_data[0][70]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \buf_data_reg[1]\(70),
      I1 => p_0_in,
      I2 => cur_dtype_pxls1,
      I3 => \buf_data_reg[1][136]_0\(7),
      O => p_2_in(70)
    );
\buf_data[0][71]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \buf_data_reg[1]\(71),
      I1 => p_0_in,
      I2 => cur_dtype_pxls1,
      I3 => \buf_data_reg[1][136]_0\(8),
      O => p_2_in(71)
    );
\buf_data[0][72]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \buf_data_reg[1]\(72),
      I1 => p_0_in,
      I2 => cur_dtype_pxls1,
      I3 => \buf_data_reg[1][136]_0\(9),
      O => p_2_in(72)
    );
\buf_data[0][73]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BF80"
    )
        port map (
      I0 => \buf_data_reg[1]\(73),
      I1 => p_0_in,
      I2 => cur_dtype_pxls1,
      I3 => \buf_data_reg[1][136]_0\(10),
      O => p_2_in(73)
    );
\buf_data[1][136]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => s_axis_aresetn,
      O => \buf_data[1][136]_i_1_n_0\
    );
\buf_data[1][136]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0040"
    )
        port map (
      I0 => p_0_in,
      I1 => s_axis_tvalid,
      I2 => \buf_valid_reg_n_0_[0]\,
      I3 => cur_dtype_pxls1,
      O => \buf_data[1][136]_i_2_n_0\
    );
\buf_data_reg[0][0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[0][136]_i_1_n_0\,
      D => p_2_in(0),
      Q => \^buf_data_reg[0][73]_1\(0),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[0][101]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[0][136]_i_1_n_0\,
      D => p_2_in(101),
      Q => sband_tk(1),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[0][102]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[0][136]_i_1_n_0\,
      D => p_2_in(102),
      Q => sband_tk(2),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[0][103]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[0][136]_i_1_n_0\,
      D => p_2_in(103),
      Q => sband_tk(3),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[0][104]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[0][136]_i_1_n_0\,
      D => p_2_in(104),
      Q => \s_axis_tdata__0\(0),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[0][105]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[0][136]_i_1_n_0\,
      D => p_2_in(105),
      Q => \s_axis_tdata__0\(1),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[0][106]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[0][136]_i_1_n_0\,
      D => p_2_in(106),
      Q => \s_axis_tdata__0\(2),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[0][107]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[0][136]_i_1_n_0\,
      D => p_2_in(107),
      Q => \s_axis_tdata__0\(3),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[0][108]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[0][136]_i_1_n_0\,
      D => p_2_in(108),
      Q => \s_axis_tdata__0\(4),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[0][109]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[0][136]_i_1_n_0\,
      D => p_2_in(109),
      Q => \s_axis_tdata__0\(5),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[0][110]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[0][136]_i_1_n_0\,
      D => p_2_in(110),
      Q => \s_axis_tdata__0\(6),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[0][111]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[0][136]_i_1_n_0\,
      D => p_2_in(111),
      Q => \s_axis_tdata__0\(7),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[0][112]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[0][136]_i_1_n_0\,
      D => p_2_in(112),
      Q => \s_axis_tdata__0\(8),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[0][113]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[0][136]_i_1_n_0\,
      D => p_2_in(113),
      Q => \s_axis_tdata__0\(9),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[0][114]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[0][136]_i_1_n_0\,
      D => p_2_in(114),
      Q => \s_axis_tdata__0\(10),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[0][115]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[0][136]_i_1_n_0\,
      D => p_2_in(115),
      Q => \s_axis_tdata__0\(11),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[0][116]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[0][136]_i_1_n_0\,
      D => p_2_in(116),
      Q => \s_axis_tdata__0\(12),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[0][117]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[0][136]_i_1_n_0\,
      D => p_2_in(117),
      Q => \s_axis_tdata__0\(13),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[0][118]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[0][136]_i_1_n_0\,
      D => p_2_in(118),
      Q => \s_axis_tdata__0\(14),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[0][119]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[0][136]_i_1_n_0\,
      D => p_2_in(119),
      Q => \s_axis_tdata__0\(15),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[0][120]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[0][136]_i_1_n_0\,
      D => p_2_in(120),
      Q => \s_axis_tdata__0\(16),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[0][121]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[0][136]_i_1_n_0\,
      D => p_2_in(121),
      Q => \s_axis_tdata__0\(17),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[0][122]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[0][136]_i_1_n_0\,
      D => p_2_in(122),
      Q => \s_axis_tdata__0\(18),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[0][123]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[0][136]_i_1_n_0\,
      D => p_2_in(123),
      Q => \s_axis_tdata__0\(19),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[0][124]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[0][136]_i_1_n_0\,
      D => p_2_in(124),
      Q => \s_axis_tdata__0\(20),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[0][125]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[0][136]_i_1_n_0\,
      D => p_2_in(125),
      Q => \s_axis_tdata__0\(21),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[0][126]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[0][136]_i_1_n_0\,
      D => p_2_in(126),
      Q => \s_axis_tdata__0\(22),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[0][127]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[0][136]_i_1_n_0\,
      D => p_2_in(127),
      Q => \s_axis_tdata__0\(23),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[0][128]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[0][136]_i_1_n_0\,
      D => p_2_in(128),
      Q => \s_axis_tdata__0\(24),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[0][129]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[0][136]_i_1_n_0\,
      D => p_2_in(129),
      Q => \s_axis_tdata__0\(25),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[0][130]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[0][136]_i_1_n_0\,
      D => p_2_in(130),
      Q => \s_axis_tdata__0\(26),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[0][131]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[0][136]_i_1_n_0\,
      D => p_2_in(131),
      Q => \s_axis_tdata__0\(27),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[0][132]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[0][136]_i_1_n_0\,
      D => p_2_in(132),
      Q => \s_axis_tdata__0\(28),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[0][133]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[0][136]_i_1_n_0\,
      D => p_2_in(133),
      Q => \s_axis_tdata__0\(29),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[0][134]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[0][136]_i_1_n_0\,
      D => p_2_in(134),
      Q => \s_axis_tdata__0\(30),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[0][135]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[0][136]_i_1_n_0\,
      D => p_2_in(135),
      Q => \s_axis_tdata__0\(31),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[0][136]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[0][136]_i_1_n_0\,
      D => p_2_in(136),
      Q => s_axis_tlast,
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[0][1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[0][136]_i_1_n_0\,
      D => p_2_in(1),
      Q => \^buf_data_reg[0][73]_1\(1),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[0][2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[0][136]_i_1_n_0\,
      D => p_2_in(2),
      Q => \^buf_data_reg[0][73]_1\(2),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[0][3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[0][136]_i_1_n_0\,
      D => p_2_in(3),
      Q => \^buf_data_reg[0][73]_1\(3),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[0][4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[0][136]_i_1_n_0\,
      D => p_2_in(4),
      Q => \buf_data_reg_n_0_[0][4]\,
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[0][68]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[0][136]_i_1_n_0\,
      D => p_2_in(68),
      Q => \^buf_data_reg[0][73]_1\(4),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[0][69]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[0][136]_i_1_n_0\,
      D => p_2_in(69),
      Q => \^buf_data_reg[0][73]_1\(5),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[0][70]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[0][136]_i_1_n_0\,
      D => p_2_in(70),
      Q => \^buf_data_reg[0][73]_1\(6),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[0][71]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[0][136]_i_1_n_0\,
      D => p_2_in(71),
      Q => \^buf_data_reg[0][73]_1\(7),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[0][72]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[0][136]_i_1_n_0\,
      D => p_2_in(72),
      Q => \^buf_data_reg[0][73]_1\(8),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[0][73]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[0][136]_i_1_n_0\,
      D => p_2_in(73),
      Q => \^buf_data_reg[0][73]_1\(9),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[1][0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[1][136]_i_2_n_0\,
      D => \buf_data_reg[1][136]_0\(0),
      Q => \buf_data_reg[1]\(0),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[1][101]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[1][136]_i_2_n_0\,
      D => \buf_data_reg[1][136]_0\(11),
      Q => \buf_data_reg[1]\(101),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[1][102]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[1][136]_i_2_n_0\,
      D => \buf_data_reg[1][136]_0\(12),
      Q => \buf_data_reg[1]\(102),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[1][103]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[1][136]_i_2_n_0\,
      D => \buf_data_reg[1][136]_0\(13),
      Q => \buf_data_reg[1]\(103),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[1][104]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[1][136]_i_2_n_0\,
      D => \buf_data_reg[1][136]_0\(14),
      Q => \buf_data_reg[1]\(104),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[1][105]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[1][136]_i_2_n_0\,
      D => \buf_data_reg[1][136]_0\(15),
      Q => \buf_data_reg[1]\(105),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[1][106]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[1][136]_i_2_n_0\,
      D => \buf_data_reg[1][136]_0\(16),
      Q => \buf_data_reg[1]\(106),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[1][107]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[1][136]_i_2_n_0\,
      D => \buf_data_reg[1][136]_0\(17),
      Q => \buf_data_reg[1]\(107),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[1][108]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[1][136]_i_2_n_0\,
      D => \buf_data_reg[1][136]_0\(18),
      Q => \buf_data_reg[1]\(108),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[1][109]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[1][136]_i_2_n_0\,
      D => \buf_data_reg[1][136]_0\(19),
      Q => \buf_data_reg[1]\(109),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[1][110]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[1][136]_i_2_n_0\,
      D => \buf_data_reg[1][136]_0\(20),
      Q => \buf_data_reg[1]\(110),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[1][111]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[1][136]_i_2_n_0\,
      D => \buf_data_reg[1][136]_0\(21),
      Q => \buf_data_reg[1]\(111),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[1][112]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[1][136]_i_2_n_0\,
      D => \buf_data_reg[1][136]_0\(22),
      Q => \buf_data_reg[1]\(112),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[1][113]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[1][136]_i_2_n_0\,
      D => \buf_data_reg[1][136]_0\(23),
      Q => \buf_data_reg[1]\(113),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[1][114]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[1][136]_i_2_n_0\,
      D => \buf_data_reg[1][136]_0\(24),
      Q => \buf_data_reg[1]\(114),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[1][115]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[1][136]_i_2_n_0\,
      D => \buf_data_reg[1][136]_0\(25),
      Q => \buf_data_reg[1]\(115),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[1][116]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[1][136]_i_2_n_0\,
      D => \buf_data_reg[1][136]_0\(26),
      Q => \buf_data_reg[1]\(116),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[1][117]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[1][136]_i_2_n_0\,
      D => \buf_data_reg[1][136]_0\(27),
      Q => \buf_data_reg[1]\(117),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[1][118]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[1][136]_i_2_n_0\,
      D => \buf_data_reg[1][136]_0\(28),
      Q => \buf_data_reg[1]\(118),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[1][119]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[1][136]_i_2_n_0\,
      D => \buf_data_reg[1][136]_0\(29),
      Q => \buf_data_reg[1]\(119),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[1][120]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[1][136]_i_2_n_0\,
      D => \buf_data_reg[1][136]_0\(30),
      Q => \buf_data_reg[1]\(120),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[1][121]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[1][136]_i_2_n_0\,
      D => \buf_data_reg[1][136]_0\(31),
      Q => \buf_data_reg[1]\(121),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[1][122]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[1][136]_i_2_n_0\,
      D => \buf_data_reg[1][136]_0\(32),
      Q => \buf_data_reg[1]\(122),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[1][123]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[1][136]_i_2_n_0\,
      D => \buf_data_reg[1][136]_0\(33),
      Q => \buf_data_reg[1]\(123),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[1][124]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[1][136]_i_2_n_0\,
      D => \buf_data_reg[1][136]_0\(34),
      Q => \buf_data_reg[1]\(124),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[1][125]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[1][136]_i_2_n_0\,
      D => \buf_data_reg[1][136]_0\(35),
      Q => \buf_data_reg[1]\(125),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[1][126]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[1][136]_i_2_n_0\,
      D => \buf_data_reg[1][136]_0\(36),
      Q => \buf_data_reg[1]\(126),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[1][127]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[1][136]_i_2_n_0\,
      D => \buf_data_reg[1][136]_0\(37),
      Q => \buf_data_reg[1]\(127),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[1][128]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[1][136]_i_2_n_0\,
      D => \buf_data_reg[1][136]_0\(38),
      Q => \buf_data_reg[1]\(128),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[1][129]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[1][136]_i_2_n_0\,
      D => \buf_data_reg[1][136]_0\(39),
      Q => \buf_data_reg[1]\(129),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[1][130]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[1][136]_i_2_n_0\,
      D => \buf_data_reg[1][136]_0\(40),
      Q => \buf_data_reg[1]\(130),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[1][131]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[1][136]_i_2_n_0\,
      D => \buf_data_reg[1][136]_0\(41),
      Q => \buf_data_reg[1]\(131),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[1][132]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[1][136]_i_2_n_0\,
      D => \buf_data_reg[1][136]_0\(42),
      Q => \buf_data_reg[1]\(132),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[1][133]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[1][136]_i_2_n_0\,
      D => \buf_data_reg[1][136]_0\(43),
      Q => \buf_data_reg[1]\(133),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[1][134]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[1][136]_i_2_n_0\,
      D => \buf_data_reg[1][136]_0\(44),
      Q => \buf_data_reg[1]\(134),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[1][135]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[1][136]_i_2_n_0\,
      D => \buf_data_reg[1][136]_0\(45),
      Q => \buf_data_reg[1]\(135),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[1][136]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[1][136]_i_2_n_0\,
      D => \buf_data_reg[1][136]_0\(46),
      Q => \buf_data_reg[1]\(136),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[1][1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[1][136]_i_2_n_0\,
      D => \buf_data_reg[1][136]_0\(1),
      Q => \buf_data_reg[1]\(1),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[1][2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[1][136]_i_2_n_0\,
      D => \buf_data_reg[1][136]_0\(2),
      Q => \buf_data_reg[1]\(2),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[1][3]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[1][136]_i_2_n_0\,
      D => \buf_data_reg[1][136]_0\(3),
      Q => \buf_data_reg[1]\(3),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[1][4]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[1][136]_i_2_n_0\,
      D => \buf_data_reg[1][136]_0\(4),
      Q => \buf_data_reg[1]\(4),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[1][68]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[1][136]_i_2_n_0\,
      D => \buf_data_reg[1][136]_0\(5),
      Q => \buf_data_reg[1]\(68),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[1][69]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[1][136]_i_2_n_0\,
      D => \buf_data_reg[1][136]_0\(6),
      Q => \buf_data_reg[1]\(69),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[1][70]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[1][136]_i_2_n_0\,
      D => \buf_data_reg[1][136]_0\(7),
      Q => \buf_data_reg[1]\(70),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[1][71]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[1][136]_i_2_n_0\,
      D => \buf_data_reg[1][136]_0\(8),
      Q => \buf_data_reg[1]\(71),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[1][72]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[1][136]_i_2_n_0\,
      D => \buf_data_reg[1][136]_0\(9),
      Q => \buf_data_reg[1]\(72),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_data_reg[1][73]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => \buf_data[1][136]_i_2_n_0\,
      D => \buf_data_reg[1][136]_0\(10),
      Q => \buf_data_reg[1]\(73),
      R => \buf_data[1][136]_i_1_n_0\
    );
\buf_valid[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FCAE0000"
    )
        port map (
      I0 => \buf_valid_reg_n_0_[0]\,
      I1 => s_axis_tvalid,
      I2 => p_0_in,
      I3 => cur_dtype_pxls1,
      I4 => s_axis_aresetn,
      O => \buf_valid[0]_i_1_n_0\
    );
\buf_valid[1]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00EA0000"
    )
        port map (
      I0 => p_0_in,
      I1 => s_axis_tvalid,
      I2 => \buf_valid_reg_n_0_[0]\,
      I3 => cur_dtype_pxls1,
      I4 => s_axis_aresetn,
      O => \buf_valid[1]_i_1_n_0\
    );
\buf_valid[1]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFF202200000000"
    )
        port map (
      I0 => cur_dtype_udef,
      I1 => sband_tl_r_reg_0,
      I2 => sband_tact021_out,
      I3 => \sband_tk_r_reg[2]\,
      I4 => cur_dtype_sink_reg_n_0,
      I5 => \buf_valid_reg_n_0_[0]\,
      O => cur_dtype_pxls1
    );
\buf_valid_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => '1',
      D => \buf_valid[0]_i_1_n_0\,
      Q => \buf_valid_reg_n_0_[0]\,
      R => '0'
    );
\buf_valid_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => '1',
      D => \buf_valid[1]_i_1_n_0\,
      Q => p_0_in,
      R => '0'
    );
cur_dtype_sink_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0000AABA"
    )
        port map (
      I0 => cur_dtype_sink_reg_n_0,
      I1 => main_dtvc,
      I2 => \buf_valid_reg_n_0_[0]\,
      I3 => sban_dtvc,
      I4 => cur_dtype_sink_i_3_n_0,
      O => cur_dtype_sink_i_1_n_0
    );
cur_dtype_sink_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0100000000000000"
    )
        port map (
      I0 => \^buf_data_reg[0][73]_1\(8),
      I1 => \^buf_data_reg[0][73]_1\(4),
      I2 => \^buf_data_reg[0][73]_1\(6),
      I3 => \^buf_data_reg[0][73]_1\(9),
      I4 => \^buf_data_reg[0][73]_1\(5),
      I5 => \^buf_data_reg[0][73]_1\(7),
      O => main_dtvc
    );
cur_dtype_sink_i_3: unisim.vcomponents.LUT3
    generic map(
      INIT => X"8F"
    )
        port map (
      I0 => cur_dtype_pxls1,
      I1 => s_axis_tlast,
      I2 => s_axis_aresetn,
      O => cur_dtype_sink_i_3_n_0
    );
cur_dtype_sink_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => '1',
      D => cur_dtype_sink_i_1_n_0,
      Q => cur_dtype_sink_reg_n_0,
      R => '0'
    );
cur_dtype_udef_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000EA00EA00EA00"
    )
        port map (
      I0 => cur_dtype_udef,
      I1 => \buf_valid_reg_n_0_[0]\,
      I2 => sban_dtvc,
      I3 => s_axis_aresetn,
      I4 => s_axis_tlast,
      I5 => cur_dtype_pxls1,
      O => cur_dtype_udef_i_1_n_0
    );
cur_dtype_udef_reg: unisim.vcomponents.FDRE
     port map (
      C => s_axis_aclk,
      CE => '1',
      D => cur_dtype_udef_i_1_n_0,
      Q => cur_dtype_udef,
      R => '0'
    );
s_axis_tready_INST_0: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => p_0_in,
      O => s_axis_tready
    );
\sband_td_r[0]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \s_axis_tdata__0\(8),
      I1 => \^sband_tact0\,
      I2 => \sband_td_r_reg[15]\(8),
      O => \buf_data_reg[0][135]_0\(0)
    );
\sband_td_r[10]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \s_axis_tdata__0\(18),
      I1 => \^sband_tact0\,
      I2 => \sband_td_r_reg[15]\(18),
      O => \buf_data_reg[0][135]_0\(10)
    );
\sband_td_r[11]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \s_axis_tdata__0\(19),
      I1 => \^sband_tact0\,
      I2 => \sband_td_r_reg[15]\(19),
      O => \buf_data_reg[0][135]_0\(11)
    );
\sband_td_r[12]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \s_axis_tdata__0\(20),
      I1 => \^sband_tact0\,
      I2 => \sband_td_r_reg[15]\(20),
      O => \buf_data_reg[0][135]_0\(12)
    );
\sband_td_r[13]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \s_axis_tdata__0\(21),
      I1 => \^sband_tact0\,
      I2 => \sband_td_r_reg[15]\(21),
      O => \buf_data_reg[0][135]_0\(13)
    );
\sband_td_r[14]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \s_axis_tdata__0\(22),
      I1 => \^sband_tact0\,
      I2 => \sband_td_r_reg[15]\(22),
      O => \buf_data_reg[0][135]_0\(14)
    );
\sband_td_r[15]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \s_axis_tdata__0\(23),
      I1 => \^sband_tact0\,
      I2 => \sband_td_r_reg[15]\(23),
      O => \buf_data_reg[0][135]_0\(15)
    );
\sband_td_r[16]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \^sband_tact0\,
      I1 => \s_axis_tdata__0\(24),
      O => \buf_data_reg[0][135]_0\(16)
    );
\sband_td_r[17]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \^sband_tact0\,
      I1 => \s_axis_tdata__0\(25),
      O => \buf_data_reg[0][135]_0\(17)
    );
\sband_td_r[18]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \^sband_tact0\,
      I1 => \s_axis_tdata__0\(26),
      O => \buf_data_reg[0][135]_0\(18)
    );
\sband_td_r[19]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \^sband_tact0\,
      I1 => \s_axis_tdata__0\(27),
      O => \buf_data_reg[0][135]_0\(19)
    );
\sband_td_r[1]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \s_axis_tdata__0\(9),
      I1 => \^sband_tact0\,
      I2 => \sband_td_r_reg[15]\(9),
      O => \buf_data_reg[0][135]_0\(1)
    );
\sband_td_r[20]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \^sband_tact0\,
      I1 => \s_axis_tdata__0\(28),
      O => \buf_data_reg[0][135]_0\(20)
    );
\sband_td_r[21]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \^sband_tact0\,
      I1 => \s_axis_tdata__0\(29),
      O => \buf_data_reg[0][135]_0\(21)
    );
\sband_td_r[22]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \^sband_tact0\,
      I1 => \s_axis_tdata__0\(30),
      O => \buf_data_reg[0][135]_0\(22)
    );
\sband_td_r[23]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \^sband_tact0\,
      I1 => \s_axis_tdata__0\(31),
      O => \buf_data_reg[0][135]_0\(23)
    );
\sband_td_r[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \s_axis_tdata__0\(10),
      I1 => \^sband_tact0\,
      I2 => \sband_td_r_reg[15]\(10),
      O => \buf_data_reg[0][135]_0\(2)
    );
\sband_td_r[3]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \s_axis_tdata__0\(11),
      I1 => \^sband_tact0\,
      I2 => \sband_td_r_reg[15]\(11),
      O => \buf_data_reg[0][135]_0\(3)
    );
\sband_td_r[4]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \s_axis_tdata__0\(12),
      I1 => \^sband_tact0\,
      I2 => \sband_td_r_reg[15]\(12),
      O => \buf_data_reg[0][135]_0\(4)
    );
\sband_td_r[5]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \s_axis_tdata__0\(13),
      I1 => \^sband_tact0\,
      I2 => \sband_td_r_reg[15]\(13),
      O => \buf_data_reg[0][135]_0\(5)
    );
\sband_td_r[6]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \s_axis_tdata__0\(14),
      I1 => \^sband_tact0\,
      I2 => \sband_td_r_reg[15]\(14),
      O => \buf_data_reg[0][135]_0\(6)
    );
\sband_td_r[7]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \s_axis_tdata__0\(15),
      I1 => \^sband_tact0\,
      I2 => \sband_td_r_reg[15]\(15),
      O => \buf_data_reg[0][135]_0\(7)
    );
\sband_td_r[8]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \s_axis_tdata__0\(16),
      I1 => \^sband_tact0\,
      I2 => \sband_td_r_reg[15]\(16),
      O => \buf_data_reg[0][135]_0\(8)
    );
\sband_td_r[9]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \s_axis_tdata__0\(17),
      I1 => \^sband_tact0\,
      I2 => \sband_td_r_reg[15]\(17),
      O => \buf_data_reg[0][135]_0\(9)
    );
\sband_tk_r[1]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => sband_tk(2),
      I1 => \^sband_tact0\,
      I2 => Q(1),
      O => \buf_data_reg[0][103]_0\(0)
    );
\sband_tk_r[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"EA"
    )
        port map (
      I0 => \^sband_tact0\,
      I1 => vfb_ready,
      I2 => \sband_tk_r_reg[2]\,
      O => E(0)
    );
\sband_tk_r[2]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \^sband_tact0\,
      I1 => sband_tk(3),
      O => \buf_data_reg[0][103]_0\(1)
    );
sband_tl_r_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0080000000800080"
    )
        port map (
      I0 => cur_dtype_udef,
      I1 => \buf_valid_reg_n_0_[0]\,
      I2 => sban_dtvc,
      I3 => sband_tl_r_reg_0,
      I4 => sband_tact021_out,
      I5 => \sband_tk_r_reg[2]\,
      O => \^sband_tact0\
    );
sband_tl_r_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8080888080808080"
    )
        port map (
      I0 => s_axis_tlast,
      I1 => \buf_valid_reg_n_0_[0]\,
      I2 => cur_dtype_sink_reg_n_0,
      I3 => sband_tl_r_reg,
      I4 => sband_tl_r_reg_0,
      I5 => cur_dtype_udef,
      O => \^sband_tl\
    );
\sband_tu_r[0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"A800"
    )
        port map (
      I0 => \buf_data_reg_n_0_[0][4]\,
      I1 => cur_dtype_sink_reg_n_0,
      I2 => sdt_tr,
      I3 => \^sdt_tv\,
      O => sband_tu
    );
sdt_tv_INST_0: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => sban_dtvc,
      I1 => \buf_valid_reg_n_0_[0]\,
      I2 => cur_dtype_udef,
      O => \^sdt_tv\
    );
sdt_tv_INST_0_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5050505000000080"
    )
        port map (
      I0 => \^buf_data_reg[0][73]_1\(7),
      I1 => \^buf_data_reg[0][73]_1\(5),
      I2 => \^buf_data_reg[0][73]_1\(9),
      I3 => \^buf_data_reg[0][73]_1\(6),
      I4 => \^buf_data_reg[0][73]_1\(4),
      I5 => \^buf_data_reg[0][73]_1\(8),
      O => sban_dtvc
    );
\vfb_data[0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => \s_axis_tdata__0\(0),
      I1 => \^sband_tact0\,
      I2 => \vfb_valid0__0\,
      I3 => \sband_td_r_reg[15]\(0),
      O => D(0)
    );
\vfb_data[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => \s_axis_tdata__0\(1),
      I1 => \^sband_tact0\,
      I2 => \vfb_valid0__0\,
      I3 => \sband_td_r_reg[15]\(1),
      O => D(1)
    );
\vfb_data[2]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => \s_axis_tdata__0\(2),
      I1 => \^sband_tact0\,
      I2 => \vfb_valid0__0\,
      I3 => \sband_td_r_reg[15]\(2),
      O => D(2)
    );
\vfb_data[3]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => \s_axis_tdata__0\(3),
      I1 => \^sband_tact0\,
      I2 => \vfb_valid0__0\,
      I3 => \sband_td_r_reg[15]\(3),
      O => D(3)
    );
\vfb_data[4]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => \s_axis_tdata__0\(4),
      I1 => \^sband_tact0\,
      I2 => \vfb_valid0__0\,
      I3 => \sband_td_r_reg[15]\(4),
      O => D(4)
    );
\vfb_data[5]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => \s_axis_tdata__0\(5),
      I1 => \^sband_tact0\,
      I2 => \vfb_valid0__0\,
      I3 => \sband_td_r_reg[15]\(5),
      O => D(5)
    );
\vfb_data[6]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => \s_axis_tdata__0\(6),
      I1 => \^sband_tact0\,
      I2 => \vfb_valid0__0\,
      I3 => \sband_td_r_reg[15]\(6),
      O => D(6)
    );
\vfb_data[7]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B888"
    )
        port map (
      I0 => \s_axis_tdata__0\(7),
      I1 => \^sband_tact0\,
      I2 => \vfb_valid0__0\,
      I3 => \sband_td_r_reg[15]\(7),
      O => D(7)
    );
vfb_eol_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"20202F2020202020"
    )
        port map (
      I0 => \^sband_tl\,
      I1 => sband_tk(1),
      I2 => \^sband_tact0\,
      I3 => \vfb_valid0__0\,
      I4 => Q(0),
      I5 => sband_tl_r,
      O => \buf_data_reg[0][101]_0\
    );
\vfb_sof[0]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"A8FFFFFFA8000000"
    )
        port map (
      I0 => \buf_data_reg_n_0_[0][4]\,
      I1 => cur_dtype_sink_reg_n_0,
      I2 => cur_dtype_udef,
      I3 => \^sdt_tv\,
      I4 => sdt_tr,
      I5 => sband_tu_r,
      O => \buf_data_reg[0][4]_0\
    );
\vfb_vcdt[0]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \^buf_data_reg[0][73]_1\(0),
      I1 => \^sband_tact0\,
      I2 => \vfb_vcdt_reg[9]\(0),
      O => \buf_data_reg[0][73]_0\(0)
    );
\vfb_vcdt[1]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \^buf_data_reg[0][73]_1\(1),
      I1 => \^sband_tact0\,
      I2 => \vfb_vcdt_reg[9]\(1),
      O => \buf_data_reg[0][73]_0\(1)
    );
\vfb_vcdt[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \^buf_data_reg[0][73]_1\(2),
      I1 => \^sband_tact0\,
      I2 => \vfb_vcdt_reg[9]\(2),
      O => \buf_data_reg[0][73]_0\(2)
    );
\vfb_vcdt[3]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \^buf_data_reg[0][73]_1\(3),
      I1 => \^sband_tact0\,
      I2 => \vfb_vcdt_reg[9]\(3),
      O => \buf_data_reg[0][73]_0\(3)
    );
\vfb_vcdt[4]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \^buf_data_reg[0][73]_1\(4),
      I1 => \^sband_tact0\,
      I2 => \vfb_vcdt_reg[9]\(4),
      O => \buf_data_reg[0][73]_0\(4)
    );
\vfb_vcdt[5]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \^buf_data_reg[0][73]_1\(5),
      I1 => \^sband_tact0\,
      I2 => \vfb_vcdt_reg[9]\(5),
      O => \buf_data_reg[0][73]_0\(5)
    );
\vfb_vcdt[6]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \^buf_data_reg[0][73]_1\(6),
      I1 => \^sband_tact0\,
      I2 => \vfb_vcdt_reg[9]\(6),
      O => \buf_data_reg[0][73]_0\(6)
    );
\vfb_vcdt[7]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \^buf_data_reg[0][73]_1\(7),
      I1 => \^sband_tact0\,
      I2 => \vfb_vcdt_reg[9]\(7),
      O => \buf_data_reg[0][73]_0\(7)
    );
\vfb_vcdt[8]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \^buf_data_reg[0][73]_1\(8),
      I1 => \^sband_tact0\,
      I2 => \vfb_vcdt_reg[9]\(8),
      O => \buf_data_reg[0][73]_0\(8)
    );
\vfb_vcdt[9]_i_3\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \^buf_data_reg[0][73]_1\(9),
      I1 => \^sband_tact0\,
      I2 => \vfb_vcdt_reg[9]\(9),
      O => \buf_data_reg[0][73]_0\(9)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity bd_e616_vfb_0_0_bd_e616_vfb_0_0_core is
  port (
    s_axis_aclk : in STD_LOGIC;
    s_axis_aresetn : in STD_LOGIC;
    s_axis_tready : out STD_LOGIC;
    s_axis_tvalid : in STD_LOGIC;
    s_axis_tlast : in STD_LOGIC;
    s_axis_tdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axis_tkeep : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axis_tuser : in STD_LOGIC_VECTOR ( 95 downto 0 );
    s_axis_tdest : in STD_LOGIC_VECTOR ( 3 downto 0 );
    mdt_tv : out STD_LOGIC;
    mdt_tr : out STD_LOGIC;
    sdt_tv : out STD_LOGIC;
    sdt_tr : out STD_LOGIC;
    vfb_tv : out STD_LOGIC;
    vfb_tr : out STD_LOGIC;
    vfb_arstn : in STD_LOGIC;
    vfb_clk : in STD_LOGIC;
    vfb_ready : in STD_LOGIC;
    core_men_vfb : in STD_LOGIC;
    vfb_full : out STD_LOGIC;
    vfb_wc_full : out STD_LOGIC;
    core_men_ack_vfb : out STD_LOGIC;
    vfb_valid : out STD_LOGIC;
    vfb_eol : out STD_LOGIC;
    vfb_sof : out STD_LOGIC_VECTOR ( 0 to 0 );
    vfb_vcdt : out STD_LOGIC_VECTOR ( 9 downto 0 );
    vfb_data : out STD_LOGIC_VECTOR ( 7 downto 0 )
  );
  attribute AXIS_TDATA_WIDTH : integer;
  attribute AXIS_TDATA_WIDTH of bd_e616_vfb_0_0_bd_e616_vfb_0_0_core : entity is 32;
  attribute AXIS_TDEST_WIDTH : integer;
  attribute AXIS_TDEST_WIDTH of bd_e616_vfb_0_0_bd_e616_vfb_0_0_core : entity is 4;
  attribute AXIS_TUSER_WIDTH : integer;
  attribute AXIS_TUSER_WIDTH of bd_e616_vfb_0_0_bd_e616_vfb_0_0_core : entity is 96;
  attribute C_HS_LINE_RATE : integer;
  attribute C_HS_LINE_RATE of bd_e616_vfb_0_0_bd_e616_vfb_0_0_core : entity is 800;
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of bd_e616_vfb_0_0_bd_e616_vfb_0_0_core : entity is "yes";
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of bd_e616_vfb_0_0_bd_e616_vfb_0_0_core : entity is "bd_e616_vfb_0_0_core";
  attribute VFB_4PXL_W : integer;
  attribute VFB_4PXL_W of bd_e616_vfb_0_0_bd_e616_vfb_0_0_core : entity is 32;
  attribute VFB_BYPASS_WC : integer;
  attribute VFB_BYPASS_WC of bd_e616_vfb_0_0_bd_e616_vfb_0_0_core : entity is 0;
  attribute VFB_DATA_TYPE : integer;
  attribute VFB_DATA_TYPE of bd_e616_vfb_0_0_bd_e616_vfb_0_0_core : entity is 42;
  attribute VFB_DCONV_OWIDTH : integer;
  attribute VFB_DCONV_OWIDTH of bd_e616_vfb_0_0_bd_e616_vfb_0_0_core : entity is 8;
  attribute VFB_DCONV_TUW : integer;
  attribute VFB_DCONV_TUW of bd_e616_vfb_0_0_bd_e616_vfb_0_0_core : entity is 12;
  attribute VFB_EN_VCX : integer;
  attribute VFB_EN_VCX of bd_e616_vfb_0_0_bd_e616_vfb_0_0_core : entity is 0;
  attribute VFB_FIFO_DEPTH : integer;
  attribute VFB_FIFO_DEPTH of bd_e616_vfb_0_0_bd_e616_vfb_0_0_core : entity is 2048;
  attribute VFB_FIFO_WIDTH : integer;
  attribute VFB_FIFO_WIDTH of bd_e616_vfb_0_0_bd_e616_vfb_0_0_core : entity is 32;
  attribute VFB_FILTER_VC : integer;
  attribute VFB_FILTER_VC of bd_e616_vfb_0_0_bd_e616_vfb_0_0_core : entity is 0;
  attribute VFB_OP_DWIDTH : integer;
  attribute VFB_OP_DWIDTH of bd_e616_vfb_0_0_bd_e616_vfb_0_0_core : entity is 8;
  attribute VFB_OP_PIXELS : integer;
  attribute VFB_OP_PIXELS of bd_e616_vfb_0_0_bd_e616_vfb_0_0_core : entity is 1;
  attribute VFB_PXL_W : integer;
  attribute VFB_PXL_W of bd_e616_vfb_0_0_bd_e616_vfb_0_0_core : entity is 8;
  attribute VFB_PXL_W_BB : integer;
  attribute VFB_PXL_W_BB of bd_e616_vfb_0_0_bd_e616_vfb_0_0_core : entity is 8;
  attribute VFB_REQ_BUFFER : integer;
  attribute VFB_REQ_BUFFER of bd_e616_vfb_0_0_bd_e616_vfb_0_0_core : entity is 0;
  attribute VFB_REQ_REORDER : integer;
  attribute VFB_REQ_REORDER of bd_e616_vfb_0_0_bd_e616_vfb_0_0_core : entity is 0;
  attribute VFB_TSB0_WIDTH : integer;
  attribute VFB_TSB0_WIDTH of bd_e616_vfb_0_0_bd_e616_vfb_0_0_core : entity is 32;
  attribute VFB_TSB1_WIDTH : integer;
  attribute VFB_TSB1_WIDTH of bd_e616_vfb_0_0_bd_e616_vfb_0_0_core : entity is 0;
  attribute VFB_TSB2_WIDTH : integer;
  attribute VFB_TSB2_WIDTH of bd_e616_vfb_0_0_bd_e616_vfb_0_0_core : entity is 3;
  attribute VFB_TU_WIDTH : integer;
  attribute VFB_TU_WIDTH of bd_e616_vfb_0_0_bd_e616_vfb_0_0_core : entity is 1;
  attribute VFB_VC : integer;
  attribute VFB_VC of bd_e616_vfb_0_0_bd_e616_vfb_0_0_core : entity is 0;
end bd_e616_vfb_0_0_bd_e616_vfb_0_0_core;

architecture STRUCTURE of bd_e616_vfb_0_0_bd_e616_vfb_0_0_core is
  signal \<const0>\ : STD_LOGIC;
  signal \VFB_MIN.reorder_n_0\ : STD_LOGIC;
  signal \VFB_MIN.reorder_n_3\ : STD_LOGIC;
  signal \VFB_MIN.reorder_n_34\ : STD_LOGIC;
  signal \VFB_MIN.reorder_n_35\ : STD_LOGIC;
  signal op_inf_n_10 : STD_LOGIC;
  signal op_inf_n_11 : STD_LOGIC;
  signal op_inf_n_32 : STD_LOGIC;
  signal op_inf_n_33 : STD_LOGIC;
  signal op_inf_n_34 : STD_LOGIC;
  signal op_inf_n_35 : STD_LOGIC;
  signal op_inf_n_36 : STD_LOGIC;
  signal op_inf_n_37 : STD_LOGIC;
  signal op_inf_n_38 : STD_LOGIC;
  signal op_inf_n_39 : STD_LOGIC;
  signal op_inf_n_40 : STD_LOGIC;
  signal op_inf_n_41 : STD_LOGIC;
  signal op_inf_n_42 : STD_LOGIC;
  signal op_inf_n_43 : STD_LOGIC;
  signal op_inf_n_44 : STD_LOGIC;
  signal op_inf_n_45 : STD_LOGIC;
  signal op_inf_n_46 : STD_LOGIC;
  signal op_inf_n_47 : STD_LOGIC;
  signal op_inf_n_48 : STD_LOGIC;
  signal op_inf_n_49 : STD_LOGIC;
  signal op_inf_n_50 : STD_LOGIC;
  signal op_inf_n_51 : STD_LOGIC;
  signal op_inf_n_52 : STD_LOGIC;
  signal op_inf_n_53 : STD_LOGIC;
  signal op_inf_n_54 : STD_LOGIC;
  signal op_inf_n_55 : STD_LOGIC;
  signal op_inf_n_9 : STD_LOGIC;
  signal p_1_in : STD_LOGIC_VECTOR ( 9 downto 0 );
  signal sband_tact0 : STD_LOGIC;
  signal sband_tact021_out : STD_LOGIC;
  signal sband_td_r : STD_LOGIC_VECTOR ( 23 downto 0 );
  signal sband_tk_r : STD_LOGIC;
  signal sband_tl : STD_LOGIC;
  signal sband_tl_r : STD_LOGIC;
  signal sband_ts : STD_LOGIC_VECTOR ( 9 downto 4 );
  signal \sband_ts__0\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal sband_ts_r : STD_LOGIC_VECTOR ( 9 downto 0 );
  signal sband_tu : STD_LOGIC;
  signal sband_tu_r : STD_LOGIC;
  signal \^sdt_tr\ : STD_LOGIC;
  signal vfb_data_0 : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal \^vfb_eol\ : STD_LOGIC;
  signal \^vfb_ready\ : STD_LOGIC;
  signal \^vfb_valid\ : STD_LOGIC;
  signal \vfb_valid0__0\ : STD_LOGIC;
begin
  \^vfb_ready\ <= vfb_ready;
  core_men_ack_vfb <= \<const0>\;
  mdt_tv <= \<const0>\;
  sdt_tr <= \^sdt_tr\;
  vfb_eol <= \^vfb_eol\;
  vfb_full <= \<const0>\;
  vfb_tr <= \^vfb_ready\;
  vfb_tv <= \^vfb_valid\;
  vfb_valid <= \^vfb_valid\;
  vfb_wc_full <= \<const0>\;
GND: unisim.vcomponents.GND
     port map (
      G => \<const0>\
    );
\VFB_MIN.reorder\: entity work.bd_e616_vfb_0_0_vfb_v1_0_16_reorder
     port map (
      D(7 downto 0) => vfb_data_0(7 downto 0),
      E(0) => sband_tk_r,
      Q(1) => op_inf_n_10,
      Q(0) => op_inf_n_11,
      \buf_data_reg[0][101]_0\ => \VFB_MIN.reorder_n_0\,
      \buf_data_reg[0][103]_0\(1) => \VFB_MIN.reorder_n_34\,
      \buf_data_reg[0][103]_0\(0) => \VFB_MIN.reorder_n_35\,
      \buf_data_reg[0][135]_0\(23 downto 0) => sband_td_r(23 downto 0),
      \buf_data_reg[0][4]_0\ => \VFB_MIN.reorder_n_3\,
      \buf_data_reg[0][73]_0\(9 downto 0) => p_1_in(9 downto 0),
      \buf_data_reg[0][73]_1\(9 downto 4) => sband_ts(9 downto 4),
      \buf_data_reg[0][73]_1\(3 downto 0) => \sband_ts__0\(3 downto 0),
      \buf_data_reg[1][136]_0\(46) => s_axis_tlast,
      \buf_data_reg[1][136]_0\(45 downto 14) => s_axis_tdata(31 downto 0),
      \buf_data_reg[1][136]_0\(13 downto 11) => s_axis_tkeep(3 downto 1),
      \buf_data_reg[1][136]_0\(10 downto 5) => s_axis_tuser(69 downto 64),
      \buf_data_reg[1][136]_0\(4) => s_axis_tuser(0),
      \buf_data_reg[1][136]_0\(3 downto 0) => s_axis_tdest(3 downto 0),
      s_axis_aclk => s_axis_aclk,
      s_axis_aresetn => s_axis_aresetn,
      s_axis_tready => s_axis_tready,
      s_axis_tvalid => s_axis_tvalid,
      sband_tact0 => sband_tact0,
      sband_tact021_out => sband_tact021_out,
      \sband_td_r_reg[15]\(23) => op_inf_n_32,
      \sband_td_r_reg[15]\(22) => op_inf_n_33,
      \sband_td_r_reg[15]\(21) => op_inf_n_34,
      \sband_td_r_reg[15]\(20) => op_inf_n_35,
      \sband_td_r_reg[15]\(19) => op_inf_n_36,
      \sband_td_r_reg[15]\(18) => op_inf_n_37,
      \sband_td_r_reg[15]\(17) => op_inf_n_38,
      \sband_td_r_reg[15]\(16) => op_inf_n_39,
      \sband_td_r_reg[15]\(15) => op_inf_n_40,
      \sband_td_r_reg[15]\(14) => op_inf_n_41,
      \sband_td_r_reg[15]\(13) => op_inf_n_42,
      \sband_td_r_reg[15]\(12) => op_inf_n_43,
      \sband_td_r_reg[15]\(11) => op_inf_n_44,
      \sband_td_r_reg[15]\(10) => op_inf_n_45,
      \sband_td_r_reg[15]\(9) => op_inf_n_46,
      \sband_td_r_reg[15]\(8) => op_inf_n_47,
      \sband_td_r_reg[15]\(7) => op_inf_n_48,
      \sband_td_r_reg[15]\(6) => op_inf_n_49,
      \sband_td_r_reg[15]\(5) => op_inf_n_50,
      \sband_td_r_reg[15]\(4) => op_inf_n_51,
      \sband_td_r_reg[15]\(3) => op_inf_n_52,
      \sband_td_r_reg[15]\(2) => op_inf_n_53,
      \sband_td_r_reg[15]\(1) => op_inf_n_54,
      \sband_td_r_reg[15]\(0) => op_inf_n_55,
      \sband_tk_r_reg[2]\ => \^vfb_valid\,
      sband_tl => sband_tl,
      sband_tl_r => sband_tl_r,
      sband_tl_r_reg => op_inf_n_9,
      sband_tl_r_reg_0 => \^vfb_eol\,
      sband_tu => sband_tu,
      sband_tu_r => sband_tu_r,
      sdt_tr => \^sdt_tr\,
      sdt_tv => sdt_tv,
      vfb_ready => \^vfb_ready\,
      \vfb_valid0__0\ => \vfb_valid0__0\,
      \vfb_vcdt_reg[9]\(9 downto 0) => sband_ts_r(9 downto 0)
    );
op_inf: entity work.bd_e616_vfb_0_0_vfb_v1_0_16_op_inf
     port map (
      D(1) => \VFB_MIN.reorder_n_34\,
      D(0) => \VFB_MIN.reorder_n_35\,
      E(0) => sband_tk_r,
      Q(1) => op_inf_n_10,
      Q(0) => op_inf_n_11,
      mdt_tr => mdt_tr,
      sband_tact0 => sband_tact0,
      sband_tact021_out => sband_tact021_out,
      \sband_td_r_reg[23]_0\(23) => op_inf_n_32,
      \sband_td_r_reg[23]_0\(22) => op_inf_n_33,
      \sband_td_r_reg[23]_0\(21) => op_inf_n_34,
      \sband_td_r_reg[23]_0\(20) => op_inf_n_35,
      \sband_td_r_reg[23]_0\(19) => op_inf_n_36,
      \sband_td_r_reg[23]_0\(18) => op_inf_n_37,
      \sband_td_r_reg[23]_0\(17) => op_inf_n_38,
      \sband_td_r_reg[23]_0\(16) => op_inf_n_39,
      \sband_td_r_reg[23]_0\(15) => op_inf_n_40,
      \sband_td_r_reg[23]_0\(14) => op_inf_n_41,
      \sband_td_r_reg[23]_0\(13) => op_inf_n_42,
      \sband_td_r_reg[23]_0\(12) => op_inf_n_43,
      \sband_td_r_reg[23]_0\(11) => op_inf_n_44,
      \sband_td_r_reg[23]_0\(10) => op_inf_n_45,
      \sband_td_r_reg[23]_0\(9) => op_inf_n_46,
      \sband_td_r_reg[23]_0\(8) => op_inf_n_47,
      \sband_td_r_reg[23]_0\(7) => op_inf_n_48,
      \sband_td_r_reg[23]_0\(6) => op_inf_n_49,
      \sband_td_r_reg[23]_0\(5) => op_inf_n_50,
      \sband_td_r_reg[23]_0\(4) => op_inf_n_51,
      \sband_td_r_reg[23]_0\(3) => op_inf_n_52,
      \sband_td_r_reg[23]_0\(2) => op_inf_n_53,
      \sband_td_r_reg[23]_0\(1) => op_inf_n_54,
      \sband_td_r_reg[23]_0\(0) => op_inf_n_55,
      \sband_td_r_reg[23]_1\(23 downto 0) => sband_td_r(23 downto 0),
      sband_tl => sband_tl,
      sband_tl_r => sband_tl_r,
      \sband_ts_r_reg[9]_0\(9 downto 0) => sband_ts_r(9 downto 0),
      \sband_ts_r_reg[9]_1\(9 downto 4) => sband_ts(9 downto 4),
      \sband_ts_r_reg[9]_1\(3 downto 0) => \sband_ts__0\(3 downto 0),
      sband_tu => sband_tu,
      sband_tu_r => sband_tu_r,
      sdt_tr => \^sdt_tr\,
      vfb_arstn => vfb_arstn,
      vfb_clk => vfb_clk,
      \vfb_cnt_reg[3]_0\ => op_inf_n_9,
      vfb_data(7 downto 0) => vfb_data(7 downto 0),
      \vfb_data_reg[7]_0\(7 downto 0) => vfb_data_0(7 downto 0),
      vfb_eol_reg_0 => \^vfb_eol\,
      vfb_eol_reg_1 => \VFB_MIN.reorder_n_0\,
      vfb_ready => \^vfb_ready\,
      \vfb_sof_reg[0]_0\ => vfb_sof(0),
      \vfb_sof_reg[0]_1\ => \VFB_MIN.reorder_n_3\,
      \vfb_valid0__0\ => \vfb_valid0__0\,
      vfb_valid_reg_0 => \^vfb_valid\,
      vfb_vcdt(9 downto 0) => vfb_vcdt(9 downto 0),
      \vfb_vcdt_reg[9]_0\(9 downto 0) => p_1_in(9 downto 0)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity bd_e616_vfb_0_0 is
  port (
    s_axis_aclk : in STD_LOGIC;
    s_axis_aresetn : in STD_LOGIC;
    s_axis_tready : out STD_LOGIC;
    s_axis_tvalid : in STD_LOGIC;
    s_axis_tlast : in STD_LOGIC;
    s_axis_tdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axis_tkeep : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axis_tuser : in STD_LOGIC_VECTOR ( 95 downto 0 );
    s_axis_tdest : in STD_LOGIC_VECTOR ( 3 downto 0 );
    mdt_tv : out STD_LOGIC;
    mdt_tr : out STD_LOGIC;
    sdt_tv : out STD_LOGIC;
    sdt_tr : out STD_LOGIC;
    vfb_tv : out STD_LOGIC;
    vfb_tr : out STD_LOGIC;
    vfb_arstn : in STD_LOGIC;
    vfb_clk : in STD_LOGIC;
    vfb_ready : in STD_LOGIC;
    core_men_vfb : in STD_LOGIC;
    vfb_full : out STD_LOGIC;
    vfb_wc_full : out STD_LOGIC;
    core_men_ack_vfb : out STD_LOGIC;
    vfb_valid : out STD_LOGIC;
    vfb_eol : out STD_LOGIC;
    vfb_sof : out STD_LOGIC_VECTOR ( 0 to 0 );
    vfb_vcdt : out STD_LOGIC_VECTOR ( 9 downto 0 );
    vfb_data : out STD_LOGIC_VECTOR ( 7 downto 0 )
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of bd_e616_vfb_0_0 : entity is true;
  attribute AXIS_TDATA_WIDTH : integer;
  attribute AXIS_TDATA_WIDTH of bd_e616_vfb_0_0 : entity is 32;
  attribute AXIS_TDEST_WIDTH : integer;
  attribute AXIS_TDEST_WIDTH of bd_e616_vfb_0_0 : entity is 4;
  attribute AXIS_TUSER_WIDTH : integer;
  attribute AXIS_TUSER_WIDTH of bd_e616_vfb_0_0 : entity is 96;
  attribute C_HS_LINE_RATE : integer;
  attribute C_HS_LINE_RATE of bd_e616_vfb_0_0 : entity is 800;
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of bd_e616_vfb_0_0 : entity is "yes";
  attribute VFB_4PXL_W : integer;
  attribute VFB_4PXL_W of bd_e616_vfb_0_0 : entity is 32;
  attribute VFB_BYPASS_WC : integer;
  attribute VFB_BYPASS_WC of bd_e616_vfb_0_0 : entity is 0;
  attribute VFB_DATA_TYPE : integer;
  attribute VFB_DATA_TYPE of bd_e616_vfb_0_0 : entity is 42;
  attribute VFB_DCONV_OWIDTH : integer;
  attribute VFB_DCONV_OWIDTH of bd_e616_vfb_0_0 : entity is 8;
  attribute VFB_EN_VCX : integer;
  attribute VFB_EN_VCX of bd_e616_vfb_0_0 : entity is 0;
  attribute VFB_FIFO_DEPTH : integer;
  attribute VFB_FIFO_DEPTH of bd_e616_vfb_0_0 : entity is 2048;
  attribute VFB_FIFO_WIDTH : integer;
  attribute VFB_FIFO_WIDTH of bd_e616_vfb_0_0 : entity is 32;
  attribute VFB_FILTER_VC : integer;
  attribute VFB_FILTER_VC of bd_e616_vfb_0_0 : entity is 0;
  attribute VFB_OP_DWIDTH : integer;
  attribute VFB_OP_DWIDTH of bd_e616_vfb_0_0 : entity is 8;
  attribute VFB_OP_PIXELS : integer;
  attribute VFB_OP_PIXELS of bd_e616_vfb_0_0 : entity is 1;
  attribute VFB_PXL_W : integer;
  attribute VFB_PXL_W of bd_e616_vfb_0_0 : entity is 8;
  attribute VFB_PXL_W_BB : integer;
  attribute VFB_PXL_W_BB of bd_e616_vfb_0_0 : entity is 8;
  attribute VFB_REQ_BUFFER : integer;
  attribute VFB_REQ_BUFFER of bd_e616_vfb_0_0 : entity is 0;
  attribute VFB_REQ_REORDER : integer;
  attribute VFB_REQ_REORDER of bd_e616_vfb_0_0 : entity is 0;
  attribute VFB_TU_WIDTH : integer;
  attribute VFB_TU_WIDTH of bd_e616_vfb_0_0 : entity is 1;
  attribute VFB_VC : integer;
  attribute VFB_VC of bd_e616_vfb_0_0 : entity is 0;
end bd_e616_vfb_0_0;

architecture STRUCTURE of bd_e616_vfb_0_0 is
  signal \<const0>\ : STD_LOGIC;
  signal \<const1>\ : STD_LOGIC;
  signal NLW_inst_core_men_ack_vfb_UNCONNECTED : STD_LOGIC;
  signal NLW_inst_mdt_tv_UNCONNECTED : STD_LOGIC;
  signal NLW_inst_vfb_full_UNCONNECTED : STD_LOGIC;
  signal NLW_inst_vfb_wc_full_UNCONNECTED : STD_LOGIC;
  attribute AXIS_TDATA_WIDTH of inst : label is 32;
  attribute AXIS_TDEST_WIDTH of inst : label is 4;
  attribute AXIS_TUSER_WIDTH of inst : label is 96;
  attribute C_HS_LINE_RATE of inst : label is 800;
  attribute DowngradeIPIdentifiedWarnings of inst : label is "yes";
  attribute VFB_4PXL_W of inst : label is 32;
  attribute VFB_BYPASS_WC of inst : label is 0;
  attribute VFB_DATA_TYPE of inst : label is 42;
  attribute VFB_DCONV_OWIDTH of inst : label is 8;
  attribute VFB_DCONV_TUW : integer;
  attribute VFB_DCONV_TUW of inst : label is 12;
  attribute VFB_EN_VCX of inst : label is 0;
  attribute VFB_FIFO_DEPTH of inst : label is 2048;
  attribute VFB_FIFO_WIDTH of inst : label is 32;
  attribute VFB_FILTER_VC of inst : label is 0;
  attribute VFB_OP_DWIDTH of inst : label is 8;
  attribute VFB_OP_PIXELS of inst : label is 1;
  attribute VFB_PXL_W of inst : label is 8;
  attribute VFB_PXL_W_BB of inst : label is 8;
  attribute VFB_REQ_BUFFER of inst : label is 0;
  attribute VFB_REQ_REORDER of inst : label is 0;
  attribute VFB_TSB0_WIDTH : integer;
  attribute VFB_TSB0_WIDTH of inst : label is 32;
  attribute VFB_TSB1_WIDTH : integer;
  attribute VFB_TSB1_WIDTH of inst : label is 0;
  attribute VFB_TSB2_WIDTH : integer;
  attribute VFB_TSB2_WIDTH of inst : label is 3;
  attribute VFB_TU_WIDTH of inst : label is 1;
  attribute VFB_VC of inst : label is 0;
begin
  core_men_ack_vfb <= \<const1>\;
  mdt_tv <= \<const0>\;
  vfb_full <= \<const0>\;
  vfb_wc_full <= \<const0>\;
GND: unisim.vcomponents.GND
     port map (
      G => \<const0>\
    );
VCC: unisim.vcomponents.VCC
     port map (
      P => \<const1>\
    );
inst: entity work.bd_e616_vfb_0_0_bd_e616_vfb_0_0_core
     port map (
      core_men_ack_vfb => NLW_inst_core_men_ack_vfb_UNCONNECTED,
      core_men_vfb => '0',
      mdt_tr => mdt_tr,
      mdt_tv => NLW_inst_mdt_tv_UNCONNECTED,
      s_axis_aclk => s_axis_aclk,
      s_axis_aresetn => s_axis_aresetn,
      s_axis_tdata(31 downto 0) => s_axis_tdata(31 downto 0),
      s_axis_tdest(3 downto 0) => s_axis_tdest(3 downto 0),
      s_axis_tkeep(3 downto 1) => s_axis_tkeep(3 downto 1),
      s_axis_tkeep(0) => '0',
      s_axis_tlast => s_axis_tlast,
      s_axis_tready => s_axis_tready,
      s_axis_tuser(95 downto 70) => B"00000000000000000000000000",
      s_axis_tuser(69 downto 64) => s_axis_tuser(69 downto 64),
      s_axis_tuser(63 downto 1) => B"000000000000000000000000000000000000000000000000000000000000000",
      s_axis_tuser(0) => s_axis_tuser(0),
      s_axis_tvalid => s_axis_tvalid,
      sdt_tr => sdt_tr,
      sdt_tv => sdt_tv,
      vfb_arstn => vfb_arstn,
      vfb_clk => vfb_clk,
      vfb_data(7 downto 0) => vfb_data(7 downto 0),
      vfb_eol => vfb_eol,
      vfb_full => NLW_inst_vfb_full_UNCONNECTED,
      vfb_ready => vfb_ready,
      vfb_sof(0) => vfb_sof(0),
      vfb_tr => vfb_tr,
      vfb_tv => vfb_tv,
      vfb_valid => vfb_valid,
      vfb_vcdt(9 downto 0) => vfb_vcdt(9 downto 0),
      vfb_wc_full => NLW_inst_vfb_wc_full_UNCONNECTED
    );
end STRUCTURE;
