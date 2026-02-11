module vending_props #(
    parameter N = 2,
    parameter M = 2
)(
    input logic clk,
    input logic rst,
    input logic [31:0] coin_in,
    input logic [31:0] button_in,
    input logic [31:0] change_out,
    input logic [31:0] beverage_out,
    // Internal signals for white-box verification
    input logic [31:0] credit,
    input logic [2:0] current_state // 0:IDLE, 1:DELIVER, 2:CHANGE
);

    // 1. Reset Assertion: When reset is high, credit and outputs must be 0
    property p_reset;
        @(posedge clk) rst |-> (credit == 0 && change_out == 0 && beverage_out == 0);
    endproperty
    a_reset: assert property(p_reset);

    // 2. Coin Increment: If a coin is inserted in IDLE, credit must increase next cycle
    property p_coin_inc;
        @(posedge clk) (current_state == 0 && coin_in > 0) |=> (credit == $past(credit) + $past(coin_in));
    endproperty
    a_coin_inc: assert property(p_coin_inc);

    // 3. Water Delivery Timing: Requesting Water (btn 1) -> Deliver (out 1) after N cycles
    property p_water_delivery;
        @(posedge clk) (current_state == 0 && button_in == 1 && credit >= 30) |-> ##N (beverage_out == 1);
    endproperty
    a_water_delivery: assert property(p_water_delivery);

    // 4. Soda Delivery Timing: Requesting Soda (btn 2) -> Deliver (out 2) after N cycles
    property p_soda_delivery;
        @(posedge clk) (current_state == 0 && button_in == 2 && credit >= 50) |-> ##N (beverage_out == 2);
    endproperty
    a_soda_delivery: assert property(p_soda_delivery);

    // 5. Change Return: If entering CHANGE state, change_out must be valid after M cycles
    property p_change_return;
        @(posedge clk) (current_state == 2) |-> ##M (change_out > 0);
    endproperty
    a_change_return: assert property(p_change_return);

endmodule