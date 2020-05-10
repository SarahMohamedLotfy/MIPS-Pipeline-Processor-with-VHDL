library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
entity BHT is 
generic (n:integer:=5);
port(index: in std_logic_vector(n-1 downto 0);
     reset: in std_logic:='0';
	 clk  : in std_logic;
     RW: in std_logic:='0';--read = 0 , write = 1
	 predictionState: in std_logic_vector(1 downto 0);
     state: out std_logic_vector(1 downto 0));
     
     
end BHT;

architecture BHTarch of BHT is 

TYPE index_type IS ARRAY(0 TO 31) OF std_logic_vector(1 DOWNTO 0);
	SIGNAL table : index_type ;

begin 

		PROCESS(clk,RW , table) IS
		begin
		if rising_edge(clk) then
		if RW='1' then--write
			table(to_integer(unsigned(index))) <= predictionState;
		end if;
		end if;
		
		
		END PROCESS;
		
		state <= table(to_integer(unsigned(index))) when RW='0' else (OTHERS => 'Z' );
 


end BHTarch;

