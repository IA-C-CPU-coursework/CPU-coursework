#!/bin/bash
set -eou pipefail

# Use a wild-card to specifiy that every file with this pattern represents a testcase file
TESTCASES="01_instruction_hex/*.txt"

# Loop over every file matching the TESTCASES pattern
for i in ${TESTCASES} ; do
    # Extract just the testcase name from the filename. See `man basename` for what this command does.
    TESTNAME=$(basename ${i} .txt)
    # Dispatch to the main test-case script
    ./test_mips_cpu_one_testcase.sh  ${TESTNAME}
done