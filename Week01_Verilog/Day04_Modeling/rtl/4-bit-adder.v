module adder4 (
    input wire [3:0] a, b,
    input wire cin,
    output wire [3:0] sum,
    output wire cout
);

    assign {cout, sum} = a + b + cin;
endmodule

module adder4_1 (
    input wire [3:0] a, b,
    input wire cin,
    output wire [3:0] sum,
    output wire cout
);
    wire w1, w2, w3;
    
    full_adder_g U1 (
        .a(a[0]),
        .b(b[0]),
        .cin(cin),
        .sum(sum[0]),
        .cout(w1)
    );
    
    full_adder_g U2 (
        .a(a[1]),
        .b(b[1]),
        .cin(w1),
        .sum(sum[1]),
        .cout(w2)
    );
    
    full_adder_g U3 (
        .a(a[2]),
        .b(b[2]),
        .cin(w2),
        .sum(sum[2]),
        .cout(w3)
    );
    
    full_adder_g U4 (
        .a(a[3]),
        .b(b[3]),
        .cin(w3),
        .sum(sum[3]),
        .cout(cout)
    );
endmodule
