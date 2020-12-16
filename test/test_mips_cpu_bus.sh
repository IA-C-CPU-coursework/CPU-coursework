#! /bin/bash

#set -e
#set -eou pipefail

testbench="
     ______          __  __                    __
    /_  __/__  _____/ /_/ /_  ___  ____  _____/ /_
     / / / _ \/ ___/ __/ __ \/ _ \/ __ \/ ___/ __ \\
    / / /  __(__  ) /_/ /_/ /  __/ / / / /__/ / / /
   /_/  \___/____/\__/_.___/\___/_/ /_/\___/_/ /_/
"
source_directory="$1" # default should be rtl/mips_cpu_bus.v
input_instruction="$2"

test_instruction=()

instructions=(
    # Arithmetic and logic
    "addu" "addiu"
    "and" "andi"
    "or" "ori"
    "slt" "slti" "sltiu" "sltu" 
    "subu"
    "xor" "xori"
    # Shift
    "sll" "sllv" 
    "sra" "srav" "srl" "srlv"
    # Multiplication and division
    "div" "divu" 
    "mult" "multu"
    "mthi" "mtlo" 
    # Branch
    "beq" "bgez" "bgezal" "bgtz" "blez" "bltz" "bltzal" "bne" 
    "j" "jal" "jalr" "jr"
    # Memory access
    "lb" "lbu" "lh" "lhu" "lui" "lw" "lwl" "lwr" 
    "sb" "sh" "sw"
    )

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


line
echo "${testbench}"


#-----------------------------------------------------------------------------
# Argument handling
#-----------------------------------------------------------------------------

if [[ ${source_directory} == "" ]]
then
    echo "❌ source directory is not provided"
    help
    exit 1
elif [[ ${source_directory} == "--help" ]]
then
    help
    exit 0
else
    if [[ -d ${source_directory} ]]
    then
        echo "source directory: ${source_directory}"
    else
        echo "❌ source directory ${source_directory} is not found"
        help
        exit 1
    fi
fi

if [[ ${input_instruction} != "" ]]
then
    if [[ " ${instructions[@]} " =~ " ${input_instruction} " ]]
    then
        test_instruction+=(${input_instruction})
        echo "test instruction: ${test_instruction[@]}"
    else
        echo "instruction required to test: ${input_instruction} is not included in ISA"
        exit 1
    fi
else 
    test_instruction=(${instructions[@]})
    echo "test instruction: ${test_instruction[@]}"
fi


#------------------------------------------------------------------------------
# Check working directory
#------------------------------------------------------------------------------

# The specification mentions:
# > To keep things simple, you can assume that your test-script will always be 
# > called from the base directory of your submission. This just means that 
# > your script is always invoked as `test/test_mips_cpu_bus.sh`.

dir="./"
root=`cd ${dir} && pwd`

echo ""
echo "1. Detected working directorty: ${root}"

# There is a file `this_is_root` in the project root directory
if [[ -f "this_is_root" ]]
then
    echo "✅ Working in the project root directory"
else 
    echo "❌ Working in the wrong directory"
    echo "    - not in the project root directory"
    exit 1
fi


#------------------------------------------------------------------------------
# Clean previously generated files in testcase directory
#------------------------------------------------------------------------------

"${root}/test/"clean_all.sh


#-----------------------------------------------------------------------------
# Assemble all testcases 
#-----------------------------------------------------------------------------

echo ""
echo "2. Start to assemble all test cases in ${root}/test/testcases"

for instruction in "${root}/test/testcases/"*
do
    if [[ -d ${instruction} ]]
    then
        instruction_name=`cd $instruction && echo "$(basename $PWD)"`
        
        if [[ ! " ${instructions[@]} " =~ " ${instruction_name} " ]]
        then
            echo "❌ Encounter unknown instruction ${instruction_name}"
            echo "${instructions[@]}"
            exit 1
        fi

        #echo "${instruction}/readme.md"
        if [[ -f "${instruction}/readme.md" ]]
        then
            >&2 echo "generating test cases from ${instruction_name}/readme.md"
            cd "${root}"
            "${root}/test/generate_testcases.sh" "${instruction}/readme.md"
        fi

        >&2 echo "assembling test cases for ${instruction_name}"
        cd "${instruction}"

        for testcase in "${instruction}/"*
        do
            if [[ -d ${testcase} ]]
            then
                testcase_name=`cd $testcase && echo "$(basename $PWD)"`
                cd "${testcase}"
                >&2 echo "assembling test case ${testcase_name}"
                ${root}/test/assembler.sh ${testcase}/${testcase_name}.S
                result=$?

                if [[ "${result}" -ne 0 ]]
                then
                    echo "❌ Error in assembling Test Cases"
                    exit 1
                fi
            fi
        done
    fi
done

cd "${root}"

echo "✅ Finished assembling all test cases"


#------------------------------------------------------------------------------
# Start to test instruction 
#------------------------------------------------------------------------------

printf "\n"
echo "3. Start to compile/run/compare test cases"

for instruction in "${test_instruction[@]}"
do
    if [[ -d "${root}/test/testcases/${instruction}" ]]
    then
        >&2 printf "🔍 found test cases for %-6s\n" "${instruction}"
        $root/test/test_mips_cpu_bus_one_instruction.sh "${instruction}"
    else
        >&2 printf "⛔ can not find test cases for %-6s\n" "${instruction}"
    fi
done


