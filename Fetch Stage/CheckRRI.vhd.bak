library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Check_RRI is 
generic (n:integer := 32);
port(	
  interrupt: in std_logic;
	reset : in std_logic ; 
	clk: in std_logic ;
	OpCode: in std_logic_vector(5-1 downto 0) ;
	
	RRI: out std_logic;
	PCwrite: out std_logic
);
end entity;

architecture Check_RRI_arch of Check_RRI is
begin
process (clk)
begin
if rising_edge(clk) then
   if (reset ='1')then 
     
    -- Initialization
     RRI<='0';
     PCwrite <='0';
	  
   else  
      -- CALL  RET RTI
     if (OpCode = "01101") or (OpCode = "10101") or (OpCode = "10111") then
       RRI<='1';
       PCwrite <='1';
   
      end if;
   end if;
end if;
end process;
end architecture;
