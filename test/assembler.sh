#!/bin/bash

#------------------------------------------------------------------------------
# This script assembles MIPS1 instruction using `mipsel-linux-gun-as` and
# `mipsel-linux-gun-objdump`.
# It takes an input ended with `.asm.txt` and write the hex binary output into
# `$filename.hex.txt`.
#------------------------------------------------------------------------------

set -e

dependencies=(gcc-mipsel-linux-gnu)

for pkg in "${dependencies[@]}"
do
    # echo $pkg
    dpkg -s $pkg > /dev/null
    if [[ $? -eq 1  ]]
    then
        echo "[ASM] : missing dependencies, $i is not installed." >&2
    fi
done


if [[ $1 == "" ]]
# check input exists
then
    echo "[ASM] : no input found, please supply an assembly file ended in .asm.txt" >&2
    exit 1
fi


if [[ ${1: -8} != ".asm.txt" ]]
# check file extension
then
    echo "[ASM] : invalid file extension, please supply an assembly file ended in .asm.txt" >&2
    exit 1
fi

echo "[ASM] : 📨 receved assembly file $1" >&2


filename=$(basename $1 .asm.txt) # get filename from fullname


mipsel-linux-gnu-as -mips1 $1 -o $filename.o
mipsel-linux-gnu-objdump -d -j .text $filename.o            \
    | grep -oP '\s*[0-9a-fA-F]*\:\s*\K([0-9a-fA-F]{8})\s*'  \
    >&1


if [[ $? -eq 0  ]]
then
    echo "[ASM] : ✅ $1 is assembled and the hex result is sent to stdout" >&2
fi

rm $filename.o
