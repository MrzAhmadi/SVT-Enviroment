`timescale 1ns/1ps

module simple_tb;

    logic clk;
    logic rst;
    logic [31:0] coin_in;
    logic [31:0] button_in;
    logic [31:0] change_out;
    logic [31:0] beverage_out;

    vending_machine #(
        .N(2), 
        .M(2)
    ) dut (
        .clk(clk),
        .rst(rst),
        .coin_in(coin_in),
        .button_in(button_in),
        .change_out(change_out),
        .beverage_out(beverage_out)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        coin_in = 0;
        button_in = 0;
        
        #20 rst = 0;

        // TC1: Water delivery test
        #10 coin_in = 10;
        #10 coin_in = 0; 
        #10 coin_in = 20;
        #10 coin_in = 0;
        
        #10 button_in = 1;
        #10 button_in = 0;

        #50;

        // TC2: Soda delivery and change test
        #10 coin_in = 50;
        #10 coin_in = 0;
        #10 coin_in = 10;
        #10 coin_in = 0;

        #10 button_in = 2;
        #10 button_in = 0;

        #100;

        $display("Simulation finished");
        $finish;
    end

endmodule