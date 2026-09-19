module soc_top(     

                );


assign  TESTMODE = 1'b0;

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
    .DBGACK           (DBGACK),
    .DBGRQI           (),
    .DBGINSTREXEC     (),
    .DBGRNG           (DBGRNG[1:0]),
    .DBGTDO           (TDO),
    .DBGIR            (),
    .DBGSCREG         (),
    .DBGTAPSM         (),
    .DBGnTDOEN        (nTDOEN),
    .DBGSDIN          (),
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
    .DHGRANT          (DHGRANT),
    .DHREADY          (DHREADY),
    .DHRESP           (DHRESP[1:0]),
    .DHRDATA          (DHRDATA[31:0]),
    .IHGRANT          (IHGRANT),
    .IHREADY          (IHREADY),
    .IHRESP           (IHRESP[1:0]),
    .IHRDATA          (IHRDATA[31:0]),
    .HRESETn          (HRESETn),
    .CPDIN            (             ),            //Coprocessor
    .CHSDE            (             ),
    .CHSEX            (2'b10        ),
    .CPBURST          (             ),
    .DBGEN            (1'b0         ),           //debug features of processor
    .EDBGRQ           (1'b0     )                // external debugger can force proccessor into debug state
    .DBGEXT           (DBGEXT[1:0]),
    .DBGIEBKPT        (DBGIEBKPT),
    .DBGDEWPT         (DBGDEWPT),
    .DBGnTRST         (DBGnTRST),
    .DBGTCKEN         (1'b1         ),          //DBGTCKEN),
    .DBGTDI           (DBGTDI),
    .DBGTMS           (DBGTMS),
    .DBGSDOUT         (DBGSDOUT),
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

ahb_bus_matrix u_ahb_bus_matrix();

ahb_rom u_ahb_rom();

ahb_slave_led u_ahb_slave_led();

ahb_slave_sram u_ahb_slave_sram();

data_ahb_top u_data_ahb_top();




endmodule
