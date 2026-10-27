module tb_cnt_one ();
    reg [7:0] rega;
    wire [3:0] count_while, count_for;
    
    cnt_one_while U1 (
        .rega(rega),
        .count(count_while)
    );
    
    cnt_one_for U2 (
        .rega(rega),
        .count(count_for)
    );
    
    always @(rega) begin
        #1;
    
        if (count_while !== count_for)
            $error("FAIL: rega = %d, count_while = %d, count_for = %d",
                   rega, count_while, count_for);
        else
            $display("PASS: rega = %d, count_while = %d, count_for = %d",
                   rega, count_while, count_for);
    end
    
    initial begin
        rega = 8'h00;
        #10
        rega = 8'b10101010;
        #10
        rega = 8'b00001111;
        #10
        rega = 8'b11110000;
        #10
        rega = 8'b11111111;
        #10 $finish;
    end
endmodule
