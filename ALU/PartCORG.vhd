
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all; 
ENTITY PartC IS  
		PORT (	S0,S1	:  IN STD_LOGIC;
			Cin: 	IN STD_LOGIC;			
	      		A:         in     STD_LOGIC_VECTOR(15 downto 0);
			F:          out STD_LOGIC_VECTOR(15 downto 0);
			Cout:	   OUT STD_LOGIC
			);


									
  		                
END ENTITY PartC;


ARCHITECTURE Behavioral OF PartC IS
BEGIN
	PROCESS(S0,S1,Cin,A)
		BEGIN
		
		 IF(S0='0' and S1='0')THEN
			Cout <= A(15); 
			
			F(14 downto 0) <= A(15 downto 1);
			F(15) <= '0';--put zero
			
		 ELSIF (S0='1' and S1='0')THEN 
			Cout <= A(0);
			F(14 downto 0) <= A(15 downto 1);
			F(15) <=A(0);
			

		 ELSIF (S0='0' and S1='1')THEN 
			Cout <= A(0);
			F(14 downto 0) <= A(15 downto 1);
			F(15) <= Cin;
			
		 ELSE  
			Cout <= A(15); 
			F(14 downto 0) <= A(15 downto 1);
			F(15)<= A(15);-- put sign bit
			

		 END IF;


	END PROCESS;
END Behavioral;