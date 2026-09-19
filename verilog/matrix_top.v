module matrix_top(
        AHB_INTERFACE_1_haddr,
        AHB_INTERFACE_1_hburst,
        AHB_INTERFACE_1_hprot,
        AHB_INTERFACE_1_hrdata,
        AHB_INTERFACE_1_hready,
        AHB_INTERFACE_1_hresp,
        AHB_INTERFACE_1_hsize,
        AHB_INTERFACE_1_htrans,
        AHB_INTERFACE_1_hwdata,
        AHB_INTERFACE_1_hwrite,
        AHB_INTERFACE_1_sel,
        AHB_INTERFACE_haddr,
        AHB_INTERFACE_hburst,
        AHB_INTERFACE_hprot,
        AHB_INTERFACE_hrdata,
        AHB_INTERFACE_hready,
        AHB_INTERFACE_hresp,
        AHB_INTERFACE_hsize,
        AHB_INTERFACE_htrans,
        AHB_INTERFACE_hwdata,
        AHB_INTERFACE_hwrite,
        AHB_INTERFACE_sel,
        M_AHB_hwrite,
        HCLK,
        HRESETn,
        led,
        uart_rxd,
        uart_txd,
        irq,
        // ---- DDR3 ----
        clk_ddr,
        clk_ddr90,
        clk_ref,
        ddr3_ck_p,
        ddr3_ck_n,
        ddr3_cke,
        ddr3_reset_n,
        ddr3_ras_n,
        ddr3_cas_n,
        ddr3_we_n,
        ddr3_cs_n,
        ddr3_ba,
        ddr3_addr,
        ddr3_odt,
        ddr3_dm,
        ddr3_dqs_p,
        ddr3_dqs_n,
        ddr3_dq
);
input  [31:0] AHB_INTERFACE_1_haddr;
input  [2:0]  AHB_INTERFACE_1_hburst;
input  [3:0]  AHB_INTERFACE_1_hprot;
output [31:0] AHB_INTERFACE_1_hrdata;
output        AHB_INTERFACE_1_hready;
output        AHB_INTERFACE_1_hresp;
input  [2:0]  AHB_INTERFACE_1_hsize;
input  [1:0]  AHB_INTERFACE_1_htrans;
input  [31:0] AHB_INTERFACE_1_hwdata;
input         AHB_INTERFACE_1_hwrite;
input         AHB_INTERFACE_1_sel;
input  [31:0] AHB_INTERFACE_haddr;
input  [2:0]  AHB_INTERFACE_hburst;
input  [3:0]  AHB_INTERFACE_hprot;
output [31:0] AHB_INTERFACE_hrdata;
output        AHB_INTERFACE_hready;
output        AHB_INTERFACE_hresp;
input  [2:0]  AHB_INTERFACE_hsize;
input  [1:0]  AHB_INTERFACE_htrans;
input  [31:0] AHB_INTERFACE_hwdata;
input         AHB_INTERFACE_hwrite;
input         AHB_INTERFACE_sel;
input         M_AHB_hwrite;
input         HCLK;
input         HRESETn;
output [7:0]  led;
input         uart_rxd;         // 串口接收（来自 testbench / 外部）
output        uart_txd;         // 串口发送
output        irq;              // APB 外设中断汇总（高有效），到 ARM 的 nIRQ

// ---- DDR3 ----
input         clk_ddr;          // 4 x HCLK
input         clk_ddr90;        // clk_ddr 移相 90 度
input         clk_ref;          // IDELAYCTRL 参考时钟 (200MHz)
output        ddr3_ck_p;
output        ddr3_ck_n;
output        ddr3_cke;
output        ddr3_reset_n;
output        ddr3_ras_n;
output        ddr3_cas_n;
output        ddr3_we_n;
output        ddr3_cs_n;
output [2:0]  ddr3_ba;
output [13:0] ddr3_addr;
output        ddr3_odt;
output [1:0]  ddr3_dm;
inout  [1:0]  ddr3_dqs_p;
inout  [1:0]  ddr3_dqs_n;
inout  [15:0] ddr3_dq;



