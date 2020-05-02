LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all; 
ENTITY PartC IS 
generic(size:integer:=16); 
		PORT (S	:  IN STD_LOGIC_VECTOR(3 downto 0);
			A,B:         in     STD_LOGIC_VECTOR(size-1 downto 0);
			F:          out STD_LOGIC_VECTOR(size-1 downto 0);
			Cout:	   OUT STD_LOGIC
			);         
END ENTITY PartC;


ARCHITECTURE Behavioral OF PartC IS
BEGIN
	PROCESS(S,A,B)
		BEGIN
		--shift right
		 IF (S="1011")THEN 
			Cout <= A(to_integer(unsigned(B)-1));
			F(size-to_integer(unsigned(B))-1 downto 0) <= A(size-1 downto to_integer(unsigned(B)));
			F(size-1 downto size-to_integer(unsigned(B))) <= (others=>'0');
			--shift left
		elsif (S="1010")then
			F(to_integer(unsigned(B)) downto 0) <= (others=>'0');
			F(size-1 downto to_integer(unsigned(B))) <= A(size-to_integer(unsigned(B))-1 downto 0);
			Cout <= A(size-to_integer(unsigned(B)));
		else
			F<=(others=>'0');
			Cout<='0';
		END IF;
	END PROCESS;
END Behavioral;