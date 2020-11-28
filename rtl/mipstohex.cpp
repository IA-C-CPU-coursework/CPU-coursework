#include <iostream>
#include <string>
#include <vector>
#include <sstream>
#include <map>
#include <bitset>
#include <iomanip>

using namespace std;
int getNum(string s)
{
    string num = "";
    for(int i =0; i<s.size();i++)
    {
        if(isdigit(s[i]))
        {num = num + s[i];}
    }
    return stoi(num);
}
string procLine(string line, map<string,pair<int, int>> &instr)
{
    string out = "";
    vector<string> parts;
    string x;
    stringstream s(line);
    while(s >> x){
        parts.push_back(x);
    }
    if(instr[parts[0]].first == 0)
    // R Type Instr
    {
        if(instr[parts[0]].second == 8)
        {
            out = out + "000000"
            +bitset<5>(getNum(parts[1])).to_string()
            +bitset<15>(0).to_string()
            +bitset<6>(instr[parts[0]].second).to_string();

            bitset<32> set(out);
            cout << setfill('0') << setw(8) << hex << set.to_ulong() << endl ;
        }
        else if(instr[parts[0]].second == 8)
        {
            out = out + "000000"
            +bitset<6>(instr[parts[0]].first).to_string()
            +bitset<5>(getNum(parts[2])).to_string()
            +bitset<5>(getNum(parts[1])).to_string()
            +bitset<16>(getNum(parts[3])).to_string();
            bitset<32> set(out);
            cout << setfill('0') << setw(8) << hex << set.to_ulong() << endl ;
        }
    }
    else if(instr[parts[0]].first<=3)
    // J Type Instr
    {
        out = out + bitset<6>(instr[parts[0]].first).to_string()+bitset<26>(parts[1]).to_string();
        bitset<32> set(out);
        cout << setfill('0') << setw(8) << hex << set.to_ulong() << endl ;
    }
    else
    // I type instr
    {                  // OPCODE                            SOURCE                          DEST                        IMMEDIATE
        out = out + bitset<6>(instr[parts[0]].first).to_string()+bitset<5>(getNum(parts[2])).to_string()+bitset<5>(getNum(parts[1])).to_string()+bitset<16>(getNum(parts[3])).to_string();
        bitset<32> set(out);
        cout << setfill('0') << setw(8) << hex << set.to_ulong() << endl;
    }
  
}
int main(){
    map<string,pair<int, int>> instr;
    
    instr["ADDU"] = make_pair(33, 0);  // R
    instr["ADDIU"] = make_pair(9, 0); // I 
    instr["AND"] = make_pair(2, 0);
    instr["ANDI"] = make_pair(2, 0);
    instr["BEQ"] = make_pair(2, 0);
    instr["BGEZ"] = make_pair(2, 0);
    instr["BGEZAL"] = make_pair(2, 0);
    instr["BGTZ"] = make_pair(2, 0);
    instr["BLEZ"] = make_pair(2, 0);
    instr["BLTZ"] = make_pair(2, 0);
    instr["BLTZAL"] = make_pair(2, 0);
    instr["BNE"] = make_pair(2, 0);

    instr["JR"] = make_pair(0, 8);
    instr["LW"] = make_pair(35, 0);
    instr["J"] = make_pair(2, 0);
    string x;
    vector<string> strings;
    while(getline(cin, x))
        {
            strings.push_back(x);
        }
    for(string line : strings)
    {
        procLine(line, instr);
    }

}