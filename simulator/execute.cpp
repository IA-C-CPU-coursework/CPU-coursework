#include<iostream>
#include<string>
#include<fstream>
#include<map>
#include<iterator>
#include<algorithm>
#include <utility>
#include <cassert>
#include <iomanip> 
#include "helper.hpp"
#include "simulator.hpp"
using namespace std;

int main(int argc,char* argv[]){
    // pass the name of the files in command line
    // first step is to read data from asm files:
    //----------------------------setup and read files--------------------------------------
    uint32_t address = 0xbfc00000; // initialise the starting point of address
    map<uint32_t,string> asm_ram; // instruction in pure format
    map<uint32_t,string> hex_ram; // instruction in binaries
    string file1 = argv[1];
    ifstream ram_file_asm;
    ram_file_asm.open(file1);
    string instruction_line;
    while(getline(ram_file_asm,instruction_line)){
        asm_ram[address] = instruction_line;
        address = address + 0x4;
    }
    cout << "read the instructions :  " << endl; 
    /*for(auto it = asm_ram.begin(); it != asm_ram.end(); it++){
        cout << hex << it->first << " " << it->second << endl;
    }*/
    // read hex ----------------
    address = 0xbfc00000; // read binaries from very begining:
    ifstream ram_file_hex;
    string file2;
    file2 = argv[2];
    ram_file_hex.open(file2);
    string instruction_binary;
    while(getline(ram_file_hex,instruction_binary)){
        hex_ram[address] = instruction_binary;
        address = address + 0x4;
    }
    cout << "read instructions in binary: " << endl;
     /* for(auto it = hex_ram.begin(); it != hex_ram.end(); it++){
        cout << hex << it->first << " " << it->second << endl;
    }*/
    ram_file_hex.close();
    //---------------------finish reading the data from ram --------------------

    //create register files:
    map<string,uint32_t> register_file;
    // initialize registers:
    uint32_t pc = 0xbfc00000; // initialize program counter;
    cout << setw(8);
    cout << hex;
    cout << setfill('0');
    string current_address;
    string readdata;
    string writedata;

    // ---------------- execution:
    //cout << a << " ss " << b << endl; 

    //cout << aa << " ss  " << bb << endl;
    //cout << c << endl;
    uint32_t a = 0xfffc1222;
    uint32_t b = 0x88221fff;

    ALU *calculator = new ALU();
    calculator->div(a,b);
    calculator->divu(a,b);
}