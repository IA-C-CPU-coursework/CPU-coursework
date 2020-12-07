#ifndef mu0_hpp
#define mu0_hpp

#include<iostream>
#include<string>
#include<vector>
using namespace std;

//take a line of instruction as the parameter, return the number of seperate strings in
// in one line
int string_number(string instruction);

//convert data to fixed width of hex 
string to_hex32(uint32_t a);

//seperate field in instructions:
vector<string> extract(string a);

uint32_t convert_to_hex(string a);

// sign extension for immediate values:
uint32_t sign_extension(uint32_t a);

uint32_t zero_extension(uint32_t a);
//sign extension for multiplication:


#endif