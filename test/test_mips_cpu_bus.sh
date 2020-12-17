#!/bin/bash

dir="./"
root=`cd $dir && pwd`

"${root}/test/test_mips_cpu_bus_real.sh" ${@} 2>test.log
