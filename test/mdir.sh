#!/bin/bash

mkdir test/testcases/$1
mkdir test/testcases/$1/$1-1
cat test/testcases/addiu/addiu-1/addiu-1_data.init > test/testcases/$1/$1-1/$1-1_data.init
cat test/testcases/addiu/addiu-1/addiu-1_data.ref > test/testcases/$1/$1-1/$1-1_data.ref
cat test/testcases/addiu/addiu-1/addiu-1_v0.ref > test/testcases/$1/$1-1/$1-1_v0.ref
cat test/testcases/addiu/addiu-1/addiu-1.S> test/testcases/$1/$1-1/$1-1.S

mkdir test/testcases/$1/$1-2
cat test/testcases/addiu/addiu-1/addiu-1_data.init > test/testcases/$1/$1-2/$1-2_data.init
cat test/testcases/addiu/addiu-1/addiu-1_data.ref > test/testcases/$1/$1-2/$1-2_data.ref
cat test/testcases/addiu/addiu-1/addiu-1_v0.ref > test/testcases/$1/$1-2/$1-2_v0.ref
cat test/testcases/addiu/addiu-1/addiu-1.S> test/testcases/$1/$1-2/$1-2.S
