module tb_latch_bad_comb_fixed();
    reg d, en;
    wire y_bad, y;
    
    latch_bad U1 (
        .d(d), 
        .en(en), 
        .y(y_bad)
    );
    
    comb_fixed U2 (
        .d(d), 
        .en(en), 
        .y(y)
    );
    
    initial begin
        en = 1; d = 1;
        #10 en = 0;
        #10 d = 0;
        #10 d = 1;
        #10 en = 1;
        #10 $finish;
    end
endmodule
