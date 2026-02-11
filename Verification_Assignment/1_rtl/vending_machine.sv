module vending_machine #(
    parameter N = 2, 
    parameter M = 2  
)(
    input  logic        clk,
    input  logic        rst,
    input  logic [31:0] coin_in,     
    input  logic [31:0] button_in,   
    output logic [31:0] change_out,  
    output logic [31:0] beverage_out 
);

    typedef enum {IDLE, DELIVER, CHANGE} state_t;
    state_t current_state;

    logic [31:0] credit;
    logic [31:0] timer;
    logic [31:0] selected_bev; 

    localparam COST_WATER = 30;
    localparam COST_SODA  = 50;
    localparam MIN_COST   = 30; 

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= IDLE;
            credit        <= 0;
            timer         <= 0;
            change_out    <= 0;
            beverage_out  <= 0;
            selected_bev  <= 0;
        end else begin
            beverage_out <= 0;
            change_out   <= 0;

            case (current_state)
                IDLE: begin
                    if (coin_in == 10 || coin_in == 20 || coin_in == 50 || 
                        coin_in == 100 || coin_in == 200) begin
                        credit <= credit + coin_in;
                    end

                    if (button_in == 1 && credit >= COST_WATER) begin
                        credit <= credit - COST_WATER;
                        selected_bev <= 1;
                        timer <= N;
                        current_state <= DELIVER;
                    end else if (button_in == 2 && credit >= COST_SODA) begin
                        credit <= credit - COST_SODA;
                        selected_bev <= 2;
                        timer <= N;
                        current_state <= DELIVER;
                    end
                end

                DELIVER: begin
                    if (timer > 0) begin
                        timer <= timer - 1;
                    end else begin
                        beverage_out <= selected_bev; 
                        
                        if (credit < MIN_COST && credit > 0) begin
                            timer <= M;
                            current_state <= CHANGE;
                        end else begin
                            current_state <= IDLE;
                        end
                    end
                end

                CHANGE: begin
                    if (timer > 0) begin
                        timer <= timer - 1;
                    end else begin
                        change_out <= credit; 
                        credit <= 0;
                        current_state <= IDLE;
                    end
                end
            endcase
        end
    end

endmodule