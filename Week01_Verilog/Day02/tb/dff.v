module tb_dff_0();
    reg clk = 0, d = 0;
    wire qout;
    
    dff_0 DUT (
        .clk(clk),
        .d(d),
        .qout(qout)
    );
    
    always #5 clk = ~clk;
    
    initial begin
        #12 d = 1;
        #10 d = 0;
        #10 d = 1;
        #10 d = 0;
        #10 $finish;
    end
endmodule

module tb_dff_1();
    reg clk = 0, d = 0;
    wire qout;
    
    dff_1 DUT (
        .clk(clk),
        .d(d),
        .qout(qout)
    );
    
    initial begin
        forever begin
            #5 clk = ~clk;
        end
    end
    
    initial begin
        #12 d = 1;
        #10 d = 0;
        #10 d = 1;
        #10 d = 0;
        #10 $finish;
    end
endmodule

module tb_dff_2();
    reg clk = 0, d = 0;
    wire qout;
    
    dff_0 DUT (
        .clk(clk),
        .d(d),
        .qout(qout)
    );
    
    initial begin
        repeat (12) begin
            #5 clk = ~clk;
        end
    end
    
    initial begin
        #12 d = 1;
        #10 d = 0;
        #10 d = 1;
        #10 d = 0;
        #10 $finish;
    end
endmodule
