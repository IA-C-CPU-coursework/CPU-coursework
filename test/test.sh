#!/bin/bash
set -eou pipefail
TESTCASE="$1"
# 1.gives the the specific testcase to be tested in command line
# 2. TESTCASE is the argument passed to the sript

#compile the main cpu part:
#include all components in the cpu:
# .sh testbench should be able to test other CPUs,name might be different 
# should compile all files under the mips_cpu folder or all files with name mips_cpu_*v
>$2 echo "1 -- compiling the MIPS CPU"
# based on the current files:
   #passed the parameter to the ram
   #since names for CPU-core part can be different, maybe try to move all files
   iverilog -g 2012 \
   rtl/mips_cpu_*.v \
   -s mips_cpu_bus \
   -Pmips_cpu_bus_tb.RAM_INIT_FILE=\"test/01_instruction/${TESTCASE}\"
   -o test/03_simulator/mips_cpu_bus_${TESTCASE}

>$2 echo "2 -- running testbench and get the output "
-set -e
# run the testbench and get the outputs
test/03_simulator/mips_cpu_${TESTCASE} > test/04_output_v0
# if result returns to a failure code, should exit immediately.


>$2 echo "3 - extract the output from RAM and register_v0"
# the first line should contain the value in v0
# the remainning lines should be data dumpped from the RAM. 
# put them in seperate files 
# in folder 04_output_v0 and folder 06_output_ram

>$2 echo "4 - compare the results"
# compare the results got from the cpu with the ones got from MARS simulator
# the referenced ones are stored in the folder
# 05_reference_RAM and 07_reference_v0

# print the result fail or pass:
# using if statements: