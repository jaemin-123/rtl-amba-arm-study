`timescale 1ns / 1ps

module tb_dff_sv;

    logic clk, d;
    wire q_v, q_sv;

    // 기존 Verilog DFF
    dff U1 (
        .d(d),
        .clk(clk),
        .q(q_v)
    );

    // 새로 작성한 SystemVerilog DFF
    dff_sv U2 (
        .d(d),
        .clk(clk),
        .q(q_sv)
    );

    initial clk = 1'b0;
    always #10 clk = ~clk;

    initial begin
        d = 1'b0;

        // 첫 번째 테스트: 1 저장
        @(negedge clk);
        d = 1'b1;

        @(posedge clk);
        #1;

        assert (q_v === q_sv)
            else $fatal(1, "Verilog/SV mismatch");

        assert (q_sv === d)
            else $fatal(1, "DFF expected value mismatch");

        $display("PASS: d=%b V=%b SV=%b", d, q_v, q_sv);

        // 두 번째 테스트: 0 저장
        @(negedge clk);
        d = 1'b0;

        @(posedge clk);
        #1;

        assert (q_v === q_sv)
            else $fatal(1, "Verilog/SV mismatch");

        assert (q_sv === d)
            else $fatal(1, "DFF expected value mismatch");

        $display("PASS: d=%b V=%b SV=%b", d, q_v, q_sv);

        $finish;
    end
endmodule
