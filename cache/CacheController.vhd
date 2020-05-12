library ieee;
use ieee.std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity controller is
port(
    tag :in std_logic_vector(2 downto 0);
    index : in std_logic_vector(4 downto 0);
    clk, wr, rd : in std_logic;
    rd_c, wr_c : out std_logic;
    rd_r, wr_r : out std_logic;
    ram_ready : in std_logic;
    --cache, ram : out std_logic;
    hit, miss :out std_logic
);
end controller;


architecture controller_arch of controller is

component TVD is
port (
    index : in std_logic_vector(4 downto 0);
    clk,wr,rd : in std_logic;

    tagsin : in std_logic_vector(2 downto 0);
    Dbitin : in std_logic;
    Vbitin : in std_logic;

    tags : out std_logic_vector(2 downto 0);
    Dbit : out std_logic;
    Vbit : out std_logic);
end component;

type states is (start, read_ram, read_miss, write_miss, write_cache);
signal current_state : states := start;
signal next_state : states:= start;


signal sig_indx : std_logic_vector(4 downto 0);
signal sig_wr : std_logic;
signal sig_rd : std_logic;
signal sig_dbin : std_logic;
signal sig_vdin : std_logic;
signal sig_tagin : std_logic_vector(2 downto 0);
signal sig_dbout : std_logic;
signal sig_vdout : std_logic;
signal sig_tagout : std_logic_vector(2 downto 0);

begin

    f0:TVD port map(sig_indx, clk ,sig_wr ,sig_rd ,sig_tagin ,sig_dbin ,sig_vdin ,sig_tagout ,sig_dbout ,sig_vdout);

    process(current_state)           
    begin
 --if(rising_edge(clk))then
    if(current_state = start)then
	     hit <='0';
	     miss <= '0';
	     rd_c <='0' ;
 	     wr_c <='0' ;
             rd_r <='0' ;
             wr_r <='0' ;
	  sig_indx <= index;
    	  sig_wr <= '0';
    	  sig_rd <= '1';
    	  sig_dbin <= '0';
    	  sig_vdin <= '0';
    	  sig_tagin <= "000";
	if(rd = '1' and wr = '0')then
	  if(tag = sig_tagout and sig_vdout = '1')then
	     hit <='1';
	     miss <= '0';
	     rd_c <='1' ;
 	     wr_c <='0' ;
             rd_r <='0' ;
             wr_r <='0' ;
	  else
             hit <='0';
             miss <= '1';
	     rd_c <='0' ;
 	     wr_c <='0' ;
             rd_r <='0' ;
             wr_r <='0' ;
	     current_state <= read_miss;
          end if;


	if(rd = '0' and wr = '1')then
	  if(tag = sig_tagout)then
	     hit <='1';
	     miss <= '0';
             rd_c <='0' ;
 	     wr_c <='1' ;
             rd_r <='0' ;
             wr_r <='0' ;
	  else
             miss <= '1';
             hit <= '0' ;
             rd_c <='0' ;
 	     wr_c <='0' ;
             rd_r <='0' ;
             wr_r <='0' ;
	     current_state <= read_miss;
          end if;
	end if;


     elsif(current_state = read_miss)then
	  if(sig_dbout = '0' or sig_vdout ='0')then
	     hit <= '0';
	     miss <= '1';
             rd_c <='0' ;
 	     wr_c <='0' ;
             rd_r <='1' ;
             wr_r <='0' ;
	     current_state <= read_ram;
          else
    	     hit <= '0';
	     miss <= '1';
             rd_c <='1' ;
 	     wr_c <='0' ;
             rd_r <='0' ;
             wr_r <='0' ;
	     current_state <= write_cache;
          end if;
     elsif(current_state = read_ram)then
	  if(ram_ready = '1' and rd = '1')then
             sig_indx <= index;
    	     sig_wr <= '0';
    	     sig_rd <= '1';
    	     sig_dbin <= '0';
    	     sig_vdin <= '1';
    	     sig_tagin <= tag;

	     hit <='1';
	     miss <= '0';
             rd_c <='1' ;
 	     wr_c <='0' ;
             rd_r <='0' ;
             wr_r <='0' ;
	  elsif(ram_ready = '1' and wr = '1')then
	     sig_indx <= index;
    	     sig_wr <= '1';
    	     sig_rd <= '0';
    	     sig_dbin <= '1';
    	     sig_vdin <= '1';
    	     sig_tagin <= tag;

             hit <='1';
	     miss <= '0';
             rd_c <='0' ;
 	     wr_c <='1' ;
             rd_r <='0' ;
             wr_r <='0' ;
	  end if;
     elsif(current_state = write_cache)then
 	  if(ram_ready = '1')then
	     hit <='0';
	     miss <= '1';
             rd_c <='0' ;
 	     wr_c <='0' ;
             rd_r <='0' ;
             wr_r <='1' ;
	     current_state <= write_miss;
	  end if;

      elsif(current_state = write_miss)then
 	  if(ram_ready = '1')then
	     hit <= '0';
	     miss <= '1';
             rd_c <='0' ;
 	     wr_c <='0' ;
             rd_r <='1' ;
             wr_r <='0' ;
	     current_state <= read_ram;
	  end if;

--/////////////////////////////////||||||||\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\--

--     elsif(current_state = write_miss)then
--	  if(sig_dbout = '0' or sig_vdout ='0')then
--	     hit <= '0';
--	     miss <= '1';
--	     rd_c <='1' ;
-- 	     wr_c <='0' ;
--             rd_r <='0' ;
--             wr_r <='0' ;
--	     current_state <= read_ram;
--          else
--    	     hit <= '0';
--	     miss <= '1';
--             rd_c <='1' ;
-- 	     wr_c <='0' ;
--             rd_r <='0' ;
--             wr_r <='0' ;
--	     current_state <= write_cache;
--          end if;

--/////////////////////////////////||||||||\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\--


    end if;
 end if;
 --end if;
    end process;

end controller_arch;

