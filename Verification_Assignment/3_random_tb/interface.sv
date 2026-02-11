interface vending_intf(input logic clk, input logic rst);
    logic [31:0] coin_in;
    logic [31:0] button_in;
    logic [31:0] change_out;
    logic [31:0] beverage_out;
endinterface