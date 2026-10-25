module blocking_ex (
    input wire clk,
    input wire rst,
    output reg a,
    output reg b
);

    always @(posedge clk) begin
        if (rst) begin
            a = 1'b0;
            b = 1'b1;
        end
        else begin
            a = b;
            b = a;
        end
    end
endmodule

module nonblocking_ex (
    input wire clk,
    input wire rst,
    output reg a,
    output reg b
);

    always @(posedge clk) begin
        if (rst) begin
            a <= 1'b0;
            b <= 1'b1;
        end
        else begin
            a <= b;
            b <= a;
        end
    end
endmodule
