#include<iostream>
#include<fstream>
#include<string>
#include<sstream>  
#include<vector>
#include <stdio.h>
#include <ctype.h>
#include <bitset>
#include <limits>
using namespace std;
//Leave space after 3 letters instructions
//Leave 2 spaces after 2 letters instructions
int IMMint = 0; 
int EAint=0;
string opcoderegister(char c)
{
	if ( c=='0')
	{
		return "000";
	}
	else if (c=='1')
	{
		return "001";
	}
	else if (c=='2')
	{
		return "010";
	}
	else if (c=='3')
	{
		return "011";
	}
	else if (c=='4')
	{
		return "100";
	}
	else if (c=='5')
	{
		return "101";
	}
	else if (c=='6')
	{
		return "110";
	}
	else if (c=='7')
	{
		return "111";
	}
}

string meniomonicOpCode(string str)
{
	//One Operand 
    if (str == "NOT ")
		return "00000000";
	else if (str == "INC ")
		return "00001000";
	else if (str == "DEC ")
		return "00010000";
	else if (str == "OUT ")
		return "00011000";
	else if (str == "IN  ")
		return "00100000";

	//jz , jmp, call
	else if (str == "JZ  ")
		return "10010000";
	else if (str == "JMP ")
		return "10011000";
	else if (str == "CALL")
		return "10100000";

	//push /pop
	else if (str == "PUSH")
		return "01101000";
	else if (str == "POP ")
		return "01110000";

	//ADD, SUB, OR, AND
	else if (str == "ADD ")
		return "00111";
	else if (str == "SUB ")
		return "01001";
	else if (str == "OR  ")
		return "01011";
	else if (str == "AND ")
		return "01010";

	//SWAP
	else if (str == "SWAP")
		return "00110";

	//IADD, SHL, SHR
	else if (str == "IADD")
		return "01000"; 
	else if (str == "SHL ")
		return "01100"; 
	else if (str == "SHR ")
		return "10111";

	//LDM
	else if (str == "LDM ")
		return "01111";

	//LDD ,STD
	else if (str == "LDD ")
		return "10000";
	else if (str == "STD ")
		return "10001";

}

