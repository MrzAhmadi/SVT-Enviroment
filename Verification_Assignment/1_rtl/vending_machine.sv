module vending_machine #(
    parameter N = 2, // Cycles for delivery [cite: 22, 24]
    parameter M = 2  // Cycles for returning change [cite: 23, 24]
)(
    input  logic        clk,
    input  logic        rst,         // [cite: 10]
    input  logic [31:0] coin_in,     // Numeric value [cite: 11]
    input  logic [31:0] button_in,   // Numeric value [cite: 11]
    output logic [31:0] change_out,  // Numeric value [cite: 12]
    output logic [31:0] beverage_out // Numeric value [cite: 13]
);

    // Internal State
    typedef enum {IDLE, DELIVER, CHANGE} state_t;
    state_t current_state;

    logic [31:0] credit;
    logic [31:0] timer;
    logic [31:0] selected_bev; // 1=Water, 2=Soda

    // Constants
    localparam COST_WATER = 30;
    localparam COST_SODA  = 50;
    localparam MIN_COST   = 30; // Lowest price item

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= IDLE;
            credit        <= 0;
            timer         <= 0;
            change_out    <= 0;
            beverage_out  <= 0;
            selected_bev  <= 0;
        end else begin
            // Default output reset per cycle
            beverage_out <= 0;
            change_out   <= 0;

            case (current_state)
                IDLE: begin
                    // Handle Coin Input [cite: 16]
                    if (coin_in == 10 || coin_in == 20 || coin_in == 50 || 
                        coin_in == 100 || coin_in == 200) begin
                        credit <= credit + coin_in;
                    end

                    // Handle Button Input [cite: 6, 17]
                    // Button 1 = Water (30), Button 2 = Soda (50)
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
                    // Wait N cycles [cite: 22]
                    if (timer > 0) begin
                        timer <= timer - 1;
                    end else begin
                        beverage_out <= selected_bev; // Deliver
                        // Check if change is needed 
                        if (credit < MIN_COST && credit > 0) begin
                            timer <= M;
                            current_state <= CHANGE;
                        end else begin
                            current_state <= IDLE;
                        end
                    end
                end

                CHANGE: begin
                    // Wait M cycles [cite: 23]
                    if (timer > 0) begin
                        timer <= timer - 1;
                    end else begin
                        change_out <= credit; // Return change
                        credit <= 0;
                        current_state <= IDLE;
                    end
                end
            endcase
        end
    end

endmodule