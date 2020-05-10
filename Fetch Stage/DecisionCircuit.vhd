LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY decision IS
GENERIC (n:integer:=32);
	PORT (
		PCnew        : IN  std_logic_vector(n-1 downto 0); --PC after incremented 
		JZ    		 : IN  std_logic;
		state 		 : IN  std_logic_vector(1 downto 0);
		TNT   		 : IN  std_logic; --Taken=1 / notTaken=0
		targetAddress: IN  std_logic_vector(n-1 downto 0);
		PC_memory 	 : IN  std_logic_vector(n-1 downto 0);
		PC_branch 	 : IN  std_logic_vector(n-1 downto 0);
		rst,clk		 : IN  std_logic;
		PCnext  	 : OUT std_logic_vector(n-1 downto 0)
	);
END ENTITY;

ARCHITECTURE decisionArch of decision is

begin
	
process(clk) 
begin 
if JZ='1'  then
  PCnext <=PC_branch;
end if;

if TNT='1' then  --if taken decision 
  PCnext <=targetAddress;
end if;


end process;


END ARCHITECTURE;