int main()
{
	ifstream file;
    file.open("input.txt");
    ofstream myfile ("Ram.txt");
	ofstream myfile2 ("Rom.txt");
	
	string str;
    string meniomonic ="" ;
    char opcode [16];
	int programcounter=1;
	int firstLine=0;
	string meniomonicbr="";

	//Reset Address
	string resetAddstr="";
	file >>resetAddstr;
	string resaddress = resetAddstr.substr(4, 2);
	stringstream ss1(resaddress);
	int resetaddressInt=0;
	ss1>>resetaddressInt;

	string resetAddstrafter="";
	file >>resetAddstrafter;
	for (int i=0;i<resetaddressInt;i++)
		 myfile2 << " "<<endl;
    myfile2 << resetAddstrafter;

	//Interupt Address
	string interAddstr="";
	file >>interAddstr;
	string intraddress = interAddstr.substr(4, 2);
	stringstream ss2(intraddress);
	int intraddressInt=0;
	ss2>>intraddressInt;

	string intrAddstrafter="";
	file >>intrAddstrafter;
	for (int i=0;i<intraddressInt;i++)
		 myfile2 << " "<<endl;
    myfile2 << intrAddstrafter;

   


   
	string addressStr="";
	file >> addressStr;
    string address = addressStr.substr(4, 2);
	stringstream ss(address);
	int addressInt=0;
	ss>>addressInt;

    while (getline(file, str)) 
	{
		if (str =="")
		{
			firstLine =1;
		}
		else
		{
			firstLine =0;
		}
		std::cout << str << "\n";
		meniomonic="";
		if (str.size()<4)
		{
		//No operand
		    if (str == "NOP")
			{
			opcode[0]='0';opcode[1]='0' ;opcode[2]='0';opcode[3]='0';opcode[4]='0';opcode[5]='0';opcode[6]='0';opcode[7]='0';
			opcode[8]='0';opcode[9]='0';opcode[10]='0';opcode[11]='0';opcode[12]='0';opcode[13]='0';opcode[14]='0';opcode[15]='0';
			}
			else if (str == "RET")
			{
			opcode[0]='1';opcode[1]='0' ;opcode[2]='1';opcode[3]='0';opcode[4]='1';opcode[5]='0';opcode[6]='0';opcode[7]='0';
			opcode[8]='0';opcode[9]='0';opcode[10]='0';opcode[11]='0';opcode[12]='0';opcode[13]='0';opcode[14]='0';opcode[15]='0';
			}
			else if (str == "RTI")
			{
			opcode[0]='1';opcode[1]='0' ;opcode[2]='1';opcode[3]='1';opcode[4]='0';opcode[5]='0';opcode[6]='0';opcode[7]='0';
			opcode[8]='0';opcode[9]='0';opcode[10]='0';opcode[11]='0';opcode[12]='0';opcode[13]='0';opcode[14]='0';opcode[15]='0';
			}
		}
		else
		{
			if ( str.size() > 4)
			{
				for (int i=0;i<4;i++)
				{
				meniomonic= meniomonic+ str[i];
				}
			    cout <<meniomonic<<endl;
			    string meniomonnicOpCode= meniomonicOpCode(meniomonic);
			    for (int l=0;l<meniomonnicOpCode.size();l++)
				{
					opcode[l]= meniomonnicOpCode[l];
				}

	            // Check if it is two operand or one operand
				std::size_t found = str.find(',');
				if (found!=std::string::npos)
				{
				cout <<str<<endl;
	              
				//ADD, SUB, OR, AND
				if (meniomonnicOpCode == "00111" || meniomonnicOpCode =="01001" || meniomonnicOpCode =="01011" ||meniomonnicOpCode =="01010")
				{
				       int  i=5;
						opcode[5] = opcoderegister(str[i+1])[0];
						opcode[6]=opcoderegister(str[i+1])[1];
						opcode[7] =opcoderegister(str[i+1])[2];
				 
					    i=8;
						   opcode[8] = opcoderegister(str[i+1])[0];
						   opcode[9]=opcoderegister(str[i+1])[1];
						   opcode[10] =opcoderegister(str[i+1])[2];
				        i=11;
						   opcode[11] = opcoderegister(str[i+1])[0];
						   opcode[12]=opcoderegister(str[i+1])[1];
						   opcode[13] =opcoderegister(str[i+1])[2];
				  
				   opcode[14] ='0';
				   opcode[15] ='0';
				}

				//SWAP
				if (meniomonnicOpCode == "00110" )
				{
				int i=5;
						   opcode[5] = opcoderegister(str[i+1])[0];
						   opcode[6]=opcoderegister(str[i+1])[1];
						   opcode[7] =opcoderegister(str[i+1])[2]; 
				  i=8;
						   opcode[8] = opcoderegister(str[i+1])[0];
						   opcode[9]=opcoderegister(str[i+1])[1];
						   opcode[10] =opcoderegister(str[i+1])[2];
				  opcode[11] ='0'; opcode[12] ='0'; opcode[13] ='0'; opcode[14] ='0'; opcode[15] ='0';
				}

				///SHL, SHR,LDM
				if (meniomonnicOpCode =="01100"||meniomonnicOpCode =="10111"||meniomonnicOpCode =="01111" )
				{
				 opcode[5] ='0'; opcode[6] ='0'; opcode[7] ='0'; 
				int i=5;
						   opcode[8] = opcoderegister(str[i+1])[0];
						   opcode[9]=opcoderegister(str[i+1])[1];
						   opcode[10] =opcoderegister(str[i+1])[2]; 
				   
				  opcode[11] ='0'; opcode[12] ='0'; opcode[13] ='0'; opcode[14] ='0'; opcode[15] ='0';
				  string IMM = "";
				  IMM = str.substr(8,str.size());
	              stringstream ss(IMM); 
                  ss >> IMMint; 
				}
				//IADD
				if (meniomonnicOpCode == "01000" )
				{
					int i=5;
						   opcode[5] = opcoderegister(str[i+1])[0];
						   opcode[6]=opcoderegister(str[i+1])[1];
						   opcode[7] =opcoderegister(str[i+1])[2]; 
				  i=8;
						   opcode[8] = opcoderegister(str[i+1])[0];
						   opcode[9]=opcoderegister(str[i+1])[1];
						   opcode[10] =opcoderegister(str[i+1])[2];
				   
				  opcode[11] ='0'; opcode[12] ='0'; opcode[13] ='0'; opcode[14] ='0'; opcode[15] ='0';
				  string IMM = "";
				  IMM = str.substr(8,str.size());
	              stringstream ss(IMM); 
                  ss >> IMMint; 
				}
				///LDD, SDD
				if (meniomonnicOpCode == "10000"||meniomonnicOpCode =="10001" )
				{
				 opcode[5] ='0'; opcode[6] ='0'; opcode[7] ='0'; 
				int i=5;
						   opcode[8] = opcoderegister(str[i+1])[0];
						   opcode[9]=opcoderegister(str[i+1])[1];
						   opcode[10] =opcoderegister(str[i+1])[2]; 
				  string EA = "";
				  EA = str.substr(8,str.size());
	              stringstream ss(EA); 
                  ss >> EAint; 
				  std::string binary = std::bitset<20>(EAint).to_string(); //to binary
				  opcode[11] ='1'; opcode[12] =binary[0]; opcode[13] =binary[1]; opcode[14] =binary[2]; 
				  opcode[15] =binary[3];
				}
				}
	else
	{
	// This is one operand
	
		int i=5;
		opcode[8] = opcoderegister(str[i+1])[0];
		opcode[9]=opcoderegister(str[i+1])[1];
		opcode[10] =opcoderegister(str[i+1])[2];
		opcode[11] ='0';opcode[12] ='0';opcode[13] ='0';opcode[14] ='0'; opcode[15] ='0'; 
		
  }
}
}

	///Write to the output file
  if (firstLine !=1)
  {
    for (int s=0;s<16;s++)
	{
		myfile <<opcode[s];
		opcode[s]= ' ';
	}
	myfile<<endl;
	if (IMMint!=0)
	{
	std::string binary = std::bitset<16>(IMMint).to_string(); //to binary
    myfile <<binary<<endl;
	}
	if (EAint!=0)
	{
	std::string binary = std::bitset<20>(EAint).to_string(); //to binary
    myfile <<binary.substr(4,19)<<endl;
	}
	IMMint=0;
	EAint=0;
  }
	programcounter++;
}
  myfile2.close();
 system("pause");
}