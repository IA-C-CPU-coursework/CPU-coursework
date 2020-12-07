#!/bin/bash
set -eou pipefail
TESTCASE="$1"
# 1. gives the the specific testcase to be tested in command line
# 2. TESTCASE is the argument passed to the sript


>&2 echo " 1 - Compiling test-bench ${TESTCASE}"
iverilog -g 2012 \
-s mips_cpu_bus_tb \
-P mips_cpu_bus_tb.RAM_INIT_FILE=\"01_instruction_hex/${TESTCASE}.txt\" \
-o 03_binaries/${TESTCASE} \
../rtl/mips_fakecpu.v ../rtl/mips_cpu_bus_tb_temp.v ../rtl/RAM_32x64k_avalon.v

03_binaries/${TESTCASE} > 04_output_v0/${TESTCASE}.txt