//{{{
wire [31:0] AHB_INTERFACE_1_haddr;
wire [2:0]  AHB_INTERFACE_1_hburst;
wire [3:0]  AHB_INTERFACE_1_hprot;
wire [31:0] AHB_INTERFACE_1_hrdata;
wire        AHB_INTERFACE_1_hready;
wire        AHB_INTERFACE_1_hresp;
wire [2:0]  AHB_INTERFACE_1_hsize;
wire [1:0]  AHB_INTERFACE_1_htrans;
wire [31:0] AHB_INTERFACE_1_hwdata;
wire        AHB_INTERFACE_1_hwrite;
wire        AHB_INTERFACE_1_sel;
wire [31:0] AHB_INTERFACE_haddr;
wire [2:0]  AHB_INTERFACE_hburst;
wire [3:0]  AHB_INTERFACE_hprot;
wire [31:0] AHB_INTERFACE_hrdata;
wire        AHB_INTERFACE_hready;
wire        AHB_INTERFACE_hresp;
wire [2:0]  AHB_INTERFACE_hsize;
wire [1:0]  AHB_INTERFACE_htrans;
wire [31:0] AHB_INTERFACE_hwdata;
wire        AHB_INTERFACE_hwrite;
wire        AHB_INTERFACE_sel;
wire [31:0] M_AHB_1_haddr;
wire [2:0]  M_AHB_1_hburst;
wire        M_AHB_1_hmastlock;
wire [3:0]  M_AHB_1_hprot;
wire [31:0] M_AHB_1_hrdata;
wire        M_AHB_1_hready;
wire        M_AHB_1_hresp;
wire [2:0]  M_AHB_1_hsize;
wire [1:0]  M_AHB_1_htrans;
wire [31:0] M_AHB_1_hwdata;
wire        M_AHB_1_hwrite;
// M_AHB_2 在新的 matrix BD 里已被 M_DDR_AXI 取代，不再使用。
wire [31:0] M_DDR_AXI_araddr;
wire [1:0]  M_DDR_AXI_arburst;
wire [3:0]  M_DDR_AXI_arcache;
wire [4:0]  M_DDR_AXI_arid;
wire [7:0]  M_DDR_AXI_arlen;
wire        M_DDR_AXI_arlock;
wire [2:0]  M_DDR_AXI_arprot;
wire [3:0]  M_DDR_AXI_arqos;
wire        M_DDR_AXI_arready;
wire [3:0]  M_DDR_AXI_arregion;
wire [2:0]  M_DDR_AXI_arsize;
wire        M_DDR_AXI_arvalid;
wire [31:0] M_DDR_AXI_awaddr;
wire [1:0]  M_DDR_AXI_awburst;
wire [3:0]  M_DDR_AXI_awcache;
wire [4:0]  M_DDR_AXI_awid;
wire [7:0]  M_DDR_AXI_awlen;
wire        M_DDR_AXI_awlock;
wire [2:0]  M_DDR_AXI_awprot;
wire [3:0]  M_DDR_AXI_awqos;
wire        M_DDR_AXI_awready;
wire [3:0]  M_DDR_AXI_awregion;
wire [2:0]  M_DDR_AXI_awsize;
wire        M_DDR_AXI_awvalid;
wire [4:0]  M_DDR_AXI_bid;
wire        M_DDR_AXI_bready;
wire [1:0]  M_DDR_AXI_bresp;
wire        M_DDR_AXI_bvalid;
wire [31:0] M_DDR_AXI_rdata;
wire [4:0]  M_DDR_AXI_rid;
wire        M_DDR_AXI_rlast;
wire        M_DDR_AXI_rready;
wire [1:0]  M_DDR_AXI_rresp;
wire        M_DDR_AXI_rvalid;
wire [31:0] M_DDR_AXI_wdata;
wire        M_DDR_AXI_wlast;
wire        M_DDR_AXI_wready;
wire [3:0]  M_DDR_AXI_wstrb;
wire        M_DDR_AXI_wvalid;
wire [31:0] M_AHB_3_haddr;
wire [2:0]  M_AHB_3_hburst;
wire        M_AHB_3_hmastlock;
wire [3:0]  M_AHB_3_hprot;
wire [31:0] M_AHB_3_hrdata;
wire        M_AHB_3_hready;
wire        M_AHB_3_hresp;
wire [2:0]  M_AHB_3_hsize;
wire [1:0]  M_AHB_3_htrans;
wire [31:0] M_AHB_3_hwdata;
wire        M_AHB_3_hwrite;
wire [31:0] M_AHB_haddr;
wire [2:0]  M_AHB_hburst;
wire        M_AHB_hmastlock;
wire [3:0]  M_AHB_hprot;
wire [31:0] M_AHB_hrdata;
wire        M_AHB_hready;
wire        M_AHB_hresp;
wire [2:0]  M_AHB_hsize;
wire [1:0]  M_AHB_htrans;
wire [31:0] M_AHB_hwdata;
wire        M_AHB_hwrite;
wire        HCLK;
wire        HRESETn;
wire [1:0]  slave_hresp;
wire [13:0] rom_addr;
wire        rom_ce_n;
wire        rom_oe_n;
wire [31:0] rom_data;
wire [1:0]  slave_1_hresp;
wire [13:0] sram_addr;
wire        sram_ce_n;
wire        sram_we_n;
wire [3:0]  sram_be_n;
wire [31:0] sram_wdata;
wire [31:0] sram_rdata;
wire        sram_oe_n;
wire [3:0]  sram_we_b_en;
wire [1:0]  slave_2_hresp;
wire [7:0]  led;
wire        led_ce_n;
wire        led_we_n;
wire [3:0]  led_be_n;
wire [31:0] led_wdata;
wire [31:0] led_rdata;
wire        led_oe_n;
wire [3:0]  led_we_b_en;
wire [13:0] led_addr;
wire [1:0]  slave_3_hresp;
//}}}


// M_AHB_3 (LED) 的 HREADY/HRESP 由下面的 u_led1 驱动，
// 这里不能再 assign，否则同一个 wire 双驱动 -> X。

