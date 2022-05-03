-- Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
-- Date        : Fri Apr 29 01:17:06 2022
-- Host        : RISC-IV running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub -rename_top clk_wiz_python_fix -prefix
--               clk_wiz_python_fix_ clk_wiz_python_fix_stub.vhdl
-- Design      : clk_wiz_python_fix
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a35tftg256-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clk_wiz_python_fix is
  Port ( 
    clk_out1 : out STD_LOGIC;
    clk_in1 : in STD_LOGIC
  );

end clk_wiz_python_fix;

architecture stub of clk_wiz_python_fix is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk_out1,clk_in1";
begin
end;
