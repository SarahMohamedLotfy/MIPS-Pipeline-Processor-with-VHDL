library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity IncDec is
    port(
SPtype :in std_logic;
SP: in std_logic_vector(31 downto 0);
SPout: out std_logic_vector(31 downto 0)
     );

end IncDec;

architecture behav of IncDec is
begin
  with SPtype select
        SPout <= 
 	       std_logic_vector( unsigned(SP) - 2 ) when '1',
 	       std_logic_vector( unsigned(SP) + 2 ) when '0',
               "00000000000000000000000000000000" when others;
end behav;