ahb_axi_matrix_wrapper u_ahb_axi_matrix (
    .AHB_INTERFACE_1_haddr     (AHB_INTERFACE_1_haddr[31:0]),                     // I  u_ahb_axi_matrix
    .AHB_INTERFACE_1_hburst    (AHB_INTERFACE_1_hburst[2:0]),                     // I  u_ahb_axi_matrix
    .AHB_INTERFACE_1_hprot     (AHB_INTERFACE_1_hprot[3:0]),                      // I  u_ahb_axi_matrix
    .AHB_INTERFACE_1_hrdata    (AHB_INTERFACE_1_hrdata[31:0]),                    // O  u_ahb_axi_matrix
    .AHB_INTERFACE_1_hready_in (AHB_INTERFACE_1_hready),                          // I  u_ahb_axi_matrix
    .AHB_INTERFACE_1_hready_out(AHB_INTERFACE_1_hready),                          // O  u_ahb_axi_matrix
    .AHB_INTERFACE_1_hresp     (AHB_INTERFACE_1_hresp),                           // O  u_ahb_axi_matrix
    .AHB_INTERFACE_1_hsize     (AHB_INTERFACE_1_hsize[2:0]),                      // I  u_ahb_axi_matrix
    .AHB_INTERFACE_1_htrans    (AHB_INTERFACE_1_htrans[1:0]),                     // I  u_ahb_axi_matrix
    .AHB_INTERFACE_1_hwdata    (AHB_INTERFACE_1_hwdata[31:0]),                    // I  u_ahb_axi_matrix
    .AHB_INTERFACE_1_hwrite    (AHB_INTERFACE_1_hwrite),                          // I  u_ahb_axi_matrix
    .AHB_INTERFACE_1_sel       (AHB_INTERFACE_1_sel),                             // I  u_ahb_axi_matrix
    .AHB_INTERFACE_haddr       (AHB_INTERFACE_haddr[31:0]),                       // I  u_ahb_axi_matrix
    .AHB_INTERFACE_hburst      (AHB_INTERFACE_hburst[2:0]),                       // I  u_ahb_axi_matrix
    .AHB_INTERFACE_hprot       (AHB_INTERFACE_hprot[3:0]),                        // I  u_ahb_axi_matrix
    .AHB_INTERFACE_hrdata      (AHB_INTERFACE_hrdata[31:0]),                      // O  u_ahb_axi_matrix
    .AHB_INTERFACE_hready_in   (AHB_INTERFACE_hready),                            // I  u_ahb_axi_matrix
    .AHB_INTERFACE_hready_out  (AHB_INTERFACE_hready),                            // O  u_ahb_axi_matrix
    .AHB_INTERFACE_hresp       (AHB_INTERFACE_hresp),                             // O  u_ahb_axi_matrix
    .AHB_INTERFACE_hsize       (AHB_INTERFACE_hsize[2:0]),                        // I  u_ahb_axi_matrix
    .AHB_INTERFACE_htrans      (AHB_INTERFACE_htrans[1:0]),                       // I  u_ahb_axi_matrix
    .AHB_INTERFACE_hwdata      (AHB_INTERFACE_hwdata[31:0]),                      // I  u_ahb_axi_matrix
    .AHB_INTERFACE_hwrite      (AHB_INTERFACE_hwrite),                            // I  u_ahb_axi_matrix
    .AHB_INTERFACE_sel         (AHB_INTERFACE_sel),                               // I  u_ahb_axi_matrix
    .M_AHB_1_haddr             (M_AHB_1_haddr[31:0]),                             // O  u_ahb_axi_matrix
    .M_AHB_1_hburst            (M_AHB_1_hburst[2:0]),                             // O  u_ahb_axi_matrix
    .M_AHB_1_hmastlock         (M_AHB_1_hmastlock),                               // O  u_ahb_axi_matrix
    .M_AHB_1_hprot             (M_AHB_1_hprot[3:0]),                              // O  u_ahb_axi_matrix
    .M_AHB_1_hrdata            (M_AHB_1_hrdata[31:0]),                            // I  u_ahb_axi_matrix
    .M_AHB_1_hready            (M_AHB_1_hready),                                  // I  u_ahb_axi_matrix
    .M_AHB_1_hresp             (M_AHB_1_hresp),                                   // I  u_ahb_axi_matrix
    .M_AHB_1_hsize             (M_AHB_1_hsize[2:0]),                              // O  u_ahb_axi_matrix
    .M_AHB_1_htrans            (M_AHB_1_htrans[1:0]),                             // O  u_ahb_axi_matrix
    .M_AHB_1_hwdata            (M_AHB_1_hwdata[31:0]),                            // O  u_ahb_axi_matrix
    .M_AHB_1_hwrite            (M_AHB_1_hwrite),                                  // O  u_ahb_axi_matrix
    // M_DDR_AXI (AXI4 slave, 0x4000_0000) -> u_ddr3_top
    .M_DDR_AXI_araddr          (M_DDR_AXI_araddr[31:0]),                          // O  u_ahb_axi_matrix
    .M_DDR_AXI_arburst         (M_DDR_AXI_arburst[1:0]),                          // O  u_ahb_axi_matrix
    .M_DDR_AXI_arcache         (M_DDR_AXI_arcache[3:0]),                          // O  u_ahb_axi_matrix
    .M_DDR_AXI_arid            (M_DDR_AXI_arid[4:0]),                             // O  u_ahb_axi_matrix
    .M_DDR_AXI_arlen           (M_DDR_AXI_arlen[7:0]),                            // O  u_ahb_axi_matrix
    .M_DDR_AXI_arlock          (M_DDR_AXI_arlock),                                // O  u_ahb_axi_matrix
    .M_DDR_AXI_arprot          (M_DDR_AXI_arprot[2:0]),                           // O  u_ahb_axi_matrix
    .M_DDR_AXI_arqos           (M_DDR_AXI_arqos[3:0]),                            // O  u_ahb_axi_matrix
    .M_DDR_AXI_arready         (M_DDR_AXI_arready),                               // I  u_ahb_axi_matrix
    .M_DDR_AXI_arregion        (M_DDR_AXI_arregion[3:0]),                         // O  u_ahb_axi_matrix
    .M_DDR_AXI_arsize          (M_DDR_AXI_arsize[2:0]),                           // O  u_ahb_axi_matrix
    .M_DDR_AXI_arvalid         (M_DDR_AXI_arvalid),                               // O  u_ahb_axi_matrix
    .M_DDR_AXI_awaddr          (M_DDR_AXI_awaddr[31:0]),                          // O  u_ahb_axi_matrix
    .M_DDR_AXI_awburst         (M_DDR_AXI_awburst[1:0]),                          // O  u_ahb_axi_matrix
    .M_DDR_AXI_awcache         (M_DDR_AXI_awcache[3:0]),                          // O  u_ahb_axi_matrix
    .M_DDR_AXI_awid            (M_DDR_AXI_awid[4:0]),                             // O  u_ahb_axi_matrix
    .M_DDR_AXI_awlen           (M_DDR_AXI_awlen[7:0]),                            // O  u_ahb_axi_matrix
    .M_DDR_AXI_awlock          (M_DDR_AXI_awlock),                                // O  u_ahb_axi_matrix
    .M_DDR_AXI_awprot          (M_DDR_AXI_awprot[2:0]),                           // O  u_ahb_axi_matrix
    .M_DDR_AXI_awqos           (M_DDR_AXI_awqos[3:0]),                            // O  u_ahb_axi_matrix
    .M_DDR_AXI_awready         (M_DDR_AXI_awready),                               // I  u_ahb_axi_matrix
    .M_DDR_AXI_awregion        (M_DDR_AXI_awregion[3:0]),                         // O  u_ahb_axi_matrix
    .M_DDR_AXI_awsize          (M_DDR_AXI_awsize[2:0]),                           // O  u_ahb_axi_matrix
    .M_DDR_AXI_awvalid         (M_DDR_AXI_awvalid),                               // O  u_ahb_axi_matrix
    .M_DDR_AXI_bid             (M_DDR_AXI_bid[4:0]),                              // I  u_ahb_axi_matrix
    .M_DDR_AXI_bready          (M_DDR_AXI_bready),                                // O  u_ahb_axi_matrix
    .M_DDR_AXI_bresp           (M_DDR_AXI_bresp[1:0]),                            // I  u_ahb_axi_matrix
    .M_DDR_AXI_bvalid          (M_DDR_AXI_bvalid),                                // I  u_ahb_axi_matrix
    .M_DDR_AXI_rdata           (M_DDR_AXI_rdata[31:0]),                           // I  u_ahb_axi_matrix
    .M_DDR_AXI_rid             (M_DDR_AXI_rid[4:0]),                              // I  u_ahb_axi_matrix
    .M_DDR_AXI_rlast           (M_DDR_AXI_rlast),                                 // I  u_ahb_axi_matrix
    .M_DDR_AXI_rready          (M_DDR_AXI_rready),                                // O  u_ahb_axi_matrix
    .M_DDR_AXI_rresp           (M_DDR_AXI_rresp[1:0]),                            // I  u_ahb_axi_matrix
    .M_DDR_AXI_rvalid          (M_DDR_AXI_rvalid),                                // I  u_ahb_axi_matrix
    .M_DDR_AXI_wdata           (M_DDR_AXI_wdata[31:0]),                           // O  u_ahb_axi_matrix
    .M_DDR_AXI_wlast           (M_DDR_AXI_wlast),                                 // O  u_ahb_axi_matrix
    .M_DDR_AXI_wready          (M_DDR_AXI_wready),                                // I  u_ahb_axi_matrix
    .M_DDR_AXI_wstrb           (M_DDR_AXI_wstrb[3:0]),                            // O  u_ahb_axi_matrix
    .M_DDR_AXI_wvalid          (M_DDR_AXI_wvalid),                                // O  u_ahb_axi_matrix
    .M_AHB_3_haddr             (M_AHB_3_haddr[31:0]),                             // O  u_ahb_axi_matrix
    .M_AHB_3_hburst            (M_AHB_3_hburst[2:0]),                             // O  u_ahb_axi_matrix
    .M_AHB_3_hmastlock         (M_AHB_3_hmastlock),                               // O  u_ahb_axi_matrix
    .M_AHB_3_hprot             (M_AHB_3_hprot[3:0]),                              // O  u_ahb_axi_matrix
    .M_AHB_3_hrdata            (M_AHB_3_hrdata[31:0]),                            // I  u_ahb_axi_matrix
    .M_AHB_3_hready            (M_AHB_3_hready),                                  // I  u_ahb_axi_matrix
    .M_AHB_3_hresp             (M_AHB_3_hresp),                                   // I  u_ahb_axi_matrix
    .M_AHB_3_hsize             (M_AHB_3_hsize[2:0]),                              // O  u_ahb_axi_matrix
    .M_AHB_3_htrans            (M_AHB_3_htrans[1:0]),                             // O  u_ahb_axi_matrix
    .M_AHB_3_hwdata            (M_AHB_3_hwdata[31:0]),                            // O  u_ahb_axi_matrix
    .M_AHB_3_hwrite            (M_AHB_3_hwrite),                                  // O  u_ahb_axi_matrix
    .M_AHB_haddr               (M_AHB_haddr[31:0]),                               // O  u_ahb_axi_matrix
    .M_AHB_hburst              (M_AHB_hburst[2:0]),                               // O  u_ahb_axi_matrix
    .M_AHB_hmastlock           (M_AHB_hmastlock),                                 // O  u_ahb_axi_matrix
    .M_AHB_hprot               (M_AHB_hprot[3:0]),                                // O  u_ahb_axi_matrix
    .M_AHB_hrdata              (M_AHB_hrdata[31:0]),                              // I  u_ahb_axi_matrix
    .M_AHB_hready              (M_AHB_hready),                                    // I  u_ahb_axi_matrix
    .M_AHB_hresp               (M_AHB_hresp),                                     // I  u_ahb_axi_matrix
    .M_AHB_hsize               (M_AHB_hsize[2:0]),                                // O  u_ahb_axi_matrix
    .M_AHB_htrans              (M_AHB_htrans[1:0]),                               // O  u_ahb_axi_matrix
    .M_AHB_hwdata              (M_AHB_hwdata[31:0]),                              // O  u_ahb_axi_matrix
    .M_AHB_hwrite              (M_AHB_hwrite),                                    // O  u_ahb_axi_matrix
    .clk_100MHz                (HCLK),                                            // I  u_ahb_axi_matrix
    .hreset                    (HRESETn)                                          // I  u_ahb_axi_matrix
);

