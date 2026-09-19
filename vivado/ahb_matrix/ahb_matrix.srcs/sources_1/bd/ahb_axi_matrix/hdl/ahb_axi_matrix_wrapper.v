//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.1 (lin64) Build 2552052 Fri May 24 14:47:09 MDT 2019
//Date        : Sat Sep 19 14:40:58 2026
//Host        : IC_EDA running 64-bit CentOS Linux release 7.9.2009 (Core)
//Command     : generate_target ahb_axi_matrix_wrapper.bd
//Design      : ahb_axi_matrix_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module ahb_axi_matrix_wrapper
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
  input [31:0]AHB_INTERFACE_1_haddr;
  input [2:0]AHB_INTERFACE_1_hburst;
  input [3:0]AHB_INTERFACE_1_hprot;
  output [31:0]AHB_INTERFACE_1_hrdata;
  input AHB_INTERFACE_1_hready_in;
  output AHB_INTERFACE_1_hready_out;
  output AHB_INTERFACE_1_hresp;
  input [2:0]AHB_INTERFACE_1_hsize;
  input [1:0]AHB_INTERFACE_1_htrans;
  input [31:0]AHB_INTERFACE_1_hwdata;
  input AHB_INTERFACE_1_hwrite;
  input AHB_INTERFACE_1_sel;
  input [31:0]AHB_INTERFACE_haddr;
  input [2:0]AHB_INTERFACE_hburst;
  input [3:0]AHB_INTERFACE_hprot;
  output [31:0]AHB_INTERFACE_hrdata;
  input AHB_INTERFACE_hready_in;
  output AHB_INTERFACE_hready_out;
  output AHB_INTERFACE_hresp;
  input [2:0]AHB_INTERFACE_hsize;
  input [1:0]AHB_INTERFACE_htrans;
  input [31:0]AHB_INTERFACE_hwdata;
  input AHB_INTERFACE_hwrite;
  input AHB_INTERFACE_sel;
  output [31:0]M_AHB_1_haddr;
  output [2:0]M_AHB_1_hburst;
  output M_AHB_1_hmastlock;
  output [3:0]M_AHB_1_hprot;
  input [31:0]M_AHB_1_hrdata;
  input M_AHB_1_hready;
  input M_AHB_1_hresp;
  output [2:0]M_AHB_1_hsize;
  output [1:0]M_AHB_1_htrans;
  output [31:0]M_AHB_1_hwdata;
  output M_AHB_1_hwrite;
  output [31:0]M_AHB_3_haddr;
  output [2:0]M_AHB_3_hburst;
  output M_AHB_3_hmastlock;
  output [3:0]M_AHB_3_hprot;
  input [31:0]M_AHB_3_hrdata;
  input M_AHB_3_hready;
  input M_AHB_3_hresp;
  output [2:0]M_AHB_3_hsize;
  output [1:0]M_AHB_3_htrans;
  output [31:0]M_AHB_3_hwdata;
  output M_AHB_3_hwrite;
  output [31:0]M_AHB_haddr;
  output [2:0]M_AHB_hburst;
  output M_AHB_hmastlock;
  output [3:0]M_AHB_hprot;
  input [31:0]M_AHB_hrdata;
  input M_AHB_hready;
  input M_AHB_hresp;
  output [2:0]M_AHB_hsize;
  output [1:0]M_AHB_htrans;
  output [31:0]M_AHB_hwdata;
  output M_AHB_hwrite;
  output [31:0]M_DDR_AXI_araddr;
  output [1:0]M_DDR_AXI_arburst;
  output [3:0]M_DDR_AXI_arcache;
  output [4:0]M_DDR_AXI_arid;
  output [7:0]M_DDR_AXI_arlen;
  output [0:0]M_DDR_AXI_arlock;
  output [2:0]M_DDR_AXI_arprot;
  output [3:0]M_DDR_AXI_arqos;
  input [0:0]M_DDR_AXI_arready;
  output [3:0]M_DDR_AXI_arregion;
  output [2:0]M_DDR_AXI_arsize;
  output [0:0]M_DDR_AXI_arvalid;
  output [31:0]M_DDR_AXI_awaddr;
  output [1:0]M_DDR_AXI_awburst;
  output [3:0]M_DDR_AXI_awcache;
  output [4:0]M_DDR_AXI_awid;
  output [7:0]M_DDR_AXI_awlen;
  output [0:0]M_DDR_AXI_awlock;
  output [2:0]M_DDR_AXI_awprot;
  output [3:0]M_DDR_AXI_awqos;
  input [0:0]M_DDR_AXI_awready;
  output [3:0]M_DDR_AXI_awregion;
  output [2:0]M_DDR_AXI_awsize;
  output [0:0]M_DDR_AXI_awvalid;
  input [4:0]M_DDR_AXI_bid;
  output [0:0]M_DDR_AXI_bready;
  input [1:0]M_DDR_AXI_bresp;
  input [0:0]M_DDR_AXI_bvalid;
  input [31:0]M_DDR_AXI_rdata;
  input [4:0]M_DDR_AXI_rid;
  input [0:0]M_DDR_AXI_rlast;
  output [0:0]M_DDR_AXI_rready;
  input [1:0]M_DDR_AXI_rresp;
  input [0:0]M_DDR_AXI_rvalid;
  output [31:0]M_DDR_AXI_wdata;
  output [0:0]M_DDR_AXI_wlast;
  input [0:0]M_DDR_AXI_wready;
  output [3:0]M_DDR_AXI_wstrb;
  output [0:0]M_DDR_AXI_wvalid;
  input clk_100MHz;
  input hreset;

  wire [31:0]AHB_INTERFACE_1_haddr;
  wire [2:0]AHB_INTERFACE_1_hburst;
  wire [3:0]AHB_INTERFACE_1_hprot;
  wire [31:0]AHB_INTERFACE_1_hrdata;
  wire AHB_INTERFACE_1_hready_in;
  wire AHB_INTERFACE_1_hready_out;
  wire AHB_INTERFACE_1_hresp;
  wire [2:0]AHB_INTERFACE_1_hsize;
  wire [1:0]AHB_INTERFACE_1_htrans;
  wire [31:0]AHB_INTERFACE_1_hwdata;
  wire AHB_INTERFACE_1_hwrite;
  wire AHB_INTERFACE_1_sel;
  wire [31:0]AHB_INTERFACE_haddr;
  wire [2:0]AHB_INTERFACE_hburst;
  wire [3:0]AHB_INTERFACE_hprot;
  wire [31:0]AHB_INTERFACE_hrdata;
  wire AHB_INTERFACE_hready_in;
  wire AHB_INTERFACE_hready_out;
  wire AHB_INTERFACE_hresp;
  wire [2:0]AHB_INTERFACE_hsize;
  wire [1:0]AHB_INTERFACE_htrans;
  wire [31:0]AHB_INTERFACE_hwdata;
  wire AHB_INTERFACE_hwrite;
  wire AHB_INTERFACE_sel;
  wire [31:0]M_AHB_1_haddr;
  wire [2:0]M_AHB_1_hburst;
  wire M_AHB_1_hmastlock;
  wire [3:0]M_AHB_1_hprot;
  wire [31:0]M_AHB_1_hrdata;
  wire M_AHB_1_hready;
  wire M_AHB_1_hresp;
  wire [2:0]M_AHB_1_hsize;
  wire [1:0]M_AHB_1_htrans;
  wire [31:0]M_AHB_1_hwdata;
  wire M_AHB_1_hwrite;
  wire [31:0]M_AHB_3_haddr;
  wire [2:0]M_AHB_3_hburst;
  wire M_AHB_3_hmastlock;
  wire [3:0]M_AHB_3_hprot;
  wire [31:0]M_AHB_3_hrdata;
  wire M_AHB_3_hready;
  wire M_AHB_3_hresp;
  wire [2:0]M_AHB_3_hsize;
  wire [1:0]M_AHB_3_htrans;
  wire [31:0]M_AHB_3_hwdata;
  wire M_AHB_3_hwrite;
  wire [31:0]M_AHB_haddr;
  wire [2:0]M_AHB_hburst;
  wire M_AHB_hmastlock;
  wire [3:0]M_AHB_hprot;
  wire [31:0]M_AHB_hrdata;
  wire M_AHB_hready;
  wire M_AHB_hresp;
  wire [2:0]M_AHB_hsize;
  wire [1:0]M_AHB_htrans;
  wire [31:0]M_AHB_hwdata;
  wire M_AHB_hwrite;
  wire [31:0]M_DDR_AXI_araddr;
  wire [1:0]M_DDR_AXI_arburst;
  wire [3:0]M_DDR_AXI_arcache;
  wire [4:0]M_DDR_AXI_arid;
  wire [7:0]M_DDR_AXI_arlen;
  wire [0:0]M_DDR_AXI_arlock;
  wire [2:0]M_DDR_AXI_arprot;
  wire [3:0]M_DDR_AXI_arqos;
  wire [0:0]M_DDR_AXI_arready;
  wire [3:0]M_DDR_AXI_arregion;
  wire [2:0]M_DDR_AXI_arsize;
  wire [0:0]M_DDR_AXI_arvalid;
  wire [31:0]M_DDR_AXI_awaddr;
  wire [1:0]M_DDR_AXI_awburst;
  wire [3:0]M_DDR_AXI_awcache;
  wire [4:0]M_DDR_AXI_awid;
  wire [7:0]M_DDR_AXI_awlen;
  wire [0:0]M_DDR_AXI_awlock;
  wire [2:0]M_DDR_AXI_awprot;
  wire [3:0]M_DDR_AXI_awqos;
  wire [0:0]M_DDR_AXI_awready;
  wire [3:0]M_DDR_AXI_awregion;
  wire [2:0]M_DDR_AXI_awsize;
  wire [0:0]M_DDR_AXI_awvalid;
  wire [4:0]M_DDR_AXI_bid;
  wire [0:0]M_DDR_AXI_bready;
  wire [1:0]M_DDR_AXI_bresp;
  wire [0:0]M_DDR_AXI_bvalid;
  wire [31:0]M_DDR_AXI_rdata;
  wire [4:0]M_DDR_AXI_rid;
  wire [0:0]M_DDR_AXI_rlast;
  wire [0:0]M_DDR_AXI_rready;
  wire [1:0]M_DDR_AXI_rresp;
  wire [0:0]M_DDR_AXI_rvalid;
  wire [31:0]M_DDR_AXI_wdata;
  wire [0:0]M_DDR_AXI_wlast;
  wire [0:0]M_DDR_AXI_wready;
  wire [3:0]M_DDR_AXI_wstrb;
  wire [0:0]M_DDR_AXI_wvalid;
  wire clk_100MHz;
  wire hreset;

  ahb_axi_matrix ahb_axi_matrix_i
       (.AHB_INTERFACE_1_haddr(AHB_INTERFACE_1_haddr),
        .AHB_INTERFACE_1_hburst(AHB_INTERFACE_1_hburst),
        .AHB_INTERFACE_1_hprot(AHB_INTERFACE_1_hprot),
        .AHB_INTERFACE_1_hrdata(AHB_INTERFACE_1_hrdata),
        .AHB_INTERFACE_1_hready_in(AHB_INTERFACE_1_hready_in),
        .AHB_INTERFACE_1_hready_out(AHB_INTERFACE_1_hready_out),
        .AHB_INTERFACE_1_hresp(AHB_INTERFACE_1_hresp),
        .AHB_INTERFACE_1_hsize(AHB_INTERFACE_1_hsize),
        .AHB_INTERFACE_1_htrans(AHB_INTERFACE_1_htrans),
        .AHB_INTERFACE_1_hwdata(AHB_INTERFACE_1_hwdata),
        .AHB_INTERFACE_1_hwrite(AHB_INTERFACE_1_hwrite),
        .AHB_INTERFACE_1_sel(AHB_INTERFACE_1_sel),
        .AHB_INTERFACE_haddr(AHB_INTERFACE_haddr),
        .AHB_INTERFACE_hburst(AHB_INTERFACE_hburst),
        .AHB_INTERFACE_hprot(AHB_INTERFACE_hprot),
        .AHB_INTERFACE_hrdata(AHB_INTERFACE_hrdata),
        .AHB_INTERFACE_hready_in(AHB_INTERFACE_hready_in),
        .AHB_INTERFACE_hready_out(AHB_INTERFACE_hready_out),
        .AHB_INTERFACE_hresp(AHB_INTERFACE_hresp),
        .AHB_INTERFACE_hsize(AHB_INTERFACE_hsize),
        .AHB_INTERFACE_htrans(AHB_INTERFACE_htrans),
        .AHB_INTERFACE_hwdata(AHB_INTERFACE_hwdata),
        .AHB_INTERFACE_hwrite(AHB_INTERFACE_hwrite),
        .AHB_INTERFACE_sel(AHB_INTERFACE_sel),
        .M_AHB_1_haddr(M_AHB_1_haddr),
        .M_AHB_1_hburst(M_AHB_1_hburst),
        .M_AHB_1_hmastlock(M_AHB_1_hmastlock),
        .M_AHB_1_hprot(M_AHB_1_hprot),
        .M_AHB_1_hrdata(M_AHB_1_hrdata),
        .M_AHB_1_hready(M_AHB_1_hready),
        .M_AHB_1_hresp(M_AHB_1_hresp),
        .M_AHB_1_hsize(M_AHB_1_hsize),
        .M_AHB_1_htrans(M_AHB_1_htrans),
        .M_AHB_1_hwdata(M_AHB_1_hwdata),
        .M_AHB_1_hwrite(M_AHB_1_hwrite),
        .M_AHB_3_haddr(M_AHB_3_haddr),
        .M_AHB_3_hburst(M_AHB_3_hburst),
        .M_AHB_3_hmastlock(M_AHB_3_hmastlock),
        .M_AHB_3_hprot(M_AHB_3_hprot),
        .M_AHB_3_hrdata(M_AHB_3_hrdata),
        .M_AHB_3_hready(M_AHB_3_hready),
        .M_AHB_3_hresp(M_AHB_3_hresp),
        .M_AHB_3_hsize(M_AHB_3_hsize),
        .M_AHB_3_htrans(M_AHB_3_htrans),
        .M_AHB_3_hwdata(M_AHB_3_hwdata),
        .M_AHB_3_hwrite(M_AHB_3_hwrite),
        .M_AHB_haddr(M_AHB_haddr),
        .M_AHB_hburst(M_AHB_hburst),
        .M_AHB_hmastlock(M_AHB_hmastlock),
        .M_AHB_hprot(M_AHB_hprot),
        .M_AHB_hrdata(M_AHB_hrdata),
        .M_AHB_hready(M_AHB_hready),
        .M_AHB_hresp(M_AHB_hresp),
        .M_AHB_hsize(M_AHB_hsize),
        .M_AHB_htrans(M_AHB_htrans),
        .M_AHB_hwdata(M_AHB_hwdata),
        .M_AHB_hwrite(M_AHB_hwrite),
        .M_DDR_AXI_araddr(M_DDR_AXI_araddr),
        .M_DDR_AXI_arburst(M_DDR_AXI_arburst),
        .M_DDR_AXI_arcache(M_DDR_AXI_arcache),
        .M_DDR_AXI_arid(M_DDR_AXI_arid),
        .M_DDR_AXI_arlen(M_DDR_AXI_arlen),
        .M_DDR_AXI_arlock(M_DDR_AXI_arlock),
        .M_DDR_AXI_arprot(M_DDR_AXI_arprot),
        .M_DDR_AXI_arqos(M_DDR_AXI_arqos),
        .M_DDR_AXI_arready(M_DDR_AXI_arready),
        .M_DDR_AXI_arregion(M_DDR_AXI_arregion),
        .M_DDR_AXI_arsize(M_DDR_AXI_arsize),
        .M_DDR_AXI_arvalid(M_DDR_AXI_arvalid),
        .M_DDR_AXI_awaddr(M_DDR_AXI_awaddr),
        .M_DDR_AXI_awburst(M_DDR_AXI_awburst),
        .M_DDR_AXI_awcache(M_DDR_AXI_awcache),
        .M_DDR_AXI_awid(M_DDR_AXI_awid),
        .M_DDR_AXI_awlen(M_DDR_AXI_awlen),
        .M_DDR_AXI_awlock(M_DDR_AXI_awlock),
        .M_DDR_AXI_awprot(M_DDR_AXI_awprot),
        .M_DDR_AXI_awqos(M_DDR_AXI_awqos),
        .M_DDR_AXI_awready(M_DDR_AXI_awready),
        .M_DDR_AXI_awregion(M_DDR_AXI_awregion),
        .M_DDR_AXI_awsize(M_DDR_AXI_awsize),
        .M_DDR_AXI_awvalid(M_DDR_AXI_awvalid),
        .M_DDR_AXI_bid(M_DDR_AXI_bid),
        .M_DDR_AXI_bready(M_DDR_AXI_bready),
        .M_DDR_AXI_bresp(M_DDR_AXI_bresp),
        .M_DDR_AXI_bvalid(M_DDR_AXI_bvalid),
        .M_DDR_AXI_rdata(M_DDR_AXI_rdata),
        .M_DDR_AXI_rid(M_DDR_AXI_rid),
        .M_DDR_AXI_rlast(M_DDR_AXI_rlast),
        .M_DDR_AXI_rready(M_DDR_AXI_rready),
        .M_DDR_AXI_rresp(M_DDR_AXI_rresp),
        .M_DDR_AXI_rvalid(M_DDR_AXI_rvalid),
        .M_DDR_AXI_wdata(M_DDR_AXI_wdata),
        .M_DDR_AXI_wlast(M_DDR_AXI_wlast),
        .M_DDR_AXI_wready(M_DDR_AXI_wready),
        .M_DDR_AXI_wstrb(M_DDR_AXI_wstrb),
        .M_DDR_AXI_wvalid(M_DDR_AXI_wvalid),
        .clk_100MHz(clk_100MHz),
        .hreset(hreset));
endmodule
