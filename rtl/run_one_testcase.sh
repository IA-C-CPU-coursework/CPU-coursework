#!/bin/bash
set -eou pipefail
TESTCASE="$1"

>&2 echo " 2 - Compiling test-bench"
iverilog -g 2012 \
-s mips_cpu_bus_tb \
-Pmips_cpu_bus_tb.RAM_INIT_FILE=\"../test/01-instruction_hex/${TESTCASE}.txt\" \
-o ../test/03_output_v0/${TESTCASE} \
mips_fakecpu.v mips_cpu_bus_tb_temp.v RAM_32x64k_avalon.v
