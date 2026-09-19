`timescale 1ns/1ps
//=====================================================================
//  matrix_ddr_tb.v
//  通过 ahb_axi_matrix_wrapper 的 AHB 从口访问 M_DDR_AXI (0x4000_0000)，
//  验证 crossbar -> DDR3 的完整通路，特别是 B/R 响应的 ID 路由：
//    AHB_INTERFACE_1_* (数据口) -> S_AXI slot1 -> MI ID = 0x10
//    AHB_INTERFACE_*   (指令口) -> S_AXI slot0 -> MI ID = 0x00
//  若 DDR3 没有原样回传 5 位 ID，crossbar 会把响应路由到错误的从口 -> 挂死。
//=====================================================================
module matrix_ddr_tb;

reg clk = 1'b0;
reg hreset = 1'b0;
reg clk_ddr = 1'b1;
reg clk_ddr90 = 1'b0;
reg clk_ref = 1'b0;

// ---------------- AHB master (数据口) ----------------
reg  [31:0] d_haddr;  reg [2:0] d_hburst; reg [3:0] d_hprot; reg [2:0] d_hsize;
reg  [1:0]  d_htrans; reg [31:0] d_hwdata; reg d_hwrite; reg d_hsel;
wire [31:0] d_hrdata; wire d_hready; wire d_hresp;

// ---------------- AHB master (指令口) ----------------
reg  [31:0] i_haddr;  reg [2:0] i_hburst; reg [3:0] i_hprot; reg [2:0] i_hsize;
reg  [1:0]  i_htrans; reg [31:0] i_hwdata; reg i_hwrite; reg i_hsel;
wire [31:0] i_hrdata; wire i_hready; wire i_hresp;

// ---------------- M_DDR_AXI ----------------
wire [31:0] araddr; wire [1:0] arburst; wire [3:0] arcache; wire [4:0] arid;
wire [7:0]  arlen;  wire arlock; wire [2:0] arprot; wire [3:0] arqos;
wire arready; wire [3:0] arregion; wire [2:0] arsize; wire arvalid;
wire [31:0] awaddr; wire [1:0] awburst; wire [3:0] awcache; wire [4:0] awid;
wire [7:0]  awlen;  wire awlock; wire [2:0] awprot; wire [3:0] awqos;
wire awready; wire [3:0] awregion; wire [2:0] awsize; wire awvalid;
wire [4:0]  bid;    wire bready; wire [1:0] bresp; wire bvalid;
wire [31:0] rdata;  wire [4:0] rid; wire rlast; wire rready; wire [1:0] rresp; wire rvalid;
wire [31:0] wdata;  wire wlast; wire wready; wire [3:0] wstrb; wire wvalid;

// ---------------- DDR3 pins ----------------
wire ddr3_ck_p, ddr3_ck_n, ddr3_cke, ddr3_reset_n;
wire ddr3_ras_n, ddr3_cas_n, ddr3_we_n, ddr3_cs_n, ddr3_odt;
wire [2:0] ddr3_ba; wire [13:0] ddr3_addr; wire [1:0] ddr3_dm;
wire [1:0] ddr3_dqs_p, ddr3_dqs_n; wire [15:0] ddr3_dq;

integer errors = 0;
integer i;
reg [31:0] rd;

always #10 clk = ~clk;
initial forever #2.5 clk_ddr = ~clk_ddr;
// 写 DQS 由 clk_ddr90 产生: 取 -90 度(3.75ns) 可让 Micron 模型
// 的 tDQSS/tDSH 检查全部通过 (+90 度 1.25ns 会报违规)
initial begin #3.75; forever #2.5 clk_ddr90 = ~clk_ddr90; end
initial forever #2.5 clk_ref = ~clk_ref;

// ---------------- crossbar ----------------
ahb_axi_matrix_wrapper u_matrix (
    .AHB_INTERFACE_1_haddr      (d_haddr),
    .AHB_INTERFACE_1_hburst     (d_hburst),
    .AHB_INTERFACE_1_hprot      (d_hprot),
    .AHB_INTERFACE_1_hrdata     (d_hrdata),
    .AHB_INTERFACE_1_hready_in  (d_hready),
    .AHB_INTERFACE_1_hready_out (d_hready),
    .AHB_INTERFACE_1_hresp      (d_hresp),
    .AHB_INTERFACE_1_hsize      (d_hsize),
    .AHB_INTERFACE_1_htrans     (d_htrans),
    .AHB_INTERFACE_1_hwdata     (d_hwdata),
    .AHB_INTERFACE_1_hwrite     (d_hwrite),
    .AHB_INTERFACE_1_sel        (d_hsel),
    .AHB_INTERFACE_haddr        (i_haddr),
    .AHB_INTERFACE_hburst       (i_hburst),
    .AHB_INTERFACE_hprot        (i_hprot),
    .AHB_INTERFACE_hrdata       (i_hrdata),
    .AHB_INTERFACE_hready_in    (i_hready),
    .AHB_INTERFACE_hready_out   (i_hready),
    .AHB_INTERFACE_hresp        (i_hresp),
    .AHB_INTERFACE_hsize        (i_hsize),
    .AHB_INTERFACE_htrans       (i_htrans),
    .AHB_INTERFACE_hwdata       (i_hwdata),
    .AHB_INTERFACE_hwrite       (i_hwrite),
    .AHB_INTERFACE_sel          (i_hsel),
    // 其它 AHB 从口悬空但必须回 HREADY，否则 crossbar 会挂
    .M_AHB_1_haddr              (), .M_AHB_1_hburst   (), .M_AHB_1_hmastlock(),
    .M_AHB_1_hprot              (), .M_AHB_1_hrdata   (32'b0), .M_AHB_1_hready(1'b1),
    .M_AHB_1_hresp              (1'b0), .M_AHB_1_hsize (), .M_AHB_1_htrans (),
    .M_AHB_1_hwdata             (), .M_AHB_1_hwrite   (),
    .M_AHB_3_haddr              (), .M_AHB_3_hburst   (), .M_AHB_3_hmastlock(),
    .M_AHB_3_hprot              (), .M_AHB_3_hrdata   (32'b0), .M_AHB_3_hready(1'b1),
    .M_AHB_3_hresp              (1'b0), .M_AHB_3_hsize (), .M_AHB_3_htrans (),
    .M_AHB_3_hwdata             (), .M_AHB_3_hwrite   (),
    .M_AHB_haddr                (), .M_AHB_hburst     (), .M_AHB_hmastlock(),
    .M_AHB_hprot                (), .M_AHB_hrdata     (32'b0), .M_AHB_hready  (1'b1),
    .M_AHB_hresp                (1'b0), .M_AHB_hsize   (), .M_AHB_htrans   (),
    .M_AHB_hwdata               (), .M_AHB_hwrite     (),
    .M_DDR_AXI_araddr           (araddr),  .M_DDR_AXI_arburst (arburst),
    .M_DDR_AXI_arcache          (arcache), .M_DDR_AXI_arid    (arid),
    .M_DDR_AXI_arlen            (arlen),   .M_DDR_AXI_arlock  (arlock),
    .M_DDR_AXI_arprot           (arprot),  .M_DDR_AXI_arqos   (arqos),
    .M_DDR_AXI_arready          (arready), .M_DDR_AXI_arregion(arregion),
    .M_DDR_AXI_arsize           (arsize),  .M_DDR_AXI_arvalid (arvalid),
    .M_DDR_AXI_awaddr           (awaddr),  .M_DDR_AXI_awburst (awburst),
    .M_DDR_AXI_awcache          (awcache), .M_DDR_AXI_awid    (awid),
    .M_DDR_AXI_awlen            (awlen),   .M_DDR_AXI_awlock  (awlock),
    .M_DDR_AXI_awprot           (awprot),  .M_DDR_AXI_awqos   (awqos),
    .M_DDR_AXI_awready          (awready), .M_DDR_AXI_awregion(awregion),
    .M_DDR_AXI_awsize           (awsize),  .M_DDR_AXI_awvalid (awvalid),
    .M_DDR_AXI_bid              (bid),     .M_DDR_AXI_bready  (bready),
    .M_DDR_AXI_bresp            (bresp),   .M_DDR_AXI_bvalid  (bvalid),
    .M_DDR_AXI_rdata            (rdata),   .M_DDR_AXI_rid     (rid),
    .M_DDR_AXI_rlast            (rlast),   .M_DDR_AXI_rready  (rready),
    .M_DDR_AXI_rresp            (rresp),   .M_DDR_AXI_rvalid  (rvalid),
    .M_DDR_AXI_wdata            (wdata),   .M_DDR_AXI_wlast   (wlast),
    .M_DDR_AXI_wready           (wready),  .M_DDR_AXI_wstrb   (wstrb),
    .M_DDR_AXI_wvalid           (wvalid),
    .clk_100MHz                 (clk),
    .hreset                     (hreset)
);

// ---------------- DDR3 controller ----------------
ddr3_top #(
     .DDR_MHZ(50), .DDR_WRITE_LATENCY(4), .DDR_READ_LATENCY(4),
     .DQS_TAP_DELAY_INIT(27), .DQ_TAP_DELAY_INIT(0), .TPHY_RDLAT(4)
) u_ddr3 (
     .clk_axi(clk), .rst_axi(~hreset),
     .s_axi_awaddr(awaddr), .s_axi_awid(awid), .s_axi_awlen(awlen),
     .s_axi_awburst(awburst), .s_axi_awvalid(awvalid), .s_axi_awready(awready),
     .s_axi_wdata(wdata), .s_axi_wstrb(wstrb), .s_axi_wlast(wlast),
     .s_axi_wvalid(wvalid), .s_axi_wready(wready),
     .s_axi_bid(bid), .s_axi_bresp(bresp), .s_axi_bvalid(bvalid), .s_axi_bready(bready),
     .s_axi_araddr(araddr), .s_axi_arid(arid), .s_axi_arlen(arlen),
     .s_axi_arburst(arburst), .s_axi_arvalid(arvalid), .s_axi_arready(arready),
     .s_axi_rdata(rdata), .s_axi_rid(rid), .s_axi_rresp(rresp),
     .s_axi_rlast(rlast), .s_axi_rvalid(rvalid), .s_axi_rready(rready),
     .clk_ddr(clk_ddr), .clk_ddr90(clk_ddr90), .clk_ref(clk_ref),
     .ddr3_ck_p(ddr3_ck_p), .ddr3_ck_n(ddr3_ck_n), .ddr3_cke(ddr3_cke),
     .ddr3_reset_n(ddr3_reset_n), .ddr3_ras_n(ddr3_ras_n), .ddr3_cas_n(ddr3_cas_n),
     .ddr3_we_n(ddr3_we_n), .ddr3_cs_n(ddr3_cs_n), .ddr3_ba(ddr3_ba),
     .ddr3_addr(ddr3_addr), .ddr3_odt(ddr3_odt), .ddr3_dm(ddr3_dm),
     .ddr3_dqs_p(ddr3_dqs_p), .ddr3_dqs_n(ddr3_dqs_n), .ddr3_dq(ddr3_dq)
);

ddr3 #(.DEBUG(0), .check_strict_mrbits(1), .check_strict_timing(0)) u_model (
     .rst_n(ddr3_reset_n), .ck(ddr3_ck_p), .ck_n(ddr3_ck_n), .cke(ddr3_cke),
     .cs_n(ddr3_cs_n), .ras_n(ddr3_ras_n), .cas_n(ddr3_cas_n), .we_n(ddr3_we_n),
     .dm_tdqs(ddr3_dm), .ba(ddr3_ba), .addr(ddr3_addr), .dq(ddr3_dq),
     .dqs(ddr3_dqs_p), .dqs_n(ddr3_dqs_n), .tdqs_n(), .odt(ddr3_odt)
);

// ---------------- AHB 单拍 写/读 ----------------
task ahb_write_data(input [31:0] a, input [31:0] d);
begin
    @(posedge clk); #1;
    d_haddr = a; d_htrans = 2'b10; d_hwrite = 1'b1; d_hsize = 3'b010;
    d_hburst = 3'b000; d_hprot = 4'h0; d_hsel = 1'b1; d_hwdata = d;
    @(posedge clk);                 // 地址相位被接受
    d_htrans = 2'b00; d_hsel = 1'b0;
    @(posedge clk);                 // 数据相位第一拍
    while (d_hready !== 1'b1) @(posedge clk);
    @(posedge clk);
end
endtask

task ahb_read_data(input [31:0] a, output [31:0] d);
begin
    @(posedge clk); #1;
    d_haddr = a; d_htrans = 2'b10; d_hwrite = 1'b0; d_hsize = 3'b010;
    d_hburst = 3'b000; d_hprot = 4'h0; d_hsel = 1'b1; d_hwdata = 32'b0;
    @(posedge clk);                 // 地址相位被接受
    d_htrans = 2'b00; d_hsel = 1'b0;
    @(posedge clk);                 // 数据相位第一拍
    while (d_hready !== 1'b1) @(posedge clk);
    d = d_hrdata;
    @(posedge clk);
end
endtask

task ahb_read_instr(input [31:0] a, output [31:0] d);
begin
    @(posedge clk); #1;
    i_haddr = a; i_htrans = 2'b10; i_hwrite = 1'b0; i_hsize = 3'b010;
    i_hburst = 3'b000; i_hprot = 4'h0; i_hsel = 1'b1; i_hwdata = 32'b0;
    @(posedge clk);                 // 地址相位被接受
    i_htrans = 2'b00; i_hsel = 1'b0;
    @(posedge clk);                 // 数据相位第一拍
    while (i_hready !== 1'b1) @(posedge clk);
    d = i_hrdata;
    @(posedge clk);
end
endtask

initial begin
    d_haddr=0; d_htrans=0; d_hwrite=0; d_hsize=0; d_hburst=0; d_hprot=0; d_hsel=0; d_hwdata=0;
    i_haddr=0; i_htrans=0; i_hwrite=0; i_hsize=0; i_hburst=0; i_hprot=0; i_hsel=0; i_hwdata=0;
    hreset = 1'b0;          // 该端口实为低有效 (peripheral_aresetn)
    #1500;
    hreset = 1'b1;
    $display("[%0t] reset released", $time);

    // 数据口 (ID=0x10) 写 4 个地址，再读回
    for (i = 0; i < 4; i = i + 1)
        ahb_write_data(32'h4000_0000 + i*4, 32'hC0DE_0000 + i);
    for (i = 0; i < 4; i = i + 1) begin
        ahb_read_data(32'h4000_0000 + i*4, rd);
        if (rd !== (32'hC0DE_0000 + i)) begin
            $display("[%0t] ERROR(data port) addr=%h rd=%h exp=%h", $time, 32'h4000_0000+i*4, rd, 32'hC0DE_0000+i);
            errors = errors + 1;
        end else
            $display("[%0t] OK  data port addr=%h rd=%h", $time, 32'h4000_0000+i*4, rd);
    end

    // 指令口 (ID=0x00) 读同样的地址，验证 slot0 的响应也能正确路由
    for (i = 0; i < 4; i = i + 1) begin
        ahb_read_instr(32'h4000_0000 + i*4, rd);
        if (rd !== (32'hC0DE_0000 + i)) begin
            $display("[%0t] ERROR(instr port) addr=%h rd=%h exp=%h", $time, 32'h4000_0000+i*4, rd, 32'hC0DE_0000+i);
            errors = errors + 1;
        end else
            $display("[%0t] OK  instr port addr=%h rd=%h", $time, 32'h4000_0000+i*4, rd);
    end

    if (errors == 0) $display("==== MATRIX->DDR3 TB PASS ====");
    else             $display("==== MATRIX->DDR3 TB FAIL: %0d errors ====", errors);
    $finish;
end

initial begin
    #2000000;
    $display("==== MATRIX->DDR3 TB TIMEOUT (errors=%0d) ====", errors);
    $finish;
end

endmodule
