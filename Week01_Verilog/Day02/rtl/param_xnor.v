module modXnor (y_out, a, b);
    parameter  size=8, delay=15;
    
    input [size-1:0] a, b;
    output [size-1:0] y_out;
    
    wire [size-1:0] #delay  y_out= a ~^ b;
endmodule

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
