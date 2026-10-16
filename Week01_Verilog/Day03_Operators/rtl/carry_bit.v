module carry_bit (
    input wire [3:0] a, b,
    output wire [3:0] sum,
    output wire carry
);
    assign {carry, sum} = a + b;
endmodule
