// ============================================================
// AHB Bus Matrix (1 Master, 2 Slaves)
// Slave0: 0x0001_0000 - 0x0001_FFFF (64KB)
// Slave1: 0x1000_0000 - 0x1000_FFFF (64KB)
// Other addresses: return HRESP=ERROR, HREADY=1 (to prevent hanging)
// ============================================================

module ahb_bus_matrix (
    HCLK,
    HRESETn,
    HADDR,
    HWRITE,
    HTRANS,
    HSIZE,
    HBURST,
    HPROT,
    HWDATA,
    HRDATA,
    HREADY,
    HRESP,
    HTRANS0,
    HWRITE0,
    HSIZE0,
    HBURST0,
    HADDR0,
    HWDATA0,
    HRDATA0,
    HREADY0,
    HRESP0,
    HTRANS1,
    HWRITE1,
    HSIZE1,
    HBURST1,
    HADDR1,
    HWDATA1,
    HRDATA1,
    HREADY1,
    HRESP1
);

    // ========== Input Port Declarations ==========
    input  wire        HCLK;
    input  wire        HRESETn;
    input  wire [31:0] HADDR;
    input  wire        HWRITE;
    input  wire [1:0]  HTRANS;
    input  wire [2:0]  HSIZE;
    input  wire [2:0]  HBURST;
    input  wire [3:0]  HPROT;
    input  wire [31:0] HWDATA;

    // ========== Output Port Declarations ==========
    output wire [31:0] HRDATA;
    output wire        HREADY;
    output wire [1:0]  HRESP;

    // ========== Slave0 Interface Port Declarations ==========
    output wire        HTRANS0;
    output wire        HWRITE0;
    output wire [1:0]  HSIZE0;
    output wire [2:0]  HBURST0;
    output wire [31:0] HADDR0;
    output wire [31:0] HWDATA0;
    input  wire [31:0] HRDATA0;
    input  wire        HREADY0;
    input  wire [1:0]  HRESP0;

    // ========== Slave1 Interface Port Declarations ==========
    output wire        HTRANS1;
    output wire        HWRITE1;
    output wire [1:0]  HSIZE1;
    output wire [2:0]  HBURST1;
    output wire [31:0] HADDR1;
    output wire [31:0] HWDATA1;
    input  wire [31:0] HRDATA1;
    input  wire        HREADY1;
    input  wire [1:0]  HRESP1;

    // ============================================================
    // Address Decoding (Combinational Logic)
    // ============================================================
    reg [1:0] slave_sel;  // 00: no slave, 01: slave0, 10: slave1, 11: reserved
    
    always @(*) begin
        // Default: no slave selected (error)
        slave_sel = 2'b00;
        
        // Slave0: 0x0001_0000 ~ 0x0001_FFFF
        if ((HADDR[31:16] == 16'h0001) && (HADDR[15:0] >= 16'h0000)) begin
            if (HADDR[15:0] <= 16'hFFFF)
                slave_sel = 2'b01;
        end
        // Slave1: 0x1000_0000 ~ 0x1000_FFFF
        else if ((HADDR[31:16] == 16'h1000) && (HADDR[15:0] >= 16'h0000)) begin
            if (HADDR[15:0] <= 16'hFFFF)
                slave_sel = 2'b10;
        end
        // Other addresses keep slave_sel = 00 → return ERROR
    end
    
    // Simplified decoding (using range comparison, better for synthesis)
    wire is_slave0 = (HADDR[31:16] == 16'h0001);  // 0x00010000 - 0x0001FFFF
    wire is_slave1 = (HADDR[31:20] == 12'h100);   // 0x10000000 - 0x1000FFFF
    
    // ============================================================
    // Slave Interface Signal Assignment (Combinational Logic)
    // ============================================================
    assign HTRANS0 = HTRANS;
    assign HWRITE0 = HWRITE;
    assign HSIZE0  = HSIZE;
    assign HBURST0 = HBURST;
    assign HADDR0  = HADDR;
    assign HWDATA0 = HWDATA;
    
    assign HTRANS1 = HTRANS;
    assign HWRITE1 = HWRITE;
    assign HSIZE1  = HSIZE;
    assign HBURST1 = HBURST;
    assign HADDR1  = HADDR;
    assign HWDATA1 = HWDATA;
    
    // ============================================================
    // Read Data / Response MUX (Combinational Logic, with priority)
    // ============================================================
    reg [31:0] hrdata_mux;
    reg        hready_mux;
    reg [1:0]  hresp_mux;
    
    always @(*) begin
        case (slave_sel)
            2'b01: begin  // Slave0
                hrdata_mux = HRDATA0;
                hready_mux = HREADY0;
                hresp_mux  = HRESP0;
            end
            2'b10: begin  // Slave1
                hrdata_mux = HRDATA1;
                hready_mux = HREADY1;
                hresp_mux  = HRESP1;
            end
            default: begin  // Address not mapped: ERROR response
                hrdata_mux = 32'hDEADBEEF;  // Error indication data
                hready_mux = 1'b1;          // Complete immediately
                hresp_mux  = 2'b01;         // ERROR response
            end
        endcase
    end
    
    assign HRDATA = hrdata_mux;
    assign HREADY = hready_mux;
    assign HRESP  = hresp_mux;

endmodule
