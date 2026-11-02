module shift_assignment_compare(
    input wire d, clk,
    output reg q3
    );
    reg q0, q1, q2;
    
    always @(posedge clk) begin
        q0 = d;
        q1 = q0;
        q2 = q1;
        q3 = q2;
    end
endmodule

module shift_assignment_compare_1(
    input wire d, clk,
    output reg q3
    );
    reg q0, q1, q2;
    
    always @(posedge clk) begin
        q3 = q2;
        q2 = q1;
        q1 = q0;
        q0 = d;
    end
endmodule

module shift_assignment_compare_2(
    input wire d, clk,
    output reg q3
    );
    reg q0, q1, q2;
    
    always @(posedge clk) begin
        q0 <= d;
        q1 <= q0;
        q2 <= q1;
        q3 <= q2;
    end
endmodule
