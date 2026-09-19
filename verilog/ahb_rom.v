// ============================================================
// AHB External ROM Controller
// Verilog-2001 Non-ANSI port style
// Separate reg declaration, no output reg syntax
// ROM: single port, 1-cycle read latency
// Fix: remove buf_clear, eliminate buffer clear race condition
// Detect new transaction by address change for continuous prefetch
// Module name: ahb_rom
// Address range: high bits all 1 (0xFFFFxxxx)
// ============================================================
module ahb_rom (
    HCLK,
    HRESETn,
    HWRITE,
    HTRANS,
    HADDR,
    HWDATA,
    HSIZE,
    HBURST,
    HPROT,
    HRDATA,
    HREADY,
    HRESP,
    rom_addr,
    rom_ce_n,
    rom_oe_n,
    rom_data
);

parameter ADDR_WIDTH = 16;
localparam ROM_ADDR_WIDTH = ADDR_WIDTH - 2;

// Input port declaration
input               HCLK;
input               HRESETn;
input               HWRITE;
input     [1:0]     HTRANS;
input    [31:0]     HADDR;
input    [31:0]     HWDATA;
input     [2:0]     HSIZE;
input     [2:0]     HBURST;
input     [3:0]     HPROT;
input    [31:0]     rom_data;

// Output port declaration
output   [31:0]     HRDATA;
output              HREADY;
output    [1:0]     HRESP;
output [ROM_ADDR_WIDTH-1:0] rom_addr;
output              rom_ce_n;
output              rom_oe_n;

// Separate sequential reg definition
reg [31:0]          HRDATA;
reg                 HREADY;
reg     [1:0]       HRESP;
reg [ROM_ADDR_WIDTH-1:0] rom_addr;
reg                 rom_ce_n;
reg                 rom_oe_n;

reg                 rom_wait;
reg                 err_pending;

// AHB decode wire
wire addr_in_range;
wire is_active;
wire valid_rd_req;
wire wr_err_req;
wire range_err_req;

assign addr_in_range = (HADDR[31:ADDR_WIDTH] == {32-ADDR_WIDTH{1'b1}});
assign is_active     = (HTRANS == 2'b10) || (HTRANS == 2'b11);
assign valid_rd_req  = addr_in_range && is_active && !HWRITE;
assign wr_err_req    = addr_in_range && is_active && HWRITE;
assign range_err_req = is_active && !addr_in_range;

// Detect new transaction by address change
reg [31:0] haddr_latch;
always @(posedge HCLK or negedge HRESETn) begin
    if (!HRESETn) begin
        haddr_latch <= 32'd0;
    end
    else begin
        haddr_latch <= HADDR;
    end
end
wire new_trans_detected = valid_rd_req && (HADDR != haddr_latch);

reg valid_rd_latch;
reg err_req_latch;
always @(posedge HCLK or negedge HRESETn) begin
    if (!HRESETn) begin
        valid_rd_latch <= 1'b0;
        err_req_latch  <= 1'b0;
    end
    else begin
        valid_rd_latch <= valid_rd_req;
        err_req_latch  <= wr_err_req || range_err_req;
    end
end

// 1-depth request buffer (remove buf_clear)
reg buf_valid;
reg [ROM_ADDR_WIDTH-1:0] buf_addr;
wire rom_busy;
assign rom_busy = rom_wait;

always @(posedge HCLK or negedge HRESETn) begin
    if (!HRESETn) begin
        buf_valid  <= 1'b0;
        buf_addr   <= {ROM_ADDR_WIDTH{1'b0}};
    end
    else begin
        // ROM busy & new transaction arrives, store to buffer
        if (rom_busy && new_trans_detected) begin
            buf_valid <= 1'b1;
            buf_addr  <= HADDR[ADDR_WIDTH-1:2];
        end
        // ROM idle & buffer has request: launch read, clear buffer immediately
        else if (!rom_busy && buf_valid) begin
            buf_valid <= 1'b0;
        end
    end
end

// ROM address & control logic
always @(posedge HCLK or negedge HRESETn) begin
    if (!HRESETn) begin
        rom_addr <= {ROM_ADDR_WIDTH{1'b0}};
        rom_ce_n <= 1'b1;
        rom_oe_n <= 1'b1;
    end
    else if (!rom_wait) begin
        if (buf_valid) begin
            rom_addr <= buf_addr;
            rom_ce_n <= 1'b0;
            rom_oe_n <= 1'b0;
        end
        else if (new_trans_detected) begin
            rom_addr <= HADDR[ADDR_WIDTH-1:2];
            rom_ce_n <= 1'b0;
            rom_oe_n <= 1'b0;
        end
        else begin
            rom_addr <= {ROM_ADDR_WIDTH{1'b0}};
            rom_ce_n <= 1'b1;
            rom_oe_n <= 1'b1;
        end
    end
end

// AHB state machine: highest priority launch buffered read
always @(posedge HCLK or negedge HRESETn) begin
    if (!HRESETn) begin
        HRDATA     <= 32'b0;
        HREADY     <= 1'b1;
        HRESP      <= 2'b00;
        err_pending<= 1'b0;
        rom_wait   <= 1'b0;
    end
    else begin
        // Highest priority: launch buffered ROM request
        if (!rom_wait && buf_valid) begin
            rom_wait   <= 1'b1;
            HREADY     <= 1'b0;
            HRESP      <= 2'b00;
            HRDATA     <= HRDATA;
        end
        else if (err_pending) begin
            HREADY     <= 1'b1;
            HRESP      <= 2'b00;
            HRDATA     <= 32'b0;
            err_pending<= 1'b0;
            rom_wait   <= 1'b0;
        end
        else if (err_req_latch) begin
            HREADY     <= 1'b0;
            HRESP      <= 2'b01;
            HRDATA     <= 32'hDEAD_BEEF;
            err_pending<= 1'b1;
            rom_wait   <= 1'b0;
        end
        else if (rom_wait) begin
            // ROM data ready, return to AHB
            HREADY     <= 1'b1;
            HRESP      <= 2'b00;
            HRDATA     <= rom_data;
            err_pending<= 1'b0;
            rom_wait   <= 1'b0;
        end
        else if (new_trans_detected) begin
            // Real-time new read request
            rom_wait   <= 1'b1;
            HREADY     <= 1'b0;
            HRESP      <= 2'b00;
            HRDATA     <= HRDATA;
        end
        else begin
            HREADY     <= 1'b1;
            HRESP      <= 2'b00;
            HRDATA     <= 32'b0;
            rom_wait   <= 1'b0;
        end
    end
end

`ifdef SIM
always @(posedge HCLK) begin
    if(buf_valid && new_trans_detected && rom_wait) begin
        $display("ERROR: ahb_rom request buffer overflow at time %0t", $time);
    end
end
`endif

endmodule
