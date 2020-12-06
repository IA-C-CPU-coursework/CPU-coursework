#!/bin/bash
set -eou pipefail

TESTCASE="$1"
TESTCASES="../test/01_instruction_hex/*${TESTCASE}*.txt"


# 1.gives the the specific testcase to be tested in command line
# 2. TESTCASE is the argument passed to the sript


# compile the cpu compoments and the tb module
for i in ${TESTCASES} ; do
    # Extract just the testcase name from the filename. See `man basename` for what this command does.
    TESTNAME=$(basename ${i} .txt)
    # Dispatch to the main test-case script
    ./test_mips_cpu_one_testcase.sh ${TESTNAME}
done