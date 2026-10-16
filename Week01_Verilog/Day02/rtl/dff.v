module dff_0(clk, d, qout);
    input clk, d;
    output qout;
    
    reg qout;
    
    always @(posedge clk) begin
        qout <= d;
    end
endmodule

module dff_1(clk, d, qout);
    input clk, d;
    output reg qout;
    
    always @(posedge clk) begin
        qout <= d;
    end
endmodule
