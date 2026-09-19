module data_ahb_top (
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
    led
);

// ==================== 顶层输入端口 ====================
input              HCLK;
input              HRESETn;
input      [31:0]  HADDR;
input              HWRITE;
input      [1:0]   HTRANS;
input      [2:0]   HSIZE;
input      [2:0]   HBURST;
input      [3:0]   HPROT;
input      [31:0]  HWDATA;

// ==================== 顶层输出端口 ====================
output     [31:0]  HRDATA;
output             HREADY;
output     [1:0]   HRESP;
output     [7:0]   led;

// 老式写法：统一声明顶层端口为wire
wire               HCLK;
wire               HRESETn;
wire      [31:0]   HADDR;
wire               HWRITE;
wire      [1:0]    HTRANS;
wire      [2:0]    HSIZE;
wire      [2:0]    HBURST;
wire      [3:0]    HPROT;
wire      [31:0]   HWDATA;
wire      [31:0]   HRDATA;
wire               HREADY;
wire      [1:0]    HRESP;
wire      [7:0]    led;

// ==================== 内部全部互联信号（集中定义） ====================
// AHB矩阵 Slave0 SRAM 分离总线
wire               HTRANS0;
wire               HWRITE0;
wire      [1:0]    HSIZE0;
wire      [2:0]    HBURST0;
wire      [31:0]   HADDR0;
wire      [31:0]   HWDATA0;
wire      [31:0]   HRDATA0;
wire               HREADY0;
wire      [1:0]    HRESP0;

// AHB矩阵 Slave1 LED 分离总线
wire               HTRANS1;
wire               HWRITE1;
wire      [1:0]    HSIZE1;
wire      [2:0]    HBURST1;
wire      [31:0]   HADDR1;
wire      [31:0]   HWDATA1;
wire      [31:0]   HRDATA1;
wire               HREADY1;
wire      [1:0]    HRESP1;

// SRAM从机 ↔ 内部RAM IP 互联信号（仅内部，不引出顶层）
wire      [15:0]   sram_addr;
wire               sram_ce_n;
wire               sram_we_n;
wire      [3:0]    sram_be_n;
wire      [31:0]   sram_wdata;
wire      [31:0]   sram_rdata;

// SRAM控制组合逻辑信号
wire               sram_oe_n;
wire      [3:0]    sram_we_b_en;
    
    // ========== AHB Bus Matrix Instance ==========
    ahb_bus_matrix u_matrix (
        .HCLK    (HCLK),
        .HRESETn (HRESETn),
        .HADDR   (HADDR),
        .HWRITE  (HWRITE),
        .HTRANS  (HTRANS),
        .HSIZE   (HSIZE),
        .HBURST  (HBURST),
        .HPROT   (HPROT),
        .HWDATA  (HWDATA),
        .HRDATA  (HRDATA),
        .HREADY  (HREADY),
        .HRESP   (HRESP),
        .HTRANS0 (HTRANS0),
        .HWRITE0 (HWRITE0),
        .HSIZE0  (HSIZE0),
        .HBURST0 (HBURST0),
        .HADDR0  (HADDR0),
        .HWDATA0 (HWDATA0),
        .HRDATA0 (HRDATA0),
        .HREADY0 (HREADY0),
        .HRESP0  (HRESP0),
        .HTRANS1 (HTRANS1),
        .HWRITE1 (HWRITE1),
        .HSIZE1  (HSIZE1),
        .HBURST1 (HBURST1),
        .HADDR1  (HADDR1),
        .HWDATA1 (HWDATA1),
        .HRDATA1 (HRDATA1),
        .HREADY1 (HREADY1),
        .HRESP1  (HRESP1)
    );
    
    // ========== SRAM Slave Instance ==========
ahb_slave_sram #(.ADDR_WIDTH(16)) u_sram0(
    .HCLK      (HCLK),                                         // I  u_sram0
    .HRESETn   (HRESETn),                                      // I  u_sram0
    .HWRITE    (HWRITE),                                       // I  u_sram0
    .HTRANS    (HTRANS[1:0]),                                  // I  u_sram0
    .HSIZE     (HSIZE[2:0]),                                   // I  u_sram0
    .HADDR     (HADDR[31:0]),                                  // I  u_sram0
    .HWDATA    (HWDATA[31:0]),                                 // I  u_sram0
    .HRDATA    (HRDATA[31:0]),                                 // O  u_sram0
    .HREADY    (HREADY),                                       // O  u_sram0
    .HRESP     (HRESP[1:0]),                                   // O  u_sram0
    .sram_addr (sram_addr[13:0]),                              // O  u_sram0
    .sram_ce_n (sram_ce_n),                                    // O  u_sram0
    .sram_we_n (sram_we_n),                                    // O  u_sram0
    .sram_be_n (sram_be_n[3:0]),                               // O  u_sram0
    .sram_wdata(sram_wdata[31:0]),                             // O  u_sram0
    .sram_rdata(sram_rdata[31:0])                              // I  u_sram0
);

    assign  sram_oe_n = ! sram_we_n;
    assign  sram_we_b_en[3:0] = sram_we_n ? 4'b0 : sram_be_n[3:0];
    // =========RAM ============================
    RAM1_16Kx32B u_ram_16K(
    .CLK    (HCLK               ),   // Global clock
    .CEN    (sram_ce_n          ),   // Chip Enable (active low)
    .WEN    (sram_we_b_en[3:0]  ),   // Byte-Write Enable (active low, 4-bit for 32-bit data)
    .OEN    (sram_oe_n          ),   // Output Enable (active low)
    .A      (sram_addr[13:0]    ),   // 14-bit Address (64X1024 words)
    .Q      (sram_rdata[31:0]   ),   // 32-bit Data Output
    .D      (sram_wdata[31:0]   )    // 32-bit Data Input
);
    // ========== LED Slave Instance ==========
    ahb_slave_led u_led1 (
        .HCLK    (HCLK),
        .HRESETn (HRESETn),
        .HWRITE  (HWRITE1),
        .HTRANS  (HTRANS1),
        .HADDR   (HADDR1),
        .HWDATA  (HWDATA1),
        .HRDATA  (HRDATA1),
        .HREADY  (HREADY1),
        .HRESP   (HRESP1),
        .led_out (led)
    );

endmodule
