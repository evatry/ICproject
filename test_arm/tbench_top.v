`timescale 1ns/1ps
//=====================================================================
//  tbench_top.v  -  SoC + DDR3(x16 2Gb 单片) + APB(LED/TIMER/UART) 仿真顶层
//
//  时钟：
//    clk        50MHz  (20ns)  -> SoC / AXI / DDR 控制器 AXI 侧
//    clk_ddr    200MHz (5ns)   -> = 4 x clk
//    clk_ddr90  200MHz，相对 clk_ddr 移相 270 度 (= -90 度, 3.75ns)
//    clk_ref    200MHz         -> IDELAYCTRL 参考时钟
//
//  DDR3 器件模型：Micron BFM（verilog/ddr3/model/ddr3.v）
//    - DEBUG=0 关掉模型自身的 $display
//    - M_DDR_AXI 的 AXI 读写数据由 matrix_top.v 里 +define+DDR_AXI_LOG 打开
//
//  APB 外设（0x8000_0000 LED / 0x8000_1000 TIMER / 0x8000_2000 UART）：
//    - uart_txd 直接环回接 uart_rxd，用来验证 UART 收发通路
//    - 另有一个独立的串口线解码器，把 txd 的比特流按 8N1 解出来打印
//    - LED 出现 0xEE = 测试程序跑完，testbench 直接 $finish
//=====================================================================
module tbench_top();

// UART 线解码用：AXI 时钟周期（ns）
localparam real T_AXI = 20.0;

reg        clk;
reg        reset_n;
reg        ntrst;

// ============================================================
// DDR3 时钟
//   clk_ddr    = 200MHz = 4 x clk
//   clk_ddr90  = 200MHz，相对 clk_ddr 移相 270 度 (= -90 度, 3.75ns)
//                注：写 DQS 用 clk_ddr90 产生，+90 度(1.25ns) 会让 Micron 模型
//                报 tDQSS/tDSH 违规（实测 0.625~1.875ns 为坏区），
//                取 -90 度后 tDQSS/tDSH 全部干净，功能不受影响
//   clk_ref    = 200MHz, 供 IDELAYCTRL
// ============================================================
reg        clk_ddr;
reg        clk_ddr90;
reg        clk_ref;

// ============================================================
// DDR3 器件引脚 (soc_top <-> Micron 模型)
// ============================================================
wire        ddr3_ck_p;
wire        ddr3_ck_n;
wire        ddr3_cke;
wire        ddr3_reset_n;
wire        ddr3_ras_n;
wire        ddr3_cas_n;
wire        ddr3_we_n;
wire        ddr3_cs_n;
wire [2:0]  ddr3_ba;
wire [13:0] ddr3_addr;
wire        ddr3_odt;
wire [1:0]  ddr3_dm;
wire [1:0]  ddr3_dqs_p;
wire [1:0]  ddr3_dqs_n;
wire [15:0] ddr3_dq;

// ============================================================
// APB 外设：UART / LED
// ============================================================
wire        uart_txd;
wire        uart_rxd;
wire [7:0]  led_dbg;

assign uart_rxd = uart_txd;      // 自发自收环回，用来验证 UART 的 RX 通路

initial
begin
    $fsdbDumpfile("wave.fsdb");
    $fsdbDumpvars(0,tbench_top);
end

initial begin
    #10000000 $finish;           // 10ms 兜底；正常由 LED=0xEE 提前结束
end

initial begin
    #0       clk = 0;
    forever #10  clk <= ~clk;
end

initial begin
    #0      reset_n = 0;
    #1500    reset_n = 1'b1;
    end

initial begin
    #0     ntrst =1;
    #130   ntrst =0;
    #300   ntrst =1;
    end

initial begin
    #50
    force tbench_top.dut.u_ARM926EJS.uCORE.CP15DbgClkEn = 1'b1;
end

// ---------------- DDR3 时钟产生 ----------------
initial begin
    clk_ddr = 1'b1;
    forever #2.5 clk_ddr = ~clk_ddr;
end

initial begin
    clk_ddr90 = 1'b0;
    #3.75;
    forever #2.5 clk_ddr90 = ~clk_ddr90;
end

initial begin
    clk_ref = 1'b0;
    forever #2.5 clk_ref = ~clk_ref;
end


soc_top dut(     
                .CLK       (clk         ),
                .TDO       (            ),
                .nTDOEN    (            ),
                .HRESETn   (reset_n     ),
                .RTCK      (            ),
                .TCK       (1'b0        ),
                .TMS       (1'b0        ),
                .TDI       (1'b0        ),
                .nTRST     (ntrst       ),
                .led       (led_dbg     ),

                // ---- APB UART ----
                .uart_rxd  (uart_rxd    ),
                .uart_txd  (uart_txd    ),

                // ---- DDR3 ----
                .clk_ddr    (clk_ddr    ),
                .clk_ddr90  (clk_ddr90  ),
                .clk_ref    (clk_ref    ),
                .ddr3_ck_p  (ddr3_ck_p  ),
                .ddr3_ck_n  (ddr3_ck_n  ),
                .ddr3_cke   (ddr3_cke   ),
                .ddr3_reset_n(ddr3_reset_n),
                .ddr3_ras_n (ddr3_ras_n ),
                .ddr3_cas_n (ddr3_cas_n ),
                .ddr3_we_n  (ddr3_we_n  ),
                .ddr3_cs_n  (ddr3_cs_n  ),
                .ddr3_ba    (ddr3_ba    ),
                .ddr3_addr  (ddr3_addr  ),
                .ddr3_odt   (ddr3_odt   ),
                .ddr3_dm    (ddr3_dm    ),
                .ddr3_dqs_p (ddr3_dqs_p ),
                .ddr3_dqs_n (ddr3_dqs_n ),
                .ddr3_dq    (ddr3_dq    )
                );

// ============================================================
// Micron DDR3 x16 2Gb 器件模型 (2048Mb_ddr3_parameters.vh -> x16)
//   DEBUG=0: 关掉模型自身的 INFO/WRITE/READ 打印，
//            仿真日志里只看 M_DDR_AXI 的 AXI 读写数据
// ============================================================
ddr3 #(
     .DEBUG                (0)
    ,.check_strict_mrbits (1)
    ,.check_strict_timing (0)       // 仿真时钟 200MHz 低于 DDR3-800 标称，关闭严格时序检查
    ,.feature_pasr        (1)
    ,.feature_truebl4     (0)
    ,.feature_odt_hi      (0)
) u_ddr3_model (
     .rst_n     (ddr3_reset_n)
    ,.ck        (ddr3_ck_p)
    ,.ck_n      (ddr3_ck_n)
    ,.cke       (ddr3_cke)
    ,.cs_n      (ddr3_cs_n)
    ,.ras_n     (ddr3_ras_n)
    ,.cas_n     (ddr3_cas_n)
    ,.we_n      (ddr3_we_n)
    ,.dm_tdqs   (ddr3_dm[1:0])
    ,.ba        (ddr3_ba[2:0])
    ,.addr      (ddr3_addr[13:0])
    ,.dq        (ddr3_dq[15:0])
    ,.dqs       (ddr3_dqs_p[1:0])
    ,.dqs_n     (ddr3_dqs_n[1:0])
    ,.tdqs_n    ()
    ,.odt       (ddr3_odt)
);


// =====================================================================
//  LED 观察 + 测试结束标记
//    APB 测试程序跑完会写 0xEE 到 LED，看到就 $finish（不用等满 10ms）
// =====================================================================
always @(led_dbg) begin
    $display("[%0t] TB: LED = 0x%02h", $time, led_dbg);
    if (led_dbg == 8'hEE) begin
        $display("[%0t] TB: 收到测试结束标记 0xEE, $finish", $time);
        $finish;
    end
end

// =====================================================================
//  调试探针：看 irq 线和 TIMER 的原始中断有没有动（只打前 12 次）
// =====================================================================
integer dbg_irq_n = 0;
integer dbg_raw_n = 0;

always @(posedge dut.irq) begin
    dbg_irq_n = dbg_irq_n + 1;
    if (dbg_irq_n <= 12)
        $display("[%0t] TB: irq 上升沿 #%0d", $time, dbg_irq_n);
end

always @(dut.u_matrix_top.u_apb_timer.raw_int) begin
    dbg_raw_n = dbg_raw_n + 1;
    if (dbg_raw_n <= 12)
        $display("[%0t] TB: timer raw_int -> %b", $time, dut.u_matrix_top.u_apb_timer.raw_int);
end

// =====================================================================
//  UART 线监控：把 uart_txd 按 8N1 解出来打印
//    测试程序里 divisor = 1 -> 波特率 = 50e6/16 = 3.125Mbaud
//    一位的时间 = 16 * 1 * T_AXI = 320ns
//  这是一条独立于 DUT 的证据：CPU 写 THR 的字符确实按串行时序发出来了
// =====================================================================
localparam real UART_BIT_NS = 16.0 * 1.0 * T_AXI;

integer    uart_i;
reg [7:0]  uart_rx_byte;

initial begin
    uart_rx_byte = 8'h00;
    forever begin
        @(negedge uart_txd);                     // 起始位
        #(UART_BIT_NS * 1.5);                    // 跳到 bit0 中点
        for (uart_i = 0; uart_i < 8; uart_i = uart_i + 1) begin
            uart_rx_byte[uart_i] = uart_txd;
            #(UART_BIT_NS);
        end
        $write("[%0t] TB: UART 线解码 = 0x%02h '%c'\n", $time, uart_rx_byte, uart_rx_byte);
        $fflush;
    end
end


endmodule
