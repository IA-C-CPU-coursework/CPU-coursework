#!/bin/bash

#------------------------------------------------------------------------------
# This script compares the output of testbench and the references.
# return Pass | Fail
# usage: ./compare_result.sh <data.ref> <v0.ref> <output>
#------------------------------------------------------------------------------

set -e

# example of data memory inspection in output 
#   DATA_MEM[bfc00400] = 10000000
# example of register_v0 inspection in output
#   [TB] : LOG : 🥳 Finished, register_v0 = 00000002

data_start=0xBFC00400
cnt=0x0

data_reference="$1"
v0_reference="$2"
result="$3"

if [[ -f "${data_reference}" ]]
then
    >&2 printf "✅ data reference file: ${data_reference} found\n"
else
    >&2 printf "❌ data reference file: ${data_reference} is not found\n"
    exit 1
fi

if [[ -f "${v0_reference}" ]]
then
    >&2 printf "✅ v0 reference file:   ${v0_reference} found\n"
else
    >&2 printf "❌ v0 reference file:   ${v0_reference} is not found\n"
    exit 1
fi

if [[ -f "$result" ]]
then
    >&2 printf "✅ output file:         ${result} found\n"
else
    >&2 printf "❌ output file:         ${result} is not found\n"
    exit 1
fi


#------------------------------------------------------------------------------
# Check Data Section
#------------------------------------------------------------------------------

>&2 printf "Check data section\n"

while IFS= read -r line
do
    DATA_REFERENCE=$(printf "POST_DATA_MEM[%08x] = %s" "$((data_start + cnt))" "${line}")
    #printf "${DATA_REFERENCE} \n"
    if grep -F -q "${DATA_REFERENCE}" "${result}"
    then
        >&2 printf "✅ ${DATA_REFERENCE} is found in the output\n"
    else
        >&2 printf "❌ ${DATA_REFERENCE} is not found in the output\n"
        >&2 printf "Fail on checking data section.\n" # fail if one of the data reference is not found
        exit 1
    fi
    cnt=$((cnt + 0x4)) # increment to next word address
done < "${data_reference}"


#------------------------------------------------------------------------------
# Check register_v0
#------------------------------------------------------------------------------

>&2 printf "Check register_v0\n"

V0_REFERENCE=$(printf "Finished, register_v0 = %s\n" $(cat "${v0_reference}"))
if grep -F -q "${V0_REFERENCE}" "${result}"
then
    >&2 printf "✅ ${V0_REFERENCE} is found in the output\n"
else
    >&2 printf "❌ ${V0_REFERENCE} is not found in the output\n"
    >&2 printf "Fail on checking register_v0.\n" # fail if one of the data reference is not found
    exit 1
fi


>&2 printf "\nPass the test.\n" # pass if all data references are found
exit 0
