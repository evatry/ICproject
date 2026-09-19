vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib
vlib questa_lib/msim/xpm
vlib questa_lib/msim/generic_baseblocks_v2_1_0
vlib questa_lib/msim/axi_infrastructure_v1_1_0
vlib questa_lib/msim/axi_register_slice_v2_1_19
vlib questa_lib/msim/fifo_generator_v13_2_4
vlib questa_lib/msim/axi_data_fifo_v2_1_18
vlib questa_lib/msim/axi_crossbar_v2_1_20
vlib questa_lib/msim/ahblite_axi_bridge_v3_0_14
vlib questa_lib/msim/axi_ahblite_bridge_v3_0_16

vmap xil_defaultlib questa_lib/msim/xil_defaultlib
vmap xpm questa_lib/msim/xpm
vmap generic_baseblocks_v2_1_0 questa_lib/msim/generic_baseblocks_v2_1_0
vmap axi_infrastructure_v1_1_0 questa_lib/msim/axi_infrastructure_v1_1_0
vmap axi_register_slice_v2_1_19 questa_lib/msim/axi_register_slice_v2_1_19
vmap fifo_generator_v13_2_4 questa_lib/msim/fifo_generator_v13_2_4
vmap axi_data_fifo_v2_1_18 questa_lib/msim/axi_data_fifo_v2_1_18
vmap axi_crossbar_v2_1_20 questa_lib/msim/axi_crossbar_v2_1_20
vmap ahblite_axi_bridge_v3_0_14 questa_lib/msim/ahblite_axi_bridge_v3_0_14
vmap axi_ahblite_bridge_v3_0_16 questa_lib/msim/axi_ahblite_bridge_v3_0_16

vlog -work xil_defaultlib -64 -sv "+incdir+../../../../ahb_matrix.srcs/sources_1/bd/ahb_axi_matrix/ipshared/ec67/hdl" \
"/home/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"/home/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93 \
"/home/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work generic_baseblocks_v2_1_0 -64 "+incdir+../../../../ahb_matrix.srcs/sources_1/bd/ahb_axi_matrix/ipshared/ec67/hdl" \
"../../../../ahb_matrix.srcs/sources_1/bd/ahb_axi_matrix/ipshared/b752/hdl/generic_baseblocks_v2_1_vl_rfs.v" \

vlog -work axi_infrastructure_v1_1_0 -64 "+incdir+../../../../ahb_matrix.srcs/sources_1/bd/ahb_axi_matrix/ipshared/ec67/hdl" \
"../../../../ahb_matrix.srcs/sources_1/bd/ahb_axi_matrix/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work axi_register_slice_v2_1_19 -64 "+incdir+../../../../ahb_matrix.srcs/sources_1/bd/ahb_axi_matrix/ipshared/ec67/hdl" \
"../../../../ahb_matrix.srcs/sources_1/bd/ahb_axi_matrix/ipshared/4d88/hdl/axi_register_slice_v2_1_vl_rfs.v" \

vlog -work fifo_generator_v13_2_4 -64 "+incdir+../../../../ahb_matrix.srcs/sources_1/bd/ahb_axi_matrix/ipshared/ec67/hdl" \
"../../../../ahb_matrix.srcs/sources_1/bd/ahb_axi_matrix/ipshared/1f5a/simulation/fifo_generator_vlog_beh.v" \

vcom -work fifo_generator_v13_2_4 -64 -93 \
"../../../../ahb_matrix.srcs/sources_1/bd/ahb_axi_matrix/ipshared/1f5a/hdl/fifo_generator_v13_2_rfs.vhd" \

vlog -work fifo_generator_v13_2_4 -64 "+incdir+../../../../ahb_matrix.srcs/sources_1/bd/ahb_axi_matrix/ipshared/ec67/hdl" \
"../../../../ahb_matrix.srcs/sources_1/bd/ahb_axi_matrix/ipshared/1f5a/hdl/fifo_generator_v13_2_rfs.v" \

vlog -work axi_data_fifo_v2_1_18 -64 "+incdir+../../../../ahb_matrix.srcs/sources_1/bd/ahb_axi_matrix/ipshared/ec67/hdl" \
"../../../../ahb_matrix.srcs/sources_1/bd/ahb_axi_matrix/ipshared/5b9c/hdl/axi_data_fifo_v2_1_vl_rfs.v" \

vlog -work axi_crossbar_v2_1_20 -64 "+incdir+../../../../ahb_matrix.srcs/sources_1/bd/ahb_axi_matrix/ipshared/ec67/hdl" \
"../../../../ahb_matrix.srcs/sources_1/bd/ahb_axi_matrix/ipshared/ace7/hdl/axi_crossbar_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib -64 "+incdir+../../../../ahb_matrix.srcs/sources_1/bd/ahb_axi_matrix/ipshared/ec67/hdl" \
"../../../bd/ahb_axi_matrix/ip/ahb_axi_matrix_axi_crossbar_0_0/sim/ahb_axi_matrix_axi_crossbar_0_0.v" \

vcom -work ahblite_axi_bridge_v3_0_14 -64 -93 \
"../../../../ahb_matrix.srcs/sources_1/bd/ahb_axi_matrix/ipshared/2efd/hdl/ahblite_axi_bridge_v3_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -64 -93 \
"../../../bd/ahb_axi_matrix/ip/ahb_axi_matrix_ahblite_axi_bridge_0_0/sim/ahb_axi_matrix_ahblite_axi_bridge_0_0.vhd" \
"../../../bd/ahb_axi_matrix/ip/ahb_axi_matrix_ahblite_axi_bridge_0_1/sim/ahb_axi_matrix_ahblite_axi_bridge_0_1.vhd" \

vcom -work axi_ahblite_bridge_v3_0_16 -64 -93 \
"../../../../ahb_matrix.srcs/sources_1/bd/ahb_axi_matrix/ipshared/c8f4/hdl/axi_ahblite_bridge_v3_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -64 -93 \
"../../../bd/ahb_axi_matrix/ip/ahb_axi_matrix_axi_ahblite_bridge_0_0/sim/ahb_axi_matrix_axi_ahblite_bridge_0_0.vhd" \
"../../../bd/ahb_axi_matrix/ip/ahb_axi_matrix_axi_ahblite_bridge_0_1/sim/ahb_axi_matrix_axi_ahblite_bridge_0_1.vhd" \
"../../../bd/ahb_axi_matrix/ip/ahb_axi_matrix_axi_ahblite_bridge_1_1/sim/ahb_axi_matrix_axi_ahblite_bridge_1_1.vhd" \

vlog -work xil_defaultlib -64 "+incdir+../../../../ahb_matrix.srcs/sources_1/bd/ahb_axi_matrix/ipshared/ec67/hdl" \
"../../../bd/ahb_axi_matrix/sim/ahb_axi_matrix.v" \

vlog -work xil_defaultlib \
"glbl.v"

