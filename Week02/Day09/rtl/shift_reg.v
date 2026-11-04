module shift_reg_bits(
    input wire clk, rst_n, sin,
    output wire sout
    );
    
    reg [7:0] q;
    
    always @(posedge clk) begin
        if(!rst_n)
            q <= 8'b0;
        else begin
            q[0] <= sin;
            q[1] <= q[0];
            q[2] <= q[1];
            q[3] <= q[2];
            q[4] <= q[3];
            q[5] <= q[4];
            q[6] <= q[5];
            q[7] <= q[6];
        end
    end
    
    assign sout = q[7];
endmodule

module shift_reg_concat(
    input wire clk, rst_n, sin,
    output wire sout
    );
    
    reg [7:0] q;
    
    always @(posedge clk) begin
        if(!rst_n)
            q <= 8'b0;
        else begin
            q <= {q[6:0], sin};
        end
    end
    
    assign sout = q[7];
endmodule
