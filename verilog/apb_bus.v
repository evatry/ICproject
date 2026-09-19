`timescale 1ns/1ns

// ============================================================================
// APB 外设总线：1 主 -> 3 从 的地址译码 + 读数据/响应多路选择
//
// 地址映射（都落在 M_AHB_3 的 0x8000_0000 / 16M 外设窗口里）
//   0x8000_0000   APB LED     (PADDR[15:12] = 0)
//   0x8000_1000   APB TIMER   (PADDR[15:12] = 1)
//   0x8000_2000   APB UART    (PADDR[15:12] = 2)
//   其它          未映射 -> PREADY=1, PSLVERR=1（AHB 侧变成 ERROR 响应）
// ============================================================================
module apb_bus (
    input  wire [31:0] PADDR,

    input  wire        PSEL,

    output wire        PSEL_LED,
    output wire        PSEL_TIMER,
    output wire        PSEL_UART,

    input  wire [31:0] PRDATA_LED,
    input  wire [31:0] PRDATA_TIMER,
    input  wire [31:0] PRDATA_UART,

    input  wire        PREADY_LED,
    input  wire        PREADY_TIMER,
    input  wire        PREADY_UART,

    input  wire        PSLVERR_LED,
    input  wire        PSLVERR_TIMER,
    input  wire        PSLVERR_UART,

    output reg  [31:0] PRDATA,
    output wire        PREADY,
    output wire        PSLVERR
);

    localparam DEV_LED   = 4'h0;
    localparam DEV_TIMER = 4'h1;
    localparam DEV_UART  = 4'h2;

    wire [3:0] dev = PADDR[15:12];

    assign PSEL_LED   = PSEL && (dev == DEV_LED);
    assign PSEL_TIMER = PSEL && (dev == DEV_TIMER);
    assign PSEL_UART  = PSEL && (dev == DEV_UART);

    always @(*) begin
        case (dev)
            DEV_LED  : PRDATA = PRDATA_LED;
            DEV_TIMER: PRDATA = PRDATA_TIMER;
            DEV_UART : PRDATA = PRDATA_UART;
            default  : PRDATA = 32'hDEAD_BEEF;   // 未映射地址的回读标记
        endcase
    end

    assign PREADY  = (dev == DEV_LED)   ? PREADY_LED   :
                     (dev == DEV_TIMER) ? PREADY_TIMER :
                     (dev == DEV_UART)  ? PREADY_UART  : 1'b1;

    assign PSLVERR = (dev == DEV_LED)   ? PSLVERR_LED   :
                     (dev == DEV_TIMER) ? PSLVERR_TIMER :
                     (dev == DEV_UART)  ? PSLVERR_UART  : 1'b1;

endmodule
