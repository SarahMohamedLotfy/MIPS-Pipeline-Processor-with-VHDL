LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
ENTITY ALU2 IS 
generic(size:integer:=16); 
		PORT (S	:  IN STD_LOGIC_VECTOR(3 downto 0);
			A,B:         in     STD_LOGIC_VECTOR(size-1 downto 0);
			F:          out STD_LOGIC_VECTOR(size-1 downto 0);
			ZF,SignF,OVF :out STD_LOGIC;
			Cout:	   OUT STD_LOGIC
);
									
  		                
END ENTITY ALU2;


ARCHITECTURE DataFlow OF ALU2 IS


SIGNAL temp,outputA,outputB,outputC: STD_LOGIC_VECTOR(size-1 downto 0);
SIGNAL CarryC,CarryA: STD_LOGIC;
BEGIN
pA:entity work.PartA generic map (size=>size) port map(S,A,B,CarryA,OVF,outputA);	
PB:entity work.PartB generic map (size=>size) PORT MAP(S,A,B,outputB);
PC:entity work.PartC generic map (size=>size) PORT MAP(S,A,B,outputC,CarryC);
	
		 temp <= outputA when (S(3 downto 0) = "0000" or S(3 downto 0) = "0001" or S(3 downto 0) = "0010" or S(3 downto 0) = "0011" or S(3 downto 0) = "0100" or S(3 downto 0) = "0101" or S(3 downto 0) = "0110") else 
		 outputB when(S(3 downto 0) = "0111" or S(3 downto 0) = "1000" or S(3 downto 0) = "1001" )else 
		 outputC  when (S(3 downto 0) = "1010" or S(3 downto 0) = "1011")else (others=>'0'); 	 
		 
		process(temp,S)
		begin
			 Cout <= CarryA  when(S(3 downto 0) = "0000" or S(3 downto 0) = "0001" or S(3 downto 0) = "0010" or S(3 downto 0) = "0011" or S(3 downto 0) = "0100" or S(3 downto 0) = "0101" or S(3 downto 0) = "0110") else 
			 CarryC  when (S(3 downto 0) = "1010" or S(3 downto 0) = "1011")else '0'; 	 
			 F <= temp;	
			ZF <= '1' when(temp = (std_logic_vector(to_unsigned(0,size))))else'0' ;
			SignF <= temp(size-1);
			
		end process;
END DataFlow;