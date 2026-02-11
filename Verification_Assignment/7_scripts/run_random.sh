#!/bin/bash
rm -rf work
vlib work

# 1. Compile RTL
vlog ../1_rtl/vending_machine.sv

# 2. Compile the Single-File Random Testbench
vlog ../3_random_tb/random_tb.sv

# 3. Run Simulation (with VCD dumping enabled)
vsim -c -voptargs=+acc work.random_tb_top -do "vcd file random.vcd; vcd add -r *; run -all; quit"

# 4. Move Trace
mv random.vcd ../6_traces/random_tb.vcd
echo "Trace moved to ../6_traces/random_tb.vcd"