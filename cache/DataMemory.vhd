library ieee;
use ieee.std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity dataMemory is
port(
    clk : in std_logic;
    rd, wr : in std_logic;
    datain: in std_logic_vector(127 downto 0);
    --datain: in std_logic_vector(15 downto 0);
    --datain: in std_logic_vector(15 downto 0);
    address: in std_logic_vector(10 downto 0);
    dataout : out std_logic_vector(127 downto 0);
    ready :out std_logic:= '0'
);
end dataMemory;


architecture data_array of dataMemory is
type ram is array (2095 downto 0) of STD_LOGIC_VECTOR (15 downto 0);
signal data_array : ram;
--output <= std_logic_vector (3 downto 0);
signal output_int : unsigned (3 downto 0);
begin
    
    process(clk, address)
    VARIABLE k, i, j, adds:INTEGER;

    begin
    k := -16;
    j := -1;
    i := 0;
    if rising_edge(clk) then

        if(wr = '1' and rd = '0') then
            k := k + 16;
	    j := j + 16;
            adds := i + to_integer(unsigned(address));
	    i := i+1;
            data_array(adds) <= datain(j downto k);
            k := k + 16;
	    j := j + 16;
            adds := i + to_integer(unsigned(address));
	    i := i+1;
            data_array(adds) <= datain(j downto k);
            output_int <= output_int -1;
	    
	    if( output_int = 0 )then 
                 ready <='1';
            end if;
	elsif(rd = '1' and wr = '0') then
             k := k + 16;
	     j := j + 16;
	     adds := i + to_integer(unsigned(address));
             i := i+1;
	     dataout(j downto k) <= data_array(adds);
	     k := k + 16;
	     j := j + 16;
             adds := i + to_integer(unsigned(address));
             i := i+1;
	     dataout(j downto k) <= data_array(adds);
	     output_int <= output_int -1; 
	     if( output_int = 0 )then
                  ready <='1';
              end if;
        end if;
    end if;
    
    end process;
end data_array;

