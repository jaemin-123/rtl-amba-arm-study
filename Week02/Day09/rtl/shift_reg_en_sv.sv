module shift_reg_en_sv(
    input logic clk, rst_n, en, sin,
    output logic sout
    );
    
    logic [7:0] q;
    
    always_ff @(posedge clk) begin
        if(!rst_n)
            q <= 8'd0;
        else if(en)
            q <= {q[6:0], sin};
    end
    
    assign sout = q[7];
endmodule
