module latch_sv(
    input logic d, en,
    output logic q
    );
    
    always_latch begin
        if(en)
            q <= d;
    end
endmodule

module dff_sv(
    input logic d, clk,
    output logic q
    );
    
    always_ff @(posedge clk) begin
            q <= d;
    end
endmodule
