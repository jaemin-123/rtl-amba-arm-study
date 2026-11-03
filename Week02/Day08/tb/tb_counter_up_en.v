module tb_counter_up_en();
    reg clk, rst_n, en;
    wire [7:0] cnt;
    
    counter_up_en U1(
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .cnt(cnt)
    );
    
    initial clk = 0;
    always #10 clk = ~clk;
    
    initial begin
        rst_n = 1; en = 1;
        #1 rst_n = 0;
        #14 rst_n = 1; 
        #34 en = 0;
        #3 en = 1;
        #40 rst_n = 0;
        #10 rst_n = 1;
        #40 $finish;
    end
endmodule
