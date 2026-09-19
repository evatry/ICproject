`ifndef SDL
    `define SDL 0.1
`endif

`timescale 1ns/1ns

// ============================================================================
// AHB -> APB 桥 (AHB-Lite slave / APB master)
//
// 协议要点
// ----------------------------------------------------------------------------
// APB 一次传输至少需要两个周期：SETUP(PSEL=1,PENABLE=0) 和
// ACCESS(PSEL=1,PENABLE=1)。而 AHB 的地址相位和数据相位是流水的
// （第 X 笔传输的数据相位那一拍，主设备已经在给第 X+1 笔的地址了），
// 所以桥必须：
//   * HREADY：IDLE 和 ACCESS 拉高，SETUP 拉低 -> 给 AHB 插 1 个等待周期
//   * 在 HREADY 为高的那一拍抓地址：
//       - IDLE  抓到的是当前这笔
//       - ACCESS 抓到的是流水线里的下一笔
//
// 时序（连续传输，PREADY=1）
// ----------------------------------------------------------------------------
//   c1 IDLE   : HTRANS=X 有效, HREADY=1 -> 接受 X 的地址, 抓 X, -> SETUP
//   c2 SETUP  : PSEL=1 PENABLE=0 PADDR=X, HREADY=0 -> X 的数据相位被拉长
//   c3 ACCESS : PSEL=1 PENABLE=1 PADDR=X PWDATA=X的数据,
//               HREADY=1 -> X 完成, 同时抓到流水线里的 X+1, -> SETUP
//   c4 SETUP  : X+1 的 SETUP ...
//   => 稳定后每 2 个 HCLK 完成一次 APB 访问
// ============================================================================
module ahb2apb (
    input  wire        HCLK,
    input  wire        HRESETn,

    // ---- AHB 从接口 ----
    input  wire        HSEL,
    input  wire [31:0] HADDR,
    input  wire [1:0]  HTRANS,
    input  wire        HWRITE,
    input  wire [31:0] HWDATA,
    output wire [31:0] HRDATA,
    output wire        HREADY,
    output wire [1:0]  HRESP,

    // ---- APB 主接口 ----
    output wire        PSEL,
    output wire        PENABLE,
    output wire        PWRITE,
    output wire [31:0] PADDR,
    output wire [31:0] PWDATA,
    input  wire [31:0] PRDATA,
    input  wire        PREADY,
    input  wire        PSLVERR
);

    localparam ST_IDLE   = 2'd0;
    localparam ST_SETUP  = 2'd1;
    localparam ST_ACCESS = 2'd2;

    reg [1:0]  state;
    reg [31:0] addr_reg;
    reg        write_reg;

    // HTRANS[1]=1 表示 NONSEQ/SEQ，即有效传输
    wire htrans_valid = HSEL && HTRANS[1];

    // HREADY: IDLE=1, SETUP=0(插等待), ACCESS=跟随 APB 的 PREADY
    assign HREADY = (state == ST_IDLE)   ? 1'b1     :
                    (state == ST_ACCESS) ? PREADY   : 1'b0;

    // 地址相位被接受：HREADY 为高的那一拍
    wire capture = htrans_valid && HREADY;

    assign PSEL    = (state == ST_SETUP) || (state == ST_ACCESS);
    assign PENABLE = (state == ST_ACCESS);
    assign PADDR   = addr_reg;
    assign PWRITE  = write_reg;
    // HWDATA 在数据相位有效，而 ACCESS 正好落在数据相位上，直接透传
    assign PWDATA  = HWDATA;

    assign HRDATA  = PRDATA;
    assign HRESP   = (state == ST_ACCESS && PSLVERR) ? 2'b01 : 2'b00;

    always @(posedge HCLK or negedge HRESETn) begin
        if (!HRESETn) begin
            state     <= ST_IDLE;
            addr_reg  <= 32'b0;
            write_reg <= 1'b0;
        end
        else begin
            if (capture) begin
                addr_reg  <= HADDR;
                write_reg <= HWRITE;
            end

            case (state)
                ST_IDLE  : if (capture)  state <= ST_SETUP;
                ST_SETUP :               state <= ST_ACCESS;
                ST_ACCESS: if (PREADY)   state <= capture ? ST_SETUP : ST_IDLE;
                default  :               state <= ST_IDLE;
            endcase
        end
    end

endmodule
