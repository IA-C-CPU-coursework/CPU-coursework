#! /bin/bash

# Set root directory of the project 

# The specification mentions:
# > To keep things simple, you can assume that your test-script will always be 
# > called from the base directory of your submission. This just means that 
# > your script is always invoked as `test/test_mips_cpu_bus.sh`.

dir="./"
root=`cd $dir && pwd`
echo "Detected root directorty of the project: ${root}"

# There is a file `this_is_root` in the project root directory
if [[ -f "this_is_root" ]]; then
    echo "✅ Executing in the project root directory"
else 
    echo "❌ Executing in the wrong directory"
    echo "    - not in the project root directory"
    exit 1
fi

testbench="
     ______          __  __                    __
    /_  __/__  _____/ /_/ /_  ___  ____  _____/ /_
     / / / _ \/ ___/ __/ __ \/ _ \/ __ \/ ___/ __ \\
    / / /  __(__  ) /_/ /_/ /  __/ / / / /__/ / / /
   /_/  \___/____/\__/_.___/\___/_/ /_/\___/_/ /_/
"
source_directory="$1" # default should be rtl/mips_cpu_bus.v
instruction="$2"

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

echo "${testbench}"


#-----------------------------------------------------------------------------
# Argument handling
#-----------------------------------------------------------------------------

if [[ ${source_directory} == "" ]]
then
    echo "❌ source_directory not provided"
    help
    exit 1
else
    if [[ -d ${source_directory} ]]; then
        echo "source_directory: ${source_directory}"
    else
        echo "❌ directory \" ${source_directory} \" is not found"
        help
        exit 1
    fi
fi

if [[ ${instruction} != "" ]]
then
    echo "instruction: ${instruction}"
fi


#-----------------------------------------------------------------------------
# Assemble all testcases 
#-----------------------------------------------------------------------------

echo ""
echo "Start to assemble all test cases in ${root}/test/testcases"

for testcase in ${root}/test/testcases/*; do
    >&2 echo " - assembling ${testcase}"
    cd "${testcase}"
    testcase_name="${PWD##*/}"

    OUT=$(${root}/test/assembler.sh ${testcase}/${testcase_name}.S 2> \
        ${testcase_name}.objdump.log)
    result=$?
    ERR=$(<${testcase_name}.objdump.log)

    if [[ "${result}" -ne 0 ]];then
        echo "❌ Error in assembling Test Cases"
        echo "${ERR}"
        exit 1
    else
        echo "${OUT}" > ${testcase_name}.hex.txt
    fi
done

cd "${root}"

echo "✅ Finished assembling all test cases in ${root}/test/testcases"

#------------------------------------------------------------------------------
# Start to test instruction 
#------------------------------------------------------------------------------


#$root/test/test_mips_cpu_bus_one_instruction.sh $instruction 
