vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xpm
vlib questa_lib/msim/xil_defaultlib

vmap xpm questa_lib/msim/xpm
vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vlog -work xpm  -incr -mfcu -sv "+incdir+../../../../Virtex-HDL.gen/sources_1/ip/clk_wiz_python_fix" \
"C:/Xilinx/Vivado/2021.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"C:/Xilinx/Vivado/2021.1/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm  -93 \
"C:/Xilinx/Vivado/2021.1/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -incr -mfcu "+incdir+../../../../Virtex-HDL.gen/sources_1/ip/clk_wiz_python_fix" \
"../../../../Virtex-HDL.gen/sources_1/ip/clk_wiz_python_fix/clk_wiz_python_fix_sim_netlist.v" \

vlog -work xil_defaultlib \
"glbl.v"

