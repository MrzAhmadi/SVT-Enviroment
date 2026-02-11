#!/bin/bash

# Move to the script's directory for relative path safety 
cd "$(dirname "$0")"

# Execute HARM using the manual configuration file 
# --vcd-ss simplifies the hierarchy to match our templates [cite: 41]
harm --vcd ../6_traces/random_tb.vcd \
     --clk clk \
     --vcd-ss random_tb_top \
     --conf ../5_harm/conf.xml > ../5_harm/mined_assertions.txt

echo "Mining complete. Results saved to 5_harm/mined_assertions.txt"