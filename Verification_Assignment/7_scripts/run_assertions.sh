#!/bin/bash
rm -rf work
vlib work

# 1. Compile RTL & Random TB (Single File)
vlog ../1_rtl/vending_machine.sv
vlog ../3_random_tb/random_tb.sv

# 2. Compile Assertions
vlog ../4_assertions/assertions.sv
vlog ../4_assertions/bind.sv

# 3. Run Simulation with Assertions
vsim -c -assertdebug -voptargs=+acc work.random_tb_top -do "vcd file assertions.vcd; vcd add -r *; run -all; quit"

mv assertions.vcd ../6_traces/assertions.vcd
echo "Trace moved to ../6_traces/assertions.vcd"