`timescale 1ns/1ns

// ============================================================================
// APB UART（16550 风格最小集）
//
// 寄存器（基地址 0x8000_2000，PADDR[7:0] 为偏移）
//   0x00  RBR (读) / THR (写) / DLL (读写, DLAB=1)
//   0x04  IER (读写)          / DLM (读写, DLAB=1)
//   0x08  IIR (读)            / FCR (写，只保存，不做 FIFO)
//   0x0C  LCR (读写)  [1:0]字长(00=5..11=8) [2]停止位 [3]校验使能
//                     [4]偶校验 [7]DLAB
//   0x14  LSR (读)    [0]DR [1]OE [2]PE [3]FE [5]THRE [6]TEMT
//
// 特性
//   * 16 位除数锁存 {DLM,DLL}，波特率 = PCLK / (16 * divisor)
//   * 16 倍过采样、起始位中点校验、可选校验位/停止位
//   * 中断（高有效电平）：IER[0]接收数据可用 IER[1]THR 空 IER[2]线路状态
//   * IIR 读清 THRE 中断；读 RBR 清 DR；读 LSR 清 OE/PE/FE
// ============================================================================
module apb_uart (
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

    // ---- 串口 ----
    input  wire        uart_rxd,
    output wire        uart_txd,

    // ---- 中断 ----
    output wire        irq
);

    localparam OFF_RBR_THR_DLL = 8'h00;
    localparam OFF_IER_DLM     = 8'h04;
    localparam OFF_IIR_FCR     = 8'h08;
    localparam OFF_LCR         = 8'h0C;
    localparam OFF_LSR         = 8'h14;

    wire [7:0] off    = PADDR[7:0];
    wire       access = PSEL && PENABLE;
    wire       wr     = access &&  PWRITE;
    wire       rd     = access && !PWRITE;

    wire hit = (off == OFF_RBR_THR_DLL) || (off == OFF_IER_DLM) ||
               (off == OFF_IIR_FCR)     || (off == OFF_LCR)     ||
               (off == OFF_LSR);

    assign PREADY  = 1'b1;
    assign PSLVERR = access && !hit;

    // ---------------- 寄存器 ----------------
    reg [7:0] dll, dlm;
    reg [7:0] ier;
    reg [7:0] lcr;
    reg [7:0] fcr;
    reg [7:0] rbr;
    reg       dr;
    reg [7:0] thr;
    reg       thr_full;
    reg       thre_int;
    reg       rx_oe, rx_pe, rx_fe;

    wire       dlab     = lcr[7];
    wire       par_en   = lcr[3];
    wire       par_even = lcr[4];
    wire       two_stop = lcr[2];
    wire [3:0] nbits    = 4'd5 + {2'b0, lcr[1:0]};   // 5 ~ 8 位数据

    wire wr_thr = wr && (off == OFF_RBR_THR_DLL) && !dlab;
    wire wr_dll = wr && (off == OFF_RBR_THR_DLL) &&  dlab;
    wire wr_ier = wr && (off == OFF_IER_DLM)     && !dlab;
    wire wr_dlm = wr && (off == OFF_IER_DLM)     &&  dlab;
    wire wr_fcr = wr && (off == OFF_IIR_FCR);
    wire wr_lcr = wr && (off == OFF_LCR);

    wire rd_rbr = rd && (off == OFF_RBR_THR_DLL) && !dlab;
    wire rd_iir = rd && (off == OFF_IIR_FCR);
    wire rd_lsr = rd && (off == OFF_LSR);

    // ---------------- 波特率发生器（16 倍过采样） ----------------
    wire [15:0] divisor   = ((dlm == 8'd0) && (dll == 8'd0)) ? 16'd1 : {dlm, dll};
    reg  [15:0] baud_cnt;
    wire        baud_tick = (baud_cnt >= (divisor - 16'd1));

    // ---------------- 接收输入同步 ----------------
    reg rx_s0, rx_s1;

    // ---------------- 发送状态机 ----------------
    localparam T_IDLE = 3'd0, T_START = 3'd1, T_DATA = 3'd2, T_PARITY = 3'd3, T_STOP = 3'd4;
    reg [2:0] tx_st;
    reg [3:0] tx_tick;
    reg [3:0] tx_idx;
    reg [7:0] tx_sr;
    reg       tx_par;
    reg       txd_r;
    reg       stop_sent;

    // ---------------- 接收状态机 ----------------
    localparam R_IDLE = 3'd0, R_START = 3'd1, R_DATA = 3'd2, R_PARITY = 3'd3, R_STOP = 3'd4;
    reg [2:0] rx_st;
    reg [3:0] rx_tick;
    reg [3:0] rx_idx;
    reg [7:0] rx_sr;
    reg       rx_par_bit;

    assign uart_txd = txd_r;

    // ============================================================
    //  一个 always 块统管：寄存器写 + 收发状态机（避免多驱动）
    // ============================================================
    always @(posedge PCLK or negedge PRESETn) begin
        if (!PRESETn) begin
            dll       <= 8'd0;
            dlm       <= 8'd0;
            ier       <= 8'd0;
            lcr       <= 8'd0;
            fcr       <= 8'd0;
            rbr       <= 8'd0;
            dr        <= 1'b0;
            thr       <= 8'd0;
            thr_full  <= 1'b0;
            thre_int  <= 1'b0;
            rx_oe     <= 1'b0;
            rx_pe     <= 1'b0;
            rx_fe     <= 1'b0;
            baud_cnt  <= 16'd0;
            rx_s0     <= 1'b1;
            rx_s1     <= 1'b1;
            tx_st     <= T_IDLE;
            tx_tick   <= 4'd0;
            tx_idx    <= 4'd0;
            tx_sr     <= 8'd0;
            tx_par    <= 1'b0;
            txd_r     <= 1'b1;
            stop_sent <= 1'b0;
            rx_st     <= R_IDLE;
            rx_tick   <= 4'd0;
            rx_idx    <= 4'd0;
            rx_sr     <= 8'd0;
            rx_par_bit<= 1'b0;
        end
        else begin
            // ---------------- 波特率计数 ----------------
            if (baud_tick) baud_cnt <= 16'd0;
            else           baud_cnt <= baud_cnt + 16'd1;

            // ---------------- 输入同步 ----------------
            rx_s0 <= uart_rxd;
            rx_s1 <= rx_s0;

            // ---------------- 总线写 ----------------
            if (wr_dll) dll <= PWDATA[7:0];
            if (wr_dlm) dlm <= PWDATA[7:0];
            if (wr_ier) ier <= PWDATA[7:0];
            if (wr_fcr) fcr <= PWDATA[7:0];
            if (wr_lcr) lcr <= PWDATA[7:0];

            if (wr_thr) begin
                thr      <= PWDATA[7:0];
                thr_full <= 1'b1;
                thre_int <= 1'b0;          // 写 THR 清 THRE 中断
            end

            if (rd_rbr) dr     <= 1'b0;    // 读 RBR 清 DR
            if (rd_iir) thre_int <= 1'b0;  // 读 IIR 清 THRE 中断
            if (rd_lsr) begin
                rx_oe <= 1'b0;
                rx_pe <= 1'b0;
                rx_fe <= 1'b0;
            end

            // ---------------- 发送 ----------------
            if (baud_tick) begin
                case (tx_st)
                    T_IDLE: begin
                        if (thr_full && !wr_thr) begin
                            tx_sr     <= thr;
                            tx_par    <= par_even ? ~^thr : ^thr;
                            thr_full  <= 1'b0;
                            thre_int  <= 1'b1;      // THR 空
                            txd_r     <= 1'b0;      // 起始位
                            tx_idx    <= 4'd0;
                            tx_tick   <= 4'd0;
                            stop_sent <= 1'b0;
                            tx_st     <= T_START;
                        end
                    end

                    T_START: begin
                        if (tx_tick == 4'd15) begin
                            tx_tick <= 4'd0;
                            txd_r   <= tx_sr[0];
                            tx_sr   <= {1'b0, tx_sr[7:1]};
                            tx_idx  <= 4'd1;
                            tx_st   <= T_DATA;
                        end
                        else tx_tick <= tx_tick + 4'd1;
                    end

                    T_DATA: begin
                        if (tx_tick == 4'd15) begin
                            tx_tick <= 4'd0;
                            if (tx_idx == nbits) begin
                                if (par_en) begin
                                    txd_r <= tx_par;
                                    tx_st <= T_PARITY;
                                end
                                else begin
                                    txd_r <= 1'b1;
                                    tx_st <= T_STOP;
                                end
                            end
                            else begin
                                txd_r  <= tx_sr[0];
                                tx_sr  <= {1'b0, tx_sr[7:1]};
                                tx_idx <= tx_idx + 4'd1;
                            end
                        end
                        else tx_tick <= tx_tick + 4'd1;
                    end

                    T_PARITY: begin
                        if (tx_tick == 4'd15) begin
                            tx_tick <= 4'd0;
                            txd_r   <= 1'b1;
                            tx_st   <= T_STOP;
                        end
                        else tx_tick <= tx_tick + 4'd1;
                    end

                    T_STOP: begin
                        if (tx_tick == 4'd15) begin
                            tx_tick <= 4'd0;
                            if (two_stop && !stop_sent) begin
                                stop_sent <= 1'b1;      // 第二个停止位
                            end
                            else begin
                                tx_st <= T_IDLE;
                            end
                        end
                        else tx_tick <= tx_tick + 4'd1;
                    end

                    default: tx_st <= T_IDLE;
                endcase
            end

            // ---------------- 接收 ----------------
            if (baud_tick) begin
                case (rx_st)
                    R_IDLE: begin
                        if (!rx_s1) begin          // 起始位下降沿
                            rx_tick <= 4'd0;
                            rx_st   <= R_START;
                        end
                    end

                    R_START: begin
                        if (rx_tick == 4'd7) begin     // 起始位中点
                            rx_tick <= 4'd0;
                            if (!rx_s1) begin
                                rx_idx <= 4'd0;
                                rx_sr  <= 8'd0;
                                rx_st  <= R_DATA;
                            end
                            else rx_st <= R_IDLE;      // 假起始位
                        end
                        else rx_tick <= rx_tick + 4'd1;
                    end

                    R_DATA: begin
                        if (rx_tick == 4'd15) begin
                            rx_tick <= 4'd0;
                            rx_sr   <= {rx_s1, rx_sr[7:1]};   // LSB 先收
                            if (rx_idx == (nbits - 4'd1)) begin
                                if (par_en) rx_st <= R_PARITY;
                                else        rx_st <= R_STOP;
                            end
                            else rx_idx <= rx_idx + 4'd1;
                        end
                        else rx_tick <= rx_tick + 4'd1;
                    end

                    R_PARITY: begin
                        if (rx_tick == 4'd15) begin
                            rx_tick     <= 4'd0;
                            rx_par_bit  <= rx_s1;
                            rx_st       <= R_STOP;
                        end
                        else rx_tick <= rx_tick + 4'd1;
                    end

                    R_STOP: begin
                        if (rx_tick == 4'd15) begin
                            rx_tick <= 4'd0;
                            rx_st   <= R_IDLE;
                            if (!rx_s1) rx_fe <= 1'b1;                        // 帧错误
                            if (par_en && (rx_par_bit != (par_even ? ~^rx_sr : ^rx_sr)))
                                rx_pe <= 1'b1;                                // 校验错误
                            if (dr) rx_oe <= 1'b1;                            // 溢出
                            else begin
                                rbr <= rx_sr;
                                dr  <= 1'b1;
                            end
                        end
                        else rx_tick <= rx_tick + 4'd1;
                    end

                    default: rx_st <= R_IDLE;
                endcase
            end
        end
    end

    // ---------------- 状态与中断 ----------------
    wire temt = ~thr_full && (tx_st == T_IDLE);

    wire [7:0] lsr_val = {1'b0, temt, ~thr_full, 1'b0, rx_fe, rx_pe, rx_oe, dr};

    wire int_rda  = dr & ier[0];
    wire int_thre = thre_int & ier[1];
    wire int_ls   = (rx_oe | rx_pe | rx_fe) & ier[2];

    assign irq = int_rda | int_thre | int_ls;

    wire [7:0] iir_val = int_rda  ? 8'h04 :
                         int_thre ? 8'h02 :
                         int_ls   ? 8'h06 : 8'h01;

    // ---------------- 读数据 ----------------
    always @(*) begin
        if (dlab && (off == OFF_RBR_THR_DLL))     PRDATA = {24'b0, dll};
        else if (dlab && (off == OFF_IER_DLM))    PRDATA = {24'b0, dlm};
        else case (off)
            OFF_RBR_THR_DLL: PRDATA = {24'b0, rbr};
            OFF_IER_DLM    : PRDATA = {24'b0, ier};
            OFF_IIR_FCR    : PRDATA = {24'b0, iir_val};
            OFF_LCR        : PRDATA = {24'b0, lcr};
            OFF_LSR        : PRDATA = {24'b0, lsr_val};
            default        : PRDATA = 32'h0000_0000;
        endcase
    end

endmodule