assign M_AHB_hresp = slave_hresp[0];

// ============================================================================
// 调试打印：只输出 AXI 对 M_DDR_AXI 的读写数据
//   打开：vlogan 加 +define+DDR_AXI_LOG（arm926fpga.f 里已默认打开）
//   关闭：去掉该 define（或注释掉本段）
//   DDR3 器件模型自身的 log 由 tbench_top 里 ddr3 例化的 DEBUG=0 关闭
// ============================================================================
`ifdef DDR_AXI_LOG
reg [31:0] mon_awaddr_r;
reg [ 4:0] mon_awid_r;
reg [ 7:0] mon_wcnt_r;
reg [31:0] mon_araddr_r;
reg [ 4:0] mon_arid_r;
reg [ 7:0] mon_rcnt_r;

wire        mon_aw_hs = M_DDR_AXI_awvalid & M_DDR_AXI_awready;
wire        mon_w_hs  = M_DDR_AXI_wvalid  & M_DDR_AXI_wready;
wire        mon_ar_hs = M_DDR_AXI_arvalid & M_DDR_AXI_arready;
wire        mon_r_hs  = M_DDR_AXI_rvalid  & M_DDR_AXI_rready;

// 同一拍握手时用当前值，避免少一拍
wire [31:0] mon_awaddr_w = mon_aw_hs ? M_DDR_AXI_awaddr : mon_awaddr_r;
wire [ 4:0] mon_awid_w   = mon_aw_hs ? M_DDR_AXI_awid   : mon_awid_r;
wire [31:0] mon_araddr_w = mon_ar_hs ? M_DDR_AXI_araddr : mon_araddr_r;
wire [ 4:0] mon_arid_w   = mon_ar_hs ? M_DDR_AXI_arid   : mon_arid_r;
wire [ 7:0] mon_wcnt_w   = mon_aw_hs ? 8'd0 : mon_wcnt_r;
wire [ 7:0] mon_rcnt_w   = mon_ar_hs ? 8'd0 : mon_rcnt_r;

always @(posedge HCLK) begin
    mon_awaddr_r <= mon_awaddr_w;
    mon_awid_r   <= mon_awid_w;
    mon_araddr_r <= mon_araddr_w;
    mon_arid_r   <= mon_arid_w;
    mon_wcnt_r   <= mon_w_hs ? (mon_wcnt_w + 8'd1) : mon_wcnt_w;
    mon_rcnt_r   <= mon_r_hs ? (mon_rcnt_w + 8'd1) : mon_rcnt_w;
end

always @(posedge HCLK) begin
    if (mon_w_hs)
        $display("[%0t] M_DDR_AXI  WR  addr=%08h  data=%08h  strb=%h  last=%b  id=%02h",
                 $time, mon_awaddr_w + {mon_wcnt_w, 2'b00}, M_DDR_AXI_wdata,
                 M_DDR_AXI_wstrb, M_DDR_AXI_wlast, mon_awid_w);
    if (mon_r_hs)
        $display("[%0t] M_DDR_AXI  RD  addr=%08h  data=%08h  last=%b  id=%02h",
                 $time, mon_araddr_w + {mon_rcnt_w, 2'b00}, M_DDR_AXI_rdata,
                 M_DDR_AXI_rlast, mon_arid_w);
end
`endif

