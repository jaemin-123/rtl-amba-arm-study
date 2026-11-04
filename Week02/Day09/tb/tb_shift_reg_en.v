`timescle 1ns/1ps

module tb_shift_en();
    reg clk, rst_n, sin, en;
    wire sout;
    
    shift_reg_en U1(
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .sin(sin),
        .sout(sout)
    );
    
    initial clk = 0;
    always #10 clk = ~clk;
    
    initial begin
        sin = 0; rst_n = 0; en = 1;
        #20 rst_n = 1; sin = 1;
        #20 sin = 0; 
        #40 en = 0;
        #40 en = 1;
        #120 sin = 1;
        #20 sin = 0;
        #40 en = 0;
        #20 rst_n = 0;
        #20 rst_n = 1;
        #100 $finish;
    end
endmodule
