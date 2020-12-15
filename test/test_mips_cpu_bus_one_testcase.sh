#!/bin/bash

set -euo pipefail

#------------------------------------------------------------------------------
# This script compiles and executes the testbench of a specific testcase
# usage: test/test_mips_cpu_bus_one_testcase.sh <testcase>
#------------------------------------------------------------------------------

TESTCASE="$1"
INSTRUCTION=$(echo "${TESTCASE}" | sed -E 's/([a-z]+)-[0-9]+/\1/g')

dir="./"
root=`cd ${dir} && pwd`
testcase_path="${root}/test/testcases/${INSTRUCTION}/${TESTCASE}"


#------------------------------------------------------------------------------
# Compile test-bench 
#------------------------------------------------------------------------------

>&2 printf "1 - Compiling test-bench ${TESTCASE}\n"

iverilog -g 2012 \
-s mips_cpu_bus_tb \
-P mips_cpu_bus_tb.RAM_INSTR_INIT_FILE=\""${testcase_path}/${TESTCASE}.hex"\" \
-P mips_cpu_bus_tb.RAM_INSTR_SIZE=$(wc -l "${testcase_path}/${TESTCASE}.hex" | cut -d " " -f 1) \
-P mips_cpu_bus_tb.RAM_DATA_INIT_FILE=\""${testcase_path}/${TESTCASE}_data.init"\" \
-P mips_cpu_bus_tb.RAM_DATA_SIZE=$(wc -l "${testcase_path}/${TESTCASE}_data.init" | cut -d " " -f 1) \
-P mips_cpu_bus_tb.VCD_OUTPUT=\""${testcase_path}/${TESTCASE}.vcd"\" \
-o "${testcase_path}/${TESTCASE}" \
"${root}/rtl/mips_cpu_bus.v" \
"${root}/rtl/mips_cpu/"*.v \
"${root}/test/mips_cpu_bus_tb.v" \
"${root}/test/RAM_32x64k_avalon.v"

if [[ $? -ne 0 ]]
then
    >&2 printf "❌ ${TESTCASE}: error in test-bench compilation\n"
else
    >&2 printf "✅ test-bench compiled\n"
fi

>&2 printf "\n"


#------------------------------------------------------------------------------
# Execute test-bench
#------------------------------------------------------------------------------

>&2 printf "2 - Executing test-bench ${TESTCASE}\n" 

set +e
"${testcase_path}/${TESTCASE}" > "${testcase_path}/${TESTCASE}.out"

if [[ $? -ne 0 ]]
then
    >&2 printf "❌ %-08s: error in test-bench execution\n" "${TESTCASE}"
else
    >&2 printf "✅ test-bench executed\n"
fi

>&2 printf "\n"


#------------------------------------------------------------------------------
# Exam test-bench result
#------------------------------------------------------------------------------

>&2 printf "3 - Comparing results with reference\n"

"${root}/test/compare_result.sh"             \
    "${testcase_path}/${TESTCASE}_data.ref" \
    "${testcase_path}/${TESTCASE}_v0.ref" \
    "${testcase_path}/${TESTCASE}.out"


if [[ $? -ne 0 ]]
then
    printf "%-8s %-6s Fail\n" "${TESTCASE}" "${INSTRUCTION}"
else
    printf "%-8s %-6s Pass\n" "${TESTCASE}" "${INSTRUCTION}"
fi
