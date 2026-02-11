#!/bin/bash

cd ../5_harm

# Remove hidden characters that often break XML parsing
sed -i 's/\r//' conf.xml

# Run HARM with the Trace and Configuration
harm --conf conf.xml --vcd ../6_traces/random_tb.vcd --clk random_tb_top::clk > mined_assertions.txt

echo "HARM mining complete. Results saved in 5_harm/mined_assertions.txt"