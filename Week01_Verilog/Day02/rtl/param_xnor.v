module modXnor (y_out, a, b);
    parameter  size=8, delay=15;
    
    input [size-1:0] a, b;
    output [size-1:0] y_out;
    
    wire [size-1:0] #delay  y_out= a ~^ b;
endmodule

** 기존 modXnor 수정
module modXnor_0 #(
    parameter size  = 8,
    parameter delay = 15
)(
    output [size-1:0] y_out,
    input  [size-1:0] a, b
);

    assign #delay y_out = a ~^ b;

endmodule


module Param;
    wire [7:0] y1_out;
    wire [3:0] y2_out;
    reg [7:0] b1, c1;
    reg [3:0] b2, c2;
    
    modXnor G1 ( 
        .a(b1), 
        .b(c1),
        .y_out(y1_out)
    );   

    modXnor #(4, 5) G2 ( 
        .a(b2), 
        .b(c2),
        .y_out(y2_out)
    ); 
endmodule

** 기존 Param 수정 후 tb 까지
module Param_0;
    reg  [7:0] a1, b1;
    reg  [3:0] a2, b2;
    wire [7:0] y1_out;
    wire [3:0] y2_out;

    modXnor_0 G1 (
        .a(a1),
        .b(b1),
        .y_out(y1_out)
    );

    // Parameter 변경
    modXnor_0 #(
        .size(4),
        .delay(5)
    ) G2 (
        .a(a2),
        .b(b2),
        .y_out(y2_out)
    );

    initial begin
        a1 = 8'b10101010;
        b1 = 8'b11110000;

        a2 = 4'b1010;
        b2 = 4'b1111;

        #20;

        a1 = 8'b11111111;
        b1 = 8'b11111111;

        a2 = 4'b0000;
        b2 = 4'b0000;

        #20 $finish;
    end
endmodule
