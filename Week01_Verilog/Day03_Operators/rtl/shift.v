module shift(
    input wire signed [7:0] data1,
    input wire [7:0] data2,
    output wire [7:0] out1, out2, out3, out4
);
    assign out1 = data1 << 2;
    assign out2 = data1 >> 2;
    assign out3 = data1 >>> 2;
    assign out4 = data2 >>> 2;
endmodule
