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
    input logic [31:0] credit,
    input logic [2:0] current_state 
);

    // Verify system state during reset
    property p_reset;
        @(posedge clk) rst |-> (credit == 0 && change_out == 0 && beverage_out == 0);
    endproperty
    a_reset: assert property(p_reset);

    // Verify credit accumulation in IDLE state
    property p_coin_inc;
        @(posedge clk) (current_state == 0 && coin_in > 0) |=> (credit == $past(credit) + $past(coin_in));
    endproperty
    a_coin_inc: assert property(p_coin_inc);

    // Verify N-cycle delivery delay for water
    property p_water_delivery;
        @(posedge clk) (current_state == 0 && button_in == 1 && credit >= 30) |-> ##N (beverage_out == 1);
    endproperty
    a_water_delivery: assert property(p_water_delivery);

    // Verify N-cycle delivery delay for soda
    property p_soda_delivery;
        @(posedge clk) (current_state == 0 && button_in == 2 && credit >= 50) |-> ##N (beverage_out == 2);
    endproperty
    a_soda_delivery: assert property(p_soda_delivery);

    // Verify M-cycle delay for change return
    property p_change_return;
        @(posedge clk) (current_state == 2) |-> ##M (change_out > 0);
    endproperty
    a_change_return: assert property(p_change_return);

endmodule