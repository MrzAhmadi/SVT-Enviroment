`timescale 1ns/1ps

module simple_tb;

    // Signals
    logic clk;
    logic rst;
    logic [31:0] coin_in;
    logic [31:0] button_in;
    logic [31:0] change_out;
    logic [31:0] beverage_out;

    // Instantiate the DUT (Design Under Test)
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

    // Clock Generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test Sequence
    initial begin
        // Initialize
        rst = 1;
        coin_in = 0;
        button_in = 0;
        
        // Apply Reset
        #20 rst = 0;

        // --- Test Case 1: Buy Water (Cost 30) with exact change ---
        $display("TC1: Insert 10, 20 -> Buy Water");
        #10 coin_in = 10;
        #10 coin_in = 0; // Clear input
        #10 coin_in = 20;
        #10 coin_in = 0;
        
        // Press Button 1 (Water)
        #10 button_in = 1;
        #10 button_in = 0;

        // Wait for delivery (N cycles)
        #50;

        // --- Test Case 2: Buy Soda (Cost 50) with Change (Input 60) ---
        $display("TC2: Insert 50, 10 -> Buy Soda -> Expect Change");
        #10 coin_in = 50;
        #10 coin_in = 0;
        #10 coin_in = 10;
        #10 coin_in = 0;

        // Press Button 2 (Soda)
        #10 button_in = 2;
        #10 button_in = 0;

        // Wait for delivery (N) and Change (M)
        #100;

        $display("Test Complete");
        $finish;
    end

endmodule