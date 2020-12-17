#!/bin/bash

#-------------------------------------------------------------------------------
# This script extracts key information from `readme.md` inside each instruction 
# directory and generates test cases.
#-------------------------------------------------------------------------------

readme=$1

python3 test/generate_testcases.py $1 1>/dev/null
