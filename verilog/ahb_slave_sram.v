module ahb_slave_sram #(
    parameter ADDR_WIDTH = 16   // 64KB = 2^16
)(
    HCLK,
    HRESETn,
    HWRITE,
    HTRANS,
    HSIZE,      // AHB transfer size port
    HADDR,
    HWDATA,
    HRDATA,
    HREADY,
    HRESP,
    sram_addr,
    sram_ce_n,
    sram_we_n,
    sram_be_n,
    sram_wdata,
    sram_rdata
);

// Input signals
input        HCLK;
input        HRESETn;
input        HWRITE;
input [1:0]  HTRANS;
input [2:0]  HSIZE;      // AHB transfer size: 000=8bit,001=16bit,010=32bit
input [31:0] HADDR;
input [31:0] HWDATA;
input [31:0] sram_rdata;

// Output signals
output        HREADY;
output [31:0] HRDATA;
output [1:0]  HRESP;
output [ADDR_WIDTH-3:0] sram_addr;
output                    sram_ce_n;
output                    sram_we_n;
output [3:0]             sram_be_n;   // Low-active byte enable mask
output [31:0]            sram_wdata;

// ==============================================
// Block 2: Wire / Reg Type Declarations
// All signal storage type definitions in one single block
// ==============================================
// All input signals are wire
wire        HCLK;
wire        HRESETn;
wire        HWRITE;
wire [1:0]  HTRANS;
wire [2:0]  HSIZE;
wire [31:0] HADDR;
wire [31:0] HWDATA;
wire [31:0] sram_rdata;

// Output wire
wire        HREADY;

// Output reg
reg  [31:0] HRDATA;
reg  [1:0]  HRESP;
reg  [ADDR_WIDTH-1:0] sram_addr;
reg                    sram_ce_n;
reg                    sram_we_n;
reg  [3:0]             sram_be_n;
reg  [31:0]            sram_wdata;
    // ========== Internal Registers and Wires ==========
    // AHB FSM states
    localparam IDLE   = 2'b00;
    localparam SETUP  = 2'b01;
    localparam ACCESS = 2'b10;
    
    reg [1:0] state, next_state;
    reg       addr_valid;
    
    // HREADY: always high, single-cycle SRAM access timing
    assign HREADY = 1'b1;
    
    // Judge valid AHB transfer: NONSEQ / SEQ
    wire is_active = (HTRANS == 2'b10) || (HTRANS == 2'b11);
    wire addr_in_range = (HADDR[31:ADDR_WIDTH] == 0);  // Address within 64KB space

    // Combinational logic: generate low-active byte enable mask by HSIZE & HADDR[1:0]
    reg [3:0] be_mask;
    always @* begin
        be_mask = 4'b1111; // Default: all bytes disabled (high level)
        case (HSIZE)
            3'b000: // 8-bit single byte access
                case(HADDR[1:0])
                    2'b00: be_mask = 4'b1110; // Byte0 low-active
                    2'b01: be_mask = 4'b1101; // Byte1 low-active
                    2'b10: be_mask = 4'b1011; // Byte2 low-active
                    2'b11: be_mask = 4'b0111; // Byte3 low-active
                endcase
            3'b001: // 16-bit half-word access
                case(HADDR[1])
                    1'b0: be_mask = 4'b1100; // Byte0 + Byte1 enabled
                    1'b1: be_mask = 4'b0011; // Byte2 + Byte3 enabled
                endcase
            3'b010: // 32-bit full word access
                be_mask = 4'b0000; // All 4 bytes enabled
            default:
                be_mask = 4'b1111;
        endcase
    end
    
    always @(posedge HCLK or negedge HRESETn) begin
        if (!HRESETn) begin
            sram_addr   <= 0;
            sram_ce_n   <= 1'b1;
            sram_we_n   <= 1'b1;
            sram_be_n   <= 4'b1111;
            sram_wdata  <= 0;
            HRDATA      <= 0;
            HRESP       <= 2'b00;
        end else begin
            if (is_active && addr_in_range) begin
                // Drive SRAM control signals
                sram_ce_n <= 1'b0;
                sram_addr <= HADDR[ADDR_WIDTH-1:2];  // Word-aligned address mapping
                
                if (HWRITE) begin
                    sram_we_n  <= 1'b0;
                    sram_wdata <= HWDATA;
                    // Assign calculated low-active byte mask for write operation
                    sram_be_n  <= be_mask;
                end else begin
                    sram_we_n <= 1'b1;
                    sram_be_n <= 4'b1111; // Byte mask unused for read transaction
                    // Capture SRAM read data
                    HRDATA <= sram_rdata;
                end
                
                HRESP <= 2'b00;  // AHB OKAY response
            end else if (is_active && !addr_in_range) begin
                // Access address out of SRAM address space
                HRESP <= 2'b01;  // AHB ERROR response
                sram_ce_n <= 1'b1;
                sram_we_n <= 1'b1;
                sram_be_n <= 4'b1111;
            end else begin
                // IDLE / BUSY transfer state, disable SRAM
                sram_ce_n <= 1'b1;
                sram_we_n <= 1'b1;
                sram_be_n <= 4'b1111;
                HRESP <= 2'b00;
            end
        end
    end

endmodule
