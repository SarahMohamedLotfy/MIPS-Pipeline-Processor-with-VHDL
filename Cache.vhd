LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY Cache IS
	--n is the number of lines retrieved. ex => if n = 1 -> dataOut holds 16 bits
	--if n = 2 -> dataOut holds 32 bits and so on
	GENERIC(n : INTEGER := 2);
	PORT(
		CLK : IN std_logic;
		W,R : IN std_logic;

		index : IN  std_logic_vector(4 DOWNTO 0);
        Offset: IN std_logic_vector(2 downto 0);
		dataIn  : IN  std_logic_vector(31 DOWNTO 0);
		dataOut : OUT std_logic_vector(16*n-1 DOWNTO 0));
END ENTITY Cache;

ARCHITECTURE syncrama OF Cache IS
    type Block_type is Array(0 to 15) of std_logic_vector(15 DOWNTO 0);
    TYPE ram_type IS ARRAY(0 TO 31) OF Block_type;

	SIGNAL Cache : ram_type ;
	
	BEGIN
    PROCESS(CLK, W, R , Offset,index,dataIn) IS
    VARIABLE offs:INTEGER;
        BEGIN	
                IF W = '1' THEN
                if(falling_edge(CLK))then
                    loopW: for i in 0 to n-1 loop
                        offs := i + to_integer(unsigned(Offset));
                        if i = 0 then
                            Cache(to_integer(unsigned(Index)))(offs) <= dataIn(15 downto 0);
                        elsif i=1 then
                            Cache(to_integer(unsigned(Index)))(offs) <= dataIn(31 downto 16);
                        end if;			
                    end loop;	
                end if;
                elsIF R = '1' THEN
                    loopR: for i in 0 to n-1 loop
                        offs := i + to_integer(unsigned(Offset));
                        if i = 0 then
                            dataOut(15 downto 0) <= Cache(to_integer(unsigned(Index)))(offs);
                        elsif i=1 then
                            dataOut(31 downto 16) <= Cache(to_integer(unsigned(Index)))(offs);
                        end if;			
                    end loop;
                ELSE 
                    dataOut <= (OTHERS=>'Z');
                END IF;
            
    END PROCESS;
		
END syncrama;