LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY MemoryMain IS
	--n is the number of lines retrieved. ex => if n = 1 -> dataOut holds 16 bits
	--if n = 2 -> dataOut holds 32 bits and so on
	GENERIC(addressBits : integer :=11);
	PORT(
		CLK : IN std_logic;
		W,R : IN std_logic;

		address : IN  std_logic_vector(addressBits-1 DOWNTO 0);

		dataIn  : IN  std_logic_vector(31 DOWNTO 0);
		dataOut : OUT std_logic_vector(31 DOWNTO 0));
END ENTITY MemoryMain;

ARCHITECTURE syncrama OF MemoryMain IS

	TYPE ram_type IS ARRAY(0 TO 2**addressBits -1) OF std_logic_vector(15 DOWNTO 0);
	SIGNAL Memory : ram_type ;
	
	BEGIN
		PROCESS(CLK, W, R , address) IS
		VARIABLE adds:INTEGER;
			BEGIN	
					IF W = '1' THEN
						if(falling_edge(CLK))then
							loopW: for i in 0 to 1 loop
								adds := i + to_integer(unsigned(address));
								if i = 0 then
									Memory(adds) <= dataIn(15 downto 0);
								elsif i=1 then
									Memory(adds) <= dataIn(31 downto 16);
								end if;			
							end loop;
						end if;	
					elsIF R = '1' THEN
						loopR: for i in 0 to 1 loop
							adds := i + to_integer(unsigned(address));
							if i = 0 then
								dataOut(15 downto 0) <= Memory(adds);
							elsif i=1 then
								dataOut(31 downto 16) <= Memory(adds);
							end if;			
						end loop;
					ELSE 
						dataOut <= (OTHERS=>'Z');
					END IF;
				
		END PROCESS;
		
END syncrama;