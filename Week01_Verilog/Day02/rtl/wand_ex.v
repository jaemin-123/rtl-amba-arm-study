module wand_ex ();
    reg a, b, c;
    wire w_nor, w_buf, w_wire;
    wand w_wand;
    
    initial begin
        a = 0; b = 0; c = 0;
        #10 a = 0; b = 1;
        #10 a = 1; b = 0;
        #10 a = 1; b = 1;
        #10 $finish;
    end
    
    nor(w_nor, a, b);
    buf(w_buf, c);
    
    nor(w_wire, a, b);
    buf(w_wire, c);
    
    nor(w_wand, a, b);
    buf(w_wand, c);
endmodule
