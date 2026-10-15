module full_adder_0 (a, b, cin, sum, cout);
    input a, b, cin;
    output sum, cout;
    
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (cin & (a ^ b));
endmodule

module full_adder_1 (a, b, cin, sum, cout);
    input a, b, cin;
    output sum, cout;
    
    wire w1, w2, w3;
    
    half_adder_0 U1 (
        .a(a),
        .b(b),
        .sum(w2),
        .cout(w1)
    );
    
    half_adder_0 U2 (
        .a(w2),
        .b(cin),
        .sum(sum),
        .cout(w3)
    );
    
    assign cout = w1 | w3;
endmodule
