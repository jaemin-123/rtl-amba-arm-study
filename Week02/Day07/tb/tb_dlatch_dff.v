module tb_dlatch_dff();
    reg d, clk;
    wire q_latch, q_ff;
    
    dlatch U1(
        .d(d),
        .en(clk),
        .q(q_latch)
    );
    
    dff U2(
        .d(d),
        .clk(clk),
        .q(q_ff)
    );
        
    initial clk = 0;
    always #10 clk = ~clk;
    
    initial begin
        d = 0;
        #5 d = 1;
        #10 d = 0;
        #10 d = 1;
        #10 $finish;
    end
endmodule
