library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.bus_multiplexer_pkg.all;

entity mux is
        generic (bus_width : integer := 8;
                sel_width : integer := 2);
        port (  input : in bus_array(2**sel_width - 1 downto 0)(bus_width - 1 downto 0);
                sel : in std_logic_vector(sel_width - 1 downto 0);
                output : out std_logic_vector(bus_width - 1 downto 0));
end mux;

architecture dataflow of mux is
begin
        output <= input(to_integer(unsigned(sel)));
end dataflow;