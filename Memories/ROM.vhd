LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
use STD.TEXTIO.all;


ENTITY ROM IS
	GENERIC (word_size : integer := 16;
	        address_width: integer := 14;
		    ROM_size: integer := 16384); --2^14 slot
	PORT(	
		CLK,EN  : IN std_logic;
		address: IN  std_logic_vector(address_width-1 DOWNTO 0);
		data_OUT : OUT  std_logic_vector(word_size-1 DOWNTO 0));
		
END ENTITY ROM;

ARCHITECTURE ROM_arch OF ROM IS
        type rom_type is array (0 to ROM_size-1) of std_logic_vector(word_size - 1 DOWNTO 0) ;
       



-------------------------------------------------------------------------------------------------------------------
	-- Initialise the RAM from text file 	
	SUBTYPE function_output is rom_type;
  	IMPURE FUNCTION init_ROM RETURN function_output is
		VARIABLE ROM_content : rom_type;
		VARIABLE text_line : line;
		VARIABLE count: integer;
		File ROM_file: TEXT open READ_MODE is "ROM.txt";
	BEGIN
		 count := 0;
  		 WHILE not ENDFILE(ROM_file) LOOP
     			readline(ROM_file, text_line);
     			bread(text_line,ROM_content(count) );
			count := count + 1;
  		 END LOOP;
		 file_close(ROM_file);
  		 RETURN ROM_content;
		 
	END FUNCTION init_ROM;
-------------------------------------------------------------------------------------------------------------------
	SIGNAL ROM_data : ram_type:=init_ROM;

BEGIN

process(CLK,EN)--for port 2  Euler 2 Read only port
begin 
if EN='0'  then
    data_OUT <=(others=>'Z');
elsif(EN ='1') then
    data_OUT <= ROM_data(to_integer(unsigned(address)));
end if;       
end process;

 
end architecture;