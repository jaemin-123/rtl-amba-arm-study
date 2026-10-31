module alu8_sv(
    input logic [7:0] a, b,
    input logic [2:0] opcode,
    output logic [15:0] result
    );
    
    typedef enum logic [2:0] {
        DEFAULT0 = 3'b000,
        ADD      = 3'b001,
        SUB      = 3'b010,
        MUL      = 3'b011,
        AND      = 3'b100,
        OR       = 3'b101,
        XOR      = 3'b110,
        DEFAULT7 = 3'b111
    } opcode_t;
    
    always_comb begin
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
