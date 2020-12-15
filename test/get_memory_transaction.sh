#!/bin/bash

#------------------------------------------------------------------------------
# This script extracts memory transaction from output of `mips_cpu_bus_tb`
#------------------------------------------------------------------------------

cat -                                   `# take input from stdin`   \
    | grep "\[TB\] \: MEM \:"           `# find all matched lines`  \
    | sed -r 's/.*(read|write).*\[(.*)\] ([0-9a-fA-F]+)/\1 \2 \3/'  \
    # use regex to match read|write, address and data
    >&1 # direct output to stdout
