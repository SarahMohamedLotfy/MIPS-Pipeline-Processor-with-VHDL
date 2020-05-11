library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Check_RRI is 
port(	
	OpCode: in std_logic_vector(5-1 downto 0) ;
	
	RRI: out std_logic;
	PCwrite: out std_logic
);
end entity;

architecture Check_RRI_arch of Check_RRI is
begin

      --RET RTI
RRI<='1'when (OpCode = "01101") (OpCode = "10111")else '0';
       
PCwrite <='0' when (OpCode = "01101") (OpCode = "10111")else '1';
   
end architecture;
