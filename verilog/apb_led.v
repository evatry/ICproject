`timescale 1ns/1ns

// ============================================================================
// APB LED（原来挂在 AHB 上的 sram_led 改成 APB 从设备）
//
// 寄存器
//   0x00  LED   RW[7:0]   写 1 点亮
// 基地址 0x8000_0000（由 apb_bus 译码）
// ============================================================================
module apb_led (
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

    // ---- LED 输出 ----
    output wire [7:0]  led_out
);

    localparam OFF_LED = 8'h00;

    wire [7:0] off    = PADDR[7:0];
    wire       access = PSEL && PENABLE;      // APB ACCESS 相位
    wire       hit    = (off == OFF_LED);

    reg [7:0] led_reg;

    assign PREADY  = 1'b1;                    // 零等待
    assign PSLVERR = access && !hit;

    always @(posedge PCLK or negedge PRESETn) begin
        if (!PRESETn) begin
            led_reg <= 8'h00;
        end
        else if (access && PWRITE && hit) begin
            led_reg <= PWDATA[7:0];
            $display("[%0t] APB LED   写 0x%08h = 0x%02h", $time, PADDR, PWDATA[7:0]);
        end
    end

    always @(*) begin
        case (off)
            OFF_LED: PRDATA = {24'b0, led_reg};
            default: PRDATA = 32'h0000_0000;
        endcase
    end

    assign led_out = led_reg;

endmodule
