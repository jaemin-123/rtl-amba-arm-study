module tb_counter_up();
    reg clk, rst_n;
    wire [7:0] cnt;
    
    counter_up U1(
        .clk(clk),
        .rst_n(rst_n),
        .cnt(cnt)
    );
    
    initial clk = 0;
    always #10 clk = ~clk;
    
    initial begin
        rst_n = 1;
        #1 rst_n = 0;
        #14 rst_n = 1;
        #60 rst_n = 0;
        #10 rst_n = 1;
        #40 $finish;
    end
endmodule
