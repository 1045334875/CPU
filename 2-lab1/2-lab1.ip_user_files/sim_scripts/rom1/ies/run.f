-makelib ies_lib/xil_defaultlib -sv \
  "D:/1vivado/Vivado/2017.4/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib ies_lib/xpm \
  "D:/1vivado/Vivado/2017.4/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/blk_mem_gen_v8_4_1 \
  "../../../ipstatic/simulation/blk_mem_gen_v8_4.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../2-lab1.srcs/sources_1/ip/rom1/sim/rom1.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

