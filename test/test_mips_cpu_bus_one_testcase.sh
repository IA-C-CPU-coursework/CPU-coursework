#!/bin/bash
set -eou pipefail
TESTCASE="$1"
# 1. gives the the specific testcase to be tested in command line
# 2. TESTCASE is the argument passed to the sript

dir="../"
root=`cd $dir && pwd`

>&2 echo " 1 - Compiling test-bench ${TESTCASE}"
iverilog -g 2012 \
-s mips_cpu_bus_tb \
-P mips_cpu_bus_tb.RAM_INSTR_INIT_FILE=\"testcases/$TESTCASE/$TESTCASE.hex.txt\" \
-P mips_cpu_bus_tb.RAM_INSTR_SIZE=$(wc -l testcases/$TESTCASE/$TESTCASE.hex.txt | cut -d " " -f 1) \
-P mips_cpu_bus_tb.RAM_DATA_INIT_FILE=\"testcases/$TESTCASE/$TESTCASE.hex.txt\" \
-P mips_cpu_bus_tb.RAM_DATA_SIZE=$(wc -l testcases/$TESTCASE/$TESTCASE.hex.txt | cut -d " " -f 1) \
-P mips_cpu_bus_tb.VCD_OUTPUT=\"testcases/$TESTCASE/$TESTCASE.vcd\" \
-o testcases/$TESTCASE/$TESTCASE \
$root/rtl/mips_cpu_bus.v \
$root/rtl/mips_cpu_bus_tb.v \
$root/rtl/mips_cpu/*.v


>&2 echo " 2 - Executing test-bench ${TESTCASE}" 
testcases/$TESTCASE/$TESTCASE > testcases/$TESTCASE/$TESTCASE.output.txt

>&2 echo " 3 - Comparing results with reference"
INSTRUCTION=$(echo "$TESTCASE" | sed -E 's/[0-9]{2}\_([a-z]+)[0-9]+/\1/g')
INSTRUCTION_NUM=$(echo "$TESTCASE" | sed -E 's/[0-9]{2}\_([a-z0-9]+)/\1/g')
echo "$INSTRUCTION_NUM $INSTRUCTION"

