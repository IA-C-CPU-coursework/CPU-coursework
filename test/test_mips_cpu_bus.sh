#! /bin/bash

testbench="
     ______          __  __                    __
    /_  __/__  _____/ /_/ /_  ___  ____  _____/ /_
     / / / _ \/ ___/ __/ __ \/ _ \/ __ \/ ___/ __ \\
    / / /  __(__  ) /_/ /_/ /  __/ / / / /__/ / / /
   /_/  \___/____/\__/_.___/\___/_/ /_/\___/_/ /_/
"
source_directory=$1 # default should be rtl/mips_cpu_bus.v
instruction=$2

function help {
    # Display help information
    echo
    echo "This is a testbench."
    echo "Syntax: test_mips_cpu_bus.sh [source_directory] [instruction](optional)"
    echo
}

function line {
    printf %"$(tput cols)"s |tr " " "="
}

echo "$testbench"


#-----------------------------------------------------------------------------
# Argument handling
#-----------------------------------------------------------------------------

if [[ $source_directory == "" ]]
then
    echo "❌ source_directory not provided"
    help
    exit 1
else
    if [[ -d $source_directory ]]; then
        echo "source_directory: $source_directory"
    else
        echo "❌ directory \" $source_directory \" is not found"
        help
        exit 1
    fi
fi

if [[ $instruction != "" ]]
then
    echo "instruction: $instruction"
fi
