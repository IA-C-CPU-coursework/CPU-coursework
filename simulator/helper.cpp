#include"helper.hpp"
using namespace std;
#include<string>
#include<iostream>
#include<string>
#include<fstream>
#include<map>
#include<iterator>
#include<algorithm>
#include <utility>
#include <cassert>
#include <iomanip> 

using namespace std;
//using lower cases, to be consistent with format in tb module;
string to_hex32(uint32_t a){
    char temp[16]={'0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'};
    string result;
    result.push_back(temp[(a>>28)&0xF]);
    result.push_back(temp[(a>>24)&0xF]);
    result.push_back(temp[(a>>20)&0xF]);
    result.push_back(temp[(a>>16)&0xF]);
    result.push_back(temp[(a>>12)&0xF]);
    result.push_back(temp[(a>>8)&0xF]);
    result.push_back(temp[(a>>4)&0xF]);
    result.push_back(temp[(a>>0)&0xF]);
    return result;
}

string to_hex64(uint64_t a){
    char temp[16]={'0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'};
    string result;
    result.push_back(temp[(a>>60)&0xF]);
    result.push_back(temp[(a>>56)&0xF]);
    result.push_back(temp[(a>>52)&0xF]);
    result.push_back(temp[(a>>48)&0xF]);
    result.push_back(temp[(a>>44)&0xF]);
    result.push_back(temp[(a>>40)&0xF]);
    result.push_back(temp[(a>>36)&0xF]);
    result.push_back(temp[(a>>32)&0xF]);
    result.push_back(temp[(a>>28)&0xF]);
    result.push_back(temp[(a>>24)&0xF]);
    result.push_back(temp[(a>>20)&0xF]);
    result.push_back(temp[(a>>16)&0xF]);
    result.push_back(temp[(a>>12)&0xF]);
    result.push_back(temp[(a>>8)&0xF]);
    result.push_back(temp[(a>>4)&0xF]);
    result.push_back(temp[(a>>0)&0xF]);
    return result;
}

uint32_t sign_extension(uint32_t a){
    uint32_t mask = 0x00008000;
    if(mask & a){
        return (a+0xffff0000);
    }
    else{
        return (a+0x00000000);
    }
       
}

uint32_t zero_extension(uint32_t a){
    return (a+0x00000000);
}

int string_number(string instruction){
    int result;
    result = count(instruction.begin(),instruction.end(),',');
    if(result == 2){
        return 4;
    }
    else if(result == 2){
        return 3;
    }
    else if(result == 0){
        return 2;
    }
    return 0;
}

vector<string> extract(string a){
    vector<string> result;
    string temp = "";
    for(int i= 0; i < a.size();i++){
        if(a[i]!= ',' && a[i]!= ' '){
           temp.push_back(a[i]);
        }
        else{
            result.push_back(temp);
            temp = "";
        }
        if(i == a.size()-1){
            result.push_back(temp);
        }
    }
    return result;
}

uint32_t convert_to_hex(string a){
    uint32_t result;
    if(a[0] == '0' && a[1] == 'x'){
        stringstream read;
        read << hex << a;
        read >> result;
    }
    else{
        result = stoi(a);
    }
    return result;
}

