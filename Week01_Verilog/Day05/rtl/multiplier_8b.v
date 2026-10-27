module multiplier_8b #(
    parameter SIZE = 8,
    parameter LongSize = 2*SIZE
)(
    input  wire [SIZE-1:0] opa, opb,
    output reg  [LongSize-1:0] result
);

    reg [LongSize-1:0] shift_opa, shift_opb;

    always @(*) begin
        shift_opa = opa;
        shift_opb = opb;
        result = 0;

        repeat (SIZE) begin
            if (shift_opb[0])
                result = result + shift_opa;

            shift_opa = shift_opa << 1;
            shift_opb = shift_opb >> 1;
        end
    end
endmodule
