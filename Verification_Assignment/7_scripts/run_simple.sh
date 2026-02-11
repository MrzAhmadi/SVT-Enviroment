#!/bin/bash
rm -rf work
vlib work

vlog ../1_rtl/vending_machine.sv
vlog ../2_simple_tb/simple_tb.sv

# Changed /* to * to fix VCD error
vsim -c -voptargs=+acc work.simple_tb -do "vcd file simple.vcd; vcd add -r *; run -all; quit"

mv simple.vcd ../6_traces/simple_tb.vcd
echo "Trace moved to ../6_traces/simple_tb.vcd"