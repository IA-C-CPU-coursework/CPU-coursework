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
    int n = string_number(instructions[pc]);
    //cout << n << endl;
    while(pc!=0x00000000){
        cout << "location read: " << hex << pc << " data: " << binaries[pc] << endl;
        int n = string_number(instructions[pc]);
        if(n==4){
            vector<string> current = extract(instructions[pc]);
            string instr = current[0];
            string rd = current[1];
            string rs = current[2];
            string rt_im = current[3];
            if(current[0] == "addu"){
                register_file[rd] = register_file[rs] + register_file[rt_im];
            }
            else if(current[0] == "addiu"){
                register_file[rd] = register_file[rs] + convert_to_hex(rt_im);
                pc = pc + 0x4;
            }
            else if(current[0] == "and"){
                
            }            
            else if(current[0] == "andi"){
                
            }           
            else if(current[0] == "or"){
                
            }
            else if(current[0] == "ori"){
                
            }           
            else if(current[0] == "slt"){
                
            }
            else if(current[0] == "slti"){
                
            }            
            else if(current[0] == "sltiu"){
                
            }            
            else if(current[0] == "sltu"){
                
            }            
            else if(current[0] == "subu"){
                
            }           
            else if(current[0] == "xor"){
                
            }
            else if(current[0] == "xori"){
                
            }
            else if(current[0] == "sll"){
                
            }
            else if(current[0] == "sllv"){
                
            }            
            else if(current[0] == "sra"){
                
            }            
            else if(current[0] == "srav"){
                
            }
            else if(current[0] == "srl"){
                
            }
            else if(current[0] == "srlv"){
                
            }
            // to be continued

        }
        else if(n==3){
            vector<string> current = extract(instructions[pc]);
            if(current[0] == "div"){

            }
            else if(current[0] == "divu"){

            }
            else if(current[0] == "mult"){
                
            }            
            else if(current[0] == "multu"){
                
            }
        }
        else if(n==2){
            vector<string> current = extract(instructions[pc]);
            if(current[0] == "mfhi"){

            }
            else if(current[0] == "mflo"){

            }
            else if(current[0] == "jr"){
                pc = register_file["$zero"];
            }
        }
    }
    //when exist the while loop: pc should be equal to 0x00000000
    //print the final value store in the $v0 register:
    cout << "the final value  register_v0 : " << register_v0 << endl;
}