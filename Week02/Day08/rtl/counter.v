module counter_up(
    input wire clk, rst_n,
    output reg [7:0] cnt
    );
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            cnt <= 8'b0;
        else
            cnt <= cnt + 8'd1;
    end
endmodule
