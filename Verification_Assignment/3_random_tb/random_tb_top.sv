`timescale 1ns/1ps

// Include the class files so they are visible in this scope
`include "transaction.sv"
`include "generator.sv"

module random_tb_top;
    logic clk;
    logic rst;

    // Clock Gen
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Interface
    vending_intf intf(clk, rst);

    // DUT Connection
    vending_machine dut (
        .clk(intf.clk),
        .rst(intf.rst),
        .coin_in(intf.coin_in),
        .button_in(intf.button_in),
        .change_out(intf.change_out),
        .beverage_out(intf.beverage_out)
    );

    // Test Execution
    generator gen;
    initial begin
        rst = 1;
        intf.coin_in = 0;
        intf.button_in = 0;
        
        #20 rst = 0;

        gen = new(intf);
        gen.run(500); // Run 500 random cycles

        #100;
        $finish;
    end
endmodule