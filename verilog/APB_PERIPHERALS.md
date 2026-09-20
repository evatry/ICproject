# APB 外设子系统（LED / TIMER / UART）

在原来的 ARM926EJ-S AHB SoC 基础上，把 **LED、TIMER、UART** 三个外设统一改成
**APB 从设备**，通过一个 **AHB→APB 桥** 挂在同一条 AHB 主口 `M_AHB_3` 上。

## 1. 结构

```
ARM926EJ-S (AHB 主)
        │  M_AHB_3 : 0x8000_0000 / 16M 外设窗口
        ▼
   ┌──────────┐
   │ ahb2apb  │   AHB-Lite 从 / APB 主
   └────┬─────┘
        │ PSEL PENABLE PWRITE PADDR PWDATA PRDATA PREADY PSLVERR
        ▼
   ┌──────────┐
   │ apb_bus  │   地址译码 + 读数据/响应 mux
   └─┬──┬──┬──┘
     │  │  └────────────► apb_uart   0x8000_2000   irq ─┐
     │  └───────────────► apb_timer  0x8000_1000   irq ─┤
     └──────────────────► apb_led    0x8000_0000        │
                                                         ▼
                                          irq ──► ARM nIRQ (低有效)
```

`matrix_top.v` 里原来的 `ahb_sram_ctrl + sram_led` 这条 AHB 直连的 LED 通路已经删掉，
换成上面这套 APB 子系统；ROM / SRAM / DDR3 三条通路不变。

## 2. 地址映射

| 地址 | 外设 | 译码依据 |
|---|---|---|
| `0x8000_0000` | APB LED   | `PADDR[15:12] == 4'h0` |
| `0x8000_1000` | APB TIMER | `PADDR[15:12] == 4'h1` |
| `0x8000_2000` | APB UART  | `PADDR[15:12] == 4'h2` |
| 其它 | 未映射 | `PREADY=1, PSLVERR=1` → AHB 侧 ERROR 响应 |

## 3. AHB→APB 桥时序（`ahb2apb.v`）

APB 一次传输至少要 SETUP + ACCESS 两个周期，而 AHB 的地址相位和数据相位是流水的
（第 X 笔的数据相位那一拍，主设备已经在给第 X+1 笔的地址）。桥的处理：

* `HREADY`：`IDLE` 和 `ACCESS` 拉高，`SETUP` 拉低 → 给 AHB 插 1 个等待周期
* 在 `HREADY` 为高的那一拍抓地址：`IDLE` 抓到的是当前这笔，`ACCESS` 抓到的是流水线里的下一笔

```
c1 IDLE   : HTRANS=X 有效, HREADY=1 -> 接受 X 的地址, 抓 X, 进 SETUP
c2 SETUP  : PSEL=1 PENABLE=0 PADDR=X, HREADY=0 -> X 的数据相位被拉长
c3 ACCESS : PSEL=1 PENABLE=1 PADDR=X PWDATA=X 的数据,
            HREADY=1 -> X 完成, 同时抓到流水线里的 X+1, 回到 SETUP
c4 SETUP  : X+1 的 SETUP ...
```

稳定后 **每 2 个 HCLK 完成一次 APB 访问**。

## 4. APB LED（`apb_led.v`，基址 `0x8000_0000`）

| 偏移 | 名称 | 属性 | 说明 |
|---|---|---|---|
| `0x00` | LED | RW[7:0] | 写 1 点亮，读回当前值 |

## 5. APB TIMER（`apb_timer.v`，基址 `0x8000_1000`）

单通道 32-bit **递减**计数器。

| 偏移 | 名称 | 属性 | 说明 |
|---|---|---|---|
| `0x00` | LOAD | RW | 重装载值 |
| `0x04` | VALUE | RO | 当前计数值 |
| `0x08` | CTRL | RW | 见下 |
| `0x0C` | INTCLR | WO | 写 1 清中断 |
| `0x10` | RIS | RO | 原始中断状态 |
| `0x14` | MIS | RO | 屏蔽后中断状态 = `RIS & IE` |

CTRL 位定义：

| 位 | 名称 | 说明 |
|---|---|---|
| `[0]` | EN | 使能。由 0 写 1 时自动把 `LOAD` 装进 `VALUE` 并从头计数 |
| `[1]` | MODE | 1 = 周期模式（数到 0 自动重装 `LOAD`），0 = 单次模式（数到 0 自动清 EN） |
| `[2]` | IE | 中断使能 |
| `[15:8]` | PRESCALE | 分频比 = `PRESCALE + 1` 个 HCLK |

* 计数到 0 时置 `RIS[0]`
* `irq` 高有效电平 = `RIS[0] & IE`

## 6. APB UART（`apb_uart.v`，基址 `0x8000_2000`）

16550 风格最小集，16 倍过采样。

