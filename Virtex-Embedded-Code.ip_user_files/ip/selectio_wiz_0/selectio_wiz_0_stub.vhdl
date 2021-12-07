-- Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
-- Date        : Mon Dec  6 20:29:42 2021
-- Host        : RISC-IV running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               c:/Users/liams/Documents/GitHub/Virtex-Embedded-Code/Virtex-Embedded-Code.gen/sources_1/ip/selectio_wiz_0/selectio_wiz_0_stub.vhdl
-- Design      : selectio_wiz_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a35tftg256-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity selectio_wiz_0 is
  Port ( 
    data_in_from_pins_p : in STD_LOGIC_VECTOR ( 3 downto 0 );
    data_in_from_pins_n : in STD_LOGIC_VECTOR ( 3 downto 0 );
    data_in_to_device : out STD_LOGIC_VECTOR ( 7 downto 0 );
    clk_in_p : in STD_LOGIC;
    clk_in_n : in STD_LOGIC;
    clk_out : out STD_LOGIC;
    io_reset : in STD_LOGIC
  );

end selectio_wiz_0;

architecture stub of selectio_wiz_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "data_in_from_pins_p[3:0],data_in_from_pins_n[3:0],data_in_to_device[7:0],clk_in_p,clk_in_n,clk_out,io_reset";
begin
end;
