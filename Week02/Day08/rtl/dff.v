module dff_sync_rst(
    input wire d, clk, rst_n,
    output reg q
    );
    
    always @(posedge clk) begin
        if(!rst_n)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule

module dff_async_rst(
    input wire d, clk, rst_n,
    output reg q
    );
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule
