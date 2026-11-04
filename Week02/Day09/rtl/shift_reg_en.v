module shift_reg_en(
    input wire clk, rst_n, sin, en,
    output wire sout
    );
    
    reg [7:0] q;
    
    always @(posedge clk) begin
        if(!rst_n)
            q <= 8'b0;
        else if(en)
            q <= {q[6:0], sin};
    end
    
    assign sout = q[7];
endmodule
