module cnt_one_while (
    input  wire [7:0] rega,
    output reg  [3:0] count
);

    reg [7:0] temp_reg;

    always @(rega) begin
        count = 0;
        temp_reg = rega;

        while (temp_reg) begin
            if (temp_reg[0])
                count = count + 1;

            temp_reg = temp_reg >> 1;
        end
    end

endmodule

module cnt_one_for (
    input  wire [7:0] rega,
    output reg  [3:0] count
);

    integer i;

    always @(*) begin
        count = 4'd0;

        for (i = 0; i < 8; i = i + 1) begin
            count = count + rega[i];
        end
    end

endmodule
