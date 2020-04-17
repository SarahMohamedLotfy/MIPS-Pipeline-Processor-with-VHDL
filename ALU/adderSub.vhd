library ieee;
use ieee.std_logic_1164.all;
entity addsub is
	generic (n:integer:=16);
   port(A,B  : in std_logic_vector(15 downto 0); 
		cin: in std_logic;	
          sum  : out std_logic_vector(15 downto 0);
          Cout : out std_logic);
end addsub;
 
architecture DataFlow of addsub is
component Full_Adder is
  port( X, Y, Cin : in std_logic;
        sum, Cout : out std_logic);
end component;
signal TMP: std_logic_vector(15 downto 0);
SIGNAL temp : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN
TMP <= a xor b;
loop1: FOR i IN 0 TO 15 GENERATE

g0: IF i = 0 GENERATE

f0: full_adder PORT MAP (a(i) ,TMP(i) ,cin, sum(0), temp(i));

END GENERATE g0;

gx: IF i > 0 GENERATE

fx: full_adder PORT MAP (a(i),TMP(i),temp(i-1),sum(i),temp(i));

END GENERATE gx;

END GENERATE;

Cout <= temp(15);
OVERFLOW <= temp(15) xor temp(14);
ZF <= '0' when (sum = "0000000000000000")else
'1';
sign <= sum(15); 
end DataFlow; 
