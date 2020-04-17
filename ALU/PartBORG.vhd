
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
ENTITY PartB IS  
	PORT (		S0,S1	:  IN STD_LOGIC;
              		A:         in     STD_LOGIC_VECTOR(15 downto 0);
			B:         in     STD_LOGIC_VECTOR(15 downto 0);
			F:          out STD_LOGIC_VECTOR(15 downto 0)
);                
END ENTITY PartB;


ARCHITECTURE Behavioral OF PartB IS
BEGIN
	PROCESS(S0,S1,A,B)
		BEGIN
		FOR i IN 0 TO 15 LOOP
		 IF(S0='0' and S1='0')THEN 
			F(i) <= A(i) and B(i);
		 ELSIF (S0='1' and S1='0')THEN 
			F(i) <= A(i) or B(i);
		 ELSIF (S0='0' and S1='1')THEN 
			F(i) <= A(i) xor B(i);
		 ELSE  
			F(i) <= not A(i);
		 END IF;
		END LOOP;

	END PROCESS;
END Behavioral;