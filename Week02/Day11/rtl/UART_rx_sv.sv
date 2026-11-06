module UART_rx_sv #(
    parameter integer CLKS_PER_BIT = 8
    )(
    input logic clk, rst_n, rx,
    output logic [7:0] rx_data,
    output logic rx_done
    );
    
    typedef enum logic [1:0]{
        IDLE = 2'b00,
        START = 2'b01,
        DATA = 2'b10, 
        STOP = 2'b11
    } state_t;
    
    state_t state, next_state;
    
    logic rx_meta, rx_sync;
    logic [2:0] bit_index;
    logic [7:0] data_buf; 
    logic [15:0] cnt;
    
    localparam integer HALF_BIT = CLKS_PER_BIT / 2;

    logic half_bit_done;
    logic bit_done;
    
    assign half_bit_done = (cnt == HALF_BIT - 1);
    assign bit_done      = (cnt == CLKS_PER_BIT - 1);
    
    always_ff @(posedge clk) begin
        if (!rst_n) begin
            rx_meta <= 1'b1;
            rx_sync <= 1'b1;
        end
        else begin
            rx_meta <= rx;
            rx_sync <= rx_meta;
        end
    end
    
    always_ff @(posedge clk) begin
        if (!rst_n)
            cnt <= 16'd0;
        else if (state == IDLE)
            cnt <= 16'd0;
        else if (next_state != state)
            cnt <= 16'd0;
        else if ((state == DATA || state == STOP) && bit_done)
            cnt <= 16'd0;
        else
            cnt <= cnt + 16'd1;
    end
    
    always_ff @(posedge clk) begin
        if(!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end
    
    always_ff @(posedge clk) begin
        if(!rst_n) begin
            bit_index <= 3'd0;
            data_buf <= 8'd0;
            rx_data <= 8'd0;
            rx_done <= 1'b0;
        end
        else begin
            rx_done <= 1'b0;
            
            case(state)
                IDLE : begin
                    bit_index <= 3'd0;
                end
                DATA : begin
                    if(bit_done) begin
                        data_buf[bit_index] <= rx_sync;
                        
                        if(bit_index < 3'd7)
                            bit_index <= bit_index + 3'd1;
                    end
                end
                STOP : begin
                    if(bit_done && rx_sync) begin
                        rx_data <= data_buf;
                        rx_done <= 1'b1;
                    end
                end
            endcase
        end
    end
    
    always_comb begin
        next_state = state;
        
        case(state)
            IDLE : begin
                if(!rx_sync)
                    next_state = START;
            end
            START : begin
                if(half_bit_done)
                    next_state = rx_sync ? IDLE : DATA;
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
