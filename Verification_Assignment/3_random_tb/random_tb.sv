`timescale 1ns/1ps

// 1. Interface
interface vending_intf(input logic clk, input logic rst);
    logic [31:0] coin_in;
    logic [31:0] button_in;
    logic [31:0] change_out;
    logic [31:0] beverage_out;
endinterface

// 2. Transaction Object
class transaction;
    rand bit [31:0] coin;
    rand bit [31:0] button;
    constraint valid_coin { coin inside {0, 10, 20, 50, 100, 200}; }
    constraint valid_button { button inside {0, 1, 2}; }
    constraint realistic_dist {
        coin dist   {0 := 80, [10:200] := 20};
        button dist {0 := 90, [1:2] := 10};
    }
endclass

// 3. Generator
class generator;
    transaction tr;
    virtual vending_intf vif;

    function new(virtual vending_intf vif);
        this.vif = vif;
        this.tr = new();
    endfunction

    task run(int count);
        repeat (count) begin
            assert(tr.randomize());
            @(posedge vif.clk);
            vif.coin_in   <= tr.coin;
            vif.button_in <= tr.button;
        end
        @(posedge vif.clk);
        vif.coin_in <= 0;
        vif.button_in <= 0;
    endtask
endclass

// 4. Top Level Module
module random_tb_top;
    logic clk;
    logic rst;

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    vending_intf intf(clk, rst);

    vending_machine dut (
        .clk(intf.clk),
        .rst(intf.rst),
        .coin_in(intf.coin_in),
        .button_in(intf.button_in),
        .change_out(intf.change_out),
        .beverage_out(intf.beverage_out)
    );
    
    // === [NEW] HARM EXPOSED SIGNALS ===
    // These wires force the simulator to keep these signals as 32-bit buses 
    // at the top level, making them easy for HARM to find.
    logic [31:0] harm_btn;
    logic [31:0] harm_bev;
    assign harm_btn = intf.button_in;
    assign harm_bev = intf.beverage_out;
    // ==================================

    generator gen;
    initial begin
        rst = 1;
        intf.coin_in = 0;
        intf.button_in = 0;
        #20 rst = 0;

        gen = new(intf);
        gen.run(2000); 

        #200;
        $finish;
    end
endmodule