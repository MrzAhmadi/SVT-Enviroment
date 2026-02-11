// Bind checker to the vending machine module
bind vending_machine vending_props #(
    .N(N), // Map delivery cycle parameter
    .M(M)  // Map change return cycle parameter
) props_inst (
    .clk(clk),
    .rst(rst),
    .coin_in(coin_in),
    .button_in(button_in),
    .change_out(change_out),
    .beverage_out(beverage_out),
    .credit(credit),
    .current_state(current_state)
);