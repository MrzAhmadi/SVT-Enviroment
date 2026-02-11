class transaction;
    // Random Inputs
    rand bit [31:0] coin;
    rand bit [31:0] button;

    // Constraints
    constraint valid_coin { coin inside {0, 10, 20, 50, 100, 200}; }
    constraint valid_button { button inside {0, 1, 2}; }

    // Distribution: Mostly 0 (no action), occasionally a value
    constraint dist_action {
        coin dist {0 := 80, [10:200] := 20};
        button dist {0 := 80, [1:2] := 20};
    }
endclass