module tb_equality();
    reg [3:0] a, b;
    reg eq1, eq2;

    initial begin
        a = 4'b1x0z;
        b = 4'b1x0z;

        eq1 = (a == b);
        eq2 = (a === b);
        
        #50 $finish;
    end
endmodule
