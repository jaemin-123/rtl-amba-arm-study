module UART_rx_fsm_sv(
    input logic clk, rst_n, rx,
    input logic half_bit_done, bit_done,
    input logic [2:0] bit_index
);

    typedef enum logic [1:0] {
        IDLE,
        START,
        DATA,
        STOP
    } state_t;
    
    state_t state, next_state;
    
    always_ff @(posedge clk) begin
        if(!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end
    
    always_comb begin
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
