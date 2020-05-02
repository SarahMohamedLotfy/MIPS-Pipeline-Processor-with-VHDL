LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY decision IS
GENERIC (n:integer:=16);
	PORT (
		PCreg		:	IN	std_logic_vector(n-1 downto 0);
		rst,clk	:	IN	std_logic;
		PCnext		:	OUT	std_logic_vector(n-1 downto 0)
	);
END ENTITY;

ARCHITECTURE decisionArch of decision is
signal dummy: std_logic;
component adder IS

Generic ( n : integer := 16);
PORT(a, b : in std_logic_vector(n-1 downto 0);
	cin : in std_logic;
	s : out std_logic_vector(n-1 downto 0);
	cout : out std_logic);
END component;

begin


a0:adder port map(PCreg,"0000000000000001",'0',PCnext,dummy);--incrment pc by 2 

END ARCHITECTURE;



