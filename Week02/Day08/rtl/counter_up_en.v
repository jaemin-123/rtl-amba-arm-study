module counter_up_en(
    input wire clk, rst_n, en,
    output reg [7:0] cnt
    );
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            cnt <= 8'b0;
        else if (en)
            cnt <= cnt + 8'd1;
    end
endmodule
