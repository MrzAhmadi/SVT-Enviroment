#!/bin/bash

cd "$(dirname "$0")"

harm --vcd ../6_traces/random_tb.vcd \
     --clk clk \
     --vcd-ss random_tb_top \
     --conf ../5_harm/conf.xml > ../5_harm/mined_assertions.txt

echo "Mining complete. Results saved to 5_harm/mined_assertions.txt"

echo "------------------------------------------------------------"
echo "Mined Assertions Results Table:"
sed -n '/╔/,/╚/p' ../5_harm/mined_assertions.txt
echo "------------------------------------------------------------"