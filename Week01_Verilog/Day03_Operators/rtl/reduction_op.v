module reduction_op(
    input wire [3:0] a, b, c,
    output wire [3:0] bit_result,
    output wire y1, y2, logic_result    
);
    assign logic_result = b && c;
    assign bit_result = b & c;
    assign y1 = ~(a[0] & a[1] & a[2] & a[3]);
    assign y2 = ~& a;
endmodule
