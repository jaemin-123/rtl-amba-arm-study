module tb_alu8 ();
    reg [7:0] a, b;
    reg [2:0] opcode;
    wire [15:0] result;
    reg [15:0] expected;
    
    localparam ADD = 3'b001;
    localparam SUB = 3'b010;
    localparam MUL = 3'b011;
    localparam AND = 3'b100;
    localparam OR = 3'b101;
    localparam XOR = 3'b110;
    
    alu8 U1 (
        .a(a),
        .b(b),
        .opcode(opcode),
        .result(result)
    );
    
    always @(a or b or opcode) begin
        case (opcode)
            ADD: expected = a + b;
            SUB: expected = a - b;
            MUL: expected = a * b;
            AND: expected = a & b;
            OR : expected = a | b;
            XOR: expected = a ^ b;
            default: expected = 16'd0;
        endcase
    
        #1;
    
        if (result !== expected)
            $error("FAIL: opcode=%b, a=%h, b=%h, result=%h, expected=%h",
                   opcode, a, b, result, expected);
        else
            $display("PASS: opcode=%b, a=%h, b=%h, result=%h",
                     opcode, a, b, result);
    end
    
    initial begin
        a = 8'hFF; b = 8'h01; opcode = ADD;
        #10
        a = 8'h03; b = 8'h05; opcode = SUB;
        #10
        a = 8'hFF; b = 8'hFF; opcode = MUL;
        #10
        a = 8'hAA; b = 8'h0F; opcode = AND;
        #10
        a = 8'hA0; b = 8'h0F; opcode = OR;
        #10
        a = 8'hFF; b = 8'h0F; opcode = XOR;
        #10 
        a = 8'h12; b = 8'h34; opcode = 3'b000;
        #10 
        a = 8'hFF; b = 8'hFF; opcode = 3'b111;
        #10 $finish;
    end
endmodule
