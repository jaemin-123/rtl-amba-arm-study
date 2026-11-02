module dlatch(
    input wire d, en,
    output reg q
    );
    
    always @(*) begin
        if(en)
            q = d;
    end
endmodule

module dff(
    input wire d, clk,
    output reg q
    );
    
    always @(posedge clk) begin
            q <= d;
    end
endmodule
