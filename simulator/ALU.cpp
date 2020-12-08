#include "ALU.hpp"
#include "helper.hpp"

uint32_t ALU::addiu(uint32_t a,uint32_t b){
    uint32_t result = a + sign_extension(b);
    return sign_extension(result);
}

uint32_t ALU::addu(uint32_t a,uint32_t b){
    uint32_t result = a + b;
    return sign_extension(result);
}

uint32_t ALU::subu(uint32_t a,uint32_t b){
    uint32_t result = a - b;
    return sign_extension(result);
}

uint32_t ALU::logic_and(uint32_t a,uint32_t b){
    uint32_t result = a & b;
    return zero_extension(result);
}

uint32_t ALU::andi(uint32_t a,uint32_t b){
    uint32_t result = a & zero_extension(b);
    return zero_extension(result);
}

uint32_t ALU::logic_or(uint32_t a,uint32_t b){
    uint32_t result = a | b;
    return zero_extension(result);
}

uint32_t ALU::ori(uint32_t a,uint32_t b){
    uint32_t result = a | zero_extension(b);
    return zero_extension(result);
}

uint32_t ALU::logic_xor(uint32_t a,uint32_t b){
    uint32_t result = a ^ b;
    return zero_extension(result);
}

uint32_t ALU::xori(uint32_t a,uint32_t b){
    uint32_t result = a ^ zero_extension(b);
    return zero_extension(result);
}

uint32_t ALU::sll(uint32_t a, int b){
    return a<<b;
}

int32_t ALU::sra(int32_t a, int b){
    int32_t result = a>>b;
    return result;
}

uint32_t ALU::srl(uint32_t a, int b){
    return a>>b;
}

uint32_t ALU::sllv(uint32_t a, uint32_t b){
    return a<<b;
}

int32_t ALU::srav(int32_t a, uint32_t b){
    int32_t result = a>>b;
    return result;
}

uint32_t ALU::srlv(uint32_t a, uint32_t b){
    return a>>b;
}

void ALU::mul(int32_t a,int32_t b){
    int64_t result = (int64_t)a*b;
    string temp = to_hex64(result);
    string hi_s = "0x" + temp.substr(0,8);
    string lo_s = "0x" + temp.substr(8,15);
    stringstream read;
    read << hex << hi_s;
    read >> hi;
    stringstream read_lo;
    read_lo << hex << lo_s;
    read_lo >> lo;
}

void ALU::mulu(uint32_t a, uint32_t b){
    int64_t result = (int64_t)a*b;
    string temp = to_hex64(result);
    string hi_s = "0x" + temp.substr(0,8);
    string lo_s = "0x" + temp.substr(8,15);
    stringstream read;
    read << hex << hi_s;
    read >> hi;
    stringstream read_lo;
    read_lo << hex << lo_s;
    read_lo >> lo;
}

void ALU::div(int32_t a, int32_t b){
    int32_t quotient = a/b;
    int32_t remainder = a%b;
    hi = remainder;
    lo = quotient;
}

void ALU::divu(uint32_t a, uint32_t b){
    int32_t quotient = a/b;
    int32_t remainder = a%b;
    hi = remainder;
    lo = quotient;
}

void ALU::mthi(uint32_t a){
     hi = a;
}

void ALU::mtlo(uint32_t a){
    lo = a;
}

uint32_t mfhi(uint32_t a){
    return hi;
}

uint32_t mflo(uint32_t a){
    return lo;
}




