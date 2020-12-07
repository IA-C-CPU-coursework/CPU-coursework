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
#include "ALU.hpp"
using namespace std;

class Simulate{
    private:
    map<string,uint32_t> register_file;
    uint32_t pc;
    map<uint32_t,string> instructions;
    map<uint32_t,string> binaries;
    uint32_t address;
    uint32_t readdata;
    uint32_t writedata;
    uint32_t register_v0;
    public:
    //execution for instruction 2,3, or 4 strings 
    Simulate(map<uint32_t,string> in_instructions,map<uint32_t,string> in_binaries){
        instructions = in_instructions;
        binaries = in_binaries;
        //initialize program counter:
        pc = 0xbcf00000;
    }

    void execution();
    
    //inialtize the data in all registers as zero;
    void initialise_register();

    void print_v0();
};