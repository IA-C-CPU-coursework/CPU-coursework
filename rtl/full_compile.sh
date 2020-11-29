#!/bin/bash
iverilog -Wall -g 2012 -s mips_cpu_bus -o mips_cpu_bus  mips_cpu_bus.v mips_control_unit.v mips_reg_file.v mips_alu.v mips_sign_extension.v