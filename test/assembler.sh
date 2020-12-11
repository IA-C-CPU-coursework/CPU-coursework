#!/bin/bash

#------------------------------------------------------------------------------
# This script assembles MIPS1 instruction using `mipsel-linux-gun-as` and
# `mipsel-linux-gun-objdump`, both included in `gcc-mipsel-linux-gnu`.
# It takes an input ended with `.asm.txt` and write the hex binary output into
# `$filename.hex.txt`.
#------------------------------------------------------------------------------

set -e

dependencies=(gcc-mipsel-linux-gnu)

for pkg in "${dependencies[@]}"
do
    # echo $pkg
    dpkg -s ${pkg} > /dev/null
    if [[ $? -eq 1  ]]
    then
        echo "[ASM] : missing dependencies, $i is not installed." >&2
    fi
done


if [[ $1 == "" ]]
# check input exists
then
    echo "[ASM] : no input found, please supply an assembly file ended in .S" >&2
    exit 1
fi


if [[ ${1: -2} != ".S" ]]
# check file extension
then
    echo "[ASM] : invalid file extension, please supply an assembly file ended in .S" >&2
    exit 1
fi

echo "[ASM] : 📨 receved assembly file $1" >&2


filename=$(basename $1 .S) # get filename from fullname
parentdir=$(dirname $1)    # get parent directory from fullname

#------------------------------------------------------------------------------
# Main part
#------------------------------------------------------------------------------

linker_parameters=" -Ttext 0xBFC00000 -Tdata 0xBFC00400 "
# start points for instruction section and data section

mipsel-linux-gnu-gcc ${parentdir}/${filename}.S \
    -O3 -g -nostdlib                            \
    -Wl,--build-id=none ${linker_parameters}    \
    -o ${parentdir}/${filename}.elf
    # -g generates debug information
    # -nostdlib do not use the standard system startup files when linking
    # -Wl pass <options> on to the linker
    # -T read linker script
    # -Ttext set the address of .text section 

mipsel-linux-gnu-objcopy --output-target binary \
    --only-section=.text                        \
    "${filename}".elf                           \
    "${filename}".bin                           \

hexdump -v -e '1/4 "%08x" "\n"' \
    "${filename}".bin           \
    > "${filename}".hex
    # -v show repeated lines
    # -e '1/4' read 4 byte at a time
    #    '"%08x"' fprintf format, 8 digits prefix with 0 in hexidecimal

if [[ $? -eq 0  ]]
then
    echo "[ASM] : ✅ $1 is assembled and the hex result is sent to stdout" >&2
fi
