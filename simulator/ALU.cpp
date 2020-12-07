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

uint32_t ALU::sra(uint32_t a, int b){
    
}

uint32_t ALU::srl(uint32_t a, int b){
    return a>>b;
}

uint32_t ALU::sllv(uint32_t a, uint32_t b){

}

uint32_t ALU::srav(uint32_t a, uint32_t b){

}

uint32_t ALU::srlv(uint32_t a, uint32_t b){

}




