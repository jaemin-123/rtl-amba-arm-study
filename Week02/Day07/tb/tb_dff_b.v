module tb_dff();
    reg d, clk;
    wire q, q2, bq, bq2;
    
    dff_b U1(
        .d(d), 
        .clk(clk), 
        .q(q), 
        .bq(bq)
    );
    
    dff_b_2 U2(
        .d(d), 
        .clk(clk), 
        .q(q2), 
        .bq(bq2)
    );
    
    initial clk = 0;
    always #10 clk = ~clk;
    
    initial begin
        d = 0;
        #5 d = 1;
        #10 d = 0;
        #10 d = 0;
        #10 d = 0;
        #10 d = 1;
        #10 d = 0;
        #10 d = 1;
        #10 $finish;
    end
endmodule
