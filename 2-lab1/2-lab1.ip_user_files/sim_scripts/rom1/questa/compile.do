vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib
vlib questa_lib/msim/xpm
vlib questa_lib/msim/blk_mem_gen_v8_4_1

vmap xil_defaultlib questa_lib/msim/xil_defaultlib
vmap xpm questa_lib/msim/xpm
vmap blk_mem_gen_v8_4_1 questa_lib/msim/blk_mem_gen_v8_4_1

vlog -work xil_defaultlib -64 -sv -L xil_defaultlib "+incdir+D:/1vivado/Vivado/2017.4/data/xilinx_vip/include" "+incdir+D:/1vivado/Vivado/2017.4/data/xilinx_vip/include" \
"D:/1vivado/Vivado/2017.4/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93 \
"D:/1vivado/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work blk_mem_gen_v8_4_1 -64 "+incdir+D:/1vivado/Vivado/2017.4/data/xilinx_vip/include" "+incdir+D:/1vivado/Vivado/2017.4/data/xilinx_vip/include" \
"../../../ipstatic/simulation/blk_mem_gen_v8_4.v" \

vlog -work xil_defaultlib -64 "+incdir+D:/1vivado/Vivado/2017.4/data/xilinx_vip/include" "+incdir+D:/1vivado/Vivado/2017.4/data/xilinx_vip/include" \
"../../../../2-lab1.srcs/sources_1/ip/rom1/sim/rom1.v" \


vlog -work xil_defaultlib \
"glbl.v"

