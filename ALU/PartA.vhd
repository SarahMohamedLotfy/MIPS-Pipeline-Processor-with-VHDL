

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all; 
ENTITY PartA IS 
generic (n:integer:=16); 
PORT (		S0,S1	:  IN STD_LOGIC;
            A:         in     STD_LOGIC_VECTOR(n-1 downto 0);
			B:         in     STD_LOGIC_VECTOR(n-1 downto 0);
			Cin: 	IN STD_LOGIC;
			Cout, OVERFLOW , ZF, Sign : out std_logic;
			F:out STD_LOGIC_VECTOR(n-1 downto 0)
);				
  		                
END ENTITY PartA;


ARCHITECTURE DataFlow OF PartA IS
component adderSub is
generic (n:integer:=16);
   port(A,B  : in std_logic_vector(15 downto 0); 
		cin: in std_logic;	
          Cout, OVERFLOW , ZF, Sign : out std_logic;
sum  : out std_logic_vector(15 downto 0));
          
end component; 

signal addA1Out,addABOut,subA1Out,addAB1Out,subABOut,subAB1Out:STD_LOGIC_VECTOR(n-1 downto 0);
signal CaddA1Out,CaddABOut,CsubA1Out,CaddAB1Out,CsubABOut,CsubAB1Out:STD_LOGIC;	
signal OVaddA1Out,OVaddABOut,OVaddAB1Out:std_logic;
signal ZFaddA1Out,ZFaddABOut,ZFaddAB1Out:std_logic;
signal SaddA1Out,SaddABOut,SaddAB1Out:std_logic;
BEGIN
ADDA1:adderSub generic map(n=>16) port map (A,"0000000000000000",'1',CaddA1Out,OVaddA1Out,ZFaddA1Out,SaddA1Out,addA1Out);
ADDAB:adderSub generic map(n=>16) port map (A,B,'0',CaddABOut,OVaddABOut,ZFaddABOut,SaddABOut,addABOut);
ADDAB1:adderSub generic map(n=>16) port map (A,B,'1',CaddAB1Out,OVaddAB1Out,ZFaddAB1Out,SaddAB1Out,addAB1Out);
--SUBA1:adderSub generic map(n=>16) port map (A,"0000000000000000",'1',CsubA1Out,subA1Out);
--SUBAB:adderSub generic map(n=>16) port map (A,B,'0',CsubABOut,subABOut);
--SUBAB1:adderSub generic map(n=>16) port map (A,B,'1',CsubAB1Out,subAB1Out);

 F <= addA1Out when(S0='0' and S1='0' and Cin='1')else
 A when(S0='0' and S1='0' and Cin='0')else 	
 addABOut  when (S0='1' and S1='0' and Cin='0')else
 addAB1Out  when (S0='1' and S1='0' and Cin='1')else
 addAB1Out  when (S0='0' and S1='1' and Cin='0')else
 addABOut  when (S0='0' and S1='1' and Cin='1')else 
 addA1Out  when (S0='1' and S1='1' and Cin='0')else
 "0000000000000000"  when (S0='1' and S1='1' and Cin='1');			


 Cout <= CaddA1Out when(S0='0' and S1='0' and Cin='1')else
 '0' when(S0='0' and S1='0' and Cin='0')else 	
 CaddABOut  when (S0='1' and S1='0' and Cin='0')else
 CaddAB1Out  when (S0='1' and S1='0' and Cin='1')else
 CaddAB1Out  when (S0='0' and S1='1' and Cin='0')else
 CaddABOut  when (S0='0' and S1='1' and Cin='1')else 
 CaddA1Out  when (S0='1' and S1='1' and Cin='0')else
 '0' when (S0='1' and S1='1' and Cin='1');			

 OVERFLOW <= OVaddA1Out when(S0='0' and S1='0' and Cin='1')else
 '0' when(S0='0' and S1='0' and Cin='0')else 	
 OVaddABOut  when (S0='1' and S1='0' and Cin='0')else
 OVaddAB1Out  when (S0='1' and S1='0' and Cin='1')else
 OVaddAB1Out  when (S0='0' and S1='1' and Cin='0')else
 OVaddABOut  when (S0='0' and S1='1' and Cin='1')else 
 OVaddA1Out  when (S0='1' and S1='1' and Cin='0')else
 '0' when (S0='1' and S1='1' and Cin='1');			

ZF <= ZFaddA1Out when(S0='0' and S1='0' and Cin='1')else
 '0' when(S0='0' and S1='0' and Cin='0')else 	
 ZFaddABOut  when (S0='1' and S1='0' and Cin='0')else
 ZFaddAB1Out  when (S0='1' and S1='0' and Cin='1')else
 ZFaddAB1Out  when (S0='0' and S1='1' and Cin='0')else
 ZFaddABOut  when (S0='0' and S1='1' and Cin='1')else 
 ZFaddA1Out  when (S0='1' and S1='1' and Cin='0')else
 '0' when (S0='1' and S1='1' and Cin='1');			
				
Sign <= SaddA1Out when(S0='0' and S1='0' and Cin='1')else
 '0' when(S0='0' and S1='0' and Cin='0')else 	
 SaddABOut  when (S0='1' and S1='0' and Cin='0')else
 SaddAB1Out  when (S0='1' and S1='0' and Cin='1')else
 SaddAB1Out  when (S0='0' and S1='1' and Cin='0')else
 SaddABOut  when (S0='0' and S1='1' and Cin='1')else 
 SaddA1Out  when (S0='1' and S1='1' and Cin='0')else
 '0' when (S0='1' and S1='1' and Cin='1');			
						
END DataFlow;