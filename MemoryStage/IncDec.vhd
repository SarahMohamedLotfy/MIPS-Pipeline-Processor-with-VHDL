library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity IncDec is
    port(
SPtype :in std_logic_vector(1 downto 0);
SP: in std_logic_vector(31 downto 0);
SPout: out std_logic_vector(31 downto 0)
     );

end IncDec;

architecture behav of IncDec is
begin
  SPout<= std_logic_vector( unsigned(SP) - 2 ) when SPtype="00" 
 	else std_logic_vector( unsigned(SP) + 2 ) when SPtype="01";
end behav;