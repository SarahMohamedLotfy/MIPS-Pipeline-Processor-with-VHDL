library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory is 
port(	
  reset, clk: in std_logic;

  EX_MEM:in std_logic_vector(114 downto 0);

  Rsrc2,ALUresult, MemoryReuslt,MemoryPC :out std_logic_vector(31 downto 0);
  SWAP,MemoryReadSignalToFetch :out std_logic;
  Rt,Rd,WBsignals :out std_logic_vector(2 downto 0)
 
);
end entity;

architecture memory_arch of memory is
---------------------------------SP Signaaaaaaaals-----------------------------------
----------------------/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\-------------------------
signal SP_input:std_logic_vector(31 downto 0);
signal SP_output:std_logic_vector(31 downto 0);
signal circ_output:std_logic_vector(31 downto 0);
----------------------/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\--------------------------
---------------------------------SP Signaaaaaaaals------------------------------------

	signal interrupt,RRI:  std_logic;
	signal MEMsignals: std_logic_vector(3 downto 0);
	signal CRR : std_logic_vector(2 downto 0);
        --signal tmp:std_logic_vector(15 downto 0);
        signal outputMEm :std_logic_vector(31 downto 0);
	--signal spType :std_logic_vector(2-1 downto 0);
	signal Address : std_logic_vector(31 downto 0);
	signal notSig : std_logic;
  
begin

with reset select
        SP_input <= 
                  circ_output  when '0',
                  "00000000000000000000011111111111"  when '1',
                  "00000000000000000000000000000000" when others;

with reset select
        notSig <= 
                  '1'  when '1',
                  EX_MEM(110)or EX_MEM(111)  when '0',
                  '0' when others;

--notSig <= not EX_MEM(109);
SP:entity work.Reg(RegArch) generic map(n=>32) port map(
input => SP_input,
en => notSig,
rst => '0',
clk => clk,
output => SP_output
);

circ:entity work.IncDec(behav) port map(
SPtype => EX_MEM(108),
SP => SP_output,
SPout => circ_output
);

mux:entity work.mux8(behavioral) port map(
sel => EX_MEM(109 downto 108),
add => EX_MEM( 99 downto 68),
SP2 => circ_output,
SP1 => SP_output,
output => Address
);

DM: entity work.ram_mem generic map(2) port map (clk,
W => EX_MEM(110),
R => EX_MEM(111),
address =>Address,
dataIn => EX_MEM( 67 downto 36),
dataOut=>outputMEm);

Rsrc2 <= EX_MEM( 31 downto 0);
SWAP <= EX_MEM(32);
Rt <= EX_MEM( 35 downto 33);
ALUresult <= EX_MEM( 67 downto 36);
--Address <= EX_MEM( 99 downto 68);
Rd<= EX_MEM( 102 downto 100);
interrupt<= EX_MEM(103);
RRI<= EX_MEM(104);
CRR<= EX_MEM(107 downto 105);
MEMsignals<=EX_MEM(111 downto 108);

WBsignals<=EX_MEM(114 downto 112);

MemoryReuslt<= outputMEm when EX_MEM(108)='1' else (others=>'0');
--TODO 
--MemoryReadSignalToFetch from memory stage decision circuit in RTI or RET or reset or INT become 1 to make PC reg read 
--its value from PC memory which is read from data memory.
MemoryReadSignalToFetch<='0';
MemoryPC<=(others=>'0');  
end architecture;




