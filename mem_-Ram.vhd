LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY RAMmem IS
	--n is the number of lines retrieved. ex => if n = 1 -> dataOut holds 16 bits
	--if n = 2 -> dataOut holds 32 bits and so on
	GENERIC(n : INTEGER := 2;
	        addressBits : integer :=32);
	PORT(
		CLK : IN std_logic;
		W,R: IN std_logic;

		address : IN  std_logic_vector(addressBits-1 DOWNTO 0);
		
		dataIn  : IN  std_logic_vector(16*n-1 DOWNTO 0);
		dataOut : OUT std_logic_vector(16*n-1 DOWNTO 0));
END ENTITY RAMmem;

ARCHITECTURE syncramamem OF RAMmem IS

	TYPE ram_type IS ARRAY(0 TO 2**11) OF std_logic_vector(15 DOWNTO 0);
	SIGNAL ram : ram_type ;
	
	BEGIN
		PROCESS(CLK, W, R , address) IS
		VARIABLE adds:INTEGER;
			BEGIN
				if(falling_edge(CLK))then	
					IF W = '1' THEN
                                loop1: for i in 0 to n-1 loop
                                       if i=0 then
										adds := to_integer(unsigned(address));
										ram(adds) <= dataIn(15 downto 0);
										elsif i=1 then
										adds := to_integer(unsigned(address)) + i;
										ram(adds) <= dataIn(31 downto 16);
										end if;
                                        end loop;
		            elsIF R = '1' THEN
						loop0: for i in 0 to n-1 loop
							if(i=0)then
									adds := to_integer(unsigned(address));
									dataOut(15 downto 0) <= ram(adds);
							else
									adds := to_integer(unsigned(address)) + i;
									dataOut(31 downto 16) <= ram(adds);
							end if;
							
						end loop;
					ELSE 
						dataOut <= (OTHERS=>'Z');
					END IF;
				end if;
		END PROCESS;
		
END syncramamem;