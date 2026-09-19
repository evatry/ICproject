//=====================================================================
//  ddr3_top.v
//  AXI4(32bit) -> DDR3 x16 控制器 + Xilinx 7 系列 DFI PHY
//
//  - AXI 侧 32 位，与 SoC crossbar 同频同域（clk_axi）
//  - DRAM 侧 16 位：单片 x16 2Gb = 256MB
//  - clk_ddr = 4 x clk_axi，clk_ddr90 为同频移相 90 度，clk_ref 供 IDELAYCTRL
//  - 参考实现：ultraembedded/core_ddr3_controller 的 tb/ddr3_core_xc7 例程
//
//  注意：AXI 侧 ID 宽 5 位，与 crossbar 的 M_DDR_AXI 一致。BD 里两个 AHB
//        从口（I/D）的 base ID 分别是 0x00 与 0x10，即最高位用来区分从口，
//        必须原样透传返回，否则 crossbar 无法把 B/R 响应路由回发起方。
//=====================================================================
`timescale 1ns/1ps

// 防止前序文件遗留 `default_nettype none（DDR3 代码按标准 Verilog 编写）
`default_nettype wire

module ddr3_top #(
     parameter DDR_MHZ            = 50      // 控制器/AXI 时钟 MHz（core 用它算刷新周期）
    ,parameter DDR_WRITE_LATENCY  = 4
    ,parameter DDR_READ_LATENCY   = 4
    ,parameter DQS_TAP_DELAY_INIT = 27
    ,parameter DQ_TAP_DELAY_INIT  = 0
    ,parameter TPHY_RDLAT         = 5
)(
    // ---------------- AXI4 slave (32bit) ----------------
    input  wire        clk_axi,
    input  wire        rst_axi,            // 高有效

    input  wire [31:0] s_axi_awaddr,
    input  wire [4:0]  s_axi_awid,
    input  wire [7:0]  s_axi_awlen,
    input  wire [1:0]  s_axi_awburst,
    input  wire        s_axi_awvalid,
    output wire        s_axi_awready,

    input  wire [31:0] s_axi_wdata,
    input  wire [3:0]  s_axi_wstrb,
    input  wire        s_axi_wlast,
    input  wire        s_axi_wvalid,
    output wire        s_axi_wready,

    output wire [4:0]  s_axi_bid,
    output wire [1:0]  s_axi_bresp,
    output wire        s_axi_bvalid,
    input  wire        s_axi_bready,

    input  wire [31:0] s_axi_araddr,
    input  wire [4:0]  s_axi_arid,
    input  wire [7:0]  s_axi_arlen,
    input  wire [1:0]  s_axi_arburst,
    input  wire        s_axi_arvalid,
    output wire        s_axi_arready,

    output wire [31:0] s_axi_rdata,
    output wire [4:0]  s_axi_rid,
    output wire [1:0]  s_axi_rresp,
    output wire        s_axi_rlast,
    output wire        s_axi_rvalid,
    input  wire        s_axi_rready,

    // ---------------- DDR 侧时钟 ----------------
    input  wire        clk_ddr,            // = 4 x clk_axi
    input  wire        clk_ddr90,          // 同频移相 90 度
    input  wire        clk_ref,            // IDELAYCTRL 参考时钟

    // ---------------- DDR3 器件引脚 ----------------
    output wire        ddr3_ck_p,
    output wire        ddr3_ck_n,
    output wire        ddr3_cke,
    output wire        ddr3_reset_n,
    output wire        ddr3_ras_n,
    output wire        ddr3_cas_n,
    output wire        ddr3_we_n,
    output wire        ddr3_cs_n,
    output wire [ 2:0] ddr3_ba,
    output wire [13:0] ddr3_addr,
    output wire        ddr3_odt,
    output wire [ 1:0] ddr3_dm,
    inout  wire [ 1:0] ddr3_dqs_p,
    inout  wire [ 1:0] ddr3_dqs_n,
    inout  wire [15:0] ddr3_dq
);

    //-----------------------------------------------------------------
    // DFI
    //-----------------------------------------------------------------
    wire [14:0] dfi_address;
    wire [ 2:0] dfi_bank;
    wire        dfi_cas_n;
    wire        dfi_cke;
    wire        dfi_cs_n;
    wire        dfi_odt;
    wire        dfi_ras_n;
    wire        dfi_reset_n;
    wire        dfi_we_n;
    wire [31:0] dfi_wrdata;
    wire        dfi_wrdata_en;
    wire [ 3:0] dfi_wrdata_mask;
    wire        dfi_rddata_en;
    wire [31:0] dfi_rddata;
    wire        dfi_rddata_valid;
    wire [ 1:0] dfi_rddata_dnv;

    wire [4:0]  bid_w;
    wire [4:0]  rid_w;

    //-----------------------------------------------------------------
    // AXI4 -> DDR3 core
    //-----------------------------------------------------------------
    ddr3_axi #(
         .DDR_MHZ           (DDR_MHZ)
        ,.DDR_WRITE_LATENCY (DDR_WRITE_LATENCY)
        ,.DDR_READ_LATENCY  (DDR_READ_LATENCY)
    ) u_ddr3_axi (
         .clk_i              (clk_axi)
        ,.rst_i              (rst_axi)

        ,.inport_awvalid_i   (s_axi_awvalid)
        ,.inport_awaddr_i    (s_axi_awaddr)
        ,.inport_awid_i      (s_axi_awid[4:0])
        ,.inport_awlen_i     (s_axi_awlen)
        ,.inport_awburst_i   (s_axi_awburst)
        ,.inport_wvalid_i    (s_axi_wvalid)
        ,.inport_wdata_i     (s_axi_wdata)
        ,.inport_wstrb_i     (s_axi_wstrb)
        ,.inport_wlast_i     (s_axi_wlast)
        ,.inport_bready_i    (s_axi_bready)
        ,.inport_arvalid_i   (s_axi_arvalid)
        ,.inport_araddr_i    (s_axi_araddr)
        ,.inport_arid_i      (s_axi_arid[4:0])
        ,.inport_arlen_i     (s_axi_arlen)
        ,.inport_arburst_i   (s_axi_arburst)
        ,.inport_rready_i    (s_axi_rready)

        ,.inport_awready_o   (s_axi_awready)
        ,.inport_wready_o    (s_axi_wready)
        ,.inport_bvalid_o    (s_axi_bvalid)
        ,.inport_bresp_o     (s_axi_bresp)
        ,.inport_bid_o       (bid_w)
        ,.inport_arready_o   (s_axi_arready)
        ,.inport_rvalid_o    (s_axi_rvalid)
        ,.inport_rdata_o     (s_axi_rdata)
        ,.inport_rresp_o     (s_axi_rresp)
        ,.inport_rid_o       (rid_w)
        ,.inport_rlast_o     (s_axi_rlast)

        ,.dfi_address_o      (dfi_address)
        ,.dfi_bank_o         (dfi_bank)
        ,.dfi_cas_n_o        (dfi_cas_n)
        ,.dfi_cke_o          (dfi_cke)
        ,.dfi_cs_n_o         (dfi_cs_n)
        ,.dfi_odt_o          (dfi_odt)
        ,.dfi_ras_n_o        (dfi_ras_n)
        ,.dfi_reset_n_o      (dfi_reset_n)
        ,.dfi_we_n_o         (dfi_we_n)
        ,.dfi_wrdata_o       (dfi_wrdata)
        ,.dfi_wrdata_en_o    (dfi_wrdata_en)
        ,.dfi_wrdata_mask_o  (dfi_wrdata_mask)
        ,.dfi_rddata_en_o    (dfi_rddata_en)

        ,.dfi_rddata_i       (dfi_rddata)
        ,.dfi_rddata_valid_i (dfi_rddata_valid)
        ,.dfi_rddata_dnv_i   (dfi_rddata_dnv)
    );

    // 5 位 ID 原样返回（bit4 = 从口索引，bit3:0 = thread ID）
    assign s_axi_bid = bid_w;
    assign s_axi_rid = rid_w;

    //-----------------------------------------------------------------
    // DFI PHY (Xilinx 7 series)
    //-----------------------------------------------------------------
    ddr3_dfi_phy #(
         .REFCLK_FREQUENCY   (200)
        ,.DQS_TAP_DELAY_INIT (DQS_TAP_DELAY_INIT)
        ,.DQ_TAP_DELAY_INIT  (DQ_TAP_DELAY_INIT)
        ,.TPHY_RDLAT         (TPHY_RDLAT)
    ) u_ddr3_phy (
         .clk_i              (clk_axi)
        ,.clk_ddr_i          (clk_ddr)
        ,.clk_ddr90_i        (clk_ddr90)
        ,.clk_ref_i          (clk_ref)
        ,.rst_i              (rst_axi)

        ,.cfg_valid_i        (1'b0)
        ,.cfg_i              (32'b0)

        ,.dfi_address_i      (dfi_address)
        ,.dfi_bank_i         (dfi_bank)
        ,.dfi_cas_n_i        (dfi_cas_n)
        ,.dfi_cke_i          (dfi_cke)
        ,.dfi_cs_n_i         (dfi_cs_n)
        ,.dfi_odt_i          (dfi_odt)
        ,.dfi_ras_n_i        (dfi_ras_n)
        ,.dfi_reset_n_i      (dfi_reset_n)
        ,.dfi_we_n_i         (dfi_we_n)
        ,.dfi_wrdata_i       (dfi_wrdata)
        ,.dfi_wrdata_en_i    (dfi_wrdata_en)
        ,.dfi_wrdata_mask_i  (dfi_wrdata_mask)
        ,.dfi_rddata_en_i    (dfi_rddata_en)

        ,.dfi_rddata_o       (dfi_rddata)
        ,.dfi_rddata_valid_o (dfi_rddata_valid)
        ,.dfi_rddata_dnv_o   (dfi_rddata_dnv)

        ,.ddr3_ck_p_o        (ddr3_ck_p)
        ,.ddr3_ck_n_o        (ddr3_ck_n)
        ,.ddr3_cke_o         (ddr3_cke)
        ,.ddr3_reset_n_o     (ddr3_reset_n)
        ,.ddr3_ras_n_o       (ddr3_ras_n)
        ,.ddr3_cas_n_o       (ddr3_cas_n)
        ,.ddr3_we_n_o        (ddr3_we_n)
        ,.ddr3_cs_n_o        (ddr3_cs_n)
        ,.ddr3_ba_o          (ddr3_ba)
        ,.ddr3_addr_o        (ddr3_addr)
        ,.ddr3_odt_o         (ddr3_odt)
        ,.ddr3_dm_o          (ddr3_dm)
        ,.ddr3_dqs_p_io      (ddr3_dqs_p)
        ,.ddr3_dqs_n_io      (ddr3_dqs_n)
        ,.ddr3_dq_io         (ddr3_dq)
    );

endmodule
