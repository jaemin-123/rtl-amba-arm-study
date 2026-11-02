module tb_shift_assignment_compare();
    reg d, clk;
    wire q3_0, q3_1, q3_2;
    
    shift_assignment_compare U1(
        .d(d), 
        .clk(clk), 
        .q3(q3_0)
    );
    
    shift_assignment_compare_1 U2(
        .d(d), 
        .clk(clk), 
        .q3(q3_1)
    );
    
    shift_assignment_compare_2 U3(
        .d(d), 
        .clk(clk), 
        .q3(q3_2)
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
        #10 d = 0;
        #10 d = 0;
        #10 d = 0;
        #10 d = 1;
        #10 d = 0;
        #10 d = 1;
        #10 $finish;
    end
endmodule
