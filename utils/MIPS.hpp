#ifndef MIPS_hpp
#define MIPS_hpp

#include <cstdint>
#include <string>
#include <vector>
#include <fstream>
using namespace std;

vector<uint32_t> mips_read_binary(istream &src);

int32_t mips_simulate(uint32_t,*memory);

bool mips_is_label_decl(const string &s);

bool mips_is_data(const string &s);

uint32_t mips_is_instruction(const string&value);

bool mips_is_instruction(const string&value);

bool mips_instrction_has_operand(const string &value);

string mips_opcode_to_opnama(uint32_t opcode);

bool mips_is_instruction(uint32_t value);

bool mips_instruction_has_opperand(uint32_t opcode);

#endif
