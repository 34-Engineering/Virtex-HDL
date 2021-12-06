vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xpm
vlib questa_lib/msim/xil_defaultlib

vmap xpm questa_lib/msim/xpm
vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vlog -work xpm  -incr -mfcu -sv "+incdir+../../../../Virtex-Embedded-Code.gen/sources_1/ip/clk_wiz_2" \
"C:/Xilinx/Vivado/2021.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm  -93 \
"C:/Xilinx/Vivado/2021.1/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -incr -mfcu "+incdir+../../../../Virtex-Embedded-Code.gen/sources_1/ip/clk_wiz_2" \
"../../../../Virtex-Embedded-Code.gen/sources_1/ip/clk_wiz_2/clk_wiz_2_sim_netlist.v" \


vlog -work xil_defaultlib \
"glbl.v"

