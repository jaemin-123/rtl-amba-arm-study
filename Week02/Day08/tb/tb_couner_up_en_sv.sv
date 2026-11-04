module tb_counter_up_en_sv();
     logic clk, en, rst_n;
     wire [7:0] cnt_v, cnt_sv;
     logic [7:0] expected;
     
     counter_up_en U1(
        .clk(clk),
        .en(en),
        .rst_n(rst_n),
        .cnt(cnt_v)
     );
     
     counter_up_en_sv U2(
        .clk(clk),
        .en(en),
        .rst_n(rst_n),
        .cnt(cnt_sv)
     );
     
     initial clk = 1'b0;
     always #10 clk = ~clk;
     
     initial begin
        rst_n = 1; en = 1;
        #5 rst_n = 0;
        #35 rst_n = 1;
        expected = 8'd0;
        
        repeat(512) begin
            @(posedge clk);
            expected = expected + 1'b1;
            #1
            assert (cnt_v === cnt_sv)
                else $fatal(1, "Verilog/ SV mismatch");
            assert (cnt_sv === expected)
                else $fatal(1, "Counter expected value mismatch");
        end
        
        $display("PASS: 512 counter checks");
        $finish;
     end
endmodule
