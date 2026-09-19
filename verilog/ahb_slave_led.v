module ahb_slave_led(
    HCLK, 
    HRESETn, 
    HWRITE, HTRANS, HADDR, HWDATA, HRDATA, HREADY, HRESP, led_out);

    // 端口方向声明
    input  HCLK;
    input  HRESETn;
    input  HWRITE;
    input  HTRANS;
    input  [31:0] HADDR;
    input  [31:0] HWDATA;
    output [31:0] HRDATA;
    output HREADY;
    output [1:0]  HRESP;
    output [7:0]  led_out;

    // 端口数据类型声明（output端口若在always块中赋值，必须声明为reg）
    reg [31:0] HRDATA;
    reg [1:0]  HRESP;
    reg [7:0]  led_out;

    // 内部信号声明
    reg [31:0] led_reg;
    wire is_active;
    wire is_led_access;

    // 组合逻辑赋值
    assign HREADY = 1'b1;
    assign is_active = (HTRANS == 2'b10) || (HTRANS == 2'b11);
    assign is_led_access = (HADDR[31:4] == 28'h1000_000);

    // 时序逻辑
    always @(posedge HCLK or negedge HRESETn) begin
        if (!HRESETn) begin
            led_reg <= 32'h0000_0000;
            led_out <= 8'b0000_0000;
            HRESP   <= 2'b00;
            HRDATA  <= 32'b0;
        end else begin
            if (is_active && is_led_access) begin
                if (HWRITE) begin
                    case (HADDR[3:0])
                        4'h0: led_reg <= HWDATA;
                        default: ;
                    endcase
                end else begin
                    case (HADDR[3:0])
                        4'h0: HRDATA <= led_reg;
                        default: HRDATA <= 32'h0;
                    endcase
                end
                HRESP <= 2'b00;
            end else if (is_active && !is_led_access) begin
                HRESP <= 2'b01;
            end else begin
                HRESP <= 2'b00;
            end
        end
    end

    // 组合逻辑输出到LED
    always @(*) begin
        led_out = led_reg[7:0];
    end

endmodule
