vlib work
vlib riviera

vlib riviera/xil_defaultlib
vlib riviera/xpm
vlib riviera/blk_mem_gen_v8_4_1

vmap xil_defaultlib riviera/xil_defaultlib
vmap xpm riviera/xpm
vmap blk_mem_gen_v8_4_1 riviera/blk_mem_gen_v8_4_1

vlog -work xil_defaultlib  -sv2k12 "+incdir+H:/anzhuang3/Vivado/2017.4/data/xilinx_vip/include" "+incdir+H:/anzhuang3/Vivado/2017.4/data/xilinx_vip/include" \
"H:/anzhuang3/Vivado/2017.4/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93 \
"H:/anzhuang3/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work blk_mem_gen_v8_4_1  -v2k5 "+incdir+H:/anzhuang3/Vivado/2017.4/data/xilinx_vip/include" "+incdir+H:/anzhuang3/Vivado/2017.4/data/xilinx_vip/include" \
"../../../ipstatic/simulation/blk_mem_gen_v8_4.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+H:/anzhuang3/Vivado/2017.4/data/xilinx_vip/include" "+incdir+H:/anzhuang3/Vivado/2017.4/data/xilinx_vip/include" \
"../../../../2-lab1.srcs/sources_1/ip/BRAM/sim/BRAM.v" \


vlog -work xil_defaultlib \
"glbl.v"

