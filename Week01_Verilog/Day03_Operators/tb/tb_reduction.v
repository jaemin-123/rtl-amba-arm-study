module tb_reduction();
    reg [3:0] a, b, c;
    wire [3:0] bit_result;
    wire y1, y2, logic_result;
    
    reduction_op DUT(
        .a(a),
        .b(b),
        .c(c),
        .bit_result(bit_result),
        .logic_result(logic_result),
        .y1(y1),
        .y2(y2)
    );
    
    initial begin
        a = 4'h5; b = 4'b1010; c = 4'b1100;
        #10 a = 4'ha; b = 4'b0000;
        #10 a = 4'hc; b = 4'b1111;
        #10 a = 4'h2; c = 4'b0000;
        #10 a = 4'hf; c = 4'b1111;
        #10 $finish;
    end
endmodule
