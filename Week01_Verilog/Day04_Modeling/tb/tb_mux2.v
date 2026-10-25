module tb_mux2();
    reg a, b, sel;
    wire out_assign;
    wire out_always;

    mux2_assign U1 (
        .a(a),
        .b(b),
        .sel(sel),
        .out(out_assign)
    );

    mux2_always U2 (
        .a(a),
        .b(b),
        .sel(sel),
        .out(out_always)
    );

    initial begin
        a = 0; b = 1; sel = 0;
        #10 a = 0; b = 1; sel = 1;
        #10 a = 1; b = 0; sel = 0;
        #10 a = 1; b = 0; sel = 1;
        #10 $finish;
    end
endmodule
