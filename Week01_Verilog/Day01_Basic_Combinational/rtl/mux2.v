module mux2_0 (a, b, sel, out);
    input [1:0] a, b;
    input sel;
    output [1:0] out;
    
    reg [1:0] out;
    
    always @ (sel or a or b) begin
        if (sel == 0)
            out = a;
        else
            out = b;
    end    
endmodule

module mux2_1 (a, b, sel, out);
    input [1:0] a, b;
    input sel;
    output [1:0] out;
    
    reg [1:0] out;
    
    always @ (sel or a or b) begin
        case (sel)
            0 : out = a;
            default : out = b;
        endcase
    end    
endmodule
