`timescle 1ns/1ps

module tb_shift_reg_en_sv();
    logic clk, rst_n, en, sin;
    wire sout_v, sout_sv;
    logic [7:0] expected;
    
    shift_reg_en U1(
        .clk(clk), 
        .rst_n(rst_n), 
        .en(en), 
        .sin(sin),
        .sout(sout_v)
    );
    
    shift_reg_en_sv U2(
        .clk(clk), 
        .rst_n(rst_n), 
        .en(en), 
        .sin(sin),
        .sout(sout_sv)
    );
    
    initial clk = 0;
    always #10 clk = ~clk;
    
    initial begin
        rst_n = 0; en = 0; sin = 0;
        #20 rst_n = 1; en = 1; sin = 1;
        #20 sin = 0;
    end
    
    initial begin        
        repeat (15) begin
            @(posedge clk);
            if(!rst_n)
                expected <= 8'd0;
            else if(en)
                expected <= (expected << 1)|{7'b0,sin};
            
            #1;
            assert ((sout_v === sout_sv) && (sout_sv === expected[7]))
                else $fatal(1, "shift mismatch at %0t", $time);
        end
        
        $display("match");
        $finish;
    end
endmodule
