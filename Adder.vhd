Library ieee;
Use ieee.std_logic_1164.all;
 
------------------------------------------------------
ENTITY adder IS

Generic ( n : integer := 16);
PORT(a, b : in std_logic_vector(n-1 downto 0);
	cin : in std_logic;
	s : out std_logic_vector(n-1 downto 0);
	cout : out std_logic);
END adder;

------------------------------------------------
Architecture adderArch of adder is
 
 -- (here we add the previous full adder) ----
component FullAdder IS  
     PORT( 
               a,b,cin : IN STD_LOGIC;
               s,cout : OUT STD_LOGIC
          );
END component;

	--- define intermidate wires
	signal tmp : std_logic_vector(n-1 downto 0);

	begin

		f0 : FullAdder port map(a(0),b(0),cin,s(0),tmp(0));
		loop1: for i in 1 to n-1 generate
			fx: FullAdder port map(a(i),b(i),tmp(i-1),s(i),tmp(i));
		end generate;

		cout <= tmp(n-1);

end architecture;