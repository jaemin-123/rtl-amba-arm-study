module dff_b(
    input wire d, clk,
    output reg q, 
    output wire bq
    );
    
    assign bq = ~q;
    
    always @(posedge clk) 
        q <= d;
endmodule

module dff_b_2(
    input wire d, clk,
    output reg q, bq
    );
 
    always @(posedge clk) begin
        q <= d;
        bq <= ~d;
    end
endmodule
