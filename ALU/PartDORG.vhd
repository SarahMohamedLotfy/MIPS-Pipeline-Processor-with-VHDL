
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all; 
ENTITY PartD IS  
		PORT (S0,S1	:  IN STD_LOGIC;
			Cin: 	IN STD_LOGIC;			
			F:          out STD_LOGIC_VECTOR(15 downto 0);
              		A:         in     STD_LOGIC_VECTOR(15 downto 0);
			Cout:	   OUT STD_LOGIC
			);
									
  		                
END ENTITY PartD;


ARCHITECTURE Behavioral OF PartD IS
BEGIN
	PROCESS(S0,S1,Cin,A)
		BEGIN
		
		 IF(S0='0' and S1='0')THEN
			Cout <= A(0); 			
			F(15 downto 1) <= A(14 downto 0);
			F(0) <= '0';--put zero
			
		 ELSIF (S0='1' and S1='0')THEN 
			Cout <= A(15);
			F(15 downto 1) <= A(14 downto 0);
			F(0) <=A(15);
			

		 ELSIF (S0='0' and S1='1')THEN 
			Cout <= A(15);
			F(15 downto 1) <= A(14 downto 0);
			F(0) <= Cin;
			
		 ELSE  
			F(15 downto 0) <= "0000000000000000";

		 END IF;


	END PROCESS;
END Behavioral;