| 偏移 | 读 | 写 | 说明 |
|---|---|---|---|
| `0x00` | RBR | THR | 接收/发送数据；`DLAB=1` 时是除数低字节 DLL |
| `0x04` | IER | IER | 中断使能；`DLAB=1` 时是除数高字节 DLM |
| `0x08` | IIR | FCR | 中断标识 / FIFO 控制（FCR 只保存，不做 FIFO） |
| `0x0C` | LCR | LCR | 线路控制 |
| `0x14` | LSR | — | 线路状态 |

LCR：[1:0] 字长（00=5 … 11=8 位），[2] 停止位（0=1 位, 1=2 位），
[3] 校验使能，[4] 偶校验，[7] DLAB。

LSR：[0] DR（收到数据），[1] OE 溢出，[2] PE 校验错，[3] FE 帧错，
[5] THRE（THR 空，可写），[6] TEMT（发送完全空闲）。

IER：[0] 接收数据可用，[1] THR 空，[2] 线路状态。

中断行为：读 RBR 清 DR；读 IIR 清 THRE 中断；读 LSR 清 OE/PE/FE。
`irq` 高有效电平。

波特率 = `PCLK / (16 × {DLM,DLL})`。
`PCLK = 50MHz` 时，`DLL = 27` → 115740 baud（约 115200）。
**测试程序里用 `DLL = 1`（3.125Mbaud）只是为了让仿真里的文本尽快打完。**

## 7. 中断

`irq = timer_irq | uart_irq`，在 `soc_top.v` 里取反接到 ARM926EJ-S 的 `nIRQ`。
复位后 TIMER 的 IE=0、UART 的 IER=0，所以 `nIRQ` 保持高，不会误触发。

## 8. 文件

| 文件 | 说明 |
|---|---|
| `verilog/ahb2apb.v` | AHB→APB 桥 |
| `verilog/apb_bus.v` | APB 地址译码 + 读数据/响应 mux |
| `verilog/apb_led.v` | APB LED |
| `verilog/apb_timer.v` | APB TIMER |
| `verilog/apb_uart.v` | APB UART |
| `verilog/matrix_top.v` | 例化上面 5 个模块，接 `M_AHB_3`，引出 `uart_txd/uart_rxd/irq` |
| `verilog/soc_top.v` | 引出 `uart_rxd/uart_txd`，`nIRQ` 接外设中断 |
| `test_arm/tbench_top.v` | UART 环回 + 独立串口解码打印 + 结束标记 `$finish` |
| `software/apb_test.c` | ARM 裸机 APB 测试程序 |
| `software/apb_startup.S` | 带 IRQ 向量与处理程序的启动代码（配 `arm926.ld`） |
| `software/build_apb_test.sh` | 编译并安装 `memory.vh` 到 `sim_soc/` |
| `sim_soc/arm926fpga.f` | 编译文件列表，已加入 5 个新文件 |

原来的 `verilog/ahb_led.v`（`sram_led`）保留但不再例化。

**注意本项目与 `../work` 的差异**：本仓库的 `verilog/ddr3/*.v` 是修好的版本
（AXI ID 5 位原样透传），DDR 端口名是小写（`clk_ddr`/`ddr3_ck_p`），
`matrix_top.v` 里还带 `+define+DDR_AXI_LOG` 的 M_DDR_AXI 监控打印。
移植 APB 时这些都已保留，不要用 `work` 的版本覆盖。

## 9. 编译与仿真

```bash
# 1. 编译 ARM APB 测试程序并安装 ROM 镜像到 sim_soc/memory.vh
cd /home/ICer/ICproject/software
./build_apb_test.sh

#    （DDR 自测程序改用 ./build_ddr_test.sh，两者共用 arm926.ld）
#    （注意 build_ddr_test.sh 里的 SIMDIR 指向 /home/ICer/work/sim_soc，
#      在 ICproject 里用的话要先把它改成 ../sim_soc）

# 2. VCS 编译 + 仿真
cd /home/ICer/ICproject/sim_soc
source ~/.bashrc
source ./first.sh          # 设置 SYNOPSYS_SIM_SETUP
bash run_2_step.sh

# 3. 看波形
./run_wave.sh
```

本仓库的 `sim_soc/arm926fpga.f` 里用的是相对路径 `../ARM926EJS/...`，
而 ARM926EJ-S 模型是专有代码没有入库，所以需要先建一个软链接：

```bash
ln -sfn /home/ICer/work/ARM926EJS /home/ICer/ICproject/ARM926EJS
```

测试程序跑完会把 `0xEE` 写进 LED 寄存器，testbench 看到就 `$finish`，
所以仿真不会白跑到 10ms。

## 10. 验证结果（VCS 仿真，全部通过）

