LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
use STD.TEXTIO.all;


ENTITY RAM IS
	GENERIC (word_size : integer := 32;
	        address_width: integer := 14;
		    RAM_size: integer := 16384); --2^14 slot
	PORT(	
		CLK,WR,EN  : IN std_logic;
		address: IN  std_logic_vector(address_width-1 DOWNTO 0);
        data_OUT : IN  std_logic_vector(word_size-1 DOWNTO 0)
		data_OUT : OUT  std_logic_vector(word_size-1 DOWNTO 0));
		
END ENTITY RAM;

ARCHITECTURE RAM_arch OF RAM IS
        type ram_type is array (0 to RAM_size-1) of std_logic_vector(word_size - 1 DOWNTO 0) ;

shared variable RAM_data : ram_type:= (others => (others =>'0'));
BEGIN

process(CLK,EN)--for port 3  IO Read/Write port
begin 
if EN='0'  then
    data_OUT <=(others=>'Z');
elsif(EN ='1') then
    if (falling_edge(CLK)) then
        if(WR ='1') then
            RAM_data(to_integer(unsigned(address))) := data_IN;
        end if;
    end if;
    if WR = '0' then
        data_OUT <= RAM_data(to_integer(unsigned(address)));
    end if;    
end if;
end process;

 
end architecture;