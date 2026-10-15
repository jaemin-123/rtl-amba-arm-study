module tb_full_adder_0 ();
    reg a, b, cin;
    wire sum, cout;
    
    initial begin
        #0 a = 0; b = 0; cin = 0;
        #10 a = 0; b = 1; cin = 0;
        #10 a = 1; b = 0; cin = 0;
        #10 a = 1; b = 1; cin = 0;
        #10 a = 0; b = 0; cin = 1;
        #10 a = 0; b = 1; cin = 1;
        #10 a = 1; b = 0; cin = 1;
        #10 a = 1; b = 1; cin = 1;
        #10
        $finish;
    end
    
    full_adder_0 DUT (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );
endmodule

module tb_full_adder_1 ();
    reg a, b, cin;
    wire sum, cout;
    
    initial begin
        #0 a = 0; b = 0; cin = 0;
        #10 a = 0; b = 1; cin = 0;
        #10 a = 1; b = 0; cin = 0;
        #10 a = 1; b = 1; cin = 0;
        #10 a = 0; b = 0; cin = 1;
        #10 a = 0; b = 1; cin = 1;
        #10 a = 1; b = 0; cin = 1;
        #10 a = 1; b = 1; cin = 1;
        #10
        $finish;
    end
    
    full_adder_1 DUT (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );
endmodule