ARM 上真的走总线读写这三个 APB 外设；testbench 另外用一个**独立的串口线解码器**
（只用 `uart_txd` 这一根线的比特流，不引用 DUT 内部信号）把 8N1 数据解出来打印，
两条通路互为证据。

```
[1] APB LED                    PASS x2
[2] APB TIMER registers        PASS x3
[3] APB TIMER one-shot mode    PASS x3
[4] APB TIMER prescaler        PASS x1
[5] APB TIMER periodic + IRQ   PASS x2   真中断: irq -> ARM nIRQ -> 向量 0x18 -> 处理程序
[6] APB UART transmit          PASS x1
[7] APB UART loopback          PASS x2
[8] APB UART divisor latch     PASS x2
[9] APB UART RX interrupt      PASS x2
-----------------------------------------
RESULT: ALL PASS
```

本次仿真在 5.17ms 处由 `0xEE` 结束标记提前 `$finish`。

## 11. 两个容易踩的坑

1. **定时器中断周期必须大于中断处理程序的执行时间。**
   一次 APB 访问要穿过 `AHB → AXI → crossbar → AXI → AHB → APB`，
   实测处理一次中断大约 250~300 个 `HCLK`。如果周期比这还短（例如 `LOAD=50`），
   刚清完中断下一个马上又来，主程序永远拿不到执行时间，表现为"中断活锁"。
   测试里用 `LOAD = 2000`。

2. **tb 里 `txd` 短接到 `rxd`（环回），所以每一次打印都会被自己收回来。**
   而 RBR 只有 1 个字节，不读就会溢出（`LSR.OE=1`）。
   要读串口之前先 `等 LSR.TEMT`，再把 RBR / LSR 排空。

## 12. 合并到本仓库时的验证记录

APB 这套东西是在 `../work` 里做完后合并进本仓库的，合并时保住了本仓库自己的
DDR3 修改（5 位 AXI ID 透传、小写 DDR 端口名、`+define+DDR_AXI_LOG` 监控）。

合并后在本仓库 `sim_soc/` 里跑 VCS：

* **APB 测试（`software/build_apb_test.sh`）**：9 组 18 项 **全部 PASS**。
* **DDR3 自测（`software/build_ddr_test.sh`）**：LED 写 **0xA5（全部通过）**。

两个测试共用 `arm926.ld` 和 `bin2vh.py`，但用不同的启动代码
（`apb_startup.S` 带 IRQ 向量，`startup.S` 不带），脚本会自动把 `memory.vh`
装到 `sim_soc/`。想跑哪个就跑哪个的 build 脚本。

## 13. 顺带修掉的 DDR3 写通道 off-by-one

合并进来时 DDR 自测是失败的（LED=0x5A）。定位过程与结论：

**现象**（`M_DDR_AXI` 监控 + DDR 引脚探针）：读地址 A 总是返回 A+4 的数据。
最小化实验写 8 个不同值再读回，得到非常干净的规律：

```
写: 40000000<-11111111  40000004<-22222222  40000008<-33333333  4000000c<-44444444
读: 40000000->22222222  40000004->33333333  40000008->44444444  4000000c->00000000
```

即**存储内容实际是 `[d1, d2, d3, 0]`**——每个写突发的 (数据,掩码) 对整体
提前了一个 32 位 lane，第 4 个 lane 从来没被写入。

**排除项**：`ddr3_axi_pmem` 的 lane 选择（`resp_offset_w = addr_q[3:2]`）正确；
DFI 接口上的写数据/掩码正确（监控可见 lane k ← dk）；`TPHY_RDLAT=4` 的读采样
是对齐的（DFI valid 窗口与 DRAM 引脚 DQ 完全吻合）；读写列地址公式一致。

**根因**：`ddr3_dfi_phy.v` 里写数据只有 1 级流水

```verilog
dfi_wrdata_q <= dfi_wrdata_i;        // 只有 1 级
```

而 DQS 的输出使能路径是 3 级（`wr_valid_q0` → `wr_valid_q1` → `dqs_out_en_n_q`），
**写数据比 DQS 窗口早了一整个 DFI beat**，DRAM 就把每个写 beat 提前一个 lane 采走。

**修复**：给写数据和写掩码各补一级流水（同一个文件，仅此一处）

```verilog
dfi_wrdata_q1 <= dfi_wrdata_i;       // 新增
dfi_wrdata_q  <= dfi_wrdata_q1;      // 原来直连 dfi_wrdata_i
dfi_wr_mask_q1 <= dfi_wrdata_mask_i; // 掩码同步
dfi_wr_mask_q  <= dfi_wr_mask_q1;
```

修复后同样两笔实验：8 笔读全部精确返回写入值，DDR 自测 LED = **0xA5**。
`ddr3_dfi_seq.v` / `ddr3_core.v` / `ddr3_axi*.v` 一行未改。
