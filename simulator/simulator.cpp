#include<iostream>
#include<string>
#include<fstream>
#include<map>
#include<iterator>
#include<algorithm>
using namespace std;

int main(){
    // first step is to read data from asm files:
    //----------------------------setup and read files--------------------------------------
    uint32_t address = 0xbfc00000; // initialise the starting point of address
    map<uint32_t,string> asm_ram; // instruction in pure format
    map<uint32_t,string> hex_ram; // instruction in binaries
    ifstream ram_file_asm;
    ram_file_asm.open("01_addiu1_instr.txt");
    string instruction_line;
    while(getline(ram_file_asm,instruction_line)){
        asm_ram[address] = instruction_line;
        address = address + 0x4;
    }
    cout << "read the instructions :  " << endl; 
    for(auto it = asm_ram.begin(); it != asm_ram.end(); it++){
        cout << hex << it->first << " " << it->second << endl;
    }
    // read hex ----------------
    address = 0xbfc00000; // read binaries from very begining:
    ifstream ram_file_hex;
    ram_file_hex.open("01_addiu.txt");
    string instruction_binary;
    while(getline(ram_file_hex,instruction_binary)){
        hex_ram[address] = instruction_binary;
        address = address + 0x4;
    }
    cout << "read instructions in binary: " << endl;
      for(auto it = hex_ram.begin(); it != hex_ram.end(); it++){
        cout << hex << it->first << " " << it->second << endl;
    }
    ram_file_hex.close();
    //---------------------finish reading the data from ram --------------------

    //create register files:
    map<string,uint32_t> register_file;
    // initialize registers:
    
}