#!/bin/bash
rm -rf work
vlib work

# 1. Compile RTL Design
vlog ../1_rtl/vending_machine.sv

# 2. Compile Simple Testbench
vlog ../2_simple_tb/simple_tb.sv

# 3. Run Simulation
# -c: Command line mode
# -voptargs=+acc: Enable visibility for all signals (crucial for VCD)
# -do "...": Commands to run inside the simulator
# vcd add -r *: Adds all signals in the current scope to the trace
vsim -c -voptargs=+acc work.simple_tb -do "vcd file simple.vcd; vcd add -r *; run -all; quit"

# 4. Move Trace to the correct folder
mv simple.vcd ../6_traces/simple_tb.vcd
echo "Trace moved to ../6_traces/simple_tb.vcd"