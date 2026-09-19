`timescale 1ns/1ps
//=====================================================================
//  tbench_top.v  -  SoC + DDR3(x16 2Gb 单片) 仿真顶层
//
//  时钟：
//    clk        50MHz  (20ns)  -> SoC / AXI / DDR 控制器 AXI 侧
//    clk_ddr    200MHz (5ns)   -> = 4 x clk
//    clk_ddr90  200MHz, 移相 90 度
//    clk_ref    200MHz         -> IDELAYCTRL 参考时钟
//
//  DDR3 器件模型：Micron BFM（verilog/ddr3/model/ddr3.v）
//    - 需要 1ps 精度（本文件 timescale 已改 1ns/1ps）
//    - DEBUG=0 关掉器件模型自己的 $display（否则 refresh 刷屏）
//    - 数据默认写到 /tmp，可用 +model_data+<dir> 指定可写目录
//
//  UART：
//    - txd 直接环回接 rxd，用来验证 UART 的接收通路
//    - 另有一个独立的串口线解码器，把 txd 的比特流按 8N1 解出来打印
//=====================================================================
module tbench_top();

// ---- 时钟周期（ns）：改这里就能整体换频 ----
//     T_AXI=20 -> 50MHz（DDR 200MHz）
//     T_AXI=10 -> 100MHz（DDR 400MHz；此时请把 matrix_top 里 DDR_MHZ 改成 100）
localparam T_AXI   = 20.0;
localparam T_DDR   = T_AXI / 4.0;        // clk_ddr = 4 x T_AXI
localparam T_DDR90 = T_DDR * 3.0 / 4.0;  // 移相 90 度后的首次翻转时刻

reg        clk;
reg        reset_n;
reg        ntrst;

// ---- DDR 侧时钟 ----
reg        ddr_clk;
reg        ddr_clk90;
reg        ddr_clk_ref;

// ---- DDR3 引脚 ----
wire        ddr3_ck_p;
wire        ddr3_ck_n;
wire        ddr3_cke;
wire        ddr3_reset_n;
wire        ddr3_ras_n;
wire        ddr3_cas_n;
wire        ddr3_we_n;
wire        ddr3_cs_n;
wire [ 2:0] ddr3_ba;
wire [13:0] ddr3_addr;
wire        ddr3_odt;
wire [ 1:0] ddr3_dm;
wire [ 1:0] ddr3_dqs_p;
wire [ 1:0] ddr3_dqs_n;
wire [15:0] ddr3_dq;

// ---- UART / LED 观察 ----
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
    #10000000 $finish;
end

// SoC 时钟
initial begin
    #0       clk = 0;
    forever #(T_AXI/2.0)  clk <= ~clk;
end

// DDR 时钟：4 倍频 + 90 度移相 + IDELAYCTRL 参考
initial begin
    #0       ddr_clk = 1'b0;
    forever #(T_DDR/2.0) ddr_clk = ~ddr_clk;
end

initial begin
    #0       ddr_clk90 = 1'b0;
    #(T_DDR90) forever #(T_DDR/2.0) ddr_clk90 = ~ddr_clk90;
end

initial begin
    #0       ddr_clk_ref = 1'b0;
    forever #(T_DDR/2.0) ddr_clk_ref = ~ddr_clk_ref;
end

initial begin
    #0      reset_n = 0;
    #1500   reset_n = 1'b1;
end

initial begin
    #0     ntrst = 1;
    #130   ntrst = 0;
    #300   ntrst = 1;
end

initial begin
    #50
    force tbench_top.dut.u_ARM926EJS.uCORE.CP15DbgClkEn = 1'b1;
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

                // ---- UART ----
                .uart_rxd  (uart_rxd    ),
                .uart_txd  (uart_txd    ),

                // ---- DDR3 ----
                .clk_ddr        (ddr_clk        ),
                .clk_ddr90      (ddr_clk90      ),
                .clk_ref        (ddr_clk_ref    ),
                .ddr3_ck_p      (ddr3_ck_p      ),
                .ddr3_ck_n      (ddr3_ck_n      ),
                .ddr3_cke       (ddr3_cke       ),
                .ddr3_reset_n   (ddr3_reset_n   ),
                .ddr3_ras_n     (ddr3_ras_n     ),
                .ddr3_cas_n     (ddr3_cas_n     ),
                .ddr3_we_n      (ddr3_we_n      ),
                .ddr3_cs_n      (ddr3_cs_n      ),
                .ddr3_ba        (ddr3_ba[2:0]   ),
                .ddr3_addr      (ddr3_addr[13:0]),
                .ddr3_odt       (ddr3_odt       ),
                .ddr3_dm        (ddr3_dm[1:0]   ),
                .ddr3_dqs_p     (ddr3_dqs_p[1:0]),
                .ddr3_dqs_n     (ddr3_dqs_n[1:0]),
                .ddr3_dq        (ddr3_dq[15:0]  )
                );

//=====================================================================
//  DDR3 器件模型：单片 x16 2Gb（Micron BFM）
//    DEBUG=0：关掉模型自己的 $display，DDR3 的读写数据看 matrix_top 里
//             +define+DDR_AXI_LOG 打开的 M_DDR_AXI 监控打印
//=====================================================================
ddr3 #(.DEBUG(0)) u_ddr3 (
     .rst_n     (ddr3_reset_n   )
    ,.ck        (ddr3_ck_p      )
    ,.ck_n      (ddr3_ck_n      )
    ,.cke       (ddr3_cke       )
    ,.cs_n      (ddr3_cs_n      )
    ,.ras_n     (ddr3_ras_n     )
    ,.cas_n     (ddr3_cas_n     )
    ,.we_n      (ddr3_we_n      )
    ,.dm_tdqs   (ddr3_dm[1:0]   )
    ,.ba        (ddr3_ba[2:0]   )
    ,.addr      (ddr3_addr[13:0])
    ,.dq        (ddr3_dq[15:0]  )
    ,.dqs       (ddr3_dqs_p[1:0])
    ,.dqs_n     (ddr3_dqs_n[1:0])
    ,.tdqs_n    (               )
    ,.odt       (ddr3_odt       )
);

//=====================================================================
//  LED 观察 + 测试结束标记
//    测试程序跑完会写 0xEE 到 LED，看到就 $finish（不用等满 10ms）
//=====================================================================
always @(led_dbg) begin
    $display("[%0t] TB: LED = 0x%02h", $time, led_dbg);
    if (led_dbg == 8'hEE) begin
        $display("[%0t] TB: 收到测试结束标记 0xEE, $finish", $time);
        $finish;
    end
end

//=====================================================================
//  调试探针：看 irq 线和 TIMER 的中断状态有没有动（只打前 12 次）
//=====================================================================
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

//=====================================================================
//  UART 线监控：把 uart_txd 按 8N1 解出来打印
//    测试程序里 divisor = 1 -> 波特率 = 50e6/16 = 3.125Mbaud
//    一位的时间 = 16 * 1 * T_AXI = 320ns
//  这是一条独立于 DUT 的证据：CPU 写 THR 的字符确实按串行时序发出来了
//=====================================================================
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
