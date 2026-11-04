module counter_up_en_sv(
    input logic clk, en, rst_n,
    output logic [7:0] cnt
    );
    
    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            cnt <= 8'b0;
        else if(en)
            cnt <= cnt + 1'b1;
    end
endmodule
