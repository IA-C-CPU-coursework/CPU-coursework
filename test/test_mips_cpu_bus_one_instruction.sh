#!/bin/bash

INSTRUCTION="$1"

dir="./"
root=`cd $dir && pwd`

TESTCASES="${root}/test/testcases/${INSTRUCTION}/*"

function log() {
    { 
        $@                                                              \
        2>&1 1>&3 3>&-                                                  \
        | tee -a "${TESTCASE}/${TESTNAME}.log";
    } 3>&1 1>&2
}


for TESTCASE in ${TESTCASES} ; do
    if [[ -d ${TESTCASE} ]]
    then
        TESTNAME=$(basename ${TESTCASE}) # Extract testcase name from file path e.g. 01_addiu1
        >&2 printf "Test on %-10s\n" "${TESTNAME}"
        log "${root}/test/test_mips_cpu_bus_one_testcase.sh" ${TESTNAME}
        #"${root}/test/test_mips_cpu_bus_one_testcase.sh" ${TESTNAME} 3>&2 2>&1 1>&3 \
            #| sed 's/^/  /' 1> "${TESTCASE}/${TESTNAME}.log" 3>&2 2>&1 1>&3 # Dispatch to the main test-case script
    fi
done
