#!/bin/bash

ROOT=${1}
TEST_PATH="${ROOT}/test"
>&2 echo "${TEST_PATH}"

find "${TEST_PATH}" -regex "${TEST_PATH}/testcases/[a-z]+/[a-z0-9-]+/[a-z0-9-]+\(.log\|.vcd\|.out\|.bin\|.hex\|.elf\)*" -type f -delete
