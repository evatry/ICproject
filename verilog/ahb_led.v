module sram_led (
    input         HCLK,          // 系统时钟
    input         HRESETn,       // 系统复位（低有效）
    input  [13:0] SRAM_A,        // 地址总线（低14位）
    input  [31:0] SRAM_WDATA,    // 写数据
    output [31:0] SRAM_RDATA,    // 读数据
    input         SRAM_CE_N,     // 片选（低有效）
    input         SRAM_OE_N,     // 输出使能（低有效）
    input  [3:0]  SRAM_WE_N,     // 字节写使能（低有效）
    output [7:0]  led_out        // LED 输出
);

    // ---------- 8位 LED 寄存器 ----------
    reg [7:0] led_reg;

    // ---------- 同步写操作 ----------
    // 条件：片选有效、写使能低字节有效、地址匹配 0x8000_0000
    // 注意：SRAM_WE_N[0] 低表示写有效，且写使能信号在时钟上升沿被采样
    always @(posedge HCLK or negedge HRESETn) begin
        if (!HRESETn) begin
            led_reg <= 8'b0;
        end else begin
            if (~SRAM_CE_N && ~SRAM_WE_N[0] && (SRAM_A == 14'h0000)) begin
                led_reg <= SRAM_WDATA[7:0];
                // 仿真打印（仅在仿真时输出）
                $display("Time %t: LED write, value = 0x%02X", $time, SRAM_WDATA[7:0]);
            end
        end
    end

    // ---------- 读操作（组合逻辑） ----------
    // 当片选和输出使能有效时，返回寄存器值（高位补零），否则高阻
    assign SRAM_RDATA = (~SRAM_CE_N && ~SRAM_OE_N) ? {24'b0, led_reg} : 32'bz;

    // ---------- 输出 LED ----------
    assign led_out = led_reg;

endmodule
