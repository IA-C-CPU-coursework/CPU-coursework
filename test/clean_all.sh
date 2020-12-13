#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo "${DIR}"

find "${DIR}" -regex "${DIR}/testcases/[a-z]+/[a-z0-9-]+/[a-z0-9-]+\(.log\|.vcd\|.out\|.bin\|.hex\|.elf\)*" -type f -delete
