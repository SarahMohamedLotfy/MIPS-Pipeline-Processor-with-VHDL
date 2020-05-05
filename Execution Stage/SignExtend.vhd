LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
entity SignExtend is
    port (
        signType:IN std_logic;-- 0 extend IMM , 1 extend EA
        Address:IN std_logic_vector(19 downto 0);
        output:OUT std_logic_vector(31 downto 0)
    );
end entity SignExtend;
architecture arch of SignExtend is
begin
    output(15 downto 0)<=Address(15 downto 0);
    output(19 downto 16)<= (others=>Address(15)) when signType ='0' else Address(19 downto 16);
    output(31 downto 20) <= (others=>Address(15)) when signType ='0' else (others=>Address(19));
end arch ; 