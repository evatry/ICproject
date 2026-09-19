//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.1 (lin64) Build 2552052 Fri May 24 14:47:09 MDT 2019
//Date        : Sat Sep 19 14:40:58 2026
//Host        : IC_EDA running 64-bit CentOS Linux release 7.9.2009 (Core)
//Command     : generate_target ahb_axi_matrix.bd
//Design      : ahb_axi_matrix
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "ahb_axi_matrix,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=ahb_axi_matrix,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=6,numReposBlks=6,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,da_clkrst_cnt=3,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "ahb_axi_matrix.hwdef" *) 
module ahb_axi_matrix
   (AHB_INTERFACE_1_haddr,
    AHB_INTERFACE_1_hburst,
    AHB_INTERFACE_1_hprot,
    AHB_INTERFACE_1_hrdata,
    AHB_INTERFACE_1_hready_in,
    AHB_INTERFACE_1_hready_out,
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
    AHB_INTERFACE_hready_in,
    AHB_INTERFACE_hready_out,
    AHB_INTERFACE_hresp,
    AHB_INTERFACE_hsize,
    AHB_INTERFACE_htrans,
    AHB_INTERFACE_hwdata,
    AHB_INTERFACE_hwrite,
    AHB_INTERFACE_sel,
    M_AHB_1_haddr,
    M_AHB_1_hburst,
    M_AHB_1_hmastlock,
    M_AHB_1_hprot,
    M_AHB_1_hrdata,
    M_AHB_1_hready,
    M_AHB_1_hresp,
    M_AHB_1_hsize,
    M_AHB_1_htrans,
    M_AHB_1_hwdata,
    M_AHB_1_hwrite,
    M_AHB_3_haddr,
    M_AHB_3_hburst,
    M_AHB_3_hmastlock,
    M_AHB_3_hprot,
    M_AHB_3_hrdata,
    M_AHB_3_hready,
    M_AHB_3_hresp,
    M_AHB_3_hsize,
    M_AHB_3_htrans,
    M_AHB_3_hwdata,
    M_AHB_3_hwrite,
    M_AHB_haddr,
    M_AHB_hburst,
    M_AHB_hmastlock,
    M_AHB_hprot,
    M_AHB_hrdata,
    M_AHB_hready,
    M_AHB_hresp,
    M_AHB_hsize,
    M_AHB_htrans,
    M_AHB_hwdata,
    M_AHB_hwrite,
    M_DDR_AXI_araddr,
    M_DDR_AXI_arburst,
    M_DDR_AXI_arcache,
    M_DDR_AXI_arid,
    M_DDR_AXI_arlen,
    M_DDR_AXI_arlock,
    M_DDR_AXI_arprot,
    M_DDR_AXI_arqos,
    M_DDR_AXI_arready,
    M_DDR_AXI_arregion,
    M_DDR_AXI_arsize,
    M_DDR_AXI_arvalid,
    M_DDR_AXI_awaddr,
    M_DDR_AXI_awburst,
    M_DDR_AXI_awcache,
    M_DDR_AXI_awid,
    M_DDR_AXI_awlen,
    M_DDR_AXI_awlock,
    M_DDR_AXI_awprot,
    M_DDR_AXI_awqos,
    M_DDR_AXI_awready,
    M_DDR_AXI_awregion,
    M_DDR_AXI_awsize,
    M_DDR_AXI_awvalid,
    M_DDR_AXI_bid,
    M_DDR_AXI_bready,
    M_DDR_AXI_bresp,
    M_DDR_AXI_bvalid,
    M_DDR_AXI_rdata,
    M_DDR_AXI_rid,
    M_DDR_AXI_rlast,
    M_DDR_AXI_rready,
    M_DDR_AXI_rresp,
    M_DDR_AXI_rvalid,
    M_DDR_AXI_wdata,
    M_DDR_AXI_wlast,
    M_DDR_AXI_wready,
    M_DDR_AXI_wstrb,
    M_DDR_AXI_wvalid,
    clk_100MHz,
    hreset);
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 AHB_INTERFACE_1 HADDR" *) input [31:0]AHB_INTERFACE_1_haddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 AHB_INTERFACE_1 HBURST" *) input [2:0]AHB_INTERFACE_1_hburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 AHB_INTERFACE_1 HPROT" *) input [3:0]AHB_INTERFACE_1_hprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 AHB_INTERFACE_1 HRDATA" *) output [31:0]AHB_INTERFACE_1_hrdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 AHB_INTERFACE_1 HREADY_IN" *) input AHB_INTERFACE_1_hready_in;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 AHB_INTERFACE_1 HREADY_OUT" *) output AHB_INTERFACE_1_hready_out;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 AHB_INTERFACE_1 HRESP" *) output AHB_INTERFACE_1_hresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 AHB_INTERFACE_1 HSIZE" *) input [2:0]AHB_INTERFACE_1_hsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 AHB_INTERFACE_1 HTRANS" *) input [1:0]AHB_INTERFACE_1_htrans;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 AHB_INTERFACE_1 HWDATA" *) input [31:0]AHB_INTERFACE_1_hwdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 AHB_INTERFACE_1 HWRITE" *) input AHB_INTERFACE_1_hwrite;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 AHB_INTERFACE_1 SEL" *) input AHB_INTERFACE_1_sel;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 AHB_INTERFACE HADDR" *) input [31:0]AHB_INTERFACE_haddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 AHB_INTERFACE HBURST" *) input [2:0]AHB_INTERFACE_hburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 AHB_INTERFACE HPROT" *) input [3:0]AHB_INTERFACE_hprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 AHB_INTERFACE HRDATA" *) output [31:0]AHB_INTERFACE_hrdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 AHB_INTERFACE HREADY_IN" *) input AHB_INTERFACE_hready_in;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 AHB_INTERFACE HREADY_OUT" *) output AHB_INTERFACE_hready_out;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 AHB_INTERFACE HRESP" *) output AHB_INTERFACE_hresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 AHB_INTERFACE HSIZE" *) input [2:0]AHB_INTERFACE_hsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 AHB_INTERFACE HTRANS" *) input [1:0]AHB_INTERFACE_htrans;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 AHB_INTERFACE HWDATA" *) input [31:0]AHB_INTERFACE_hwdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 AHB_INTERFACE HWRITE" *) input AHB_INTERFACE_hwrite;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 AHB_INTERFACE SEL" *) input AHB_INTERFACE_sel;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 M_AHB_1 HADDR" *) output [31:0]M_AHB_1_haddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 M_AHB_1 HBURST" *) output [2:0]M_AHB_1_hburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 M_AHB_1 HMASTLOCK" *) output M_AHB_1_hmastlock;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 M_AHB_1 HPROT" *) output [3:0]M_AHB_1_hprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 M_AHB_1 HRDATA" *) input [31:0]M_AHB_1_hrdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 M_AHB_1 HREADY" *) input M_AHB_1_hready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 M_AHB_1 HRESP" *) input M_AHB_1_hresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 M_AHB_1 HSIZE" *) output [2:0]M_AHB_1_hsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 M_AHB_1 HTRANS" *) output [1:0]M_AHB_1_htrans;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 M_AHB_1 HWDATA" *) output [31:0]M_AHB_1_hwdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 M_AHB_1 HWRITE" *) output M_AHB_1_hwrite;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 M_AHB_3 HADDR" *) output [31:0]M_AHB_3_haddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 M_AHB_3 HBURST" *) output [2:0]M_AHB_3_hburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 M_AHB_3 HMASTLOCK" *) output M_AHB_3_hmastlock;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 M_AHB_3 HPROT" *) output [3:0]M_AHB_3_hprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 M_AHB_3 HRDATA" *) input [31:0]M_AHB_3_hrdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 M_AHB_3 HREADY" *) input M_AHB_3_hready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 M_AHB_3 HRESP" *) input M_AHB_3_hresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 M_AHB_3 HSIZE" *) output [2:0]M_AHB_3_hsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 M_AHB_3 HTRANS" *) output [1:0]M_AHB_3_htrans;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 M_AHB_3 HWDATA" *) output [31:0]M_AHB_3_hwdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 M_AHB_3 HWRITE" *) output M_AHB_3_hwrite;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 M_AHB HADDR" *) output [31:0]M_AHB_haddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 M_AHB HBURST" *) output [2:0]M_AHB_hburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 M_AHB HMASTLOCK" *) output M_AHB_hmastlock;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 M_AHB HPROT" *) output [3:0]M_AHB_hprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 M_AHB HRDATA" *) input [31:0]M_AHB_hrdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 M_AHB HREADY" *) input M_AHB_hready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 M_AHB HRESP" *) input M_AHB_hresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 M_AHB HSIZE" *) output [2:0]M_AHB_hsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 M_AHB HTRANS" *) output [1:0]M_AHB_htrans;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 M_AHB HWDATA" *) output [31:0]M_AHB_hwdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:ahblite:2.0 M_AHB HWRITE" *) output M_AHB_hwrite;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DDR_AXI " *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M_DDR_AXI, ADDR_WIDTH 32, ARUSER_WIDTH 0, AWUSER_WIDTH 0, BUSER_WIDTH 0, CLK_DOMAIN ahb_axi_matrix_clk_100MHz, DATA_WIDTH 32, FREQ_HZ 100000000, HAS_BRESP 1, HAS_BURST 0, HAS_CACHE 1, HAS_LOCK 1, HAS_PROT 1, HAS_QOS 0, HAS_REGION 0, HAS_RRESP 1, HAS_WSTRB 1, ID_WIDTH 5, INSERT_VIP 0, MAX_BURST_LENGTH 16, NUM_READ_OUTSTANDING 2, NUM_READ_THREADS 1, NUM_WRITE_OUTSTANDING 2, NUM_WRITE_THREADS 1, PHASE 0.000, PROTOCOL AXI4, READ_WRITE_MODE READ_WRITE, RUSER_BITS_PER_BYTE 0, RUSER_WIDTH 0, SUPPORTS_NARROW_BURST 0, WUSER_BITS_PER_BYTE 0, WUSER_WIDTH 0" *) output [31:0]M_DDR_AXI_araddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DDR_AXI " *) output [1:0]M_DDR_AXI_arburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DDR_AXI " *) output [3:0]M_DDR_AXI_arcache;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DDR_AXI " *) output [4:0]M_DDR_AXI_arid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DDR_AXI " *) output [7:0]M_DDR_AXI_arlen;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DDR_AXI " *) output [0:0]M_DDR_AXI_arlock;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DDR_AXI " *) output [2:0]M_DDR_AXI_arprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DDR_AXI " *) output [3:0]M_DDR_AXI_arqos;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DDR_AXI " *) input [0:0]M_DDR_AXI_arready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DDR_AXI " *) output [3:0]M_DDR_AXI_arregion;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DDR_AXI " *) output [2:0]M_DDR_AXI_arsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DDR_AXI " *) output [0:0]M_DDR_AXI_arvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DDR_AXI " *) output [31:0]M_DDR_AXI_awaddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DDR_AXI " *) output [1:0]M_DDR_AXI_awburst;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DDR_AXI " *) output [3:0]M_DDR_AXI_awcache;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DDR_AXI " *) output [4:0]M_DDR_AXI_awid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DDR_AXI " *) output [7:0]M_DDR_AXI_awlen;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DDR_AXI " *) output [0:0]M_DDR_AXI_awlock;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DDR_AXI " *) output [2:0]M_DDR_AXI_awprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DDR_AXI " *) output [3:0]M_DDR_AXI_awqos;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DDR_AXI " *) input [0:0]M_DDR_AXI_awready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DDR_AXI " *) output [3:0]M_DDR_AXI_awregion;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DDR_AXI " *) output [2:0]M_DDR_AXI_awsize;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DDR_AXI " *) output [0:0]M_DDR_AXI_awvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DDR_AXI " *) input [4:0]M_DDR_AXI_bid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DDR_AXI " *) output [0:0]M_DDR_AXI_bready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DDR_AXI " *) input [1:0]M_DDR_AXI_bresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DDR_AXI " *) input [0:0]M_DDR_AXI_bvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DDR_AXI " *) input [31:0]M_DDR_AXI_rdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DDR_AXI " *) input [4:0]M_DDR_AXI_rid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DDR_AXI " *) input [0:0]M_DDR_AXI_rlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DDR_AXI " *) output [0:0]M_DDR_AXI_rready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DDR_AXI " *) input [1:0]M_DDR_AXI_rresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DDR_AXI " *) input [0:0]M_DDR_AXI_rvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DDR_AXI " *) output [31:0]M_DDR_AXI_wdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DDR_AXI " *) output [0:0]M_DDR_AXI_wlast;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DDR_AXI " *) input [0:0]M_DDR_AXI_wready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DDR_AXI " *) output [3:0]M_DDR_AXI_wstrb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_DDR_AXI " *) output [0:0]M_DDR_AXI_wvalid;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_100MHZ CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_100MHZ, ASSOCIATED_BUSIF M_DDR_AXI, ASSOCIATED_RESET hreset, CLK_DOMAIN ahb_axi_matrix_clk_100MHz, FREQ_HZ 100000000, INSERT_VIP 0, PHASE 0.000" *) input clk_100MHz;
  input hreset;

  wire [31:0]AHB_INTERFACE_1_1_HADDR;
  wire [2:0]AHB_INTERFACE_1_1_HBURST;
  wire [3:0]AHB_INTERFACE_1_1_HPROT;
  wire [31:0]AHB_INTERFACE_1_1_HRDATA;
  wire AHB_INTERFACE_1_1_HREADY_IN;
  wire AHB_INTERFACE_1_1_HREADY_OUT;
  wire AHB_INTERFACE_1_1_HRESP;
  wire [2:0]AHB_INTERFACE_1_1_HSIZE;
  wire [1:0]AHB_INTERFACE_1_1_HTRANS;
  wire [31:0]AHB_INTERFACE_1_1_HWDATA;
  wire AHB_INTERFACE_1_1_HWRITE;
  wire AHB_INTERFACE_1_1_SEL;
  wire [31:0]AHB_INTERFACE_1_HADDR;
  wire [2:0]AHB_INTERFACE_1_HBURST;
  wire [3:0]AHB_INTERFACE_1_HPROT;
  wire [31:0]AHB_INTERFACE_1_HRDATA;
  wire AHB_INTERFACE_1_HREADY_IN;
  wire AHB_INTERFACE_1_HREADY_OUT;
  wire AHB_INTERFACE_1_HRESP;
  wire [2:0]AHB_INTERFACE_1_HSIZE;
  wire [1:0]AHB_INTERFACE_1_HTRANS;
  wire [31:0]AHB_INTERFACE_1_HWDATA;
  wire AHB_INTERFACE_1_HWRITE;
  wire AHB_INTERFACE_1_SEL;
  wire [31:0]ahblite_axi_bridge_0_M_AXI_ARADDR;
  wire [1:0]ahblite_axi_bridge_0_M_AXI_ARBURST;
  wire [3:0]ahblite_axi_bridge_0_M_AXI_ARCACHE;
  wire [3:0]ahblite_axi_bridge_0_M_AXI_ARID;
  wire [7:0]ahblite_axi_bridge_0_M_AXI_ARLEN;
  wire ahblite_axi_bridge_0_M_AXI_ARLOCK;
  wire [2:0]ahblite_axi_bridge_0_M_AXI_ARPROT;
  wire [0:0]ahblite_axi_bridge_0_M_AXI_ARREADY;
  wire [2:0]ahblite_axi_bridge_0_M_AXI_ARSIZE;
  wire ahblite_axi_bridge_0_M_AXI_ARVALID;
  wire [31:0]ahblite_axi_bridge_0_M_AXI_AWADDR;
  wire [1:0]ahblite_axi_bridge_0_M_AXI_AWBURST;
  wire [3:0]ahblite_axi_bridge_0_M_AXI_AWCACHE;
  wire [3:0]ahblite_axi_bridge_0_M_AXI_AWID;
  wire [7:0]ahblite_axi_bridge_0_M_AXI_AWLEN;
  wire ahblite_axi_bridge_0_M_AXI_AWLOCK;
  wire [2:0]ahblite_axi_bridge_0_M_AXI_AWPROT;
  wire [0:0]ahblite_axi_bridge_0_M_AXI_AWREADY;
  wire [2:0]ahblite_axi_bridge_0_M_AXI_AWSIZE;
  wire ahblite_axi_bridge_0_M_AXI_AWVALID;
  wire [4:0]ahblite_axi_bridge_0_M_AXI_BID;
  wire ahblite_axi_bridge_0_M_AXI_BREADY;
  wire [1:0]ahblite_axi_bridge_0_M_AXI_BRESP;
  wire [0:0]ahblite_axi_bridge_0_M_AXI_BVALID;
  wire [31:0]ahblite_axi_bridge_0_M_AXI_RDATA;
  wire [4:0]ahblite_axi_bridge_0_M_AXI_RID;
  wire [0:0]ahblite_axi_bridge_0_M_AXI_RLAST;
  wire ahblite_axi_bridge_0_M_AXI_RREADY;
  wire [1:0]ahblite_axi_bridge_0_M_AXI_RRESP;
  wire [0:0]ahblite_axi_bridge_0_M_AXI_RVALID;
  wire [31:0]ahblite_axi_bridge_0_M_AXI_WDATA;
  wire ahblite_axi_bridge_0_M_AXI_WLAST;
  wire [0:0]ahblite_axi_bridge_0_M_AXI_WREADY;
  wire [3:0]ahblite_axi_bridge_0_M_AXI_WSTRB;
  wire ahblite_axi_bridge_0_M_AXI_WVALID;
  wire [31:0]ahblite_axi_bridge_1_M_AXI_ARADDR;
  wire [1:0]ahblite_axi_bridge_1_M_AXI_ARBURST;
  wire [3:0]ahblite_axi_bridge_1_M_AXI_ARCACHE;
  wire [3:0]ahblite_axi_bridge_1_M_AXI_ARID;
  wire [7:0]ahblite_axi_bridge_1_M_AXI_ARLEN;
  wire ahblite_axi_bridge_1_M_AXI_ARLOCK;
  wire [2:0]ahblite_axi_bridge_1_M_AXI_ARPROT;
  wire [1:1]ahblite_axi_bridge_1_M_AXI_ARREADY;
  wire [2:0]ahblite_axi_bridge_1_M_AXI_ARSIZE;
  wire ahblite_axi_bridge_1_M_AXI_ARVALID;
  wire [31:0]ahblite_axi_bridge_1_M_AXI_AWADDR;
  wire [1:0]ahblite_axi_bridge_1_M_AXI_AWBURST;
  wire [3:0]ahblite_axi_bridge_1_M_AXI_AWCACHE;
  wire [3:0]ahblite_axi_bridge_1_M_AXI_AWID;
  wire [7:0]ahblite_axi_bridge_1_M_AXI_AWLEN;
  wire ahblite_axi_bridge_1_M_AXI_AWLOCK;
  wire [2:0]ahblite_axi_bridge_1_M_AXI_AWPROT;
  wire [1:1]ahblite_axi_bridge_1_M_AXI_AWREADY;
  wire [2:0]ahblite_axi_bridge_1_M_AXI_AWSIZE;
  wire ahblite_axi_bridge_1_M_AXI_AWVALID;
  wire [9:5]ahblite_axi_bridge_1_M_AXI_BID;
  wire ahblite_axi_bridge_1_M_AXI_BREADY;
  wire [3:2]ahblite_axi_bridge_1_M_AXI_BRESP;
  wire [1:1]ahblite_axi_bridge_1_M_AXI_BVALID;
  wire [63:32]ahblite_axi_bridge_1_M_AXI_RDATA;
  wire [9:5]ahblite_axi_bridge_1_M_AXI_RID;
  wire [1:1]ahblite_axi_bridge_1_M_AXI_RLAST;
  wire ahblite_axi_bridge_1_M_AXI_RREADY;
  wire [3:2]ahblite_axi_bridge_1_M_AXI_RRESP;
  wire [1:1]ahblite_axi_bridge_1_M_AXI_RVALID;
  wire [31:0]ahblite_axi_bridge_1_M_AXI_WDATA;
  wire ahblite_axi_bridge_1_M_AXI_WLAST;
  wire [1:1]ahblite_axi_bridge_1_M_AXI_WREADY;
  wire [3:0]ahblite_axi_bridge_1_M_AXI_WSTRB;
  wire ahblite_axi_bridge_1_M_AXI_WVALID;
  wire [31:0]axi_ahblite_bridge_0_M_AHB_HADDR;
  wire [2:0]axi_ahblite_bridge_0_M_AHB_HBURST;
  wire axi_ahblite_bridge_0_M_AHB_HMASTLOCK;
  wire [3:0]axi_ahblite_bridge_0_M_AHB_HPROT;
  wire [31:0]axi_ahblite_bridge_0_M_AHB_HRDATA;
  wire axi_ahblite_bridge_0_M_AHB_HREADY;
  wire axi_ahblite_bridge_0_M_AHB_HRESP;
  wire [2:0]axi_ahblite_bridge_0_M_AHB_HSIZE;
  wire [1:0]axi_ahblite_bridge_0_M_AHB_HTRANS;
  wire [31:0]axi_ahblite_bridge_0_M_AHB_HWDATA;
  wire axi_ahblite_bridge_0_M_AHB_HWRITE;
  wire [31:0]axi_ahblite_bridge_1_M_AHB_HADDR;
  wire [2:0]axi_ahblite_bridge_1_M_AHB_HBURST;
  wire axi_ahblite_bridge_1_M_AHB_HMASTLOCK;
  wire [3:0]axi_ahblite_bridge_1_M_AHB_HPROT;
  wire [31:0]axi_ahblite_bridge_1_M_AHB_HRDATA;
  wire axi_ahblite_bridge_1_M_AHB_HREADY;
  wire axi_ahblite_bridge_1_M_AHB_HRESP;
  wire [2:0]axi_ahblite_bridge_1_M_AHB_HSIZE;
  wire [1:0]axi_ahblite_bridge_1_M_AHB_HTRANS;
  wire [31:0]axi_ahblite_bridge_1_M_AHB_HWDATA;
  wire axi_ahblite_bridge_1_M_AHB_HWRITE;
  wire [31:0]axi_ahblite_bridge_3_M_AHB_HADDR;
  wire [2:0]axi_ahblite_bridge_3_M_AHB_HBURST;
  wire axi_ahblite_bridge_3_M_AHB_HMASTLOCK;
  wire [3:0]axi_ahblite_bridge_3_M_AHB_HPROT;
  wire [31:0]axi_ahblite_bridge_3_M_AHB_HRDATA;
  wire axi_ahblite_bridge_3_M_AHB_HREADY;
  wire axi_ahblite_bridge_3_M_AHB_HRESP;
  wire [2:0]axi_ahblite_bridge_3_M_AHB_HSIZE;
  wire [1:0]axi_ahblite_bridge_3_M_AHB_HTRANS;
  wire [31:0]axi_ahblite_bridge_3_M_AHB_HWDATA;
  wire axi_ahblite_bridge_3_M_AHB_HWRITE;
  wire [31:0]axi_crossbar_0_M00_AXI_ARADDR;
  wire [1:0]axi_crossbar_0_M00_AXI_ARBURST;
  wire [3:0]axi_crossbar_0_M00_AXI_ARCACHE;
  wire [4:0]axi_crossbar_0_M00_AXI_ARID;
  wire [7:0]axi_crossbar_0_M00_AXI_ARLEN;
  wire [0:0]axi_crossbar_0_M00_AXI_ARLOCK;
  wire [2:0]axi_crossbar_0_M00_AXI_ARPROT;
  wire axi_crossbar_0_M00_AXI_ARREADY;
  wire [2:0]axi_crossbar_0_M00_AXI_ARSIZE;
  wire [0:0]axi_crossbar_0_M00_AXI_ARVALID;
  wire [31:0]axi_crossbar_0_M00_AXI_AWADDR;
  wire [1:0]axi_crossbar_0_M00_AXI_AWBURST;
  wire [3:0]axi_crossbar_0_M00_AXI_AWCACHE;
  wire [4:0]axi_crossbar_0_M00_AXI_AWID;
  wire [7:0]axi_crossbar_0_M00_AXI_AWLEN;
  wire [0:0]axi_crossbar_0_M00_AXI_AWLOCK;
  wire [2:0]axi_crossbar_0_M00_AXI_AWPROT;
  wire axi_crossbar_0_M00_AXI_AWREADY;
  wire [2:0]axi_crossbar_0_M00_AXI_AWSIZE;
  wire [0:0]axi_crossbar_0_M00_AXI_AWVALID;
  wire [4:0]axi_crossbar_0_M00_AXI_BID;
  wire [0:0]axi_crossbar_0_M00_AXI_BREADY;
  wire [1:0]axi_crossbar_0_M00_AXI_BRESP;
  wire axi_crossbar_0_M00_AXI_BVALID;
  wire [31:0]axi_crossbar_0_M00_AXI_RDATA;
  wire [4:0]axi_crossbar_0_M00_AXI_RID;
  wire axi_crossbar_0_M00_AXI_RLAST;
  wire [0:0]axi_crossbar_0_M00_AXI_RREADY;
  wire [1:0]axi_crossbar_0_M00_AXI_RRESP;
  wire axi_crossbar_0_M00_AXI_RVALID;
  wire [31:0]axi_crossbar_0_M00_AXI_WDATA;
  wire [0:0]axi_crossbar_0_M00_AXI_WLAST;
  wire axi_crossbar_0_M00_AXI_WREADY;
  wire [3:0]axi_crossbar_0_M00_AXI_WSTRB;
  wire [0:0]axi_crossbar_0_M00_AXI_WVALID;
  wire [63:32]axi_crossbar_0_M01_AXI_ARADDR;
  wire [3:2]axi_crossbar_0_M01_AXI_ARBURST;
  wire [7:4]axi_crossbar_0_M01_AXI_ARCACHE;
  wire [9:5]axi_crossbar_0_M01_AXI_ARID;
  wire [15:8]axi_crossbar_0_M01_AXI_ARLEN;
  wire [1:1]axi_crossbar_0_M01_AXI_ARLOCK;
  wire [5:3]axi_crossbar_0_M01_AXI_ARPROT;
  wire axi_crossbar_0_M01_AXI_ARREADY;
  wire [5:3]axi_crossbar_0_M01_AXI_ARSIZE;
  wire [1:1]axi_crossbar_0_M01_AXI_ARVALID;
  wire [63:32]axi_crossbar_0_M01_AXI_AWADDR;
  wire [3:2]axi_crossbar_0_M01_AXI_AWBURST;
  wire [7:4]axi_crossbar_0_M01_AXI_AWCACHE;
  wire [9:5]axi_crossbar_0_M01_AXI_AWID;
  wire [15:8]axi_crossbar_0_M01_AXI_AWLEN;
  wire [1:1]axi_crossbar_0_M01_AXI_AWLOCK;
  wire [5:3]axi_crossbar_0_M01_AXI_AWPROT;
  wire axi_crossbar_0_M01_AXI_AWREADY;
  wire [5:3]axi_crossbar_0_M01_AXI_AWSIZE;
  wire [1:1]axi_crossbar_0_M01_AXI_AWVALID;
  wire [4:0]axi_crossbar_0_M01_AXI_BID;
  wire [1:1]axi_crossbar_0_M01_AXI_BREADY;
  wire [1:0]axi_crossbar_0_M01_AXI_BRESP;
  wire axi_crossbar_0_M01_AXI_BVALID;
  wire [31:0]axi_crossbar_0_M01_AXI_RDATA;
  wire [4:0]axi_crossbar_0_M01_AXI_RID;
  wire axi_crossbar_0_M01_AXI_RLAST;
  wire [1:1]axi_crossbar_0_M01_AXI_RREADY;
  wire [1:0]axi_crossbar_0_M01_AXI_RRESP;
  wire axi_crossbar_0_M01_AXI_RVALID;
  wire [63:32]axi_crossbar_0_M01_AXI_WDATA;
  wire [1:1]axi_crossbar_0_M01_AXI_WLAST;
  wire axi_crossbar_0_M01_AXI_WREADY;
  wire [7:4]axi_crossbar_0_M01_AXI_WSTRB;
  wire [1:1]axi_crossbar_0_M01_AXI_WVALID;
  wire [95:64]axi_crossbar_0_M02_AXI_ARADDR;
  wire [5:4]axi_crossbar_0_M02_AXI_ARBURST;
  wire [11:8]axi_crossbar_0_M02_AXI_ARCACHE;
  wire [14:10]axi_crossbar_0_M02_AXI_ARID;
  wire [23:16]axi_crossbar_0_M02_AXI_ARLEN;
  wire [2:2]axi_crossbar_0_M02_AXI_ARLOCK;
  wire [8:6]axi_crossbar_0_M02_AXI_ARPROT;
  wire [11:8]axi_crossbar_0_M02_AXI_ARQOS;
  wire [0:0]axi_crossbar_0_M02_AXI_ARREADY;
  wire [11:8]axi_crossbar_0_M02_AXI_ARREGION;
  wire [8:6]axi_crossbar_0_M02_AXI_ARSIZE;
  wire [2:2]axi_crossbar_0_M02_AXI_ARVALID;
  wire [95:64]axi_crossbar_0_M02_AXI_AWADDR;
  wire [5:4]axi_crossbar_0_M02_AXI_AWBURST;
  wire [11:8]axi_crossbar_0_M02_AXI_AWCACHE;
  wire [14:10]axi_crossbar_0_M02_AXI_AWID;
  wire [23:16]axi_crossbar_0_M02_AXI_AWLEN;
  wire [2:2]axi_crossbar_0_M02_AXI_AWLOCK;
  wire [8:6]axi_crossbar_0_M02_AXI_AWPROT;
  wire [11:8]axi_crossbar_0_M02_AXI_AWQOS;
  wire [0:0]axi_crossbar_0_M02_AXI_AWREADY;
  wire [11:8]axi_crossbar_0_M02_AXI_AWREGION;
  wire [8:6]axi_crossbar_0_M02_AXI_AWSIZE;
  wire [2:2]axi_crossbar_0_M02_AXI_AWVALID;
  wire [4:0]axi_crossbar_0_M02_AXI_BID;
  wire [2:2]axi_crossbar_0_M02_AXI_BREADY;
  wire [1:0]axi_crossbar_0_M02_AXI_BRESP;
  wire [0:0]axi_crossbar_0_M02_AXI_BVALID;
  wire [31:0]axi_crossbar_0_M02_AXI_RDATA;
  wire [4:0]axi_crossbar_0_M02_AXI_RID;
  wire [0:0]axi_crossbar_0_M02_AXI_RLAST;
  wire [2:2]axi_crossbar_0_M02_AXI_RREADY;
  wire [1:0]axi_crossbar_0_M02_AXI_RRESP;
  wire [0:0]axi_crossbar_0_M02_AXI_RVALID;
  wire [95:64]axi_crossbar_0_M02_AXI_WDATA;
  wire [2:2]axi_crossbar_0_M02_AXI_WLAST;
  wire [0:0]axi_crossbar_0_M02_AXI_WREADY;
  wire [11:8]axi_crossbar_0_M02_AXI_WSTRB;
  wire [2:2]axi_crossbar_0_M02_AXI_WVALID;
  wire [127:96]axi_crossbar_0_M03_AXI_ARADDR;
  wire [7:6]axi_crossbar_0_M03_AXI_ARBURST;
  wire [15:12]axi_crossbar_0_M03_AXI_ARCACHE;
  wire [19:15]axi_crossbar_0_M03_AXI_ARID;
  wire [31:24]axi_crossbar_0_M03_AXI_ARLEN;
  wire [3:3]axi_crossbar_0_M03_AXI_ARLOCK;
  wire [11:9]axi_crossbar_0_M03_AXI_ARPROT;
  wire axi_crossbar_0_M03_AXI_ARREADY;
  wire [11:9]axi_crossbar_0_M03_AXI_ARSIZE;
  wire [3:3]axi_crossbar_0_M03_AXI_ARVALID;
  wire [127:96]axi_crossbar_0_M03_AXI_AWADDR;
  wire [7:6]axi_crossbar_0_M03_AXI_AWBURST;
  wire [15:12]axi_crossbar_0_M03_AXI_AWCACHE;
  wire [19:15]axi_crossbar_0_M03_AXI_AWID;
  wire [31:24]axi_crossbar_0_M03_AXI_AWLEN;
  wire [3:3]axi_crossbar_0_M03_AXI_AWLOCK;
  wire [11:9]axi_crossbar_0_M03_AXI_AWPROT;
  wire axi_crossbar_0_M03_AXI_AWREADY;
  wire [11:9]axi_crossbar_0_M03_AXI_AWSIZE;
  wire [3:3]axi_crossbar_0_M03_AXI_AWVALID;
  wire [4:0]axi_crossbar_0_M03_AXI_BID;
  wire [3:3]axi_crossbar_0_M03_AXI_BREADY;
  wire [1:0]axi_crossbar_0_M03_AXI_BRESP;
  wire axi_crossbar_0_M03_AXI_BVALID;
  wire [31:0]axi_crossbar_0_M03_AXI_RDATA;
  wire [4:0]axi_crossbar_0_M03_AXI_RID;
  wire axi_crossbar_0_M03_AXI_RLAST;
  wire [3:3]axi_crossbar_0_M03_AXI_RREADY;
  wire [1:0]axi_crossbar_0_M03_AXI_RRESP;
  wire axi_crossbar_0_M03_AXI_RVALID;
  wire [127:96]axi_crossbar_0_M03_AXI_WDATA;
  wire [3:3]axi_crossbar_0_M03_AXI_WLAST;
  wire axi_crossbar_0_M03_AXI_WREADY;
  wire [15:12]axi_crossbar_0_M03_AXI_WSTRB;
  wire [3:3]axi_crossbar_0_M03_AXI_WVALID;
  wire clk_100MHz_1;
  wire rst_clk_100MHz_100M_peripheral_aresetn;
  wire [15:0]NLW_axi_crossbar_0_m_axi_arqos_UNCONNECTED;
  wire [15:0]NLW_axi_crossbar_0_m_axi_arregion_UNCONNECTED;
  wire [15:0]NLW_axi_crossbar_0_m_axi_awqos_UNCONNECTED;
  wire [15:0]NLW_axi_crossbar_0_m_axi_awregion_UNCONNECTED;

  assign AHB_INTERFACE_1_1_HADDR = AHB_INTERFACE_1_haddr[31:0];
  assign AHB_INTERFACE_1_1_HBURST = AHB_INTERFACE_1_hburst[2:0];
  assign AHB_INTERFACE_1_1_HPROT = AHB_INTERFACE_1_hprot[3:0];
  assign AHB_INTERFACE_1_1_HREADY_IN = AHB_INTERFACE_1_hready_in;
  assign AHB_INTERFACE_1_1_HSIZE = AHB_INTERFACE_1_hsize[2:0];
  assign AHB_INTERFACE_1_1_HTRANS = AHB_INTERFACE_1_htrans[1:0];
  assign AHB_INTERFACE_1_1_HWDATA = AHB_INTERFACE_1_hwdata[31:0];
  assign AHB_INTERFACE_1_1_HWRITE = AHB_INTERFACE_1_hwrite;
  assign AHB_INTERFACE_1_1_SEL = AHB_INTERFACE_1_sel;
  assign AHB_INTERFACE_1_HADDR = AHB_INTERFACE_haddr[31:0];
  assign AHB_INTERFACE_1_HBURST = AHB_INTERFACE_hburst[2:0];
  assign AHB_INTERFACE_1_HPROT = AHB_INTERFACE_hprot[3:0];
  assign AHB_INTERFACE_1_HREADY_IN = AHB_INTERFACE_hready_in;
  assign AHB_INTERFACE_1_HSIZE = AHB_INTERFACE_hsize[2:0];
  assign AHB_INTERFACE_1_HTRANS = AHB_INTERFACE_htrans[1:0];
  assign AHB_INTERFACE_1_HWDATA = AHB_INTERFACE_hwdata[31:0];
  assign AHB_INTERFACE_1_HWRITE = AHB_INTERFACE_hwrite;
  assign AHB_INTERFACE_1_SEL = AHB_INTERFACE_sel;
  assign AHB_INTERFACE_1_hrdata[31:0] = AHB_INTERFACE_1_1_HRDATA;
  assign AHB_INTERFACE_1_hready_out = AHB_INTERFACE_1_1_HREADY_OUT;
  assign AHB_INTERFACE_1_hresp = AHB_INTERFACE_1_1_HRESP;
  assign AHB_INTERFACE_hrdata[31:0] = AHB_INTERFACE_1_HRDATA;
  assign AHB_INTERFACE_hready_out = AHB_INTERFACE_1_HREADY_OUT;
  assign AHB_INTERFACE_hresp = AHB_INTERFACE_1_HRESP;
  assign M_AHB_1_haddr[31:0] = axi_ahblite_bridge_1_M_AHB_HADDR;
  assign M_AHB_1_hburst[2:0] = axi_ahblite_bridge_1_M_AHB_HBURST;
  assign M_AHB_1_hmastlock = axi_ahblite_bridge_1_M_AHB_HMASTLOCK;
  assign M_AHB_1_hprot[3:0] = axi_ahblite_bridge_1_M_AHB_HPROT;
  assign M_AHB_1_hsize[2:0] = axi_ahblite_bridge_1_M_AHB_HSIZE;
  assign M_AHB_1_htrans[1:0] = axi_ahblite_bridge_1_M_AHB_HTRANS;
  assign M_AHB_1_hwdata[31:0] = axi_ahblite_bridge_1_M_AHB_HWDATA;
  assign M_AHB_1_hwrite = axi_ahblite_bridge_1_M_AHB_HWRITE;
  assign M_AHB_3_haddr[31:0] = axi_ahblite_bridge_3_M_AHB_HADDR;
  assign M_AHB_3_hburst[2:0] = axi_ahblite_bridge_3_M_AHB_HBURST;
  assign M_AHB_3_hmastlock = axi_ahblite_bridge_3_M_AHB_HMASTLOCK;
  assign M_AHB_3_hprot[3:0] = axi_ahblite_bridge_3_M_AHB_HPROT;
  assign M_AHB_3_hsize[2:0] = axi_ahblite_bridge_3_M_AHB_HSIZE;
  assign M_AHB_3_htrans[1:0] = axi_ahblite_bridge_3_M_AHB_HTRANS;
  assign M_AHB_3_hwdata[31:0] = axi_ahblite_bridge_3_M_AHB_HWDATA;
  assign M_AHB_3_hwrite = axi_ahblite_bridge_3_M_AHB_HWRITE;
  assign M_AHB_haddr[31:0] = axi_ahblite_bridge_0_M_AHB_HADDR;
  assign M_AHB_hburst[2:0] = axi_ahblite_bridge_0_M_AHB_HBURST;
  assign M_AHB_hmastlock = axi_ahblite_bridge_0_M_AHB_HMASTLOCK;
  assign M_AHB_hprot[3:0] = axi_ahblite_bridge_0_M_AHB_HPROT;
  assign M_AHB_hsize[2:0] = axi_ahblite_bridge_0_M_AHB_HSIZE;
  assign M_AHB_htrans[1:0] = axi_ahblite_bridge_0_M_AHB_HTRANS;
  assign M_AHB_hwdata[31:0] = axi_ahblite_bridge_0_M_AHB_HWDATA;
  assign M_AHB_hwrite = axi_ahblite_bridge_0_M_AHB_HWRITE;
  assign M_DDR_AXI_araddr[31:0] = axi_crossbar_0_M02_AXI_ARADDR;
  assign M_DDR_AXI_arburst[1:0] = axi_crossbar_0_M02_AXI_ARBURST;
  assign M_DDR_AXI_arcache[3:0] = axi_crossbar_0_M02_AXI_ARCACHE;
  assign M_DDR_AXI_arid[4:0] = axi_crossbar_0_M02_AXI_ARID;
  assign M_DDR_AXI_arlen[7:0] = axi_crossbar_0_M02_AXI_ARLEN;
  assign M_DDR_AXI_arlock[0] = axi_crossbar_0_M02_AXI_ARLOCK;
  assign M_DDR_AXI_arprot[2:0] = axi_crossbar_0_M02_AXI_ARPROT;
  assign M_DDR_AXI_arqos[3:0] = axi_crossbar_0_M02_AXI_ARQOS;
  assign M_DDR_AXI_arregion[3:0] = axi_crossbar_0_M02_AXI_ARREGION;
  assign M_DDR_AXI_arsize[2:0] = axi_crossbar_0_M02_AXI_ARSIZE;
  assign M_DDR_AXI_arvalid[0] = axi_crossbar_0_M02_AXI_ARVALID;
  assign M_DDR_AXI_awaddr[31:0] = axi_crossbar_0_M02_AXI_AWADDR;
  assign M_DDR_AXI_awburst[1:0] = axi_crossbar_0_M02_AXI_AWBURST;
  assign M_DDR_AXI_awcache[3:0] = axi_crossbar_0_M02_AXI_AWCACHE;
  assign M_DDR_AXI_awid[4:0] = axi_crossbar_0_M02_AXI_AWID;
  assign M_DDR_AXI_awlen[7:0] = axi_crossbar_0_M02_AXI_AWLEN;
  assign M_DDR_AXI_awlock[0] = axi_crossbar_0_M02_AXI_AWLOCK;
  assign M_DDR_AXI_awprot[2:0] = axi_crossbar_0_M02_AXI_AWPROT;
  assign M_DDR_AXI_awqos[3:0] = axi_crossbar_0_M02_AXI_AWQOS;
  assign M_DDR_AXI_awregion[3:0] = axi_crossbar_0_M02_AXI_AWREGION;
  assign M_DDR_AXI_awsize[2:0] = axi_crossbar_0_M02_AXI_AWSIZE;
  assign M_DDR_AXI_awvalid[0] = axi_crossbar_0_M02_AXI_AWVALID;
  assign M_DDR_AXI_bready[0] = axi_crossbar_0_M02_AXI_BREADY;
  assign M_DDR_AXI_rready[0] = axi_crossbar_0_M02_AXI_RREADY;
  assign M_DDR_AXI_wdata[31:0] = axi_crossbar_0_M02_AXI_WDATA;
  assign M_DDR_AXI_wlast[0] = axi_crossbar_0_M02_AXI_WLAST;
  assign M_DDR_AXI_wstrb[3:0] = axi_crossbar_0_M02_AXI_WSTRB;
  assign M_DDR_AXI_wvalid[0] = axi_crossbar_0_M02_AXI_WVALID;
  assign axi_ahblite_bridge_0_M_AHB_HRDATA = M_AHB_hrdata[31:0];
  assign axi_ahblite_bridge_0_M_AHB_HREADY = M_AHB_hready;
  assign axi_ahblite_bridge_0_M_AHB_HRESP = M_AHB_hresp;
  assign axi_ahblite_bridge_1_M_AHB_HRDATA = M_AHB_1_hrdata[31:0];
  assign axi_ahblite_bridge_1_M_AHB_HREADY = M_AHB_1_hready;
  assign axi_ahblite_bridge_1_M_AHB_HRESP = M_AHB_1_hresp;
  assign axi_ahblite_bridge_3_M_AHB_HRDATA = M_AHB_3_hrdata[31:0];
  assign axi_ahblite_bridge_3_M_AHB_HREADY = M_AHB_3_hready;
  assign axi_ahblite_bridge_3_M_AHB_HRESP = M_AHB_3_hresp;
  assign axi_crossbar_0_M02_AXI_ARREADY = M_DDR_AXI_arready[0];
  assign axi_crossbar_0_M02_AXI_AWREADY = M_DDR_AXI_awready[0];
  assign axi_crossbar_0_M02_AXI_BID = M_DDR_AXI_bid[4:0];
  assign axi_crossbar_0_M02_AXI_BRESP = M_DDR_AXI_bresp[1:0];
  assign axi_crossbar_0_M02_AXI_BVALID = M_DDR_AXI_bvalid[0];
  assign axi_crossbar_0_M02_AXI_RDATA = M_DDR_AXI_rdata[31:0];
  assign axi_crossbar_0_M02_AXI_RID = M_DDR_AXI_rid[4:0];
  assign axi_crossbar_0_M02_AXI_RLAST = M_DDR_AXI_rlast[0];
  assign axi_crossbar_0_M02_AXI_RRESP = M_DDR_AXI_rresp[1:0];
  assign axi_crossbar_0_M02_AXI_RVALID = M_DDR_AXI_rvalid[0];
  assign axi_crossbar_0_M02_AXI_WREADY = M_DDR_AXI_wready[0];
  assign clk_100MHz_1 = clk_100MHz;
  assign rst_clk_100MHz_100M_peripheral_aresetn = hreset;
  ahb_axi_matrix_ahblite_axi_bridge_0_0 ahblite_axi_bridge_0
       (.m_axi_araddr(ahblite_axi_bridge_0_M_AXI_ARADDR),
        .m_axi_arburst(ahblite_axi_bridge_0_M_AXI_ARBURST),
        .m_axi_arcache(ahblite_axi_bridge_0_M_AXI_ARCACHE),
        .m_axi_arid(ahblite_axi_bridge_0_M_AXI_ARID),
        .m_axi_arlen(ahblite_axi_bridge_0_M_AXI_ARLEN),
        .m_axi_arlock(ahblite_axi_bridge_0_M_AXI_ARLOCK),
        .m_axi_arprot(ahblite_axi_bridge_0_M_AXI_ARPROT),
        .m_axi_arready(ahblite_axi_bridge_0_M_AXI_ARREADY),
        .m_axi_arsize(ahblite_axi_bridge_0_M_AXI_ARSIZE),
        .m_axi_arvalid(ahblite_axi_bridge_0_M_AXI_ARVALID),
        .m_axi_awaddr(ahblite_axi_bridge_0_M_AXI_AWADDR),
        .m_axi_awburst(ahblite_axi_bridge_0_M_AXI_AWBURST),
        .m_axi_awcache(ahblite_axi_bridge_0_M_AXI_AWCACHE),
        .m_axi_awid(ahblite_axi_bridge_0_M_AXI_AWID),
        .m_axi_awlen(ahblite_axi_bridge_0_M_AXI_AWLEN),
        .m_axi_awlock(ahblite_axi_bridge_0_M_AXI_AWLOCK),
        .m_axi_awprot(ahblite_axi_bridge_0_M_AXI_AWPROT),
        .m_axi_awready(ahblite_axi_bridge_0_M_AXI_AWREADY),
        .m_axi_awsize(ahblite_axi_bridge_0_M_AXI_AWSIZE),
        .m_axi_awvalid(ahblite_axi_bridge_0_M_AXI_AWVALID),
        .m_axi_bid(ahblite_axi_bridge_0_M_AXI_BID[3:0]),
        .m_axi_bready(ahblite_axi_bridge_0_M_AXI_BREADY),
        .m_axi_bresp(ahblite_axi_bridge_0_M_AXI_BRESP),
        .m_axi_bvalid(ahblite_axi_bridge_0_M_AXI_BVALID),
        .m_axi_rdata(ahblite_axi_bridge_0_M_AXI_RDATA),
        .m_axi_rid(ahblite_axi_bridge_0_M_AXI_RID[3:0]),
        .m_axi_rlast(ahblite_axi_bridge_0_M_AXI_RLAST),
        .m_axi_rready(ahblite_axi_bridge_0_M_AXI_RREADY),
        .m_axi_rresp(ahblite_axi_bridge_0_M_AXI_RRESP),
        .m_axi_rvalid(ahblite_axi_bridge_0_M_AXI_RVALID),
        .m_axi_wdata(ahblite_axi_bridge_0_M_AXI_WDATA),
        .m_axi_wlast(ahblite_axi_bridge_0_M_AXI_WLAST),
        .m_axi_wready(ahblite_axi_bridge_0_M_AXI_WREADY),
        .m_axi_wstrb(ahblite_axi_bridge_0_M_AXI_WSTRB),
        .m_axi_wvalid(ahblite_axi_bridge_0_M_AXI_WVALID),
        .s_ahb_haddr(AHB_INTERFACE_1_HADDR),
        .s_ahb_hburst(AHB_INTERFACE_1_HBURST),
        .s_ahb_hclk(clk_100MHz_1),
        .s_ahb_hprot(AHB_INTERFACE_1_HPROT),
        .s_ahb_hrdata(AHB_INTERFACE_1_HRDATA),
        .s_ahb_hready_in(AHB_INTERFACE_1_HREADY_IN),
        .s_ahb_hready_out(AHB_INTERFACE_1_HREADY_OUT),
        .s_ahb_hresetn(rst_clk_100MHz_100M_peripheral_aresetn),
        .s_ahb_hresp(AHB_INTERFACE_1_HRESP),
        .s_ahb_hsel(AHB_INTERFACE_1_SEL),
        .s_ahb_hsize(AHB_INTERFACE_1_HSIZE),
        .s_ahb_htrans(AHB_INTERFACE_1_HTRANS),
        .s_ahb_hwdata(AHB_INTERFACE_1_HWDATA),
        .s_ahb_hwrite(AHB_INTERFACE_1_HWRITE));
  ahb_axi_matrix_ahblite_axi_bridge_0_1 ahblite_axi_bridge_1
       (.m_axi_araddr(ahblite_axi_bridge_1_M_AXI_ARADDR),
        .m_axi_arburst(ahblite_axi_bridge_1_M_AXI_ARBURST),
        .m_axi_arcache(ahblite_axi_bridge_1_M_AXI_ARCACHE),
        .m_axi_arid(ahblite_axi_bridge_1_M_AXI_ARID),
        .m_axi_arlen(ahblite_axi_bridge_1_M_AXI_ARLEN),
        .m_axi_arlock(ahblite_axi_bridge_1_M_AXI_ARLOCK),
        .m_axi_arprot(ahblite_axi_bridge_1_M_AXI_ARPROT),
        .m_axi_arready(ahblite_axi_bridge_1_M_AXI_ARREADY),
        .m_axi_arsize(ahblite_axi_bridge_1_M_AXI_ARSIZE),
        .m_axi_arvalid(ahblite_axi_bridge_1_M_AXI_ARVALID),
        .m_axi_awaddr(ahblite_axi_bridge_1_M_AXI_AWADDR),
        .m_axi_awburst(ahblite_axi_bridge_1_M_AXI_AWBURST),
        .m_axi_awcache(ahblite_axi_bridge_1_M_AXI_AWCACHE),
        .m_axi_awid(ahblite_axi_bridge_1_M_AXI_AWID),
        .m_axi_awlen(ahblite_axi_bridge_1_M_AXI_AWLEN),
        .m_axi_awlock(ahblite_axi_bridge_1_M_AXI_AWLOCK),
        .m_axi_awprot(ahblite_axi_bridge_1_M_AXI_AWPROT),
        .m_axi_awready(ahblite_axi_bridge_1_M_AXI_AWREADY),
        .m_axi_awsize(ahblite_axi_bridge_1_M_AXI_AWSIZE),
        .m_axi_awvalid(ahblite_axi_bridge_1_M_AXI_AWVALID),
        .m_axi_bid(ahblite_axi_bridge_1_M_AXI_BID[8:5]),
        .m_axi_bready(ahblite_axi_bridge_1_M_AXI_BREADY),
        .m_axi_bresp(ahblite_axi_bridge_1_M_AXI_BRESP),
        .m_axi_bvalid(ahblite_axi_bridge_1_M_AXI_BVALID),
        .m_axi_rdata(ahblite_axi_bridge_1_M_AXI_RDATA),
        .m_axi_rid(ahblite_axi_bridge_1_M_AXI_RID[8:5]),
        .m_axi_rlast(ahblite_axi_bridge_1_M_AXI_RLAST),
        .m_axi_rready(ahblite_axi_bridge_1_M_AXI_RREADY),
        .m_axi_rresp(ahblite_axi_bridge_1_M_AXI_RRESP),
        .m_axi_rvalid(ahblite_axi_bridge_1_M_AXI_RVALID),
        .m_axi_wdata(ahblite_axi_bridge_1_M_AXI_WDATA),
        .m_axi_wlast(ahblite_axi_bridge_1_M_AXI_WLAST),
        .m_axi_wready(ahblite_axi_bridge_1_M_AXI_WREADY),
        .m_axi_wstrb(ahblite_axi_bridge_1_M_AXI_WSTRB),
        .m_axi_wvalid(ahblite_axi_bridge_1_M_AXI_WVALID),
        .s_ahb_haddr(AHB_INTERFACE_1_1_HADDR),
        .s_ahb_hburst(AHB_INTERFACE_1_1_HBURST),
        .s_ahb_hclk(clk_100MHz_1),
        .s_ahb_hprot(AHB_INTERFACE_1_1_HPROT),
        .s_ahb_hrdata(AHB_INTERFACE_1_1_HRDATA),
        .s_ahb_hready_in(AHB_INTERFACE_1_1_HREADY_IN),
        .s_ahb_hready_out(AHB_INTERFACE_1_1_HREADY_OUT),
        .s_ahb_hresetn(rst_clk_100MHz_100M_peripheral_aresetn),
        .s_ahb_hresp(AHB_INTERFACE_1_1_HRESP),
        .s_ahb_hsel(AHB_INTERFACE_1_1_SEL),
        .s_ahb_hsize(AHB_INTERFACE_1_1_HSIZE),
        .s_ahb_htrans(AHB_INTERFACE_1_1_HTRANS),
        .s_ahb_hwdata(AHB_INTERFACE_1_1_HWDATA),
        .s_ahb_hwrite(AHB_INTERFACE_1_1_HWRITE));
  ahb_axi_matrix_axi_ahblite_bridge_0_0 axi_ahblite_bridge_0
       (.m_ahb_haddr(axi_ahblite_bridge_0_M_AHB_HADDR),
        .m_ahb_hburst(axi_ahblite_bridge_0_M_AHB_HBURST),
        .m_ahb_hmastlock(axi_ahblite_bridge_0_M_AHB_HMASTLOCK),
        .m_ahb_hprot(axi_ahblite_bridge_0_M_AHB_HPROT),
        .m_ahb_hrdata(axi_ahblite_bridge_0_M_AHB_HRDATA),
        .m_ahb_hready(axi_ahblite_bridge_0_M_AHB_HREADY),
        .m_ahb_hresp(axi_ahblite_bridge_0_M_AHB_HRESP),
        .m_ahb_hsize(axi_ahblite_bridge_0_M_AHB_HSIZE),
        .m_ahb_htrans(axi_ahblite_bridge_0_M_AHB_HTRANS),
        .m_ahb_hwdata(axi_ahblite_bridge_0_M_AHB_HWDATA),
        .m_ahb_hwrite(axi_ahblite_bridge_0_M_AHB_HWRITE),
        .s_axi_aclk(clk_100MHz_1),
        .s_axi_araddr(axi_crossbar_0_M00_AXI_ARADDR),
        .s_axi_arburst(axi_crossbar_0_M00_AXI_ARBURST),
        .s_axi_arcache(axi_crossbar_0_M00_AXI_ARCACHE),
        .s_axi_aresetn(rst_clk_100MHz_100M_peripheral_aresetn),
        .s_axi_arid(axi_crossbar_0_M00_AXI_ARID),
        .s_axi_arlen(axi_crossbar_0_M00_AXI_ARLEN),
        .s_axi_arlock(axi_crossbar_0_M00_AXI_ARLOCK),
        .s_axi_arprot(axi_crossbar_0_M00_AXI_ARPROT),
        .s_axi_arready(axi_crossbar_0_M00_AXI_ARREADY),
        .s_axi_arsize(axi_crossbar_0_M00_AXI_ARSIZE),
        .s_axi_arvalid(axi_crossbar_0_M00_AXI_ARVALID),
        .s_axi_awaddr(axi_crossbar_0_M00_AXI_AWADDR),
        .s_axi_awburst(axi_crossbar_0_M00_AXI_AWBURST),
        .s_axi_awcache(axi_crossbar_0_M00_AXI_AWCACHE),
        .s_axi_awid(axi_crossbar_0_M00_AXI_AWID),
        .s_axi_awlen(axi_crossbar_0_M00_AXI_AWLEN),
        .s_axi_awlock(axi_crossbar_0_M00_AXI_AWLOCK),
        .s_axi_awprot(axi_crossbar_0_M00_AXI_AWPROT),
        .s_axi_awready(axi_crossbar_0_M00_AXI_AWREADY),
        .s_axi_awsize(axi_crossbar_0_M00_AXI_AWSIZE),
        .s_axi_awvalid(axi_crossbar_0_M00_AXI_AWVALID),
        .s_axi_bid(axi_crossbar_0_M00_AXI_BID),
        .s_axi_bready(axi_crossbar_0_M00_AXI_BREADY),
        .s_axi_bresp(axi_crossbar_0_M00_AXI_BRESP),
        .s_axi_bvalid(axi_crossbar_0_M00_AXI_BVALID),
        .s_axi_rdata(axi_crossbar_0_M00_AXI_RDATA),
        .s_axi_rid(axi_crossbar_0_M00_AXI_RID),
        .s_axi_rlast(axi_crossbar_0_M00_AXI_RLAST),
        .s_axi_rready(axi_crossbar_0_M00_AXI_RREADY),
        .s_axi_rresp(axi_crossbar_0_M00_AXI_RRESP),
        .s_axi_rvalid(axi_crossbar_0_M00_AXI_RVALID),
        .s_axi_wdata(axi_crossbar_0_M00_AXI_WDATA),
        .s_axi_wlast(axi_crossbar_0_M00_AXI_WLAST),
        .s_axi_wready(axi_crossbar_0_M00_AXI_WREADY),
        .s_axi_wstrb(axi_crossbar_0_M00_AXI_WSTRB),
        .s_axi_wvalid(axi_crossbar_0_M00_AXI_WVALID));
  ahb_axi_matrix_axi_ahblite_bridge_0_1 axi_ahblite_bridge_1
       (.m_ahb_haddr(axi_ahblite_bridge_1_M_AHB_HADDR),
        .m_ahb_hburst(axi_ahblite_bridge_1_M_AHB_HBURST),
        .m_ahb_hmastlock(axi_ahblite_bridge_1_M_AHB_HMASTLOCK),
        .m_ahb_hprot(axi_ahblite_bridge_1_M_AHB_HPROT),
        .m_ahb_hrdata(axi_ahblite_bridge_1_M_AHB_HRDATA),
        .m_ahb_hready(axi_ahblite_bridge_1_M_AHB_HREADY),
        .m_ahb_hresp(axi_ahblite_bridge_1_M_AHB_HRESP),
        .m_ahb_hsize(axi_ahblite_bridge_1_M_AHB_HSIZE),
        .m_ahb_htrans(axi_ahblite_bridge_1_M_AHB_HTRANS),
        .m_ahb_hwdata(axi_ahblite_bridge_1_M_AHB_HWDATA),
        .m_ahb_hwrite(axi_ahblite_bridge_1_M_AHB_HWRITE),
        .s_axi_aclk(clk_100MHz_1),
        .s_axi_araddr(axi_crossbar_0_M01_AXI_ARADDR),
        .s_axi_arburst(axi_crossbar_0_M01_AXI_ARBURST),
        .s_axi_arcache(axi_crossbar_0_M01_AXI_ARCACHE),
        .s_axi_aresetn(rst_clk_100MHz_100M_peripheral_aresetn),
        .s_axi_arid(axi_crossbar_0_M01_AXI_ARID),
        .s_axi_arlen(axi_crossbar_0_M01_AXI_ARLEN),
        .s_axi_arlock(axi_crossbar_0_M01_AXI_ARLOCK),
        .s_axi_arprot(axi_crossbar_0_M01_AXI_ARPROT),
        .s_axi_arready(axi_crossbar_0_M01_AXI_ARREADY),
        .s_axi_arsize(axi_crossbar_0_M01_AXI_ARSIZE),
        .s_axi_arvalid(axi_crossbar_0_M01_AXI_ARVALID),
        .s_axi_awaddr(axi_crossbar_0_M01_AXI_AWADDR),
        .s_axi_awburst(axi_crossbar_0_M01_AXI_AWBURST),
        .s_axi_awcache(axi_crossbar_0_M01_AXI_AWCACHE),
        .s_axi_awid(axi_crossbar_0_M01_AXI_AWID),
        .s_axi_awlen(axi_crossbar_0_M01_AXI_AWLEN),
        .s_axi_awlock(axi_crossbar_0_M01_AXI_AWLOCK),
        .s_axi_awprot(axi_crossbar_0_M01_AXI_AWPROT),
        .s_axi_awready(axi_crossbar_0_M01_AXI_AWREADY),
        .s_axi_awsize(axi_crossbar_0_M01_AXI_AWSIZE),
        .s_axi_awvalid(axi_crossbar_0_M01_AXI_AWVALID),
        .s_axi_bid(axi_crossbar_0_M01_AXI_BID),
        .s_axi_bready(axi_crossbar_0_M01_AXI_BREADY),
        .s_axi_bresp(axi_crossbar_0_M01_AXI_BRESP),
        .s_axi_bvalid(axi_crossbar_0_M01_AXI_BVALID),
        .s_axi_rdata(axi_crossbar_0_M01_AXI_RDATA),
        .s_axi_rid(axi_crossbar_0_M01_AXI_RID),
        .s_axi_rlast(axi_crossbar_0_M01_AXI_RLAST),
        .s_axi_rready(axi_crossbar_0_M01_AXI_RREADY),
        .s_axi_rresp(axi_crossbar_0_M01_AXI_RRESP),
        .s_axi_rvalid(axi_crossbar_0_M01_AXI_RVALID),
        .s_axi_wdata(axi_crossbar_0_M01_AXI_WDATA),
        .s_axi_wlast(axi_crossbar_0_M01_AXI_WLAST),
        .s_axi_wready(axi_crossbar_0_M01_AXI_WREADY),
        .s_axi_wstrb(axi_crossbar_0_M01_AXI_WSTRB),
        .s_axi_wvalid(axi_crossbar_0_M01_AXI_WVALID));
  ahb_axi_matrix_axi_ahblite_bridge_1_1 axi_ahblite_bridge_3
       (.m_ahb_haddr(axi_ahblite_bridge_3_M_AHB_HADDR),
        .m_ahb_hburst(axi_ahblite_bridge_3_M_AHB_HBURST),
        .m_ahb_hmastlock(axi_ahblite_bridge_3_M_AHB_HMASTLOCK),
        .m_ahb_hprot(axi_ahblite_bridge_3_M_AHB_HPROT),
        .m_ahb_hrdata(axi_ahblite_bridge_3_M_AHB_HRDATA),
        .m_ahb_hready(axi_ahblite_bridge_3_M_AHB_HREADY),
        .m_ahb_hresp(axi_ahblite_bridge_3_M_AHB_HRESP),
        .m_ahb_hsize(axi_ahblite_bridge_3_M_AHB_HSIZE),
        .m_ahb_htrans(axi_ahblite_bridge_3_M_AHB_HTRANS),
        .m_ahb_hwdata(axi_ahblite_bridge_3_M_AHB_HWDATA),
        .m_ahb_hwrite(axi_ahblite_bridge_3_M_AHB_HWRITE),
        .s_axi_aclk(clk_100MHz_1),
        .s_axi_araddr(axi_crossbar_0_M03_AXI_ARADDR),
        .s_axi_arburst(axi_crossbar_0_M03_AXI_ARBURST),
        .s_axi_arcache(axi_crossbar_0_M03_AXI_ARCACHE),
        .s_axi_aresetn(rst_clk_100MHz_100M_peripheral_aresetn),
        .s_axi_arid(axi_crossbar_0_M03_AXI_ARID),
        .s_axi_arlen(axi_crossbar_0_M03_AXI_ARLEN),
        .s_axi_arlock(axi_crossbar_0_M03_AXI_ARLOCK),
        .s_axi_arprot(axi_crossbar_0_M03_AXI_ARPROT),
        .s_axi_arready(axi_crossbar_0_M03_AXI_ARREADY),
        .s_axi_arsize(axi_crossbar_0_M03_AXI_ARSIZE),
        .s_axi_arvalid(axi_crossbar_0_M03_AXI_ARVALID),
        .s_axi_awaddr(axi_crossbar_0_M03_AXI_AWADDR),
        .s_axi_awburst(axi_crossbar_0_M03_AXI_AWBURST),
        .s_axi_awcache(axi_crossbar_0_M03_AXI_AWCACHE),
        .s_axi_awid(axi_crossbar_0_M03_AXI_AWID),
        .s_axi_awlen(axi_crossbar_0_M03_AXI_AWLEN),
        .s_axi_awlock(axi_crossbar_0_M03_AXI_AWLOCK),
        .s_axi_awprot(axi_crossbar_0_M03_AXI_AWPROT),
        .s_axi_awready(axi_crossbar_0_M03_AXI_AWREADY),
        .s_axi_awsize(axi_crossbar_0_M03_AXI_AWSIZE),
        .s_axi_awvalid(axi_crossbar_0_M03_AXI_AWVALID),
        .s_axi_bid(axi_crossbar_0_M03_AXI_BID),
        .s_axi_bready(axi_crossbar_0_M03_AXI_BREADY),
        .s_axi_bresp(axi_crossbar_0_M03_AXI_BRESP),
        .s_axi_bvalid(axi_crossbar_0_M03_AXI_BVALID),
        .s_axi_rdata(axi_crossbar_0_M03_AXI_RDATA),
        .s_axi_rid(axi_crossbar_0_M03_AXI_RID),
        .s_axi_rlast(axi_crossbar_0_M03_AXI_RLAST),
        .s_axi_rready(axi_crossbar_0_M03_AXI_RREADY),
        .s_axi_rresp(axi_crossbar_0_M03_AXI_RRESP),
        .s_axi_rvalid(axi_crossbar_0_M03_AXI_RVALID),
        .s_axi_wdata(axi_crossbar_0_M03_AXI_WDATA),
        .s_axi_wlast(axi_crossbar_0_M03_AXI_WLAST),
        .s_axi_wready(axi_crossbar_0_M03_AXI_WREADY),
        .s_axi_wstrb(axi_crossbar_0_M03_AXI_WSTRB),
        .s_axi_wvalid(axi_crossbar_0_M03_AXI_WVALID));
  ahb_axi_matrix_axi_crossbar_0_0 axi_crossbar_0
       (.aclk(clk_100MHz_1),
        .aresetn(rst_clk_100MHz_100M_peripheral_aresetn),
        .m_axi_araddr({axi_crossbar_0_M03_AXI_ARADDR,axi_crossbar_0_M02_AXI_ARADDR,axi_crossbar_0_M01_AXI_ARADDR,axi_crossbar_0_M00_AXI_ARADDR}),
        .m_axi_arburst({axi_crossbar_0_M03_AXI_ARBURST,axi_crossbar_0_M02_AXI_ARBURST,axi_crossbar_0_M01_AXI_ARBURST,axi_crossbar_0_M00_AXI_ARBURST}),
        .m_axi_arcache({axi_crossbar_0_M03_AXI_ARCACHE,axi_crossbar_0_M02_AXI_ARCACHE,axi_crossbar_0_M01_AXI_ARCACHE,axi_crossbar_0_M00_AXI_ARCACHE}),
        .m_axi_arid({axi_crossbar_0_M03_AXI_ARID,axi_crossbar_0_M02_AXI_ARID,axi_crossbar_0_M01_AXI_ARID,axi_crossbar_0_M00_AXI_ARID}),
        .m_axi_arlen({axi_crossbar_0_M03_AXI_ARLEN,axi_crossbar_0_M02_AXI_ARLEN,axi_crossbar_0_M01_AXI_ARLEN,axi_crossbar_0_M00_AXI_ARLEN}),
        .m_axi_arlock({axi_crossbar_0_M03_AXI_ARLOCK,axi_crossbar_0_M02_AXI_ARLOCK,axi_crossbar_0_M01_AXI_ARLOCK,axi_crossbar_0_M00_AXI_ARLOCK}),
        .m_axi_arprot({axi_crossbar_0_M03_AXI_ARPROT,axi_crossbar_0_M02_AXI_ARPROT,axi_crossbar_0_M01_AXI_ARPROT,axi_crossbar_0_M00_AXI_ARPROT}),
        .m_axi_arqos({axi_crossbar_0_M02_AXI_ARQOS,NLW_axi_crossbar_0_m_axi_arqos_UNCONNECTED[7:0]}),
        .m_axi_arready({axi_crossbar_0_M03_AXI_ARREADY,axi_crossbar_0_M02_AXI_ARREADY,axi_crossbar_0_M01_AXI_ARREADY,axi_crossbar_0_M00_AXI_ARREADY}),
        .m_axi_arregion({axi_crossbar_0_M02_AXI_ARREGION,NLW_axi_crossbar_0_m_axi_arregion_UNCONNECTED[7:0]}),
        .m_axi_arsize({axi_crossbar_0_M03_AXI_ARSIZE,axi_crossbar_0_M02_AXI_ARSIZE,axi_crossbar_0_M01_AXI_ARSIZE,axi_crossbar_0_M00_AXI_ARSIZE}),
        .m_axi_arvalid({axi_crossbar_0_M03_AXI_ARVALID,axi_crossbar_0_M02_AXI_ARVALID,axi_crossbar_0_M01_AXI_ARVALID,axi_crossbar_0_M00_AXI_ARVALID}),
        .m_axi_awaddr({axi_crossbar_0_M03_AXI_AWADDR,axi_crossbar_0_M02_AXI_AWADDR,axi_crossbar_0_M01_AXI_AWADDR,axi_crossbar_0_M00_AXI_AWADDR}),
        .m_axi_awburst({axi_crossbar_0_M03_AXI_AWBURST,axi_crossbar_0_M02_AXI_AWBURST,axi_crossbar_0_M01_AXI_AWBURST,axi_crossbar_0_M00_AXI_AWBURST}),
        .m_axi_awcache({axi_crossbar_0_M03_AXI_AWCACHE,axi_crossbar_0_M02_AXI_AWCACHE,axi_crossbar_0_M01_AXI_AWCACHE,axi_crossbar_0_M00_AXI_AWCACHE}),
        .m_axi_awid({axi_crossbar_0_M03_AXI_AWID,axi_crossbar_0_M02_AXI_AWID,axi_crossbar_0_M01_AXI_AWID,axi_crossbar_0_M00_AXI_AWID}),
        .m_axi_awlen({axi_crossbar_0_M03_AXI_AWLEN,axi_crossbar_0_M02_AXI_AWLEN,axi_crossbar_0_M01_AXI_AWLEN,axi_crossbar_0_M00_AXI_AWLEN}),
        .m_axi_awlock({axi_crossbar_0_M03_AXI_AWLOCK,axi_crossbar_0_M02_AXI_AWLOCK,axi_crossbar_0_M01_AXI_AWLOCK,axi_crossbar_0_M00_AXI_AWLOCK}),
        .m_axi_awprot({axi_crossbar_0_M03_AXI_AWPROT,axi_crossbar_0_M02_AXI_AWPROT,axi_crossbar_0_M01_AXI_AWPROT,axi_crossbar_0_M00_AXI_AWPROT}),
        .m_axi_awqos({axi_crossbar_0_M02_AXI_AWQOS,NLW_axi_crossbar_0_m_axi_awqos_UNCONNECTED[7:0]}),
        .m_axi_awready({axi_crossbar_0_M03_AXI_AWREADY,axi_crossbar_0_M02_AXI_AWREADY,axi_crossbar_0_M01_AXI_AWREADY,axi_crossbar_0_M00_AXI_AWREADY}),
        .m_axi_awregion({axi_crossbar_0_M02_AXI_AWREGION,NLW_axi_crossbar_0_m_axi_awregion_UNCONNECTED[7:0]}),
        .m_axi_awsize({axi_crossbar_0_M03_AXI_AWSIZE,axi_crossbar_0_M02_AXI_AWSIZE,axi_crossbar_0_M01_AXI_AWSIZE,axi_crossbar_0_M00_AXI_AWSIZE}),
        .m_axi_awvalid({axi_crossbar_0_M03_AXI_AWVALID,axi_crossbar_0_M02_AXI_AWVALID,axi_crossbar_0_M01_AXI_AWVALID,axi_crossbar_0_M00_AXI_AWVALID}),
        .m_axi_bid({axi_crossbar_0_M03_AXI_BID,axi_crossbar_0_M02_AXI_BID,axi_crossbar_0_M01_AXI_BID,axi_crossbar_0_M00_AXI_BID}),
        .m_axi_bready({axi_crossbar_0_M03_AXI_BREADY,axi_crossbar_0_M02_AXI_BREADY,axi_crossbar_0_M01_AXI_BREADY,axi_crossbar_0_M00_AXI_BREADY}),
        .m_axi_bresp({axi_crossbar_0_M03_AXI_BRESP,axi_crossbar_0_M02_AXI_BRESP,axi_crossbar_0_M01_AXI_BRESP,axi_crossbar_0_M00_AXI_BRESP}),
        .m_axi_bvalid({axi_crossbar_0_M03_AXI_BVALID,axi_crossbar_0_M02_AXI_BVALID,axi_crossbar_0_M01_AXI_BVALID,axi_crossbar_0_M00_AXI_BVALID}),
        .m_axi_rdata({axi_crossbar_0_M03_AXI_RDATA,axi_crossbar_0_M02_AXI_RDATA,axi_crossbar_0_M01_AXI_RDATA,axi_crossbar_0_M00_AXI_RDATA}),
        .m_axi_rid({axi_crossbar_0_M03_AXI_RID,axi_crossbar_0_M02_AXI_RID,axi_crossbar_0_M01_AXI_RID,axi_crossbar_0_M00_AXI_RID}),
        .m_axi_rlast({axi_crossbar_0_M03_AXI_RLAST,axi_crossbar_0_M02_AXI_RLAST,axi_crossbar_0_M01_AXI_RLAST,axi_crossbar_0_M00_AXI_RLAST}),
        .m_axi_rready({axi_crossbar_0_M03_AXI_RREADY,axi_crossbar_0_M02_AXI_RREADY,axi_crossbar_0_M01_AXI_RREADY,axi_crossbar_0_M00_AXI_RREADY}),
        .m_axi_rresp({axi_crossbar_0_M03_AXI_RRESP,axi_crossbar_0_M02_AXI_RRESP,axi_crossbar_0_M01_AXI_RRESP,axi_crossbar_0_M00_AXI_RRESP}),
        .m_axi_rvalid({axi_crossbar_0_M03_AXI_RVALID,axi_crossbar_0_M02_AXI_RVALID,axi_crossbar_0_M01_AXI_RVALID,axi_crossbar_0_M00_AXI_RVALID}),
        .m_axi_wdata({axi_crossbar_0_M03_AXI_WDATA,axi_crossbar_0_M02_AXI_WDATA,axi_crossbar_0_M01_AXI_WDATA,axi_crossbar_0_M00_AXI_WDATA}),
        .m_axi_wlast({axi_crossbar_0_M03_AXI_WLAST,axi_crossbar_0_M02_AXI_WLAST,axi_crossbar_0_M01_AXI_WLAST,axi_crossbar_0_M00_AXI_WLAST}),
        .m_axi_wready({axi_crossbar_0_M03_AXI_WREADY,axi_crossbar_0_M02_AXI_WREADY,axi_crossbar_0_M01_AXI_WREADY,axi_crossbar_0_M00_AXI_WREADY}),
        .m_axi_wstrb({axi_crossbar_0_M03_AXI_WSTRB,axi_crossbar_0_M02_AXI_WSTRB,axi_crossbar_0_M01_AXI_WSTRB,axi_crossbar_0_M00_AXI_WSTRB}),
        .m_axi_wvalid({axi_crossbar_0_M03_AXI_WVALID,axi_crossbar_0_M02_AXI_WVALID,axi_crossbar_0_M01_AXI_WVALID,axi_crossbar_0_M00_AXI_WVALID}),
        .s_axi_araddr({ahblite_axi_bridge_1_M_AXI_ARADDR,ahblite_axi_bridge_0_M_AXI_ARADDR}),
        .s_axi_arburst({ahblite_axi_bridge_1_M_AXI_ARBURST,ahblite_axi_bridge_0_M_AXI_ARBURST}),
        .s_axi_arcache({ahblite_axi_bridge_1_M_AXI_ARCACHE,ahblite_axi_bridge_0_M_AXI_ARCACHE}),
        .s_axi_arid({1'b0,ahblite_axi_bridge_1_M_AXI_ARID,1'b0,ahblite_axi_bridge_0_M_AXI_ARID}),
        .s_axi_arlen({ahblite_axi_bridge_1_M_AXI_ARLEN,ahblite_axi_bridge_0_M_AXI_ARLEN}),
        .s_axi_arlock({ahblite_axi_bridge_1_M_AXI_ARLOCK,ahblite_axi_bridge_0_M_AXI_ARLOCK}),
        .s_axi_arprot({ahblite_axi_bridge_1_M_AXI_ARPROT,ahblite_axi_bridge_0_M_AXI_ARPROT}),
        .s_axi_arqos({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready({ahblite_axi_bridge_1_M_AXI_ARREADY,ahblite_axi_bridge_0_M_AXI_ARREADY}),
        .s_axi_arsize({ahblite_axi_bridge_1_M_AXI_ARSIZE,ahblite_axi_bridge_0_M_AXI_ARSIZE}),
        .s_axi_arvalid({ahblite_axi_bridge_1_M_AXI_ARVALID,ahblite_axi_bridge_0_M_AXI_ARVALID}),
        .s_axi_awaddr({ahblite_axi_bridge_1_M_AXI_AWADDR,ahblite_axi_bridge_0_M_AXI_AWADDR}),
        .s_axi_awburst({ahblite_axi_bridge_1_M_AXI_AWBURST,ahblite_axi_bridge_0_M_AXI_AWBURST}),
        .s_axi_awcache({ahblite_axi_bridge_1_M_AXI_AWCACHE,ahblite_axi_bridge_0_M_AXI_AWCACHE}),
        .s_axi_awid({1'b0,ahblite_axi_bridge_1_M_AXI_AWID,1'b0,ahblite_axi_bridge_0_M_AXI_AWID}),
        .s_axi_awlen({ahblite_axi_bridge_1_M_AXI_AWLEN,ahblite_axi_bridge_0_M_AXI_AWLEN}),
        .s_axi_awlock({ahblite_axi_bridge_1_M_AXI_AWLOCK,ahblite_axi_bridge_0_M_AXI_AWLOCK}),
        .s_axi_awprot({ahblite_axi_bridge_1_M_AXI_AWPROT,ahblite_axi_bridge_0_M_AXI_AWPROT}),
        .s_axi_awqos({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready({ahblite_axi_bridge_1_M_AXI_AWREADY,ahblite_axi_bridge_0_M_AXI_AWREADY}),
        .s_axi_awsize({ahblite_axi_bridge_1_M_AXI_AWSIZE,ahblite_axi_bridge_0_M_AXI_AWSIZE}),
        .s_axi_awvalid({ahblite_axi_bridge_1_M_AXI_AWVALID,ahblite_axi_bridge_0_M_AXI_AWVALID}),
        .s_axi_bid({ahblite_axi_bridge_1_M_AXI_BID,ahblite_axi_bridge_0_M_AXI_BID}),
        .s_axi_bready({ahblite_axi_bridge_1_M_AXI_BREADY,ahblite_axi_bridge_0_M_AXI_BREADY}),
        .s_axi_bresp({ahblite_axi_bridge_1_M_AXI_BRESP,ahblite_axi_bridge_0_M_AXI_BRESP}),
        .s_axi_bvalid({ahblite_axi_bridge_1_M_AXI_BVALID,ahblite_axi_bridge_0_M_AXI_BVALID}),
        .s_axi_rdata({ahblite_axi_bridge_1_M_AXI_RDATA,ahblite_axi_bridge_0_M_AXI_RDATA}),
        .s_axi_rid({ahblite_axi_bridge_1_M_AXI_RID,ahblite_axi_bridge_0_M_AXI_RID}),
        .s_axi_rlast({ahblite_axi_bridge_1_M_AXI_RLAST,ahblite_axi_bridge_0_M_AXI_RLAST}),
        .s_axi_rready({ahblite_axi_bridge_1_M_AXI_RREADY,ahblite_axi_bridge_0_M_AXI_RREADY}),
        .s_axi_rresp({ahblite_axi_bridge_1_M_AXI_RRESP,ahblite_axi_bridge_0_M_AXI_RRESP}),
        .s_axi_rvalid({ahblite_axi_bridge_1_M_AXI_RVALID,ahblite_axi_bridge_0_M_AXI_RVALID}),
        .s_axi_wdata({ahblite_axi_bridge_1_M_AXI_WDATA,ahblite_axi_bridge_0_M_AXI_WDATA}),
        .s_axi_wlast({ahblite_axi_bridge_1_M_AXI_WLAST,ahblite_axi_bridge_0_M_AXI_WLAST}),
        .s_axi_wready({ahblite_axi_bridge_1_M_AXI_WREADY,ahblite_axi_bridge_0_M_AXI_WREADY}),
        .s_axi_wstrb({ahblite_axi_bridge_1_M_AXI_WSTRB,ahblite_axi_bridge_0_M_AXI_WSTRB}),
        .s_axi_wvalid({ahblite_axi_bridge_1_M_AXI_WVALID,ahblite_axi_bridge_0_M_AXI_WVALID}));
endmodule
