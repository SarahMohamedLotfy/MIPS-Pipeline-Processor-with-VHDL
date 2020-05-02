

LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all; 
ENTITY PartA IS 
generic (size:integer:=16); 
PORT (		S	:  IN STD_LOGIC_VECTOR(3 downto 0);
            A:         in     STD_LOGIC_VECTOR(size-1 downto 0);
			B:         in     STD_LOGIC_VECTOR(size-1 downto 0);
			Cout,OVF: out std_logic;
			F:out STD_LOGIC_VECTOR(size-1 downto 0)
);				
  		                
END ENTITY PartA;


ARCHITECTURE DataFlow OF PartA IS

signal addA1Out,addABOut,subA1Out,addB1Out,subABOut:STD_LOGIC_VECTOR(size-1 downto 0);
signal CaddA1Out,CaddABOut,CsubA1Out,CaddB1Out,CsubABOut:STD_LOGIC;	
signal temp :STD_LOGIC_VECTOR(size-1 downto 0);

BEGIN
ADDA1:entity work.pa generic map(n=>size) port map (A,(others=>'0'),'1',CaddA1Out,addA1Out);
ADDAB:entity work.pa generic map(n=>size) port map (A,B,'0',CaddABOut,addABOut);
ADDAB1:entity work.pa generic map(n=>size) port map ((others=>'0'),B,'1',CaddB1Out,addB1Out);
SUBA1:entity work.pa generic map(n=>size) port map (A,(others=>'1') ,'0',CsubA1Out,subA1Out);
SUBAB:entity work.pa generic map(n=>size) port map (A,(not B),'1',CsubABOut,subABOut);

	 
 temp <= addA1Out when(S="0011")else
 A when(S="0001")else
 B when(S="0010")else 	
 addABOut  when (S="0101")else
 addA1Out  when (S="0011")else
 subABOut  when (S="0110")else 
 subA1Out  when (S="0100")else
 (others=>'0');			
	F<=temp;
	 
	 OVF <= '1'  when (  
	 ( (S="0101") and 
	 ( (A(size-1) ='0' and B(size-1) = '0' and temp(size-1)='1') or (A(size-1) ='1' and B(size-1) = '1' and temp(size-1)='0' )))
	 OR
	 ( (S="0110") and 
	 ( (A(size-1) ='0' and B(size-1) = '1' and temp(size-1)='1') or (A(size-1) ='1' and B(size-1) = '0' and temp(size-1)='0' )))
	 )else '0';
	 
 
 

 Cout <= CaddA1Out when(S="0011")else 	
 CaddABOut  when (S="0101")else
 CaddA1Out  when (S="0011")else
 CsubABOut  when (S="0110")else 
 CsubA1Out  when (S="0100")
 else '0';
END DataFlow;