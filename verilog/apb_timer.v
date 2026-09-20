`timescale 1ns/1ns

// ============================================================================
// APB TIMER：单通道 32-bit 递减计数器
//
// 寄存器（基地址 0x8000_1000）
//   0x00  LOAD     RW  重装载值
//   0x04  VALUE    RO  当前计数值
//   0x08  CTRL     RW  [0] EN   [1] MODE(1=周期 0=单次)  [2] IE
//                      [15:8] PRESCALE  分频 = PRESCALE+1 个 HCLK
//   0x0C  INTCLR   WO  写 1 清中断
//   0x10  RIS      RO  原始中断状态
//   0x14  MIS      RO  屏蔽后中断状态 = RIS & IE
//
// 行为
//   * CTRL.EN 由 0 写 1 时，自动把 LOAD 装进 VALUE 并从头计数
//   * 计数到 0 时置 RIS；周期模式自动重装 LOAD，单次模式自动清 EN
//   * irq 为电平输出（高有效）= RIS & IE
// ============================================================================
module apb_timer (
    input  wire        PCLK,
    input  wire        PRESETn,

    // ---- APB 从接口 ----
    input  wire        PSEL,
    input  wire        PENABLE,
    input  wire        PWRITE,
    input  wire [31:0] PADDR,
    input  wire [31:0] PWDATA,
    output reg  [31:0] PRDATA,
    output wire        PREADY,
    output wire        PSLVERR,

    // ---- 中断 ----
    output wire        irq
);

    localparam OFF_LOAD   = 8'h00;
    localparam OFF_VALUE  = 8'h04;
    localparam OFF_CTRL   = 8'h08;
    localparam OFF_INTCLR = 8'h0C;
    localparam OFF_RIS    = 8'h10;
    localparam OFF_MIS    = 8'h14;

    wire [7:0] off    = PADDR[7:0];
    wire       access = PSEL && PENABLE;
    wire       wr     = access &&  PWRITE;
    wire       rd     = access && !PWRITE;

    wire hit = (off == OFF_LOAD)  || (off == OFF_VALUE) || (off == OFF_CTRL) ||
               (off == OFF_INTCLR)|| (off == OFF_RIS)   || (off == OFF_MIS);

    assign PREADY  = 1'b1;
    assign PSLVERR = access && !hit;

    reg [31:0] load_reg;
    reg [31:0] value_reg;
    reg        en_reg;
    reg        mode_reg;      // 1 = 周期, 0 = 单次
    reg        ie_reg;
    reg [7:0]  psc_reg;       // 预分频，分频比 = psc_reg + 1
    reg [7:0]  psc_cnt;
    reg        raw_int;

    // 预分频到点
    wire tick = en_reg && (psc_cnt == psc_reg);

    // CTRL 写且把 EN 从 0 抬到 1（启动）
    wire ctrl_start = wr && (off == OFF_CTRL) && PWDATA[0] && !en_reg;

    always @(posedge PCLK or negedge PRESETn) begin
        if (!PRESETn) begin
            load_reg  <= 32'd0;
            value_reg <= 32'd0;
            en_reg    <= 1'b0;
            mode_reg  <= 1'b0;
            ie_reg    <= 1'b0;
            psc_reg   <= 8'd0;
            psc_cnt   <= 8'd0;
            raw_int   <= 1'b0;
        end
        else begin
            // ---------------- 总线写 ----------------
            if (wr && (off == OFF_LOAD)) begin
                load_reg <= PWDATA;
                if (!en_reg) value_reg <= PWDATA;   // 停止时写 LOAD 直接装进计数器
            end

            if (wr && (off == OFF_INTCLR)) begin
                if (PWDATA[0]) raw_int <= 1'b0;   // 写 1 清中断
            end

            if (wr && (off == OFF_CTRL)) begin
                mode_reg <= PWDATA[1];
                ie_reg   <= PWDATA[2];
                psc_reg  <= PWDATA[15:8];
                if (PWDATA[0]) begin
                    en_reg <= 1'b1;
                    if (!en_reg) value_reg <= load_reg;   // 0->1 重新装载
                end
                else begin
                    en_reg <= 1'b0;
                end
            end

            // ---------------- 计数 ----------------
            if (ctrl_start) begin
                psc_cnt <= 8'd0;
            end
            else if (!en_reg) begin
                psc_cnt <= 8'd0;
            end
            else if (tick) begin
                psc_cnt <= 8'd0;
                if (value_reg == 32'd0) begin
                    raw_int <= 1'b1;
                    if (mode_reg) value_reg <= load_reg;   // 周期模式：重装
                    else          en_reg    <= 1'b0;       // 单次模式：停
                end
                else begin
                    value_reg <= value_reg - 32'd1;
                end
            end
            else begin
                psc_cnt <= psc_cnt + 8'd1;
            end
        end
    end

    // ---------------- 读数据 ----------------
    always @(*) begin
        case (off)
            OFF_LOAD : PRDATA = load_reg;
            OFF_VALUE: PRDATA = value_reg;
            OFF_CTRL : PRDATA = {16'b0, psc_reg, 5'b0, ie_reg, mode_reg, en_reg};
            OFF_RIS  : PRDATA = {31'b0, raw_int};
            OFF_MIS  : PRDATA = {31'b0, raw_int & ie_reg};
            default  : PRDATA = 32'h0;
        endcase
    end

    assign irq = raw_int & ie_reg;

endmodule
