#include "simulator.hpp"
using namespace std;


void Simulate::initialise_register(){
    register_file["$zero"] = 0x0; register_file["$at"] = 0x0;
    register_file["$v0"] = 0x0;   register_file["$v1"] = 0x0;
    register_file["$a0"] = 0x0;   register_file["$a1"] = 0x0;
    register_file["$a2"] = 0x0;   register_file["$a3"] = 0x0;
    register_file["$t0"] = 0x0;   register_file["$t1"] = 0x0;
    register_file["$t2"] = 0x0;   register_file["$t3"] = 0x0;
    register_file["$t4"] = 0x0;   register_file["$t5"] = 0x0;
    register_file["$t6"] = 0x0;   register_file["$t7"] = 0x0;
    register_file["$s0"] = 0x0;   register_file["$s1"] = 0x0;
    register_file["$s2"] = 0x0;   register_file["$s3"] = 0x0;
    register_file["$s4"] = 0x0;   register_file["$s5"] = 0x0;
    register_file["$s6"] = 0x0;   register_file["$s7"] = 0x0;
    register_file["$t8"] = 0x0;   register_file["$t9"] = 0x0;
    register_file["$k0"] = 0x0;   register_file["$k1"] = 0x0;
    register_file["$gp"] = 0x0;   register_file["$sp"] = 0x0;
    register_file["$fp"] = 0x0;   register_file["$ra"] = 0x0;

}

void Simulate::execution(){
    //initialise program counter at the beginning:
    while(pc!=0x00000000){
        
    }
    //when exist the while loop: pc should be equal to 0x00000000
    //print the final value store in the $v0 register:
}