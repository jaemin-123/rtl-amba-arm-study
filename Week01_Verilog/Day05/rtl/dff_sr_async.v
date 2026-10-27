module dff_sr_async(
    input wire clk, d, r_n, s_n,
    output wire q_n,
    output reg q
    );
    
    always @(posedge clk, negedge r_n, negedge s_n) begin
        if(!r_n)
            q <= 0;
        else if(!s_n)
            q <= 1;
        else
            q <= d;
    end
    
    assign q_n = ~q;
endmodule
