module soc_top(     
                CLK,
                TDO,
                nTDOEN,
                HRESETn,
                RTCK,
                TCK,
                TMS,
                TDI,
                nTRST,
                led,
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
input               CLK;
output              TDO;
output              nTDOEN;
input               HRESETn;
output              RTCK;
input               TCK;
input               TMS;
input               TDI;
input               nTRST;
output [7:0]        led;    

// ---- DDR3 ----
input               clk_ddr;
input               clk_ddr90;
input               clk_ref;
output              ddr3_ck_p;
output              ddr3_ck_n;
output              ddr3_cke;
output              ddr3_reset_n;
output              ddr3_ras_n;
output              ddr3_cas_n;
output              ddr3_we_n;
output              ddr3_cs_n;
output [2:0]        ddr3_ba;
output [13:0]       ddr3_addr;
output              ddr3_odt;
output [1:0]        ddr3_dm;
inout  [1:0]        ddr3_dqs_p;
inout  [1:0]        ddr3_dqs_n;
inout  [15:0]       ddr3_dq;


wire                TESTMODE;
wire                HCLK;
wire [33:0]         DBG0;
wire [33:0]         DBG1;
wire [7:0]          DSWITCH;
wire [3:0]          DCSIZECore;
wire [3:0]          ICSIZECore;
wire [31:0]         DHADDR;
wire [1:0]          DHTRANS;
wire [2:0]          DHBURST;
wire                DHWRITE;
wire [2:0]          DHSIZE;
wire [3:0]          DHBL;
wire [3:0]          DHPROT;
wire [31:0]         DHWDATA;
wire                DHBUSREQ;
wire                DHLOCK;
wire [31:0]         IHADDR;
wire [1:0]          IHTRANS;
wire [2:0]          IHBURST;
wire                IHWRITE;
wire [2:0]          IHSIZE;
wire [3:0]          IHPROT;
wire                IHBUSREQ;
wire                IHLOCK;
wire                TDO;
wire                nTDOEN;
wire                CLK;
wire                DHREADY;
wire [1:0]          DHRESP;
wire [31:0]         DHRDATA;
wire                IHREADY;
wire [1:0]          IHRESP;
wire [31:0]         IHRDATA;
wire                HRESETn;
wire                DBGnTRST;
wire                DBGTDI;
wire                DBGTMS;
wire                DBGTCKEN;
wire                RTCK;
wire                nTRST;
wire                TCK;
wire                TMS;
wire                TDI;
wire [13:0]         rom_addr;
wire                rom_ce_n;
wire                rom_oe_n;
wire [31:0]         rom_data;
wire [7:0]          led;


assign  TESTMODE = 1'b0;

assign  HCLK = CLK;

ARM926EJS  u_ARM926EJS(
  // I/O specific to validation/FPGA variant of ARM926EJ-S

`ifdef FPGA
    .DBG0             (DBG0[33:0]),
    .DBG1             (DBG1[33:0]),
    .DSWITCH          (DSWITCH[7:0]),
`endif

`ifdef TESTCHIP
    .DCACHESIZE       (DCSIZECore[3:0]),
    .ICACHESIZE       (ICSIZECore[3:0]),
`endif

  // standard ARM926EJ-S I/O

    // Outputs
    .STANDBYWFI       (             ),              //waiting for interrupt mode.
    .CFGBIGEND        (             ),              //little endian.
    .DHADDR           (DHADDR[31:0]),               //Data AHB
    .DHTRANS          (DHTRANS[1:0]),
    .DHBURST          (DHBURST[2:0]),
    .DHWRITE          (DHWRITE),
    .DHSIZE           (DHSIZE[2:0]),
    .DHBL             (DHBL[3:0]),
    .DHPROT           (DHPROT[3:0]),
    .DHWDATA          (DHWDATA[31:0]),
    .DHBUSREQ         (DHBUSREQ),
    .DHLOCK           (DHLOCK),
    .IHADDR           (IHADDR[31:0]),               //Instruction AHB
    .IHTRANS          (IHTRANS[1:0]),
    .IHBURST          (IHBURST[2:0]),
    .IHWRITE          (IHWRITE),
    .IHSIZE           (IHSIZE[2:0]),
    .IHPROT           (IHPROT[3:0]),
    .IHBUSREQ         (IHBUSREQ),
    .IHLOCK           (IHLOCK),
    .CPCLKEN          (         ),                    // Coprocessor
    .CPINSTR          (         ),
    .CPDOUT           (         ),
    .CPPASS           (         ),
    .CPLATECANCEL     (         ),
    .nCPINSTRVALID    (         ),
    .nCPMREQ          (         ),
    .nCPTRANS         (         ),
    .CPABORT          (         ),
    .COMMRX           (         ),
    .COMMTX           (         ),
    .DBGACK           (         ),
    .DBGRQI           (),
    .DBGINSTREXEC     (),
    .DBGRNG           (         ),
    .DBGTDO           (TDO),
    .DBGIR            (),
    .DBGSCREG         (),
    .DBGTAPSM         (),
    .DBGnTDOEN        (nTDOEN),
    .DBGSDIN          (         ),
    .ETMBIGEND        (         ),
    .ETMHIVECS        (         ),                      //ETMHIVECS),
    .ETMIA            (         ),                      //ETMIA[31:0]),
    .ETMInMREQ        (         ),                      //ETMInMREQ),
    .ETMISEQ          (         ),                      //ETMISEQ),
    .ETMITBIT         (         ),                      //ETMITBIT),
    .ETMIJBIT         (         ),                      //ETMIJBIT),
    .ETMZIFIRST       (         ),                      //ETMZIFIRST),
    .ETMZILAST        (         ),                      //ETMZILAST),
    .ETMIABORT        (         ),                      //ETMIABORT),
    .ETMDA            (         ),                      //ETMDA[31:0]),
    .ETMDMAS          (         ),                      //ETMDMAS[1:0]),
    .ETMDMORE         (         ),                      //ETMDMORE),
    .ETMDnMREQ        (         ),                      //ETMDnMREQ),
    .ETMDnRW          (         ),                      //ETMDnRW),
    .ETMDSEQ          (         ),                      //ETMDSEQ),
    .ETMRDATA         (         ),                      //ETMRDATA[31:0]),
    .ETMDABORT        (         ),                      //ETMDABORT),
    .ETMWDATA         (         ),                      //ETMWDATA[31:0]),
    .ETMnWAIT         (         ),                      //ETMnWAIT),
    .ETMDBGACK        (         ),                      //ETMDBGACK),
    .ETMINSTREXEC     (         ),                      //ETMINSTREXEC),
    .ETMRNGOUT        (         ),                      //ETMRNGOUT[1:0]),
    .ETMID31To25      (         ),                      //ETMID31To25[31:25]),
    .ETMID15To11      (         ),                      //ETMID15To11[15:11]),
    .ETMCHSD          (         ),                      //ETMCHSD[1:0]),
    .ETMCHSE          (         ),                      //ETMCHSE[1:0]),
    .ETMPASS          (         ),                      //ETMPASS),
    .ETMLATECANCEL    (         ),                      //ETMLATECANCEL),
    .ETMPROCID        (         ),                      //ETMPROCID[31:0]),
    .ETMPROCIDWR      (         ),                      //ETMPROCIDWR),
    .ETMINSTRVALID    (         ),                      //ETMINSTRVALID),
    // Inputs
    .CLK              (CLK),
    .nFIQ             (1'b1     ),                      //nFIQint),
    .nIRQ             (1'b1     ),                      //nIRQint),
    .VINITHI          (1'b1     ),                      //1: boot from 0xffff0000 0: boot from 0
    .BIGENDINIT       (1'b0     ),                      //1:Big endian  0:little endian  BIGENDINIT),
    .DHCLKEN          (1'b1     ),                      // must tie 1 , if HCLK and CLK are the same frequency HCLKEN),
    .IHCLKEN          (1'b1     ),                      // must tie 1 , if HCLK and CLK are the same frequency HCLKEN),
    .TAPID            (32'h07026F0F),                     //TAPID[31:0]),
    .DHGRANT          (1'b1),
    .DHREADY          (DHREADY),
    .DHRESP           (DHRESP[1:0]),
    .DHRDATA          (DHRDATA[31:0]),
    .IHGRANT          (1'b1),
    .IHREADY          (IHREADY),
    .IHRESP           (IHRESP[1:0]),
    .IHRDATA          (IHRDATA[31:0]),
    .HRESETn          (HRESETn),
    .CPDIN            (32'b0        ),            //Coprocessor
    .CHSDE            (2'b10        ),
    .CHSEX            (2'b10        ),
    .CPBURST          (4'b0         ),
    .DBGEN            (1'b1         ),           //debug features of processor
    .EDBGRQ           (1'b0     ),               // external debugger can force proccessor into debug state
    .DBGEXT           (2'b00    ),
    .DBGIEBKPT        (1'b0     ),
    .DBGDEWPT         (1'b0     ),
    .DBGnTRST         (DBGnTRST),
    .DBGTCKEN         (DBGTCKEN),
    .DBGTDI           (DBGTDI),
    .DBGTMS           (DBGTMS),
    .DBGSDOUT         (1'b0         ),
    .ETMEN            (1'b0),                   //nPWRDOWN),
    .FIFOFULL         (1'b0),                   //FIFOFULL),

    .CPEN             (1'b0),                   //disable coprocessor
    .INITRAM          (1'b0),                   //enable boot from instruction TCM

    .DRnRW            (     ),                  //data TCM
    .DRADDR           (     ),
    .DRWD             (     ),
    .DRIDLE           (     ),
    .DRCS             (     ),
    .DRWBL            (     ),
    .DRSEQ            (     ),
    .DRRD             (32'b0),
    .DRWAIT           (1'b0),
    .DRSIZE           (4'b0),

    .IRnRW            (     ),                  //instruction TCM
    .IRADDR           (     ),
    .IRWD             (     ),
    .IRIDLE           (     ),
    .IRCS             (     ),
    .IRWBL            (     ),
    .IRSEQ            (     ),
    .IRRD             (32'b0),
    .IRWAIT           (1'b0),
    .IRSIZE           (4'b0),

    .DRDMAEN          (1'b0),
    .DRDMACS          (1'b0),
    .DRDMAADDR        (18'b0),

    .IRDMAEN          (1'b0),
    .IRDMACS          (1'b0),
    .IRDMAADDR        (18'b0),

    .SCANENABLE       (1'b0),
    .INTEST           (1'b0),
    .EXTEST           (1'b0),
    .TESTMODE         (1'b0)


);


  a9sMICE
    uMICE
      (
       // Outputs
       .DBGnTRST      (DBGnTRST),
       .DBGTCKEN      (DBGTCKEN),
       .DBGTMS        (DBGTMS),
       .DBGTDI        (DBGTDI),
       .RTCK          (RTCK),
       // Inputs
       .bypass        (1'b0),                                   //MICEBYPASS 
       .CLK           (CLK),
       .nTRST         (nTRST),
       .TCK           (TCK),
       .TMS           (TMS),
       .TDI           (TDI));

assign DHRESP[1] = 1'b0;
assign IHRESP[1] = 1'b0;

matrix_top u_matrix_top (
    .AHB_INTERFACE_1_haddr      (DHADDR[31:0]),                                    // I  u_matrix_top
    .AHB_INTERFACE_1_hburst     (DHBURST[2:0]),                                    // I  u_matrix_top
    .AHB_INTERFACE_1_hprot      (DHPROT[3:0]),                                     // I  u_matrix_top
    .AHB_INTERFACE_1_hrdata     (DHRDATA[31:0]),                                   // O  u_matrix_top
    .AHB_INTERFACE_1_hready     (DHREADY),                                         // O  u_matrix_top
    .AHB_INTERFACE_1_hresp      (DHRESP[0]),                                       // O  u_matrix_top
    .AHB_INTERFACE_1_hsize      (DHSIZE[2:0]),                                     // I  u_matrix_top
    .AHB_INTERFACE_1_htrans     (DHTRANS[1:0]),                                    // I  u_matrix_top
    .AHB_INTERFACE_1_hwdata     (DHWDATA[31:0]),                                   // I  u_matrix_top
    .AHB_INTERFACE_1_hwrite     (DHWRITE),                                         // I  u_matrix_top
    .AHB_INTERFACE_1_sel        (1'b1),                                            // I  u_matrix_top
    .AHB_INTERFACE_haddr        (IHADDR[31:0]),                                    // I  u_matrix_top
    .AHB_INTERFACE_hburst       (IHBURST[2:0]),                                    // I  u_matrix_top
    .AHB_INTERFACE_hprot        (IHPROT[3:0]),                                     // I  u_matrix_top
    .AHB_INTERFACE_hrdata       (IHRDATA[31:0]),                                   // O  u_matrix_top
    .AHB_INTERFACE_hready       (IHREADY),                                         // O  u_matrix_top
    .AHB_INTERFACE_hresp        (IHRESP[0]),                                       // O  u_matrix_top
    .AHB_INTERFACE_hsize        (IHSIZE[2:0]),                                     // I  u_matrix_top
    .AHB_INTERFACE_htrans       (IHTRANS[1:0]),                                    // I  u_matrix_top
    .AHB_INTERFACE_hwdata       (32'b0),                                           // I  u_matrix_top
    .AHB_INTERFACE_hwrite       (IHWRITE),                                         // I  u_matrix_top
    .AHB_INTERFACE_sel          (1'b1),                                            // I  u_matrix_top
    .M_AHB_hwrite               (IHWRITE),                                         // I  u_matrix_top
    .HCLK                       (HCLK),                                            // I  u_matrix_top
    .HRESETn                    (HRESETn),                                         // I  u_matrix_top
    .led                        (led[7:0]),                                        // O  u_matrix_top

    // ---- DDR3 ----
    .clk_ddr                    (clk_ddr),
    .clk_ddr90                  (clk_ddr90),
    .clk_ref                    (clk_ref),
    .ddr3_ck_p                  (ddr3_ck_p),
    .ddr3_ck_n                  (ddr3_ck_n),
    .ddr3_cke                   (ddr3_cke),
    .ddr3_reset_n               (ddr3_reset_n),
    .ddr3_ras_n                 (ddr3_ras_n),
    .ddr3_cas_n                 (ddr3_cas_n),
    .ddr3_we_n                  (ddr3_we_n),
    .ddr3_cs_n                  (ddr3_cs_n),
    .ddr3_ba                    (ddr3_ba[2:0]),
    .ddr3_addr                  (ddr3_addr[13:0]),
    .ddr3_odt                   (ddr3_odt),
    .ddr3_dm                    (ddr3_dm[1:0]),
    .ddr3_dqs_p                 (ddr3_dqs_p[1:0]),
    .ddr3_dqs_n                 (ddr3_dqs_n[1:0]),
    .ddr3_dq                    (ddr3_dq[15:0])
);




endmodule
