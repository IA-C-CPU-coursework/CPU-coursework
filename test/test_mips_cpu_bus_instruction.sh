#!/bin/bash
set -eou pipefail
TESTCASE="$1"
# 1.gives the the specific testcase to be tested in command line
# 2. TESTCASE is the argument passed to the sript

# compile the cpu compoments and the tb module
iverilog -g 2012 \
-s mips_cpu_bus_tb \
-Pmips_cpu_bus_tb.RAM_INIT_FILE=\"../test/01_instruction_hex/*${TESTCASE}.txt\" \
-o ../test/03_binaries/${TESTCASE} \
mips_fakecpu.v mips_cpu_bus_tb_temp.v RAM_32x64k_avalon.v

../test/03_binaries/${TESTCASE} > ../test/04_output_v0/${TESTCASE}.txt