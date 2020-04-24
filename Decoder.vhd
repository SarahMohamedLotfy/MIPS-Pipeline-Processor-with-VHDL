LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.math_real.all;
USE ieee.numeric_std.all;

-- Generic decoder that can be used for any number of selection lines
ENTITY decoder IS
	GENERIC (n : integer := 3;
			 m : integer := 8);

	PORT(	
		    enable           : IN std_logic;
	     	selection_lines  : IN std_logic_vector(n - 1 DOWNTO 0);
            output           : OUT std_logic_vector(m- 1 DOWNTO 0)
	    );

END ENTITY decoder;

ARCHITECTURE decoder_arch of decoder IS
BEGIN
        -- The selection lines are the index of the output bit that should be set.
		loop1: for i in 0 to m-1  generate
		     output(i)<='1' when (to_integer(unsigned(selection_lines))=i) and enable = '1' else '0';
		end generate;

END decoder_arch;
