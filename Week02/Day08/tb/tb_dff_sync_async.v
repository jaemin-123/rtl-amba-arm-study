`timescale 1ns / 1ps

module tb_dff();
    reg d, clk, rst_n;
    wire q_sync, q_async;
    
    dff_sync_rst U1(
        .d(d), 
        .clk(clk), 
        .rst_n(rst_n), 
        .q(q_sync)
    );
    
    dff_async_rst U2(
        .d(d), 
        .clk(clk), 
        .rst_n(rst_n), 
        .q(q_async)
    );
    
    initial clk = 0;
    always #10 clk = ~clk;
    
    initial begin
        d = 1; rst_n = 1;
        #1 rst_n = 0;
        #1 rst_n = 1;
        #26 rst_n = 0;
        #4 rst_n = 1;
        #30 $finish;
    end
endmodule
