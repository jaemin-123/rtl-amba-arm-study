module tb_alu8_sv;

    // 1. 신호 선언
    logic [7:0] a, b;
    logic [15:0] result_v, result_sv;

    int pass_count = 0;

    // 2. SystemVerilog enum을 이용한 Opcode 정의
    typedef enum logic [2:0] {
        OP_DEFAULT0 = 3'b000,
        OP_ADD      = 3'b001,
        OP_SUB      = 3'b010,
        OP_MUL      = 3'b011,
        OP_AND      = 3'b100,
        OP_OR       = 3'b101,
        OP_XOR      = 3'b110,
        OP_DEFAULT7 = 3'b111
    } opcode_t;

    opcode_t opcode;

    // 3. Verilog ALU
    alu8 U1 (
        .a(a),
        .b(b),
        .opcode(opcode),
        .result(result_v)
    );

    // 4. SystemVerilog ALU
    alu8_sv U2 (
        .a(a),
        .b(b),
        .opcode(opcode),
        .result(result_sv)
    );

    // 5. Reference Model: 예상 결과 계산
    function automatic logic [15:0] golden_alu(
        input logic [7:0] x,
        input logic [7:0] y,
        input opcode_t op
    );
        logic [15:0] x16, y16;

        x16 = {8'b0, x};
        y16 = {8'b0, y};

        case (op)
            OP_ADD: golden_alu = x16 + y16;
            OP_SUB: golden_alu = x16 - y16;
            OP_MUL: golden_alu = x16 * y16;
            OP_AND: golden_alu = x16 & y16;
            OP_OR : golden_alu = x16 | y16;
            OP_XOR: golden_alu = x16 ^ y16;
            default: golden_alu = 16'd0;
        endcase
    endfunction

    // 6. 입력 인가 + 결과 검증 Task
    task automatic check_alu(
        input logic [7:0] in_a,
        input logic [7:0] in_b,
        input opcode_t in_op
    );
        logic [15:0] expected;

        // 입력 인가
        a = in_a;
        b = in_b;
        opcode = in_op;

        // 예상값 계산
        expected = golden_alu(in_a, in_b, in_op);

        // DUT 조합논리 출력 안정화
        #1;

        // Verilog와 SystemVerilog 결과 비교
        assert (result_v === result_sv)
        else
            $fatal(1, "V/SV MISMATCH: op=%b a=%h b=%h V=%h SV=%h",
                   in_op, in_a, in_b, result_v, result_sv);

        // 예상 결과와 비교
        assert (result_sv === expected)
        else
            $fatal(1, "WRONG RESULT: op=%b a=%h b=%h got=%h expected=%h",
                   in_op, in_a, in_b, result_sv, expected);

        pass_count++;

        $display("PASS [%0d] op=%b a=%h b=%h result=%h",
                 pass_count, in_op, in_a, in_b, result_sv);

    endtask

    // 7. 테스트 실행
    initial begin

        // 직접 지정한 테스트 8개
        check_alu(8'hFF, 8'h01, OP_ADD);
        check_alu(8'h03, 8'h05, OP_SUB);
        check_alu(8'hFF, 8'hFF, OP_MUL);
        check_alu(8'hAA, 8'h0F, OP_AND);
        check_alu(8'hA0, 8'h0F, OP_OR);
        check_alu(8'hFF, 8'h0F, OP_XOR);
        check_alu(8'h12, 8'h34, OP_DEFAULT0);
        check_alu(8'hFF, 8'hFF, OP_DEFAULT7);

        // 랜덤 입력 100개
        // Opcode는 0~7을 순환하여 모두 검사
        for (int i = 0; i < 100; i++) begin
            check_alu(
                $urandom_range(0, 255),
                $urandom_range(0, 255),
                opcode_t'(i % 8)
            );
        end

        $display("--------------------------------");
        $display("ALL TESTS PASSED: %0d", pass_count);
        $display("--------------------------------");

        $finish;
    end

endmodule
