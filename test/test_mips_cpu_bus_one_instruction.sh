#!/bin/bash
set -eou pipefail

INSTRUCTION="$1"

dir="../"
root=`cd $dir && pwd`

TESTCASES="$root/test/testcases/*$INSTRUCTION*"

for TESTCASE in ${TESTCASES} ; do
    TESTNAME=$(basename ${TESTCASE}) # Extract testcase name from file path e.g. 01_addiu1
    ./test_mips_cpu_bus_one_testcase.sh ${TESTNAME} # Dispatch to the main test-case script
done
