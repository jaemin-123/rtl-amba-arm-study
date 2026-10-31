module alu8(
    input wire [7:0] a, b,
    input wire [2:0] opcode,
    output reg [15:0] result
    );
    
    localparam ADD = 3'b001;
    localparam SUB = 3'b010;
    localparam MUL = 3'b011;
    localparam AND = 3'b100;
    localparam OR = 3'b101;
    localparam XOR = 3'b110;
    
    always @(*) begin
        case (opcode)
            ADD : result = a + b;
            SUB : result = a - b;
            MUL : result = a * b;
            AND : result = a & b;
            OR  : result = a | b;
            XOR : result = a ^ b;
            default : result = 0;
        endcase
    end
endmodule
