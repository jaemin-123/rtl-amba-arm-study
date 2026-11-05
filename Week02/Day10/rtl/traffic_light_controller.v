module traffic_light_controller (
    input wire clk, rst_n, ta, tb,
    output reg [1:0] la, lb
);

    localparam [1:0]
        S0 = 2'b00,
        S1 = 2'b01,
        S2 = 2'b10,
        S3 = 2'b11;

    localparam [1:0]
        GREEN  = 2'b00,
        YELLOW = 2'b01,
        RED    = 2'b10;

    reg [1:0] state, next_state;

    // 1. State Register
    always @(posedge clk) begin
        if (!rst_n)
            state <= S0;
        else
            state <= next_state;
    end

    // 2. Next State & Output Logic
    always @(*) begin
        next_state = state;
        la = RED;
        lb = RED;

        case (state)
            S0: begin
                la = GREEN;
                lb = RED;

                if (!ta)
                    next_state = S1;
            end

            S1: begin
                la = YELLOW;
                lb = RED;
                next_state = S2;
            end

            S2: begin
                la = RED;
                lb = GREEN;

                if (!tb)
                    next_state = S3;
            end

            S3: begin
                la = RED;
                lb = YELLOW;
                next_state = S0;
            end

            default: begin
                next_state = S0;
                la = RED;
                lb = RED;
            end
        endcase
    end

endmodule
