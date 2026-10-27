module multiplier_8b_sv #(
    parameter SIZE = 8,
    parameter LongSize = 2*SIZE
)(
    input logic [SIZE-1:0] opa, opb,
    output logic [LongSize-1:0] result
);

    logic [LongSize-1:0] shift_opa, shift_opb;

    always_comb begin
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
