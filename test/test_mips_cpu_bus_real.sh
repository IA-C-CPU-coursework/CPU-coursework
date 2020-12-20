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
    "mfhi" "mflo" 
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


>&2 line
>&2 echo "${testbench}"


#-----------------------------------------------------------------------------
# Argument handling
#-----------------------------------------------------------------------------

if [[ ${source_directory} == "" ]]
then
    >&2 echo "❌ source directory is not provided"
    >&2 help
    exit 1
elif [[ ${source_directory} == "--help" ]]
then
    >&2 help
    exit 0
else
    if [[ -d ${source_directory} ]]
    then
        >&2 echo "source directory: ${source_directory}"
    else
        >&2 echo "❌ source directory ${source_directory} is not found"
        help
        exit 1
    fi
fi

if [[ ${input_instruction} != "" ]]
then
    if [[ " ${instructions[@]} " =~ " ${input_instruction} " ]]
    then
        test_instruction+=(${input_instruction})
        >&2 echo "test instruction: ${test_instruction[@]}"
    else
        >&2 echo "instruction required to test: ${input_instruction} is not included in ISA"
        exit 1
    fi
else 
    test_instruction=(${instructions[@]})
    >&2 echo "test instruction: ${test_instruction[@]}"
fi


#------------------------------------------------------------------------------
# Check working directory
#------------------------------------------------------------------------------

# The specification mentions:
# > To keep things simple, you can assume that your test-script will always be 
# > called from the base directory of your submission. This just means that 
# > your script is always invoked as `test/test_mips_cpu_bus.sh`.

dir="./"
ROOT=`cd ${dir} && pwd`

>&2 echo ""
>&2 echo "1. Detected working directorty: ${ROOT}"

# There is a file `this_is_root` in the project root directory
if [[ -f "this_is_root" ]]
then
    >&2 echo "✅ Working in the project root directory"
else 
    >&2 echo "❌ Working in the wrong directory"
    >&2 echo "    - not in the project root directory"
    exit 1
fi


#------------------------------------------------------------------------------
# Clear previously generated files in testcase directory
#------------------------------------------------------------------------------

"${ROOT}/test/"clear_all.sh ${ROOT}


#-----------------------------------------------------------------------------
# Assemble all testcases 
#-----------------------------------------------------------------------------

>&2 echo ""
>&2 echo "2. Start to assemble all test cases in ${ROOT}/test/testcases"

for instruction in "${ROOT}/test/testcases/"*
do
    if [[ -d ${instruction} ]]
    then
        instruction_name=`cd $instruction && echo "$(basename $PWD)"`
        
        if [[ ! " ${instructions[@]} " =~ " ${instruction_name} " ]]
        then
            >&2 echo "❌ Encounter unknown instruction ${instruction_name}"
            >&2 echo "${instructions[@]}"
            exit 1
        fi

        #echo "${instruction}/readme.md"
        if [[ -f "${instruction}/readme.md" ]]
        then
            >&2 echo "generating test cases from ${instruction_name}/readme.md"
            cd "${ROOT}"
            "${ROOT}/test/generate_testcases.sh" "${ROOT}" "${instruction}/readme.md"
        fi

        >&2 echo "assembling test cases for ${instruction_name}"
        >&2 cd "${instruction}"

        for testcase in "${instruction}/"*
        do
            if [[ -d ${testcase} ]]
            then
                testcase_name=`cd $testcase && echo "$(basename $PWD)"`
                cd "${testcase}"
                >&2 echo "assembling test case ${testcase_name}"
                ${ROOT}/test/assembler.sh ${testcase}/${testcase_name}.S
                result=$?

                if [[ "${result}" -ne 0 ]]
                then
                    >&2 echo "❌ Error in assembling Test Cases"
                    exit 1
                fi
            fi
        done
    fi
done

cd "${ROOT}"

>&2 echo "✅ Finished assembling all test cases"


#------------------------------------------------------------------------------
# Start to test instruction 
#------------------------------------------------------------------------------

>&2 printf "\n"
>&2 echo "3. Start to compile/run/compare test cases"

for instruction in "${test_instruction[@]}"
do
    if [[ -d "${ROOT}/test/testcases/${instruction}" ]]
    then
        >&2 printf "🔍 found test cases for %-6s\n" "${instruction}"
        "${ROOT}/test/test_mips_cpu_bus_one_instruction.sh" "${ROOT}" "${1}" "${instruction}" # ROOT/ rtl/ instruction_name
    else
        >&2 printf "⛔ can not find test cases for %-6s\n" "${instruction}"
    fi
done


