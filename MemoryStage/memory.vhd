library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory is 
port(	
  reset, clk: in std_logic;

  EX_MEM:in std_logic_vector(114 downto 0);

  Rsrc2,ALUresult, MemoryReuslt,MemoryPC :out std_logic_vector(31 downto 0);
  SWAP,MemoryReadSignalToFetch,rd,Wr :out std_logic;
  Rs,Rd,WBsignals :out std_logic_vector(2 downto 0)
  DataToWrite=>MemoryDataToWrite,DataRead=>,DataRequest=>DataRequest,
);
end entity;

architecture memory_arch of memory is
 

	signal interrupt,RRI:  std_logic;
	signal MEMsignals: std_logic_vector(3 downto 0);
	signal CRR : std_logic_vector(2 downto 0);

	signal spType :std_logic_vector(2-1 downto 0);
	signal Address : std_logic_vector(31 downto 0);
	
  
begin
  
Rsrc2 <= EX_MEM( 31 downto 0);
SWAP<= EX_MEM(32);
Rs <= EX_MEM( 35 downto 33);
ALUresult<= EX_MEM( 67 downto 36);
Address<= EX_MEM( 99 downto 68);
Rd<= EX_MEM( 102 downto 100);
interrupt<= EX_MEM(103);
RRI<= EX_MEM(104);
CRR<= EX_MEM(107 downto 105);
MEMsignals<=EX_MEM(111 downto 108);

WBsignals<=EX_MEM(114 downto 112);

MemoryReuslt<=(others=>'0');
--TODO 
--MemoryReadSignalToFetch from memory stage decision circuit in RTI or RET or reset or INT become 1 to make PC reg read 
--its value from PC memory which is read from data memory.
MemoryReadSignalToFetch<='0';
MemoryPC<=(others=>'0');  
end architecture;




