module mux4_0 (a, b, c, d, sel, out);
    input [1:0] a, b, c, d;
    input [3:0] sel;
    output [1:0] out;
    
    reg [1:0] out;
    
    always @ (sel or a or b) begin
        if (sel == 0)
            out = a;
        else if (sel == 1)
            out = b;
        else if (sel == 2)
            out = c;
        else
            out = d;
    end    
endmodule

module mux4_1 (a, b, c, d, sel, out);
    input [1:0] a, b, c, d;
    input [3:0] sel;
    output [1:0] out;
    
    reg [1:0] out;
    
    always @ (sel or a or b) begin
        case (sel)
            0 : out = a;
            1 : out = b;
            2 : out = c;
            default : out = d;
        endcase
    end    
endmodule
