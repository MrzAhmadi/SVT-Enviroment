class generator;
    transaction tr;
    virtual vending_intf vif;
    
    function new(virtual vending_intf vif);
        this.vif = vif;
        this.tr = new();
    endfunction

    task run(int num_transactions);
        for (int i = 0; i < num_transactions; i++) begin
            assert(tr.randomize()); 
            
            @(posedge vif.clk);
            vif.coin_in   <= tr.coin;
            vif.button_in <= tr.button;
        end
        // Clear inputs after done
        @(posedge vif.clk);
        vif.coin_in <= 0;
        vif.button_in <= 0;
    endtask
endclass