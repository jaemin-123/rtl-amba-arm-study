module tb_assignment_compare;

    reg clk;
    reg rst;

    wire a_blk, b_blk;
    wire a_nblk, b_nblk;

    blocking_ex U1 (
        .clk(clk),
        .rst(rst),
        .a(a_blk),
        .b(b_blk)
    );

    nonblocking_ex U2 (
        .clk(clk),
        .rst(rst),
        .a(a_nblk),
        .b(b_nblk)
    );
    
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        rst = 1;
        #12; rst = 0;
        #50; $finish;
    end
endmodule
