module tb_multiplier_8b_sv;

    logic [7:0]  opa, opb;
    logic [15:0] result;
    logic [15:0] expected;

    multiplier_8b_sv U1 (
        .opa(opa),
        .opb(opb),
        .result(result)
    );

    // 테스트를 수행하는 Task
    task automatic check_mul(
        input logic [7:0] a,
        input logic [7:0] b
    );
        begin
            opa = a;
            opb = b;

            expected = 16'(a) * 16'(b);

            #1; // 조합논리 출력 갱신 대기

            assert (result === expected)
                $display("PASS: %0d * %0d = %0d",
                         opa, opb, result);
            else
                $error("FAIL: %0d * %0d = %0d (expected %0d)",
                       opa, opb, result, expected);
        end
    endtask

    initial begin
        check_mul(0,   25);
        check_mul(1,  123);
        check_mul(3,    5);
        check_mul(15,  10);
        check_mul(128,  2);
        check_mul(255, 255);
        
        repeat (100) begin
            check_mul(
                $urandom_range(0, 255),
                $urandom_range(0, 255)
            );
        end
        $finish;
    end

endmodule
