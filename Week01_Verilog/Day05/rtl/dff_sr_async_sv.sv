module dff_sr_async_sv (
    input  logic clk,
    input  logic d,
    input  logic r_n,
    input  logic s_n,
    output logic q,
    output logic q_n
);

    always_ff @(posedge clk or negedge r_n or negedge s_n) begin
        if (!r_n)
            q <= 1'b0;
        else if (!s_n)
            q <= 1'b1;
        else
            q <= d;
    end

    assign q_n = ~q;

endmodule
