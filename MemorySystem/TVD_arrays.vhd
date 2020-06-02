library ieee;
use ieee.std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity TVD is
port(
    index : in std_logic_vector(4 downto 0);
    clk,wr,rd : in std_logic;

    tagsin : in std_logic_vector(2 downto 0);
    Dbitin : in std_logic;
    Vbitin : in std_logic;

    tags : out std_logic_vector(2 downto 0);
    Dbit : out std_logic;
    Vbit : out std_logic

);
end TVD;


architecture TVD_arch of TVD is
type tag_array is array (31 downto 0) of STD_LOGIC_VECTOR (2 downto 0);
signal tag_bits : tag_array:=(others=>(others=>'0'));

type Validbit_array is array (31 downto 0)of STD_LOGIC;
signal valid_bit : Validbit_array:=(others=>'0');

type dirtybit_array is array (31 downto 0) of STD_LOGIC;
signal dirty_bit : dirtybit_array:=(others=>'0');

begin

    process(clk,rd,wr,index,tagsin,Dbitin,Vbitin)
    begin
    
        if(rd = '1' and wr ='0')then
		tags <= tag_bits(to_integer(unsigned(index)));
		Dbit <= dirty_bit(to_integer(unsigned(index)));
		Vbit <= valid_bit(to_integer(unsigned(index)));
	elsif(rd = '0' and wr = '1')then
		tag_bits(to_integer(unsigned(index))) <= tagsin;
		dirty_bit(to_integer(unsigned(index)))<= Dbitin;
		valid_bit(to_integer(unsigned(index)))<= Vbitin;
    	end if;
    end process;
    
end TVD_arch;








