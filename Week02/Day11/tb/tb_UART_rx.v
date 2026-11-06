`timescale 1ns/1ps

module tb_UART_rx;

    localparam integer CLKS_PER_BIT = 8;
    
    reg clk, rst_n, rx;
    wire [7:0] rx_data;
    wire rx_done;
    
    integer i;
    reg [7:0] payload;
    
    
    UART_rx_8N1 #(
        .CLKS_PER_BIT(CLKS_PER_BIT)
    ) U1 (
        .clk(clk),
        .rst_n(rst_n),
        .rx(rx),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );
    
    initial clk = 0;
    always #10 clk = ~clk;
    
    initial begin
        rx = 1; 
        rst_n = 0;
        payload = 8'hA6;
        
        @(negedge clk);
        rst_n = 1;
        repeat (4) @(negedge clk);
        
        @(negedge clk);
        rx = 0;                         
        repeat (CLKS_PER_BIT) @(negedge clk);
        
        for (i = 0; i < 8; i = i + 1) begin
            rx = payload[i];
            repeat (CLKS_PER_BIT) @(negedge clk);
        end
        
        rx = 1;                       
        repeat (CLKS_PER_BIT) @(negedge clk);
        
        repeat(4) @(negedge clk);
        $finish;
    end
endmodule
