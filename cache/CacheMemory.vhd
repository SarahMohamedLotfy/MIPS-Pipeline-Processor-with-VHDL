library ieee;
use ieee.std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity cache is
port(
    clk, memwr, memrd : in std_logic;             --from ram
    rd, wr : in std_logic;                        --from proocessor
    datain: in std_logic_vector(15 downto 0);     --from processor
    dataram: in std_logic_vector(127 downto 0);   --from ram
    address: in std_logic_vector(10 downto 0);
    dataout : out std_logic_vector(15 downto 0);  --to processor
    datarout : out std_logic_vector(127 downto 0) --to ram
);
end cache;


architecture cache_data of cache is
type cacheMem is array (31 downto 0) of STD_LOGIC_VECTOR (127 downto 0);
signal data_array : cacheMem;
signal sig_indx : std_logic_vector(127 downto 0);
signal sig : std_logic_vector(127 downto 0);
begin
    
    process(clk)
    begin
    if rising_edge(Clk) then
        if(rd = '1' and memwr = '0' and memrd = '0') then
            sig_indx <= data_array(to_integer(unsigned(address(7 downto 3))));
            --dataout <= sig_indx(9 downto 6);
            --dataout <= data_array(1)(0);
	   case address(2 downto 0) is
            when "000" =>
                dataout <= sig_indx(15 downto 0);
            when "001" =>
                dataout <= sig_indx(31 downto 16);
            when "010" =>
                dataout <= sig_indx(47 downto 32);
            when "011" =>
                dataout <= sig_indx(63 downto 48);
	    when "100" =>
                dataout <= sig_indx(79 downto 64);
            when "101" =>
                dataout <= sig_indx(95 downto 80);
            when "110" =>
                dataout <= sig_indx(111 downto 96);
            when "111" =>
                dataout <= sig_indx(127 downto 112);
            when others => -- 'U', 'X', '-', etc.
                dataout <= (others => 'X');

        end case;
        elsif(wr = '1' and  memwr = '0' and memrd = '0') then
          --data_array(to_integer(unsigned(address(7 downto 3)))) <= datain;
          --data_array(3)<= datain;
          sig_indx <= data_array(to_integer(unsigned(address(7 downto 3))));
          case address(2 downto 0) is
            when "000" =>
                data_array(to_integer(unsigned(address(7 downto 3)))) <= sig_indx(127 downto 16) & datain;
            when "001" =>
                data_array(to_integer(unsigned(address(7 downto 3)))) <= sig_indx(127 downto 32) & datain & sig_indx(15 downto 0);
            when "010" =>
                data_array(to_integer(unsigned(address(7 downto 3)))) <= sig_indx(127 downto 48) & datain & sig_indx(31 downto 0);
            when "011" =>
                data_array(to_integer(unsigned(address(7 downto 3)))) <= sig_indx(127 downto 64) & datain & sig_indx(47 downto 0);
	    when "100" =>
                data_array(to_integer(unsigned(address(7 downto 3)))) <= sig_indx(127 downto 80) & datain & sig_indx(63 downto 0);
            when "101" =>
                data_array(to_integer(unsigned(address(7 downto 3)))) <= sig_indx(127 downto 96) & datain & sig_indx(79 downto 0);
            when "110" =>
                data_array(to_integer(unsigned(address(7 downto 3)))) <= sig_indx(127 downto 112) & datain & sig_indx(95 downto 0);
            when "111" =>
                data_array(to_integer(unsigned(address(7 downto 3)))) <= datain & sig_indx(111 downto 0);
            when others => -- 'U', 'X', '-', etc.
                data_array(to_integer(unsigned(address(7 downto 3)))) <= (others => 'X');
            end case;
        elsif(memwr = '1') then
            data_array(to_integer(unsigned(address(7 downto 3)))) <= dataram;

	elsif(memrd = '1') then
            datarout <= data_array(to_integer(unsigned(address(7 downto 3))));

	end if;
    end if;
    end process;
end cache_data;
