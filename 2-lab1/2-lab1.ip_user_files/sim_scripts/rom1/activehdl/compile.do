vlib work
vlib activehdl

vlib activehdl/xil_defaultlib
vlib activehdl/xpm
vlib activehdl/blk_mem_gen_v8_4_1

vmap xil_defaultlib activehdl/xil_defaultlib
vmap xpm activehdl/xpm
vmap blk_mem_gen_v8_4_1 activehdl/blk_mem_gen_v8_4_1

vlog -work xil_defaultlib  -sv2k12 "+incdir+D:/1vivado/Vivado/2017.4/data/xilinx_vip/include" "+incdir+D:/1vivado/Vivado/2017.4/data/xilinx_vip/include" \
"D:/1vivado/Vivado/2017.4/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93 \
"D:/1vivado/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work blk_mem_gen_v8_4_1  -v2k5 "+incdir+D:/1vivado/Vivado/2017.4/data/xilinx_vip/include" "+incdir+D:/1vivado/Vivado/2017.4/data/xilinx_vip/include" \
"../../../ipstatic/simulation/blk_mem_gen_v8_4.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+D:/1vivado/Vivado/2017.4/data/xilinx_vip/include" "+incdir+D:/1vivado/Vivado/2017.4/data/xilinx_vip/include" \
"../../../../2-lab1.srcs/sources_1/ip/rom1/sim/rom1.v" \


vlog -work xil_defaultlib \
"glbl.v"