//ahb_rom #(.ADDR_WIDTH(16)) u_ahb_rom(
//    .HCLK    (HCLK),                                            // I  u_ahb_rom
//    .HRESETn (HRESETn),                                         // I  u_ahb_rom
//    .HWRITE  (M_AHB_hwrite),                                    // I  u_ahb_rom
//    .HTRANS  (M_AHB_htrans[1:0]),                               // I  u_ahb_rom
//    .HADDR   (M_AHB_haddr[31:0]),                               // I  u_ahb_rom
//    .HWDATA  (32'b0),                                           // I  u_ahb_rom
//    .HSIZE   (M_AHB_hsize[2:0]),                                // I  u_ahb_rom
//    .HBURST  (M_AHB_hburst[2:0]),                               // I  u_ahb_rom
//    .HPROT   (M_AHB_hprot[3:0]),                                // I  u_ahb_rom
//    .HRDATA  (M_AHB_hrdata[31:0]),                              // O  u_ahb_rom
//    .HREADY  (M_AHB_hready),                                    // O  u_ahb_rom
//    .HRESP   (slave_hresp[1:0]),                                // O  u_ahb_rom
//    .rom_addr(rom_addr[13:0]),                                  // O  u_ahb_rom
//    .rom_ce_n(rom_ce_n),                                        // O  u_ahb_rom
//    .rom_oe_n(rom_oe_n),                                        // O  u_ahb_rom
//    .rom_data(rom_data[31:0])                                   // I  u_ahb_rom
//);
ahb_sram_ctrl #(
    .AHB_ADDR_WIDTH(32),
    .SRAM_ADDR_WIDTH(14),
    .DATA_WIDTH(32),
    .WAIT_CYCLES(0)
) u_ahb_rom (
    .HCLK               (HCLK),
    .HRESETn            (HRESETn),
    .HWRITE             (M_AHB_hwrite),
    .HTRANS             (M_AHB_htrans[1:0]),
    .HADDR              (M_AHB_haddr[31:0]),
    .HWDATA             (32'b0),
    .HSIZE              (M_AHB_hsize[2:0]),
    .HRDATA             (M_AHB_hrdata[31:0]),
    .HREADY             (M_AHB_hready),
    .HRESP              (slave_hresp[1:0]),

    .SRAM_A             (rom_addr[13:0]),
    .SRAM_WDATA         (),
    .SRAM_RDATA         (rom_data[31:0]),
    .SRAM_CE_N          (rom_ce_n),
    .SRAM_OE_N          (rom_oe_n),
    .SRAM_WE_N          ()
);

rom_16KX32 u_rom (
    .CLK    (HCLK),                             // I  u_rom
    .CEN    (rom_ce_n),                         // I  u_rom
    .WEN    (4'b1111),                          // I  u_rom
    .OEN    (rom_oe_n),                         // I  u_rom
    .A      ({2'b00,rom_addr[13:2]}),                   // I  u_rom
    .Q      (rom_data[31:0]),                   // O  u_rom
    .D      (32'b0)                             // I  u_rom
);

assign M_AHB_1_hresp = slave_1_hresp[0];
//ahb_slave_sram #(.ADDR_WIDTH(16)) u_sram0(
//    .HCLK      (HCLK),                                         // I  u_sram0
//    .HRESETn   (HRESETn),                                      // I  u_sram0
//    .HWRITE    (M_AHB_1_hwrite),                               // I  u_sram0
//    .HTRANS    (M_AHB_1_htrans[1:0]),                          // I  u_sram0
//    .HSIZE     (M_AHB_1_hsize[2:0]),                           // I  u_sram0
//    .HADDR     (M_AHB_1_haddr[31:0]),                          // I  u_sram0
//    .HWDATA    (M_AHB_1_hwdata[31:0]),                         // I  u_sram0
//    .HRDATA    (M_AHB_1_hrdata[31:0]),                         // O  u_sram0
//    .HREADY    (M_AHB_1_hready),                               // O  u_sram0
//    .HRESP     (slave_1_hresp[1:0]),                           // O  u_sram0
//    .sram_addr (sram_addr[13:0]),                              // O  u_sram0
//    .sram_ce_n (sram_ce_n),                                    // O  u_sram0
//    .sram_we_n (sram_we_n),                                    // O  u_sram0
//    .sram_be_n (sram_be_n[3:0]),                               // O  u_sram0
//    .sram_wdata(sram_wdata[31:0]),                             // O  u_sram0
//    .sram_rdata(sram_rdata[31:0])                              // I  u_sram0
//);

ahb_sram_ctrl #(
    .AHB_ADDR_WIDTH(32),
    .SRAM_ADDR_WIDTH(14),
    .DATA_WIDTH(32),
    .WAIT_CYCLES(0)
) u_sram0 (
    .HCLK               (HCLK),
    .HRESETn            (HRESETn),
    .HWRITE             (M_AHB_1_hwrite),
    .HTRANS             (M_AHB_1_htrans[1:0]),
    .HADDR              (M_AHB_1_haddr[31:0]),
    .HWDATA             (M_AHB_1_hwdata[31:0]),
    .HSIZE              (M_AHB_1_hsize[2:0]),
    .HRDATA             (M_AHB_1_hrdata[31:0]),
    .HREADY             (M_AHB_1_hready),
    .HRESP              (slave_1_hresp[1:0]),

    .SRAM_A             (sram_addr[13:0]),
    .SRAM_WDATA         (sram_wdata[31:0]),
    .SRAM_RDATA         (sram_rdata[31:0]),
    .SRAM_CE_N          (sram_ce_n),
    .SRAM_OE_N          (sram_oe_n),
    .SRAM_WE_N          (sram_we_b_en[3:0])
);

//ahb_slave_sram #(.ADDR_WIDTH(16)) u_sram0(
//    .HCLK      (HCLK),                                         // I  u_sram0
//    .HRESETn   (HRESETn),                                      // I  u_sram0
//    .HWRITE    (M_AHB_1_hwrite),                               // I  u_sram0
//    .HTRANS    (M_AHB_1_htrans[1:0]),                          // I  u_sram0
//    .HSIZE     (M_AHB_1_hsize[2:0]),                           // I  u_sram0
//    .HADDR     (M_AHB_1_haddr[31:0]),                          // I  u_sram0
//    .HWDATA    (M_AHB_1_hwdata[31:0]),                         // I  u_sram0
//    .HRDATA    (M_AHB_1_hrdata[31:0]),                         // O  u_sram0
//    .HREADY    (M_AHB_1_hready),                               // O  u_sram0
//    .HRESP     (slave_1_hresp[1:0]),                           // O  u_sram0
//    .sram_addr (sram_addr[13:0]),                              // O  u_sram0
//    .sram_ce_n (sram_ce_n),                                    // O  u_sram0
//    .sram_we_n (sram_we_n),                                    // O  u_sram0
//    .sram_be_n (sram_be_n[3:0]),                               // O  u_sram0
//    .sram_wdata(sram_wdata[31:0]),                             // O  u_sram0
//    .sram_rdata(sram_rdata[31:0])                              // I  u_sram0
//);
//

//    assign  sram_oe_n = ! sram_we_n;
//    assign  sram_we_b_en[3:0] = sram_we_n ? 4'b0 : sram_be_n[3:0];
    // =========RAM ============================
    RAM1_16Kx32B u_ram_16K(
    .CLK    (HCLK               ),   //I Global clock
    .CEN    (sram_ce_n          ),   //I Chip Enable (active low)
    .WEN    (sram_we_b_en[3:0]  ),   //I Byte-Write Enable (active low, 4-bit for 32-bit data)
    .OEN    (sram_oe_n          ),   //I Output Enable (active low)
    .A      ({2'b00,sram_addr[13:2]}    ),   //I 14-bit Address (64X1024 words)
    .Q      (sram_rdata[31:0]   ),   //O 32-bit Data Output
    .D      (sram_wdata[31:0]   )    //I 32-bit Data Input
);

// ============================================================
//  APB 外设子系统：挂在 M_AHB_3 (0x8000_0000 / 16M) 这条线上
//
//    AHB 主(ARM) --M_AHB_3--> ahb2apb --> apb_bus(地址译码)
//                                          |-- 0x8000_0000  apb_led
//                                          |-- 0x8000_1000  apb_timer
//                                          |-- 0x8000_2000  apb_uart
//
//  中断：timer_irq | uart_irq -> irq -> ARM nIRQ
// ============================================================
wire        apb_psel;
wire        apb_penable;
wire        apb_pwrite;
wire [31:0] apb_paddr;
wire [31:0] apb_pwdata;
wire [31:0] apb_prdata;
wire        apb_pready;
wire        apb_pslverr;

wire        psel_led,   psel_timer,   psel_uart;
wire [31:0] prdata_led, prdata_timer, prdata_uart;
wire        pready_led, pready_timer, pready_uart;
wire        perr_led,   perr_timer,   perr_uart;
wire        timer_irq,  uart_irq;

ahb2apb u_ahb2apb (
    .HCLK    (HCLK),
    .HRESETn (HRESETn),
    .HSEL    (1'b1),                     // 该口只会收到外设窗口的传输
    .HADDR   (M_AHB_3_haddr[31:0]),
    .HTRANS  (M_AHB_3_htrans[1:0]),
    .HWRITE  (M_AHB_3_hwrite),
    .HWDATA  (M_AHB_3_hwdata[31:0]),
    .HRDATA  (M_AHB_3_hrdata[31:0]),
    .HREADY  (M_AHB_3_hready),
    .HRESP   (M_AHB_3_hresp),
    .PSEL    (apb_psel),
    .PENABLE (apb_penable),
    .PWRITE  (apb_pwrite),
    .PADDR   (apb_paddr[31:0]),
    .PWDATA  (apb_pwdata[31:0]),
    .PRDATA  (apb_prdata[31:0]),
    .PREADY  (apb_pready),
    .PSLVERR (apb_pslverr)
);

apb_bus u_apb_bus (
    .PADDR         (apb_paddr[31:0]),
    .PSEL          (apb_psel),
    .PSEL_LED      (psel_led),
    .PSEL_TIMER    (psel_timer),
    .PSEL_UART     (psel_uart),
    .PRDATA_LED    (prdata_led[31:0]),
    .PRDATA_TIMER  (prdata_timer[31:0]),
    .PRDATA_UART   (prdata_uart[31:0]),
    .PREADY_LED    (pready_led),
    .PREADY_TIMER  (pready_timer),
    .PREADY_UART   (pready_uart),
    .PSLVERR_LED   (perr_led),
    .PSLVERR_TIMER (perr_timer),
    .PSLVERR_UART  (perr_uart),
    .PRDATA        (apb_prdata[31:0]),
    .PREADY        (apb_pready),
    .PSLVERR       (apb_pslverr)
);

apb_led u_apb_led (
    .PCLK    (HCLK),
    .PRESETn (HRESETn),
    .PSEL    (psel_led),
    .PENABLE (apb_penable),
    .PWRITE  (apb_pwrite),
    .PADDR   (apb_paddr[31:0]),
    .PWDATA  (apb_pwdata[31:0]),
    .PRDATA  (prdata_led[31:0]),
    .PREADY  (pready_led),
    .PSLVERR (perr_led),
    .led_out (led[7:0])
);

apb_timer u_apb_timer (
    .PCLK    (HCLK),
    .PRESETn (HRESETn),
    .PSEL    (psel_timer),
    .PENABLE (apb_penable),
    .PWRITE  (apb_pwrite),
    .PADDR   (apb_paddr[31:0]),
    .PWDATA  (apb_pwdata[31:0]),
    .PRDATA  (prdata_timer[31:0]),
    .PREADY  (pready_timer),
    .PSLVERR (perr_timer),
    .irq     (timer_irq)
);

apb_uart u_apb_uart (
    .PCLK     (HCLK),
    .PRESETn  (HRESETn),
    .PSEL     (psel_uart),
    .PENABLE  (apb_penable),
    .PWRITE   (apb_pwrite),
    .PADDR    (apb_paddr[31:0]),
    .PWDATA   (apb_pwdata[31:0]),
    .PRDATA   (prdata_uart[31:0]),
    .PREADY   (pready_uart),
    .PSLVERR  (perr_uart),
    .uart_rxd (uart_rxd),
    .uart_txd (uart_txd),
    .irq      (uart_irq)
);

assign irq = timer_irq | uart_irq;

// ============================================================================
// DDR3 控制器（AXI4 slave）接到 matrix 的 M_DDR_AXI 口
//   M_DDR_AXI 解码区间：0x4000_0000 - 0x403F_FFFF (4MB)
//   控制器与 crossbar 同频同域 (HCLK)，rst_axi 高有效
// ============================================================================
ddr3_top #(
     .DDR_MHZ            (50)        // clk_axi = HCLK = 50MHz
    ,.DDR_WRITE_LATENCY  (4)
    ,.DDR_READ_LATENCY   (4)
    ,.DQS_TAP_DELAY_INIT (27)
    ,.DQ_TAP_DELAY_INIT  (0)
    ,.TPHY_RDLAT         (4)        // 读数据有效窗口，仿真标定为 4
) u_ddr3_top (
     .clk_axi            (HCLK),
     .rst_axi            (~HRESETn),

     .s_axi_awaddr       (M_DDR_AXI_awaddr[31:0]),
     .s_axi_awid         (M_DDR_AXI_awid[4:0]),
     .s_axi_awlen        (M_DDR_AXI_awlen[7:0]),
     .s_axi_awburst      (M_DDR_AXI_awburst[1:0]),
     .s_axi_awvalid      (M_DDR_AXI_awvalid),
     .s_axi_awready      (M_DDR_AXI_awready),

     .s_axi_wdata        (M_DDR_AXI_wdata[31:0]),
     .s_axi_wstrb        (M_DDR_AXI_wstrb[3:0]),
     .s_axi_wlast        (M_DDR_AXI_wlast),
     .s_axi_wvalid       (M_DDR_AXI_wvalid),
     .s_axi_wready       (M_DDR_AXI_wready),

     .s_axi_bid          (M_DDR_AXI_bid[4:0]),
     .s_axi_bresp        (M_DDR_AXI_bresp[1:0]),
     .s_axi_bvalid       (M_DDR_AXI_bvalid),
     .s_axi_bready       (M_DDR_AXI_bready),

     .s_axi_araddr       (M_DDR_AXI_araddr[31:0]),
     .s_axi_arid         (M_DDR_AXI_arid[4:0]),
     .s_axi_arlen        (M_DDR_AXI_arlen[7:0]),
     .s_axi_arburst      (M_DDR_AXI_arburst[1:0]),
     .s_axi_arvalid      (M_DDR_AXI_arvalid),
     .s_axi_arready      (M_DDR_AXI_arready),

     .s_axi_rdata        (M_DDR_AXI_rdata[31:0]),
     .s_axi_rid          (M_DDR_AXI_rid[4:0]),
     .s_axi_rresp        (M_DDR_AXI_rresp[1:0]),
     .s_axi_rlast        (M_DDR_AXI_rlast),
     .s_axi_rvalid       (M_DDR_AXI_rvalid),
     .s_axi_rready       (M_DDR_AXI_rready),

     .clk_ddr            (clk_ddr),
     .clk_ddr90          (clk_ddr90),
     .clk_ref            (clk_ref),

     .ddr3_ck_p          (ddr3_ck_p),
     .ddr3_ck_n          (ddr3_ck_n),
     .ddr3_cke           (ddr3_cke),
     .ddr3_reset_n       (ddr3_reset_n),
     .ddr3_ras_n         (ddr3_ras_n),
     .ddr3_cas_n         (ddr3_cas_n),
     .ddr3_we_n          (ddr3_we_n),
     .ddr3_cs_n          (ddr3_cs_n),
     .ddr3_ba            (ddr3_ba[2:0]),
     .ddr3_addr          (ddr3_addr[13:0]),
     .ddr3_odt           (ddr3_odt),
     .ddr3_dm            (ddr3_dm[1:0]),
     .ddr3_dqs_p         (ddr3_dqs_p[1:0]),
     .ddr3_dqs_n         (ddr3_dqs_n[1:0]),
     .ddr3_dq            (ddr3_dq[15:0])
);

endmodule
