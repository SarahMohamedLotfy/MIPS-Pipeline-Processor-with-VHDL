
library IEEE; 
use IEEE.STD_LOGIC_1164.all;
 use ieee.numeric_std.all; 
entity pa is
   generic (n:integer:=16);
   port(a : in STD_LOGIC_VECTOR(n-1 downto 0);
      b : in STD_LOGIC_VECTOR(n-1 downto 0);
      cin:in STD_LOGIC;
      ca: out STD_LOGIC;
      sum : out STD_LOGIC_VECTOR(n-1 downto 0) 

   ); 
end pa; 
 
architecture DataFlow of pa is
           
   SIGNAL temp : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
BEGIN

loop1: FOR i IN 0 TO n-1 GENERATE

g0: IF i = 0 GENERATE

f0: entity work.Full_Adder PORT MAP (a(i) ,b(i) ,cin, sum(0), temp(i));

END GENERATE g0;

gx: IF i > 0 GENERATE

fx: entity work.Full_Adder PORT MAP (a(i),b(i),temp(i-1),sum(i),temp(i));

END GENERATE gx;

END GENERATE;
ca <= temp(n-1);

end DataFlow;