library ieee;
use ieee.std_logic_1164.all;
use IEEE.Numeric_Std.all;
entity MemorySystem is
  port (
    clk,rst,WR,RD,Instr,Data:IN std_logic;
    address:IN std_logic_vector(31 downto 0);
    Datain:IN std_logic_vector(31 downto 0);
    DataStall,InstrStall:out std_logic;
    DataOut:out std_logic_vector(31 downto 0)
  ) ;
end MemorySystem ;

architecture arch of MemorySystem is
signal BusDataIND,BusDataOUTD,BusDataINI,BusDataOUTI:std_logic_vector(127 downto 0);
signal DataOutI,DataOutD:std_logic_vector(31 downto 0);
-----------------------------------------------------Address Sections--------------------------------------
signal tag,Offset:std_logic_vector(2 downto 0);
signal index:std_logic_vector(4 downto 0);
----------------------------------------------------------------------------------------------------------
signal hit_miss:std_logic;
---------------------------------------------------Data controller Signals-------------------------------------
signal memoryReadyFromMainMemoryFromData:std_logic;
signal CacheRead,CacheWrite,Cache_Bus_Read,Cache_Bus_Write,Memory_Bus_Read,Memory_Bus_Write,Dhit_miss:std_logic:='0';    
----------------------------------------------------------------------------------------------------------
---------------------------------------------------Instr controller Signals-------------------------------------
signal memoryReadyFromMainMemoryFromInstr:std_logic;
signal ICacheRead,ICache_Bus_Read,ICache_Bus_Write,IMemory_Bus_Read,IMemory_Bus_Write,Ihit_miss,InstrstallSig:std_logic:='0';    
----------------------------------------------------------------------------------------------------------


---------------------------------------------------Main Memory Signals-------------------------------------
signal memoryReady:std_logic;
signal MainMemoryAddress:std_logic_vector(10 downto 0);
signal CounterValue:std_logic_vector(1 downto 0);
signal counterReset:std_logic;-- when hit =1 then reset counter.
signal DataControllerRst,InstrControllerRst:std_logic;

----------------------------------------------------------------------------------------------------------

begin
DataOut(31 downto 16) <= DataOutD(31 downto 16) when (Data ='1') else (others=>'0') when (Data='0' and Instr ='1');
DataOut(15 downto 0) <= DataOutD(15 downto 0) when (Data ='1') else DataOutI(15 downto 0) when (Data='0' and Instr ='1'); 

DataControllerRst <= not Data or rst;
InstrControllerRst<= not(Instr) or Data or rst;

InstrStall<= InstrstallSig when (Instr ='1' and Data='0') else '1' when (Data='1' and Instr='1');-- for structural hazard Data has higher priority.

tag <= address(10 downto 8);
Offset <= address(2 downto 0);
index<= address(7 downto 3);
MainMemoryAddress<=address(10 downto 0);
counterReset<=hit_miss or rst;
hit_miss<=Dhit_miss or Ihit_miss;
DataMemoryController:entity work.controller port map(tag=>tag,index=>index,clk=>clk,rst=>DataControllerRst, wr=>WR, rd=>RD,memory_ready=>memoryReadyFromMainMemoryFromData,


Cache_read=>CacheRead, Cache_write=>CacheWrite,Cache_Bus_Write=>Cache_Bus_Write
,Memory_Bus_Read=>Memory_Bus_Read,Cache_Bus_Read=>Cache_Bus_Read,Memory_Bus_Write=>Memory_Bus_Write,
hit_miss=>Dhit_miss,Stall=>DataStall);

InstrMemoryController:entity work.instrcontroller port map(tag=>tag,index=>index,clk=>clk,rst=>InstrControllerRst,rd=>RD,memory_ready=>memoryReadyFromMainMemoryFromInstr,

Cache_read=>ICacheRead,Cache_Bus_Write=>ICache_Bus_Write
,Memory_Bus_Read=>IMemory_Bus_Read,Cache_Bus_Read=>ICache_Bus_Read,Memory_Bus_Write=>IMemory_Bus_Write,
hit_miss=>Ihit_miss,Stall=>InstrstallSig);







DataMainMemory:entity work.mainmemory port map(clk=>clk,rst=>counterReset,busRead=>Memory_Bus_Read,busWrite=>Memory_Bus_Write,
address=>MainMemoryAddress,
BusDataIN=>BusDataIND,
BusDataOUT=>BusDataOUTD,
counter=>CounterValue,
readySignal=>memoryReadyFromMainMemoryFromData);    


InstrMainMemory:entity work.mainmemory port map(clk=>clk,rst=>counterReset,busRead=>IMemory_Bus_Read,busWrite=>IMemory_Bus_Write,
address=>MainMemoryAddress,
BusDataIN=>BusDataINI,
BusDataOUT=>BusDataOUTI,
counter=>CounterValue,
readySignal=>memoryReadyFromMainMemoryFromInstr); 



DataCache:entity work.datacache  port Map(clk=>clk,BusRead=>Cache_Bus_Read,BusWrite=>Cache_Bus_Write,
CacheRead=>CacheRead,CacheWrite=>CacheWrite,
index=>index,
Offset=>Offset,
Counter=>CounterValue,
dataIn=>Datain,
dataOut=>DataOutD,
BusDataIN=>BusDataOUTD,
BusDataOUT=>BusDataIND);

InstrCache:entity work.instrcache  port Map(clk=>clk,BusRead=>ICache_Bus_Read,BusWrite=>ICache_Bus_Write,
CacheRead=>ICacheRead,
index=>index,
Offset=>Offset,
Counter=>CounterValue,
dataOut=>DataOutI,
BusDataIN=>BusDataOUTI,
BusDataOUT=>BusDataINI);

CounterProcess: process(clk, counterReset,CounterValue,Cache_Bus_Read,Cache_Bus_Write,Memory_Bus_Read,Memory_Bus_Write,ICache_Bus_Read,ICache_Bus_Write,IMemory_Bus_Read,IMemory_Bus_Write)
begin
    if(rising_edge(clk))then
        if counterReset = '1' then
            CounterValue <="00";
        elsif (Cache_Bus_Read='1' or Cache_Bus_Write='1' or Memory_Bus_Read='1' or Memory_Bus_Write='1' or ICache_Bus_Read='1' or ICache_Bus_Write='1' or IMemory_Bus_Read='1' or IMemory_Bus_Write='1') then
            CounterValue <=std_logic_vector(unsigned(CounterValue)+1);
        end if;
    end if;
end process CounterProcess;




end architecture ; -- arch