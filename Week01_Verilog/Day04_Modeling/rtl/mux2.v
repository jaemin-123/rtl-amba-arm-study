module mux2_assign(
    input wire a, b, sel,
    output wire out
    );
    
    assign out = sel ? a : b;
endmodule

module mux2_always(
    input wire a, b, sel,
    output reg out
    );
    
    always @ (*) begin
        if (sel)
            out = a;
        else
            out = b;
    end    
endmodule
