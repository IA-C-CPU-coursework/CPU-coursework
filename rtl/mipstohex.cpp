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
    else if(s[2]=='p'){
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
    cerr << "op is " << instr[parts[0]].first<<" op2 is " << instr[parts[1]].second <<endl;
    if(instr[parts[0]].first == 0)// R Type Instr
    {
        int op2 = instr[parts[0]].second;
        cerr << "Starting R type" << endl;

        if(op2 == 8) //JR 
        {
            out = out + "000000"
            +bitset<5>(getReg(parts[1])).to_string()
            +bitset<15>(0).to_string()
            +bitset<6>(op2).to_string();

            
        }
        else if(op2 == 16 || op2 == 18) //MTHI MTLO 
        {
            out = out + bitset<16>(0).to_string()
            +bitset<5>(getReg(parts[1])).to_string()
            +bitset<5>(0).to_string()
            +bitset<6>(op2).to_string();    
        }
        else if((op2 <=27)||(op2 >= 24)) //DIV DIVU MULT MULTU
        {
             out = out + "000000" //OP
            +bitset<5>(getReg(parts[1])).to_string()  //source
            +bitset<5>(getReg(parts[2])).to_string()  //R2
            +bitset<10>(0).to_string()
            +bitset<6>(op2).to_string();
             

            cerr << parts[0] << ":" << getReg(parts[1]) << ":" <<getReg(parts[2]) <<":" << getReg(parts[3]) << ":" << instr[parts[0]].second << endl;
        }

        else if((op2 == 0)||(op2 == 2)) 
        {
            cerr << "sll";
            out = out + bitset<11>(0).to_string()  //OP
            +bitset<5>(getReg(parts[2])).to_string()  //source
            +bitset<5>(getReg(parts[1])).to_string()  //R2
            +bitset<5>(hex2Dec(parts[3])).to_string()
            +bitset<6>(op2).to_string();
             
            cerr << parts[0] << ":" << getReg(parts[1]) << ":" <<getReg(parts[2]) <<":" << getReg(parts[3]) << ":" << instr[parts[0]].second << endl;
        }
        
        else if((op2 == 4)||(op2==7)||(op2=6))// SRAV SLLV SRLV
        {   
            out = out + "000000" //OP
            +bitset<5>(getReg(parts[3])).to_string()  //R2
            +bitset<5>(getReg(parts[2])).to_string()  //source
            +bitset<5>(getReg(parts[1])).to_string()  //DEST
            +bitset<5>(0).to_string()     // shift
            +bitset<6>(op2).to_string();
             
            cerr << parts[0] << ":" << getReg(parts[1]) << ":" <<getReg(parts[2]) <<":" << getReg(parts[3]) << ":" << instr[parts[0]].second << endl;
        }
        else
        
        {   
            out = out + "000000" //OP
            +bitset<5>(getReg(parts[2])).to_string()  //source
            +bitset<5>(getReg(parts[3])).to_string()  //R2
            +bitset<5>(getReg(parts[1])).to_string()  //DEST
            +bitset<5>(0).to_string()     // shift
            +bitset<6>(op2).to_string();
             
            cerr << parts[0] << ":" << getReg(parts[1]) << ":" <<getReg(parts[2]) <<":" << getReg(parts[3]) << ":" << instr[parts[0]].second << endl;
        }
    }
    else if(instr[parts[0]].first<=3&&instr[parts[0]].first!=1)// J Type Instr
    {   //                  OP                                      ADDRESS
        cerr << "Starting" << endl;
        if (labels.find(parts[1]) == labels.end() ) {
            
            out = out + bitset<6>(instr[parts[0]].first).to_string()+bitset<26>(parts[1]).to_string();
             
     } else {
            cerr << "found lablel at " << labels[parts[1]] << endl;
            out = out + bitset<6>(instr[parts[0]].first).to_string()+labels[parts[1]];

            }
    
    }
    else
    // I type instr
    {
        int op = instr[parts[0]].first;
        cerr << "Starting I type" << endl;
        if(op == 15) // lui
        {                     //OPCODE                                      //SET ZEROES                            //DEST                                  IMMEDIATE
            out = out + bitset<6>(op).to_string()+bitset<5>(0).to_string()+bitset<5>(getReg(parts[1])).to_string()+bitset<16>(hex2Dec(parts[2])).to_string();
             
            cerr << parts[0] << ":" <<getReg(parts[1]) << ":" << parts[2]<< endl;
        }
        else if((op == 4)||(op == 5)){ // beq and bne
                            // OPCODE                                            SOURCE                          DEST                            OFFSET
            out = out + bitset<6>(op).to_string()+bitset<5>(getReg(parts[1])).to_string()+bitset<5>(getReg(parts[2])).to_string()+bitset<16>(hex2Dec(parts[3])).to_string();
                          
        }
        else if((op == 1)&&(instr[parts[0]].second =! 3)) // BGEZ and BGEZAL BLTZ BLTZAL
        {                     //OPCODE                                      //SOURCE                                 //SET 1  either or zero                            IMMEDIATE
            out = out + bitset<6>(op).to_string()+bitset<5>(getReg(parts[1])).to_string()+bitset<5>(instr[parts[0]].second ).to_string()+bitset<16>(hex2Dec(parts[2])).to_string();
             
            cerr << parts[0] << ":" <<getReg(parts[1]) << ":" << parts[2]<< endl;
             
        }
        else if((op == 7 )|| (op == 6)|| ((op == 1)&&(instr[parts[0]].second == 3))) // BGTZ and BLEZ 
        {                     //OPCODE                                      //SOURCE                                 // set 0                                IMMEDIATE
            out = out + bitset<6>(op).to_string()+bitset<5>(getReg(parts[1])).to_string()+bitset<5>(0).to_string()+bitset<16>(hex2Dec(parts[2])).to_string();
             
            cerr << parts[0] << ":" <<getReg(parts[1]) << ":" << parts[2]<< endl;
             
        }
        else if(((op>=32)&&(op <= 38))||(op==40)||(op==41)||(op == 43)) // LOAD / STORE TYPE INSTR
        {
            string offsetBase = parts[2];
            int pos = offsetBase.find('(');
            string offset = offsetBase.substr(0,pos);
            string base = offsetBase.substr(pos+1,offsetBase.length()-1);
                                 //OPCODE                                      //SOURCE                         // dest                                IMMEDIATE
            out = out + bitset<6>(op).to_string()+bitset<5>(getReg(base)).to_string()+bitset<5>(getReg(parts[1])).to_string()+bitset<16>(hex2Dec(offset)).to_string();
            cerr << offset << ";" << base << endl;
            cerr << parts[0] << ":" <<getReg(base) << ":" << getReg(parts[1])<< ":" << offset << endl;
             
        }
        else{
                            // OPCODE                                            SOURCE                          DEST                            IMMEDIATE
            out = out + bitset<6>(op).to_string()+bitset<5>(getReg(parts[2])).to_string()+bitset<5>(getReg(parts[1])).to_string()+bitset<16>(hex2Dec(parts[3])).to_string();
                         
        }
    }
    bitset<32> set(out);
    cout << setfill('0') << setw(8) << hex << set.to_ulong() << endl;
  
}
int main(){
    map<string,pair<int, int>> instr;
    
    instr["addu"] = make_pair(0, 33);  // R
    instr["addiu"] = make_pair(9, 0);  // I 
    instr["and"] = make_pair(0, 36);   // R
    instr["andi"] = make_pair(12, 0);   // I
    instr["beq"] = make_pair(4, 0);     // I
    instr["bgez"] = make_pair(1, 1);    // I  secondary opcode
    instr["bgezal"] = make_pair(1, 17);  // I  secondary opcode
    instr["bgtz"] = make_pair(7, 0);    // I
    instr["blez"] = make_pair(6, 0);    // I
    instr["bltz"] = make_pair(1, 0);    // I  secondary opcode
    instr["bltzal"] = make_pair(1, 16);  // I  secondary opcode
    instr["bne"] = make_pair(5, 0);     // I 
    instr["div"] = make_pair(0, 26);    // R
    instr["divu"] = make_pair(0, 27);   // R
    instr["j"] = make_pair(2, 0);       //J
    instr["jalr"] = make_pair(0, 9);    //R
    instr["jal"] = make_pair(3, 0);     //J
    instr["jr"] = make_pair(0, 8);      //R
    instr["lb"] = make_pair(32, 0);     //I   load type
    instr["lbu"] = make_pair(36, 0);    //I   load type
    instr["lh"] = make_pair(33, 0);     //I   load type
    instr["lhu"] = make_pair(37, 0);    //I   load type
    instr["lui"] = make_pair(15, 0);    // I  Special load type
    instr["lw"] = make_pair(35, 0);     // I  load type
    instr["lwl"] = make_pair(34, 0);     //I  load type
    instr["lwr"] = make_pair(38, 0);    //I   load type
    instr["mthi"] = make_pair(0, 16);    // R type
    instr["mtlo"] = make_pair(0, 18);   // R type
    instr["mult"] = make_pair(0, 24);    // R type
    instr["multu"] = make_pair(0, 25);  // R type
    instr["or"] = make_pair(0, 37);     // R type general case
    instr["ori"] = make_pair(13, 0);    // I
    instr["sb"] = make_pair(40, 0);     // I
    instr["sh"] = make_pair(41, 0);     // I
    instr["sw"] = make_pair(43, 0);     //I
    instr["sll"] = make_pair(0, 0);    //R type with immediate
    instr["sllv"] = make_pair(0, 4);  // R type rd, rt, rs
    instr["slt"] = make_pair(0, 42);  //R type general
    instr["slti"] = make_pair(10, 0); // I type general
    instr["sltiu"] = make_pair(11, 0); // I type general
    instr["sltu"] = make_pair(0, 43);  // R type general
    instr["srav"] = make_pair(0, 7);  // R type rd, rt, rs
    instr["srl"] = make_pair(0, 2);   // R type with immediate
    instr["srlv"] = make_pair(0, 6);  // R type rd, rt, rs
    instr["subu"] = make_pair(0, 35);  // R type
    instr["xor"] = make_pair(0, 38);  //R type general
    instr["xori"] = make_pair(14, 0);  // I type





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