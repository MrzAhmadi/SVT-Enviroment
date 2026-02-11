#!/bin/bash
rm -rf work
vlib work

vlog ../1_rtl/vending_machine.sv
vlog ../3_random_tb/interface.sv
vlog +incdir+../3_random_tb ../3_random_tb/random_tb_top.sv
vlog ../4_assertions/assertions.sv
vlog ../4_assertions/bind.sv

# Changed /* to * to fix VCD error
vsim -c -assertdebug -voptargs=+acc work.random_tb_top -do "vcd file assertions.vcd; vcd add -r *; run -all; quit"

mv assertions.vcd ../6_traces/assertions.vcd
echo "Trace moved to ../6_traces/assertions.vcd"