#!/bin/bash
# 文件名：run_sim.sh

# 设置工作库
#WORK_LIB="my_worklib"

# 设置 VCS 选项（可根据需要调整）
VLOGAN_OPTS="-sverilog +v2k"
VHDLAN_OPTS="-full64"    # -v200x"
VCS_OPTS="-full64 -debug_access+all  -l 1.log -P /home/synopsys/verdi/Verdi_O-2018.09-SP2/share/PLI/VCS/LINUXAMD64/novas.tab /home/synopsys/verdi/Verdi_O-2018.09-SP2/share/PLI/VCS/LINUXAMD64/pli.a"
# 清理旧的编译文件（可选）
#rm -rf csrc simv* vc_hdrs.h vlogan.log vhdlan.log

# 第一步：分析 Verilog 文件
echo "--- Compiling Verilog files ---"
vlogan -work work $VLOGAN_OPTS -f arm926fpga.f || exit 1

# 第二步：分析 VHDL 文件
echo "--- Compiling VHDL files ---"
vhdlan -work work $VHDLAN_OPTS -f arm926fpga_vhdl.f || exit 1

# 第三步：链接生成可执行文件
echo "--- Elaborating design ---"
vcs $VCS_OPTS -top tbench_top -top glbl || exit 1

# 第四步：运行仿真
echo "--- Running simulation ---"
./simv +vcs+lic+wait

echo "--- Simulation finished ---"
