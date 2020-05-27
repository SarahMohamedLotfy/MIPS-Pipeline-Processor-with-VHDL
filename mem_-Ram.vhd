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
		W,R,SP: IN std_logic; -- SP = 1 for inc the address before fetch from memory. 

		address : IN  std_logic_vector(addressBits-1 DOWNTO 0);
		
		dataIn  : IN  std_logic_vector(16*n-1 DOWNTO 0);
		dataOut : OUT std_logic_vector(16*n-1 DOWNTO 0));
END ENTITY RAMmem;

ARCHITECTURE syncramamem OF RAMmem IS

	TYPE ram_type IS ARRAY(0 TO (2**11)+1) OF std_logic_vector(15 DOWNTO 0);
	SIGNAL ram : ram_type ;
	
	BEGIN
	
	 dataOut(15 downto 0) <= ram(to_integer(unsigned(address)+2)) when R ='1' and SP='1' 
	 else  ram(to_integer(unsigned(address))) when R ='1'  and SP='0'
	 else  (others=>'0') when R='0';

	 dataOut(31 downto 16) <= ram(to_integer(unsigned(address)+3)) when R ='1'  and SP='1' 
	 else  ram(to_integer(unsigned(address)+1)) when R ='1'  and SP='0'
	 else  (others=>'0') when R='0';
	 	
	-- PROCESS(clk,R,SP,address) IS
	-- 	VARIABLE adds:INTEGER;
	-- 		BEGIN
	-- 				IF R = '1'  THEN
	-- 				if(falling_edge(clk))then
	-- 					loop0: for i in 0 to n-1 loop
	-- 						if(SP='1')then--inc  	
	-- 							if(i=0)then
	-- 									adds := to_integer(unsigned(address))+2;
	-- 									dataOut(15 downto 0) <= ram(adds);
									
	-- 							elsif (i=1) then
	-- 									adds := to_integer(unsigned(address))+3;
	-- 									dataOut(31 downto 16) <= ram(adds);
	-- 							end if;
	-- 						elsif SP='0' then
	-- 							if(i=0)then
	-- 								adds := to_integer(unsigned(address));
	-- 								dataOut(15 downto 0) <= ram(adds);
								
	-- 							elsif (i=1) then
	-- 									adds := to_integer(unsigned(address)) + i;
	-- 									dataOut(31 downto 16) <= ram(adds);
	-- 							end if;
	-- 						end if;
	-- 					end loop;
	-- 				end if;	
	-- 			end if;
	-- 	END PROCESS;
	PROCESS(CLK,address ,W) IS
		VARIABLE adds:INTEGER;
			BEGIN
					IF W = '1' THEN
						if(falling_edge(CLK))then			
							loop1: for i in 0 to n-1 loop
                                       if i=0 then
										adds := to_integer(unsigned(address));
										ram(adds) <= dataIn(15 downto 0);
										elsif i=1 then
										adds := to_integer(unsigned(address)) + i;
										ram(adds) <= dataIn(31 downto 16);
										end if;
										end loop;
						end if;		
					END IF;
				
		END PROCESS;
		
END syncramamem;