#!/bin/bash
# ============================================================
#  DDR3 集成自测: AHB 主口 -> crossbar(M_DDR_AXI) -> ddr3_top -> Micron 模型
#    数据口 (AHB_INTERFACE_1, S_AXI slot1, ID=0x10) 写 4 拍再读回
#    指令口 (AHB_INTERFACE,   S_AXI slot0, ID=0x00) 读同样地址
#  目的是验证 B/R 响应的 ID 能被 crossbar 正确路由回发起方。
# ============================================================
set -e
cd "$(dirname "$0")"

[ -f "$HOME/.bashrc" ] && source "$HOME/.bashrc" >/dev/null 2>&1 || true
[ -f ../first.sh ] && source ../first.sh || true

echo "--- vlogan ---"
vlogan -work work -sverilog +v2k -nc -l t_vlogan.log -f matrix_ddr_tb.f

echo "--- vhdlan (matrix 里的 AHB/AXI 桥是 VHDL) ---"
vhdlan -work work -full64 -l t_vhdlan.log -f ../arm926fpga_vhdl.f

echo "--- vcs ---"
vcs -full64 -debug_access+all -l t_vcs.log -top matrix_ddr_tb -top glbl

echo "--- run ---"
./simv +vcs+lic+wait -l t_sim.log

echo "--- result ---"
grep -E "OK  |ERROR\(|TB PASS|TB FAIL|TB TIMEOUT" t_sim.log | tail -20
