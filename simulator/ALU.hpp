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
using namespace std;

class ALU{
private:
    uint32_t hi;
    uint32_t lo;
    int branch;

public:
    uint32_t addiu(uint32_t a,uint32_t b);

    uint32_t addu(uint32_t a,uint32_t b);

    uint32_t logic_and(uint32_t a,uint32_t b);

    uint32_t subu(uint32_t a,uint32_t b);

    uint32_t andi(uint32_t a,uint32_t b);

    uint32_t logic_or(uint32_t a,uint32_t b);

    uint32_t ori(uint32_t a,uint32_t b);

    uint32_t logic_xor(uint32_t a,uint32_t b);

    uint32_t xori(uint32_t a,uint32_t b);
// shifts
    uint32_t sll(uint32_t a, int b);

    uint32_t sra(uint32_t a, int b);

    uint32_t srl(uint32_t a, int b);

    uint32_t sllv(uint32_t a, uint32_t b);

    uint32_t srav(uint32_t a, uint32_t b);

    uint32_t srlv(uint32_t a, uint32_t b);

// multiplication and division
    void mul(uint32_t a,uint32_t b);

    void mulu(uint32_t a, uint32_t b);

    void div(uint32_t a, uint32_t b);

    void divu(uint32_t a, uint32_t b);

    void mthi(uint32_t a);

    void mtlo(uint32_t a);

    uint32_t mfhi(uint32_t a);

    uint32_t mflo(uint32_t a);

    // add more function for branch purpose
};