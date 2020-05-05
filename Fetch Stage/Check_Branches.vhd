library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Check_Branches is 
generic (n:integer := 32);
port(	
  interrupt: in std_logic;
	reset : in std_logic ; 
	clk: in std_logic ;
	OpCode: in std_logic_vector(5-1 downto 0) ;
	
	JZ: out std_logic
);
end entity;

architecture Check_Branches_arch of Check_Branches is
begin
process (clk)
begin
if rising_edge(clk) then
   if (reset ='1')then 
    -- Initialization
    JZ<='0';
    
   else  
      -- JZ or JMP
     if (OpCode = "10011") or (OpCode = "10100") then
	     JZ <='1';
     end if;
   end if;
end if;
end process;
end architecture;



