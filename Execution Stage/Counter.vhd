library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Counter is
	generic(n: integer := 1);
	port(
		enable:in std_logic;
		reset:in std_logic:='0';
		clk:in std_logic;
		output:out std_logic_vector(n-1 downto 0)
		);
end Counter;

architecture CounterImplementation of Counter is

	signal toOutput: std_logic_vector( n-1 downto 0);
	signal addResult: std_logic_vector( n-1 downto 0);
    signal dummy: std_logic;
    signal one: std_logic_vector ( n-1 downto 0);
	signal zero: std_logic_vector (n-2 downto 0);
    Begin
	zero <= (others => '0');
	one <= zero &'1'  ;
    PCAdder:entity work.adder generic map(n)port map(toOutput,one,'0',addResult,dummy);

	process(enable,reset,clk)
    begin
    if (rising_edge(clk))then
		if (reset = '1') then
			toOutput <= (others => '0');
		
      
		elsif(enable = '1') then
			toOutput <= addResult;
		end if;
	end if;	
	end process;
	output <= toOutput;
end CounterImplementation;