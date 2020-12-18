#-------------------------------------------------------------------------------
# This script extracts key information from `readme.md` inside each instruction 
# directory and generates test cases.
# 
# test case template:

# ```assembly       | <= start of test case
# # addiu-2         | // optional comment 
# # 1=0+1           | 
# addiu $t0,$t0,0x1 | <= assembly instructions
# addiu $v0,$t0,0x0 | 
# jr $ra            | 
#                   | // optional empty line    
#                   |
# # v0 ref          | <= start of v0 reference  
# 00000001          | <= v0 reference           
# ========          | <= end                    
#                   |
# # data init       | <= start of data init
# 01010100          | <= data init 
# 00101010          | <= data init 
# ========          | <= end                   
#                   |
# # data ref        | <= start of data reference  
# 01010100          | <= data reference           
# 00101010          | <= data reference                     
# ========          | <= end
#                   |
# ```               | <= end of test case

#-------------------------------------------------------------------------------

import re
import sys
import os

err = sys.stderr

arguments = len(sys.argv) - 1
if (arguments < 1):
    print("please supply a path to readme.md")
    exit(1)

f = open(sys.argv[1], "r")
print(sys.argv[1])
readme = f.read()

instruction_name_re = r"\#\sTest\sbench\sfor\s\`(\w+)\`"
testcase_re         = r"^```assembly\n.+?```$"
instruciton_re      = r"^(\s*\w+\s*\:\s*){0,1}\w+\s*(\$[a-z0-9]{2,4}).*?\n|(nop)\n|^\s*[a-z0-9]+\s*\:\s*\n|^(?![a-fx]+)([a-z]+)(\s+\w+\n)"
v0_ref_re           = r"\#\sv0\sref\s*\n([0-9a-fx]{8})\s*\n[\=]{8}\s*"
data_ref_re         = r"\#\sdata\sref\s*\n((([0-9a-fx]{8})\s*\n)+)[\=]{8}\s*"
data_init_re        = r"\#\sdata\sinit\s*\n((([0-9a-fx]{8})\s*\n)+)[\=]{8}\s*"


ROOT_DIR = os.getcwd()

instruction_name = re.match(instruction_name_re, readme).group(1)
instruction_path = ROOT_DIR+"/test/testcases/"+instruction_name
print("Generating test cases for",instruction_name)
print("in",instruction_path)

testcases = [ x.group() for x in re.finditer(testcase_re, readme, re.S | re.M)]
index = 1

for testcase in testcases:
    testcase_name = instruction_name+"-"+str(index)
    testcase_path = instruction_path+"/"+testcase_name
    if not os.path.isdir(testcase_path):
        os.makedirs(testcase_path)
    print("\n===== {testcase_name} =====".format(testcase_name=testcase_name))

    print("File: "+testcase_name+".S")
    instructions =  ".set noreorder\n" + "\n".join(list(map(lambda x:x.strip(),
        [ x.group() for x in re.finditer(instruciton_re, testcase, re.S | re.M)]
    )))
    print(instructions)
    instruction_file = open(testcase_path + "/" + testcase_name + ".S", "w+")
    instruction_file.write(instructions)
    instruction_file.close()


    print("File: " + testcase_name + "_v0.ref")
    v0_ref_hex = "00000000"
    v0_ref = re.search(v0_ref_re, testcase, re.M)
    if v0_ref:
        v0_ref_hex = v0_ref.group(1).rstrip()
    else:
        err.write("WARNING {testcase_name}_v0.ref is not specified\n".format(testcase_name=testcase_name))
    print(v0_ref_hex)
    v0_ref_file = open(testcase_path + "/" + testcase_name +"_v0.ref", "w+")
    v0_ref_file.write(str(v0_ref_hex))
    v0_ref_file.close()


    print("File: " + testcase_name + "_data.init")
    data_init_hex = "00000000\n"*4
    data_init = re.search(data_init_re, testcase, re.M)
    if data_init:
        data_init_hex = data_init.group(1).rstrip()+"\n"
    else:
        err.write("WARNING {testcase_name}_data.init is not specified\n".format(testcase_name=testcase_name))
    print(data_init_hex)
    data_init_file = open(testcase_path + "/" + testcase_name + "_data.init", "w+")
    data_init_file.write(str(data_init_hex))
    data_init_file.close()


    print("File: " + testcase_name + "_data.ref")
    data_ref_hex = "00000000\n"*4
    data_ref = re.search(data_ref_re, testcase, re.M)
    if data_ref:
        data_ref_hex = data_ref.group(1).rstrip()+"\n"
    else:
        err.write("WARNING {testcase_name}_data.ref is not specified\n".format(testcase_name=testcase_name))
    print(data_ref_hex)
    data_ref_file = open(testcase_path + "/" + testcase_name + "_data.ref", "w+")
    data_ref_file.write(str(data_ref_hex))
    data_ref_file.close()

    index+=1
