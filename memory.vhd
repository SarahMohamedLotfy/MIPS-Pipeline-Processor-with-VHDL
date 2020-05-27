library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory is 
port(	
  reset, clk: in std_logic;

  EX_MEM:in std_logic_vector(116 downto 0);
  INTHandlerIN,RTIHandlerIN,RETHandlerIN,CALLHandlerIN:IN std_logic;

  Rsrc2,ALUresult, MemoryReuslt,MemoryPC :out std_logic_vector(31 downto 0);
  SWAP,MemoryReadSignalToFetch,ResumeSignalFromMemory,RTIFlagsEnable :out std_logic;
  Rt,Rd,WBsignals,FlagsOut :out std_logic_vector(2 downto 0)
 
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

	signal interrupt,RET,RTI,CALL:  std_logic;
	signal MEMsignals: std_logic_vector(3 downto 0);
	signal CRR : std_logic_vector(2 downto 0);
        --signal tmp:std_logic_vector(15 downto 0);
        signal outputMEm,INdata,CRRIN :std_logic_vector(31 downto 0);
	signal spType,ControlCircuitSPtype,CounterValue :std_logic_vector(2-1 downto 0):="11";
	signal Address,FlagsControlOut,tempAddress : std_logic_vector(31 downto 0);
	signal notSig,ReadSig,WriteSig,ResumeSignalFromMemorySig : std_logic;
  
begin

  FlagsOut<=FlagsControlOut(2 downto 0);
--DirectAddress<= EX_MEM( 99 downto 68) when reset ='0' and interrupt='0'  else X"00000000" when reset='1' and interrupt='0' else X"00000002" when interrupt='1' and reset='0' else EX_MEM( 99 downto 68); 

SP_input <= circ_output when reset='0' else X"000007FE" when reset ='1';
ResumeSignalFromMemory<=ResumeSignalFromMemorySig when reset='0' else '0' when reset='1';

-- spType <= EX_MEM(109 downto 108) when ((EX_MEM(110) ='1' or EX_MEM(111)='1') and reset ='0' and interrupt='0')   
-- else "11" when (EX_MEM(110) ='0' and EX_MEM(111)='0' and reset ='0' and interrupt='0') 
-- else "10" when (reset ='1')
-- else ControlCircuitSPtype when (reset ='0' and interrupt='1');

-- ReadSig <= EX_MEM(111) when reset ='0' and interrupt='0' else  '1' when reset='1' and interrupt='0';--TODO in case of interrupt and ret and rti
-- WriteSig <= EX_MEM(110) when reset ='0' and interrupt='0' else  '0' when reset='1' and interrupt='0';

--notSig <= '1' when reset='1'  or( WriteSig ='1' or ReadSig='1')else '0' when (spType(1)='1' or ( WriteSig ='0' and ReadSig='0' and reset ='0'));
--notSig <= '1' when (reset='0' and ( ReadSig ='1' or WriteSig='1')) else '0' when  (reset ='1' or ( WriteSig = '0' and ReadSig='0'))else '0';

SP:entity work.reg(RegArch) generic map(n=>32) port map(
input => SP_input,
en => notSig,
rst => '0',
clk => clk,
output => SP_output
);

circ:entity work.incdec port map(
SPtype =>spType,
SP => SP_output,
SPout => circ_output
);

mux:entity work.mux8 port map(
sel => spType,
add => tempAddress,
SP2 => SP_output,--inc 
SP1 => SP_output,--dec
output => Address
);

DM: entity work.rammem generic map(2) port map (clk,
W => WriteSig,
R => ReadSig,
SP => spType(0),
address =>Address,
dataIn => INdata,
dataOut=>outputMEm);

Rsrc2 <= EX_MEM( 31 downto 0);
SWAP <= EX_MEM(32);
Rt <= EX_MEM( 35 downto 33);
ALUresult <= outputMEm when EX_MEM(111)='1'  else EX_MEM( 67 downto 36) when EX_MEM(111)='0';
--Address <= EX_MEM( 99 downto 68);
Rd<= EX_MEM( 102 downto 100);
interrupt<= EX_MEM(103);
RET<= EX_MEM(104);
RTI<=EX_MEM(115);
CALL<=EX_MEM(116);
CRR<= EX_MEM(107 downto 105);
CRRIN(2 downto 0)<=CRR;
CRRIN(31 downto 3)<=(others=>'0');
--memRead 3, memWrite 2, spType 0 1 
MEMsignals<=EX_MEM(111 downto 108);

WBsignals<=EX_MEM(114 downto 112);

MemoryReuslt<= outputMEm when EX_MEM(111)='1'  else (others=>'0');
--TODO 
ControlBlock:entity work.memorystagecontrol port map(
    clk=>clk,INT=>interrupt,RST=>reset,CALL=>CALL,RET=>RET,RTI=>RTI,WRIn=>EX_MEM(110) ,RDIn=>EX_MEM(111),
    ALUdata=>EX_MEM( 67 downto 36),CRRFlags=>CRRIN,AddressIn=>EX_MEM( 99 downto 68),
    DataToWrite=>INdata,Address=>tempAddress,SPIN=>EX_MEM(109 downto 108),MEMOUT=>outputMEm,
    SPType=>spType,MemoryPC=>MemoryPC,INTHandler=>INTHandlerIN,RTIHandler=>RTIHandlerIN,RETHandler=>RETHandlerIN,RTIFlagsEnable=>RTIFlagsEnable,CALLHandler=>CALLHandlerIN,
    WriteSignal=>WriteSig,ReadSignal=>ReadSig,ResumeSignal=>ResumeSignalFromMemorySig,MemoryReadSignal=>MemoryReadSignalToFetch,spEnable=>notSig
  ) ;

--MemoryReadSignalToFetch from memory stage decision circuit in RTI or RET or reset or INT become 1 to make PC reg read 
--its value from PC memory which is read from data memory.
--MemoryReadSignalToFetch<='1' when reset='1' else '0';
--MemoryPC<= outputMEm when reset ='1' or interrupt ='1' else (others=>'0') when reset ='0' and interrupt ='0';  
end architecture;




