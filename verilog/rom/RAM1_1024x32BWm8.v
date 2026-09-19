// synopsys translate_off
`timescale 1ns / 1ps
// synopsys translate_on

module RAM1_16Kx32 (
    input  wire         CLK,   // Global clock
    input  wire         CEN,   // Chip Enable (active low)
    input  wire [3:0]   WEN,   // Byte-Write Enable (active low, 4-bit for 32-bit data)
    input  wire         OEN,   // Output Enable (active low)
    input  wire [13:0]  A,     // 14-bit Address (1024 words)
    output wire [31:0]  Q,     // 32-bit Data Output
    input  wire [31:0]  D      // 32-bit Data Input
);

    // ========== Synplify BRAM Inference Directives ==========
    /* synthesis 
        syn_ramstyle = "block_ram",
        syn_preserve = 1,
        syn_keep = 1
    */
    
    // ========== Memory Declaration ==========
    (* syn_ramstyle = "block_ram" *)
    reg [31:0] mem [0:16383];  // 1024x32 memory array
    
    reg [31:0] data_reg;      // Output register

    // ========== Byte-Write Logic ==========
    //always @(posedge CLK) begin
    //    if (!CEN && (WEN != 4'b1111)) begin  // Write when any byte enable is active
    //        if (!WEN[0]) mem[A][7:0]   <= D[7:0];
    //        if (!WEN[1]) mem[A][15:8]  <= D[15:8];
    //        if (!WEN[2]) mem[A][23:16] <= D[23:16];
    //        if (!WEN[3]) mem[A][31:24] <= D[31:24];
    //    end
    //end

    // ========== Synchronous Read ==========
    always @(posedge CLK) begin
        if (!CEN && !OEN) begin  // Read enable
            data_reg <= mem[A];
        end
    end

    // ========== Tri-State Output ==========
    assign Q = (!OEN) ? data_reg : {32{1'bz}};

    // ========== Synplify Synthesis Script ==========
    // synopsys dc_script_begin
    // set_attribute mem -type ram_block TRUE /RAM1_1024x32BWm8/
    // set_attribute mem -byte_write TRUE /RAM1_1024x32BWm8/
    // synopsys dc_script_end

    // ========== Initialization (Simulation Only) ==========
    // synopsys translate_off
    initial begin
         $readmemh("../verilog/rom/memory.hex", mem);  // Optional initialization
        //data_reg = 32'b0;
    end
    // synopsys translate_on

endmodule
