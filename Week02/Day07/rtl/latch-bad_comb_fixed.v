module latch_bad(
    input wire d, en,
    output reg y
    );
    
    always @(*) begin
        if (en)
            y = d;
    end 
endmodule

module comb_fixed(
    input wire d, en,
    output reg y
    );
    
    always @(*) begin
        y = 1'b0;
        if (en)
            y = d;
    end 
endmodule
