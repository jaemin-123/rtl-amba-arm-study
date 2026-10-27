module tb_dff_sr_async();
    reg clk, d, r_n, s_n;
    wire q, q_n, q_sv, q_n_sv;
    
    dff_sr_async U1 (
        .clk(clk),
        .d(d),
        .r_n(r_n),
        .s_n(s_n),
        .q(q),
        .q_n(q_n)
    );
    
    dff_sr_async_sv U2 (
        .clk(clk),
        .d(d),
        .r_n(r_n),
        .s_n(s_n),
        .q(q_sv),
        .q_n(q_n_sv)
    );
    
    initial begin
        clk = 0; d = 0; r_n = 1; s_n = 1;
        #7 d = 1;
        #15 r_n = 0;
        #15 r_n = 1;
        #23 d = 0;
        #37 s_n = 0;
        #15 s_n =1;
        #20 $finish;    
    end
    
    always #5 clk = ~clk;
endmodule
