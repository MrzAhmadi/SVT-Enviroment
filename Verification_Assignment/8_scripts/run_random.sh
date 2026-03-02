#!/bin/bash

rm -rf work
vlib work

vlog ../1_rtl/vending_machine.sv

vlog ../3_random_tb/random_tb.sv

vsim -c -voptargs=+acc work.random_tb_top -do "vcd file random.vcd; vcd add -r *; run -all; quit"

mv random.vcd ../6_traces/random_tb.vcd
echo "Trace moved to ../6_traces/random_tb.vcd"