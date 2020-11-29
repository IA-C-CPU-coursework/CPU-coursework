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
int hex2Dec(string s)
{   
    stringstream ss;
    int num;
    ss <<s;
    ss >> hex >> num;
    return num;
}
int getReg(string s)
{
    if(s[1]=='z'){
        return 0;
    }
    else if(s[1]=='a'){
        return 1;}
    else if(s[1]=='v'){
        return 2+s[2] - '0';}
    else if(s[1]=='a'){
        return 4+s[2] - '0';}
    else if(s[1]=='t'){
        int num = s[2] - '0';
        if(num<8){return 8+s[2] - '0';}
        return 16+s[2] - '0';
        }
    else if(s.substr(2,4)=="sp"){
        return 29;}
    else if(s[1]=='s'){
        return 16+s[2] - '0';}
    else if(s[1]=='k'){
        return 26+s[2] - '0';}
    else if(s[1]=='g'){
        return 28;}
    else if(s[1]=='f'){
        return 30;}
    else{
        return 31;}
    


}
map<string,string> findLabel(vector<string> &strings)
{
    stringstream ss;
    map<string,string> labels;
    for(int i =0;i<strings.size();i++)
    {
        int pos = strings[i].find(":");
        if (pos != std::string::npos) {
        string label = strings[i].substr(0,pos);
        //ss << setfill('0') << setw(8) << hex << i << endl; //hex version
        ss << bitset<26>(i).to_string();
        labels[label] =  ss.str();
        ss.str("");
        cerr << "label :" << label << " line :" << i<< " newstring is " << strings[i].substr(pos+1,string::npos) <<endl;
        strings[i] = strings[i].substr(pos+1,string::npos);
        }
    }
    return labels;
}
string procLine(string line, map<string,pair<int, int>> &instr,map<string,string> labels)
{
    string out = "";
    vector<string> parts;
    string x;
    stringstream s(line);
    cerr << "runnign procline on " << line << endl;
    while(getline(s, x, ',')) {
        parts.push_back(x);
    }
    cerr << "op is " << instr[parts[0]].first<< endl;
    if(instr[parts[0]].first == 0)// R Type Instr
    {
        cerr << "Starting R type" << endl;
        if(instr[parts[0]].second == 8) //JR 
        {
            out = out + "000000"
            +bitset<5>(getReg(parts[1])).to_string()
            +bitset<15>(0).to_string()
            +bitset<6>(instr[parts[0]].second).to_string();

            bitset<32> set(out);
            cout << setfill('0') << setw(8) << hex << set.to_ulong() << endl ;
        }
        else
        {
            out = out + "000000"
            +bitset<6>(instr[parts[0]].first).to_string()
            +bitset<5>(getReg(parts[2])).to_string()
            +bitset<5>(getReg(parts[3])).to_string()
            +bitset<5>(getReg(parts[1])).to_string()
            +bitset<5>(0).to_string()
            +bitset<5>(instr[parts[0]].second).to_string();
            bitset<32> set(out);
            cout << setfill('0') << setw(8) << hex << set.to_ulong() << endl ;
            cerr << parts[0] << ":" << getReg(parts[1]) << ":" <<getReg(parts[2]) <<":" << getReg(parts[3]) << ":" << instr[parts[0]].second << endl;
        }
    }
    else if(instr[parts[0]].first<=3)// J Type Instr
    {   //                  OP                                      ADDRESS
        cerr << "Starting" << endl;
        if (labels.find(parts[1]) == labels.end() ) {
            
            out = out + bitset<6>(instr[parts[0]].first).to_string()+bitset<26>(parts[1]).to_string();
            bitset<32> set(out);
            cout << setfill('0') << setw(8) << hex << set.to_ulong() << endl ;
     } else {
            cerr << "found lablel at " << labels[parts[1]] << endl;
            out = out + bitset<6>(instr[parts[0]].first).to_string()+labels[parts[1]];
            bitset<32> set(out);
            cout << setfill('0') << setw(8) << hex << set.to_ulong() << endl ;
            }
    
    }
    else
    // I type instr
    {
        cerr << "Starting I type" << endl;
        if(instr[parts[0]].first == 15) // lui
        {                     //OPCODE                                      //SET ZEROES                            //DEST                                  IMMEDIATE
            out = out + bitset<6>(instr[parts[0]].first).to_string()+bitset<5>(0).to_string()+bitset<5>(getReg(parts[1])).to_string()+bitset<16>(hex2Dec(parts[2])).to_string();
            bitset<32> set(out);
            cerr << parts[0] << ":" <<getReg(parts[1]) << ":" << parts[2]<< endl;
            cout << setfill('0') << setw(8) << hex << set.to_ulong() << endl;
        }
        else{
                            // OPCODE                                            SOURCE                          DEST                            IMMEDIATE
            out = out + bitset<6>(instr[parts[0]].first).to_string()+bitset<5>(getReg(parts[2])).to_string()+bitset<5>(getReg(parts[1])).to_string()+bitset<16>(hex2Dec(parts[3])).to_string();
            bitset<32> set(out);
            cerr << set.to_string() << endl;
            cout << setfill('0') << setw(8) << hex << set.to_ulong() << endl;
        }
    }
  
}
int main(){
    map<string,pair<int, int>> instr;
    
    instr["addu"] = make_pair(0, 33);  // R
    instr["addiu"] = make_pair(9, 0);  // I 
    instr["and"] = make_pair(0, 36);   // R
    instr["andi"] = make_pair(2, 0);   // I
    instr["beq"] = make_pair(2, 0);
    instr["bgez"] = make_pair(2, 0);
    instr["bgezal"] = make_pair(2, 0);
    instr["bgtz"] = make_pair(2, 0);
    instr["BLEZ"] = make_pair(2, 0);
    instr["BLTZ"] = make_pair(2, 0);
    instr["BLTZAL"] = make_pair(2, 0);
    instr["BNE"] = make_pair(2, 0);

    instr["jr"] = make_pair(0, 8);
    instr["lw"] = make_pair(35, 0);
    instr["j"] = make_pair(2, 0);
    instr["lui"] = make_pair(15, 0); // I
    string x;
    vector<string> strings;
    while(getline(cin, x))
        {
            strings.push_back(x);
        }
    map<string,string> labels = findLabel(strings);
    for(int i = 0; i <strings.size();i++)
    {
        procLine(strings[i], instr,labels);
    }

}