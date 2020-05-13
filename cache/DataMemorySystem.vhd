library ieee;
use ieee.std_logic_1164.all;

entity dataMemorySys is
port(
    clk, memwrite, memread : in std_logic;
    datain: in std_logic_vector(15 downto 0);
    address: in std_logic_vector(10 downto 0);
    stall : out std_logic;
    dataout : out std_logic_vector(15 downto 0)
);
end dataMemorySys;

architecture dataMemorySysArch of dataMemorySys is

component controller is
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
end component;

component cache is
port(
    clk, memwr, memrd : in std_logic;             --from ram
    rd, wr : in std_logic;                        --from proocessor
    datain: in std_logic_vector(15 downto 0);     --from processor
    dataram: in std_logic_vector(127 downto 0);   --from ram
    address: in std_logic_vector(10 downto 0);
    dataout : out std_logic_vector(15 downto 0);  --to processor
    datarout : out std_logic_vector(127 downto 0) --to ram
);
end component;

component dataMemory is
port(
    clk : in std_logic;
    rd, wr : in std_logic;
    datain: in std_logic_vector(127 downto 0);
    address: in std_logic_vector(10 downto 0);
    dataout : out std_logic_vector(127 downto 0);
    ready :out std_logic:= '0'
);
end component;

component mux is
    port(sel:in STD_LOGIC_vector (2 downto 0);
         input:in STD_LOGIC_VECTOR(127 downto 0);
	 output: out std_logic_vector(15 downto 0)
     );
end component;

signal index_in : std_logic_vector(4 downto 0) := address(7 downto 3);
signal tag_in : std_logic_vector(2 downto 0) := address(10 downto 8);
signal sele : std_logic_vector(2 downto 0) := address(2 downto 0);
signal ram_readyout : std_logic;
--signal cache_out : std_logic;
--signal ram_out : std_logic;
signal hit_out : std_logic;
signal miss_out : std_logic;

signal ram_wr : std_logic;
signal ram_rd : std_logic;
signal cah_wr : std_logic;
signal cah_rd : std_logic;

signal dramin : std_logic_vector(15 downto 0);
signal dout : std_logic_vector(15 downto 0);
signal dataramout : std_logic_vector(127 downto 0);--
signal datarout : std_logic_vector(127 downto 0);--
signal data_out : std_logic_vector(127 downto 0);
signal outtt : std_logic_vector(15 downto 0);
signal rammout : std_logic;
signal ramreadyout : std_logic;
signal llmux : std_logic_vector(127 downto 0);


begin

index_in <= address(7 downto 3);
tag_in <= address(10 downto 8);

CC : controller port map(tag_in, index_in, clk, memwrite, memread, cah_rd, cah_wr, ram_rd, ram_wr, ram_readyout, hit_out, miss_out );
cach : cache port map(clk, memwrite, memread, cah_rd, cah_wr, datain, dataramout, address, dout, datarout);
ram : dataMemory port map(clk, ram_rd, ram_wr, datarout, address, dataramout, ram_readyout);

stall <= miss_out;
dataout <= dout;
--CC : controller port map(tag_in, index_in, clk, memwrite, memread, ram_readyout, cache_out , ram_out , hit_out, miss_out);
--cach : cache port map(clk, cah_wr, cah_rd, datarout, address , data_out);
--ram : dataMemory port map(clk, ram_wr, ram_rd, dramin, address, dataramout, ramreadyout);
--mx : mux port map(sele, llmux , outtt);


--CC : controller port map(tag_in, index_in, clk, memwrite, memread, ramreadyout, cache_out , ram_out , hit_out, miss_out);
--cach : cache port map(clk, memwrite, memread, dataramout, address,  ram_out , data_out);
--ram : dataMemory port map(clk, memwrite, memread, dramin, address, dataramout, ramreadyout);
--mx : mux port map(sele, data_out , outtt);
--dataout <= outtt;

--process(clk,ram_readyout, cache_out , ram_out , hit_out, miss_out)
--begin
----if (rd = '1' and wr ='0')then
----  if(hit_out = '1')then
----     cah_rd <= '1';
------  elsif(miss_out = '1')then
------     
------end if;
------elsif(rd = '0' and wr ='1')then
------   if(hit_out = '1')then
------     cah_wr <= '1';
----   end if;
----
----end if;
--
--end process;

end dataMemorySysArch;
