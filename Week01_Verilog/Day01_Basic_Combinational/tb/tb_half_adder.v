module tb_half_adder_0 ();
    reg a, b;
    wire cout, sum;
    
    initial begin
        #0 a = 0; b = 0;
        #10 a = 0; b = 1;
        #10 a = 1; b = 0;
        #10 a = 1; b = 1;
        #10
        $finish;
    end
    
    half_adder_0 DUT(
        .a(a),
        .b(b),
        .cout(cout),
        .sum(sum)
    );
endmodule

module tb_half_adder_1 ();
    reg a, b;
    wire cout, sum;
    
    initial begin
        #0 a = 0; b = 0;
        #10 a = 0; b = 1;
        #10 a = 1; b = 0;
        #10 a = 1; b = 1;
        #10
        $finish;
    end
    
    half_adder_1 DUT(
        .a(a),
        .b(b),
        .cout(cout),
        .sum(sum)
    );
endmodule

module tb_half_adder_2 ();
    reg a, b;
    wire cout, sum;
    
    initial begin
        #0 a = 0; b = 0;
        #10 a = 0; b = 1;
        #10 a = 1; b = 0;
        #10 a = 1; b = 1;
        #10
        $finish;
    end
    
    half_adder_2 DUT(
        .a(a),
        .b(b),
        .cout(cout),
        .sum(sum)
    );
endmodule
