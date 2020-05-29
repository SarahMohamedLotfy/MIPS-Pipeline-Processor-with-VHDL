
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
ENTITY PartB IS 
generic (size:integer:=16);  
	PORT (S:  IN STD_LOGIC_VECTOR(3 downto 0);
            A,B:         in     STD_LOGIC_VECTOR(size-1 downto 0);
			F:          out STD_LOGIC_VECTOR(size-1 downto 0)
);                
END ENTITY PartB;


ARCHITECTURE Behavioral OF PartB IS
BEGIN
	PROCESS(S,A,B)
		BEGIN
		 IF(S="1000")THEN 
			F <= A and B;
		 ELSIF (S="1001")THEN 
			F <= A or B;
		 ELSIF(S="0111")then   
			F <= not A;
		else
			F<=(others=>'0');	
		END IF;
		
	END PROCESS;
END Behavioral;