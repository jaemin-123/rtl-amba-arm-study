module UART_rx_fsm(
    input wire clk, rst_n, rx,
    input wire half_bit_done, bit_done,
    input wire [2:0] bit_index
);
    reg [1:0] state, next_state;

    localparam IDLE = 2'b00;
    localparam START = 2'b01;
    localparam DATA = 2'b10;
    localparam STOP = 2'b11;
    
    always @(posedge clk) begin
        if(!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end
    
    always @(*) begin
        next_state = state;
        
        case(state)
            IDLE : begin
                if(!rx)
                    next_state = START;
            end
            START : begin
                if(half_bit_done)
                    next_state = rx ? IDLE : DATA;
            end
            DATA : begin
                if(bit_done && (bit_index == 3'd7))
                    next_state = STOP;
            end
            STOP : begin
                if(bit_done)
                    next_state = IDLE;
            end
            default : next_state = IDLE;
        endcase
    end
endmodule
