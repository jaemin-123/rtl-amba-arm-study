module tb_shift_reg();
    reg clk, rst_n, sin;
    wire sout_bits, sout_concat;
    
    shift_reg_bits U1(
        .clk(clk),
        .rst_n(rst_n),
        .sin(sin),
        .sout(sout_bits)
    );
    
    shift_reg_concat U2(
        .clk(clk),
        .rst_n(rst_n),
        .sin(sin),
        .sout(sout_concat)
    );
    
    initial clk = 0;
    always #10 clk = ~clk;
    
    initial begin
        sin = 0; rst_n = 0;
        #20 rst_n = 1; sin = 1;
        #20 sin = 0; 
        #300 $finish;
    end
endmodule
