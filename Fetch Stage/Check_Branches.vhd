library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Check_Branches is 
port(	
	OpCode: in std_logic_vector(4 downto 0) ;
	
	JZ,CALL,unconditionalBranch: out std_logic
);
end entity;

architecture Check_Branches_arch of Check_Branches is
begin
JZ <='1' when OpCode="10011" else '0';
unconditionalBranch<='1' when (OpCode="10100" or OpCode="10101") else '0';
CALL<='1' when  OpCode="10101" else '0';
end architecture;



