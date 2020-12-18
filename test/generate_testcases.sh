#!/bin/bash

#-------------------------------------------------------------------------------
# This script extracts key information from `readme.md` inside each instruction 
# directory and generates test cases.
#-------------------------------------------------------------------------------

ROOT=${1}
readme=${2}

python3 "${ROOT}/test/generate_testcases.py" "${readme}" 1>/dev/null
