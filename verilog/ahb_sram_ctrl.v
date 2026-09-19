`ifndef SDL
    `define SDL 0.1
`endif

`timescale 1ns/1ns

// ============================================================================
// AHB -> 同步 SRAM 控制器
//
// 修正点：AHB 规定 HWDATA 只在 **数据相位** 有效（地址相位的下一拍）。
// 原实现在地址相位就直接拉低 SRAM_CE_N/SRAM_WE_N 并把当时的 HWDATA
// 写进 SRAM，所以锁进去的是上一次的数据 / X（孤立写全错，只有连续写
// 同一个值的清零循环碰巧看起来是对的）。
//
// 现在：地址相位只采样 HADDR/HWRITE/HSIZE，写操作推迟到数据相位执行，
//       此时 HWDATA 才有效。
// ============================================================================

module ahb_sram_ctrl (
    // AHB 总线接口
    HCLK, HRESETn, HWRITE, HTRANS, HADDR, HWDATA, HSIZE,
    HRDATA, HREADY, HRESP,
    // SRAM 物理接口
    SRAM_A, SRAM_WDATA, SRAM_RDATA, SRAM_CE_N, SRAM_OE_N, SRAM_WE_N
);

parameter AHB_ADDR_WIDTH  = 32;
parameter SRAM_ADDR_WIDTH = 14;
parameter DATA_WIDTH      = 32;
parameter WAIT_CYCLES     = 1;   // 建议配置为 1（物理 SRAM 必须掩盖 1 拍延迟）

input                       HCLK;
input                       HRESETn;
input                       HWRITE;
input      [1:0]            HTRANS;
input      [AHB_ADDR_WIDTH-1:0] HADDR;
input      [DATA_WIDTH-1:0] HWDATA;
input      [2:0]            HSIZE;

output     [DATA_WIDTH-1:0] HRDATA;
output reg                  HREADY;
output reg [1:0]            HRESP;

output reg [SRAM_ADDR_WIDTH-1:0] SRAM_A;
output reg [DATA_WIDTH-1:0] SRAM_WDATA;
input      [DATA_WIDTH-1:0] SRAM_RDATA;
output reg                  SRAM_CE_N;
output reg                  SRAM_OE_N;
output reg [3:0]            SRAM_WE_N;

// ----------------------------------------------------------------------------
// AHB 相位
//   HTRANS[1]=1 的那一拍是地址相位，下一拍是数据相位。
// ----------------------------------------------------------------------------
wire addr_phase = (HTRANS == 2'b10) || (HTRANS == 2'b11);

// 地址相位锁存下来的写请求，在数据相位使用
reg                       wr_act;
reg [SRAM_ADDR_WIDTH-1:0] wr_addr;
reg [3:0]                 wr_be;

// 按 HSIZE/HADDR[1:0] 生成字节写使能（低有效）
function [3:0] be_from_size;
    input [2:0] sz;
    input [1:0] a;
    begin
        case (sz)
            3'b000: begin // 字节
                case (a)
                    2'b00:   be_from_size = 4'b1110;
                    2'b01:   be_from_size = 4'b1101;
                    2'b10:   be_from_size = 4'b1011;
                    default: be_from_size = 4'b0111;
                endcase
            end
            3'b001:  be_from_size = a[1] ? 4'b0011 : 4'b1100;   // 半字
            3'b010:  be_from_size = 4'b0000;                    // 字
            default: be_from_size = 4'b1111;
        endcase
    end
endfunction

always @(posedge HCLK or negedge HRESETn) begin
    if (!HRESETn) begin
        wr_act  <= 1'b0;
        wr_addr <= {SRAM_ADDR_WIDTH{1'b0}};
        wr_be   <= 4'b1111;
    end
    else if (HREADY) begin
        wr_act <= addr_phase && HWRITE;
        if (addr_phase) begin
            wr_addr <= HADDR[SRAM_ADDR_WIDTH-1:0];
            wr_be   <= be_from_size(HSIZE, HADDR[1:0]);
        end
    end
end

// ----------------------------------------------------------------------------
// SRAM 接口时序
//   数据相位 && wr_act : 执行写（HWDATA 有效）
//   地址相位 && 读     : 发读地址
//   其余               : 不选通（存储器保持上次输出，读数据在数据相位仍然有效）
// ----------------------------------------------------------------------------
always @(*) begin
    // 默认值，防止锁存器
    SRAM_CE_N  = 1'b1;
    SRAM_OE_N  = 1'b1;
    SRAM_WE_N  = 4'b1111;
    SRAM_A     = wr_addr;
    SRAM_WDATA = HWDATA;

    if (wr_act) begin
        // ---- 写数据相位 ----
        SRAM_CE_N  = 1'b0;
        SRAM_OE_N  = 1'b1;
        SRAM_WE_N  = wr_be;
        SRAM_A     = wr_addr;
        SRAM_WDATA = HWDATA;
    end
    else if (HREADY && addr_phase) begin
        // ---- 地址相位：只发读，写请求不在这里动 SRAM ----
        SRAM_CE_N  = 1'b0;
        SRAM_OE_N  = HWRITE;              // 读时 = 0
        SRAM_WE_N  = 4'b1111;
        SRAM_A     = HADDR[SRAM_ADDR_WIDTH-1:0];
        SRAM_WDATA = HWDATA;
    end
end

assign HRDATA = SRAM_RDATA;
assign HRESP  = 2'b0;

// ----------------------------------------------------------------------------
// HREADY 产生（WAIT_CYCLES=0 时恒为 1，即零等待）
// ----------------------------------------------------------------------------
reg [3:0] wait_cnt;
reg       a_phase_last;

always @(posedge HCLK or negedge HRESETn) begin
    if (!HRESETn) begin
        HREADY       <= #`SDL 1'b1;
        wait_cnt     <= #`SDL 4'd0;
        a_phase_last <= #`SDL 1'b0;
    end
    else begin
        if (addr_phase && HREADY && (WAIT_CYCLES > 0)) begin
            wait_cnt     <= #`SDL WAIT_CYCLES - 1;
            HREADY       <= #`SDL 1'b0;
            a_phase_last <= #`SDL 1'b1;
        end
        else if (wait_cnt != 4'd0) begin
            wait_cnt <= #`SDL wait_cnt - 4'd1;
            HREADY   <= #`SDL 1'b0;
        end
        else begin
            HREADY       <= #`SDL 1'b1;
            a_phase_last <= #`SDL 1'b0;
        end
    end
end

endmodule
