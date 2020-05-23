library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
entity BHT is 
generic (n:integer:=5);
port(ReadIndex,WriteIndex: in std_logic_vector(n-1 downto 0);--read index from current pc ,, write index from decodepc to write new state.
     clk  : in std_logic;
	 Rd: in std_logic:='0'; -- jz =1 
	 Wr: in std_logic:='0';-- T_NT = 00 or 01
	 predictionState: in std_logic_vector(1 downto 0);--from FSM To write
     state: out std_logic_vector(1 downto 0));--Read State To decision circuit
     
     
end BHT;

architecture BHTarch of BHT is 

TYPE index_type IS ARRAY(0 TO (2**n)-1) OF std_logic_vector(1 DOWNTO 0);
	SIGNAL table : index_type:=(others=>"01");--weakly not taken as initial state.

begin 

		PROCESS(clk,Wr,Rd) IS
		begin
		if rising_edge(clk) then
			if Wr='1' then--write
				table(to_integer(unsigned(WriteIndex))) <= predictionState;
			end if;
		end if;
		
		
		END PROCESS;
		
		state <= table(to_integer(unsigned(ReadIndex))) when Rd='1' else (OTHERS => 'Z' );
 


end BHTarch;

