#!/bin/bash

cd ../5_harm

# Run HARM using the Random TB trace
# We use the full hierarchical name for the clock as found in the VCD
harm --conf conf.xml --vcd ../6_traces/random_tb.vcd --clk random_tb_top::clk > mined_assertions.txt

echo "HARM mining complete. Output saved to 5_harm/mined_assertions.txt"