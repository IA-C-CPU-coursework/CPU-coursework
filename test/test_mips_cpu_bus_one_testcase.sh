#!/bin/bash
#set -eou pipefail
TESTCASE="$1"
INSTRUCTION=$(echo "${TESTCASE}" | sed -E 's/([a-z]+)-[0-9]+/\1/g')
# 1. gives the the specific testcase to be tested in command line
# 2. TESTCASE is the argument passed to the sript

dir="./"
root=`cd ${dir} && pwd`
testcase_path="${root}/test/testcases/${INSTRUCTION}/${TESTCASE}"

>&2 printf "\t\t1 - Compiling test-bench ${TESTCASE}\n"
iverilog -g 2012 \
-s mips_cpu_bus_tb \
-P mips_cpu_bus_tb.RAM_INSTR_INIT_FILE=\""${testcase_path}/${TESTCASE}.hex"\" \
-P mips_cpu_bus_tb.RAM_INSTR_SIZE=$(wc -l "${testcase_path}/${TESTCASE}.hex" | cut -d " " -f 1) \
-P mips_cpu_bus_tb.RAM_DATA_INIT_FILE=\""${testcase_path}/${TESTCASE}_data.init"\" \
-P mips_cpu_bus_tb.RAM_DATA_SIZE=$(wc -l "${testcase_path}/${TESTCASE}_data.init" | cut -d " " -f 1) \
-P mips_cpu_bus_tb.VCD_OUTPUT=\""${testcase_path}/${TESTCASE}.vcd"\" \
-o "${testcase_path}/${TESTCASE}" \
$root/rtl/mips_cpu_bus.v \
$root/rtl/mips_cpu_bus_tb.v \
$root/rtl/mips_cpu/*.v


>&2 printf "\t\t2 - Executing test-bench ${TESTCASE}\n" 
"${testcase_path}/${TESTCASE}" > "${testcase_path}/${TESTCASE}.out"

>&2 printf "\t\t3 - Comparing results with reference\n"
printf "%-8s %-6s exists\n" "${TESTCASE}" "${INSTRUCTION}"
