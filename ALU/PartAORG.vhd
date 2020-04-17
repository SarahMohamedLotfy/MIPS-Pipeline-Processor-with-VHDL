

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all; 
ENTITY PartA IS 
generic (n:integer:=16); 
PORT (		S0,S1	:  IN STD_LOGIC;
            A:         in     STD_LOGIC_VECTOR(n-1 downto 0);
			B:         in     STD_LOGIC_VECTOR(n-1 downto 0);
			Cin: 	IN STD_LOGIC;
			Cout,OVF: out std_logic;
			F:out STD_LOGIC_VECTOR(n-1 downto 0)
);				
  		                
END ENTITY PartA;


ARCHITECTURE DataFlow OF PartA IS
component pa is
generic (n:integer:=16);
   port(a : in STD_LOGIC_VECTOR(n-1 downto 0);
      b : in STD_LOGIC_VECTOR(n-1 downto 0);
      cin:in STD_LOGIC;
      ca: out STD_LOGIC;
      sum : out STD_LOGIC_VECTOR(n-1 downto 0) 
   );
end component; 
signal addA1Out,addABOut,subA1Out,addAB1Out,subABOut,subAB1Out:STD_LOGIC_VECTOR(n-1 downto 0);
signal CaddA1Out,CaddABOut,CsubA1Out,CaddAB1Out,CsubABOut,CsubAB1Out:STD_LOGIC;	
signal temp :STD_LOGIC_VECTOR(15 downto 0);
BEGIN
ADDA1:pa generic map(n=>16) port map (A,"0000000000000000",'1',CaddA1Out,addA1Out);
ADDAB:pa generic map(n=>16) port map (A,B,'0',CaddABOut,addABOut);
ADDAB1:pa generic map(n=>16) port map (A,B,'1',CaddAB1Out,addAB1Out);
SUBA1:Pa generic map(n=>16) port map (A,"1111111111111110",'1',CsubA1Out,subA1Out);
SUBAB:Pa generic map(n=>16) port map (A,(not B),'1',CsubABOut,subABOut);
SUBAB1:Pa generic map(n=>16) port map (A,(not B),'0',CsubAB1Out,subAB1Out);
	 
	 
 temp <= addA1Out when(S0='0' and S1='0' and Cin='1')else
 A when(S0='0' and S1='0' and Cin='0')else 	
 addABOut  when (S0='1' and S1='0' and Cin='0')else
 addAB1Out  when (S0='1' and S1='0' and Cin='1')else
 subAB1Out  when (S0='0' and S1='1' and Cin='0')else
 subABOut  when (S0='0' and S1='1' and Cin='1')else 
 subA1Out  when (S0='1' and S1='1' and Cin='0')else
 "0000000000000000"  when (S0='1' and S1='1' and Cin='1');			

	F <= temp; 
	 
	 OVF <= '1'  when (  
	 ( ((S0='1' and S1='0' and Cin='0') or (S0='1' and S1='0' and Cin='1')) and 
	 ( (A(15) ='0' and B(15) = '0' and temp(15)='1') or (A(15) ='1' and B(15) = '1' and temp(15)='0' )))
	 OR
	 ( ((S0='0' and S1='1' and Cin='0') or (S0='0' and S1='1' and Cin='1')) and 
	 ( (A(15) ='0' and B(15) = '1' and temp(15)='1') or (A(15) ='1' and B(15) = '0' and temp(15)='0' )))
	 )else '0';
	 
 
 

 Cout <= CaddA1Out when(S0='0' and S1='0' and Cin='1')else
 '0' when(S0='0' and S1='0' and Cin='0')else 	
 CaddABOut  when (S0='1' and S1='0' and Cin='0')else
 CaddAB1Out  when (S0='1' and S1='0' and Cin='1')else
 CsubAB1Out  when (S0='0' and S1='1' and Cin='0')else
 CsubABOut  when (S0='0' and S1='1' and Cin='1')else 
 CsubA1Out  when (S0='1' and S1='1' and Cin='0')else
 '0' when (S0='1' and S1='1' and Cin='1');
 
END DataFlow;