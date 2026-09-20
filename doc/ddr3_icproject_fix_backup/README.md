# ICproject 仓库里 3 个 DDR 改动的备份

## 背景

`ICproject` 仓库（远端 `github.com/evatry/ICproject.git`）在 commit
`f319237` / `9f6fdcd` 里，除了 APB 外设子系统之外，还夹带了 3 处 DDR 相关改动。
而 `work` 这边的 DDR 通路已经用 `ddr_test.c` 实测过 **440 写 / 440 读全部一致、
0 错数**，所以**不采用**下面这些改动，把它们备份在这里备查。

## 备份内容

`ddr_changes.patch` 是 `work`（可用版）→ `ICproject`（改动版）的 unified diff，
`+` 号即 ICproject 多出来的改动。三个文件：

| 文件 | ICproject 里的改动 | 现状 |
|---|---|---|
| `verilog/ddr3/ddr3_dfi_phy.v` | 写数据 `dfi_wrdata_q` 与写掩码 `dfi_wr_mask_q` 各补一级流水，对齐 DQS 输出使能路径（`wr_valid_q0 -> wr_valid_q1 -> dqs_out_en_n_q` 共 3 级）。作者描述原问题为"DRAM 把每个写 beat 提前一个 32 位 lane 采走，存储内容变成 `[d1,d2,d3,0]`" | 未采用 |
| `sim_soc/run_2_step.sh` | 仿真时加 `mkdir -p ddr3_data` + `+model_data+./ddr3_data`，让 Micron 模型的数据文件落在本地而不是 `/tmp` | 未采用 |
| `software/build_ddr_test.sh` | `SIMDIR` 由硬编码 `/home/ICer/work/sim_soc` 改成相对路径 `$(cd .. && pwd)/sim_soc` | 未采用 |

> 对比：`work` 的 DDR 通路此前已修好 5 位 AXI ID 透传（`0x00`/`0x10` 两个从口
> 的 B/R 响应路由）、`TPHY_RDLAT=4` 读窗口、`tbench_top.v` 的 `1ns/1ps` 精度与
> `clk_ddr90` 相位等，读写自测全绿，因此写通道不需要再补流水。

## 原始版本可从 git 取回

```bash
cd /home/ICer/ICproject
git show backup/ddr-writebeat-fix-62ec235:verilog/ddr3/ddr3_dfi_phy.v     # 改动版
git show backup/ddr-writebeat-fix-62ec235:sim_soc/run_2_step.sh
git show backup/ddr-writebeat-fix-62ec235:software/build_ddr_test.sh
```
该分支指向 commit `62ec235`（回退之前的完整状态）。

## 如果想重新试用这些改动

```bash
cd /home/ICer/work
git apply doc/ddr3_icproject_fix_backup/ddr_changes.patch
```
（apply 之前先确认 DDR 自测仍可通过；如无必要不建议加，因为现有版本已验证可用。）
