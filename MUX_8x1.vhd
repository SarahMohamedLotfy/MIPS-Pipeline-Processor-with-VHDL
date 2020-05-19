library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mux8 is
    port(sel:in STD_LOGIC_vector (1 downto 0);
         add:in STD_LOGIC_VECTOR(31 downto 0);
         SP1:in STD_LOGIC_VECTOR(31 downto 0);
         SP2:in STD_LOGIC_VECTOR(31 downto 0);
         output: out std_logic_vector(31 downto 0)
     );
end mux8;


architecture behavioral of mux8 is

begin
    with sel select
        output <= 
                  SP1  when "00",
                  SP2  when "01",
		  add  when "10",
		  "00000000000000000000000000000000"   when "11",
                  "00000000000000000000000000000000" when others;
end behavioral;


