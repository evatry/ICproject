// ============================================================
//  DDR3 自测 filelist（在 ddr3_selftest/ 目录下运行）
//  通路: AHB 主口 -> ahb_axi_matrix_wrapper -> M_DDR_AXI -> ddr3_top -> Micron 模型
// ============================================================
+libext+.v
+incdir+../../verilog/ddr3/model

// ---- DDR3 控制器 ----
../../verilog/ddr3/ddr3_top.v
../../verilog/ddr3/ddr3_axi_pmem.v
../../verilog/ddr3/ddr3_axi_retime.v
../../verilog/ddr3/ddr3_axi.v
../../verilog/ddr3/ddr3_core.v
../../verilog/ddr3/ddr3_dfi_seq.v
../../verilog/ddr3/ddr3_dfi_phy.v

// ---- Micron DDR3 x16 器件模型（最后编译，避免宏污染） ----
../../verilog/ddr3/model/ddr3.v

// ---- matrix BD (crossbar) ----
../../vivado/ahb_matrix/ahb_matrix.ip_user_files/bd/ahb_axi_matrix/ip/ahb_axi_matrix_axi_crossbar_0_0/sim/ahb_axi_matrix_axi_crossbar_0_0.v
../../vivado/ahb_matrix/ahb_matrix.ip_user_files/bd/ahb_axi_matrix/sim/ahb_axi_matrix.v
../../vivado/ahb_matrix/ahb_matrix.srcs/sources_1/bd/ahb_axi_matrix/hdl/ahb_axi_matrix_wrapper.v

// ---- testbench ----
matrix_ddr_tb.v

// ---- Xilinx 7-series 原语 + glbl ----
-y /home/Xilinx/Vivado/2019.1/data/verilog/src/unisims
../../verilog/glbl.v
