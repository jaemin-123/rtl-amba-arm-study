module tb_inertial_delay;

    reg a, b;
    wire out_delay;
    wire out_no_delay;

    and U1(out_no_delay, a, b);

    and #30 U2(out_delay, a, b);

    initial begin
        a = 0; b = 0;
        #10; a = 1; b = 1;
        #20; a = 0; b = 0;
        #60; a = 1; b = 1;
        #50; a = 0; b = 0;
        #60; $finish;
    end
endmodule
