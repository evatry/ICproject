-makelib xcelium_lib/xil_defaultlib -sv \
  "/home/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "/home/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "/home/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/generic_baseblocks_v2_1_0 \
  "../../../../ahb_matrix.srcs/sources_1/bd/ahb_axi_matrix/ipshared/b752/hdl/generic_baseblocks_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axi_infrastructure_v1_1_0 \
  "../../../../ahb_matrix.srcs/sources_1/bd/ahb_axi_matrix/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axi_register_slice_v2_1_19 \
  "../../../../ahb_matrix.srcs/sources_1/bd/ahb_axi_matrix/ipshared/4d88/hdl/axi_register_slice_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/fifo_generator_v13_2_4 \
  "../../../../ahb_matrix.srcs/sources_1/bd/ahb_axi_matrix/ipshared/1f5a/simulation/fifo_generator_vlog_beh.v" \
-endlib
-makelib xcelium_lib/fifo_generator_v13_2_4 \
  "../../../../ahb_matrix.srcs/sources_1/bd/ahb_axi_matrix/ipshared/1f5a/hdl/fifo_generator_v13_2_rfs.vhd" \
-endlib
-makelib xcelium_lib/fifo_generator_v13_2_4 \
  "../../../../ahb_matrix.srcs/sources_1/bd/ahb_axi_matrix/ipshared/1f5a/hdl/fifo_generator_v13_2_rfs.v" \
-endlib
-makelib xcelium_lib/axi_data_fifo_v2_1_18 \
  "../../../../ahb_matrix.srcs/sources_1/bd/ahb_axi_matrix/ipshared/5b9c/hdl/axi_data_fifo_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/axi_crossbar_v2_1_20 \
  "../../../../ahb_matrix.srcs/sources_1/bd/ahb_axi_matrix/ipshared/ace7/hdl/axi_crossbar_v2_1_vl_rfs.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/ahb_axi_matrix/ip/ahb_axi_matrix_axi_crossbar_0_0/sim/ahb_axi_matrix_axi_crossbar_0_0.v" \
-endlib
-makelib xcelium_lib/ahblite_axi_bridge_v3_0_14 \
  "../../../../ahb_matrix.srcs/sources_1/bd/ahb_axi_matrix/ipshared/2efd/hdl/ahblite_axi_bridge_v3_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/ahb_axi_matrix/ip/ahb_axi_matrix_ahblite_axi_bridge_0_0/sim/ahb_axi_matrix_ahblite_axi_bridge_0_0.vhd" \
  "../../../bd/ahb_axi_matrix/ip/ahb_axi_matrix_ahblite_axi_bridge_0_1/sim/ahb_axi_matrix_ahblite_axi_bridge_0_1.vhd" \
-endlib
-makelib xcelium_lib/axi_ahblite_bridge_v3_0_16 \
  "../../../../ahb_matrix.srcs/sources_1/bd/ahb_axi_matrix/ipshared/c8f4/hdl/axi_ahblite_bridge_v3_0_vh_rfs.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/ahb_axi_matrix/ip/ahb_axi_matrix_axi_ahblite_bridge_0_0/sim/ahb_axi_matrix_axi_ahblite_bridge_0_0.vhd" \
  "../../../bd/ahb_axi_matrix/ip/ahb_axi_matrix_axi_ahblite_bridge_0_1/sim/ahb_axi_matrix_axi_ahblite_bridge_0_1.vhd" \
  "../../../bd/ahb_axi_matrix/ip/ahb_axi_matrix_axi_ahblite_bridge_1_1/sim/ahb_axi_matrix_axi_ahblite_bridge_1_1.vhd" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../bd/ahb_axi_matrix/sim/ahb_axi_matrix.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

