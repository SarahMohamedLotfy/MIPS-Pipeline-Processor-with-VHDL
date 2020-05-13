LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
entity DecodeStage is
  port (
      clk,rst,INT,Mux_Selector:IN std_logic;
      IF_ID:IN std_logic_vector(82 downto 0);
      RegWriteFromWB,SWAPFromWB:IN std_logic;
      MEM_WBRd,MEM_WBRs,RsFromFetch:IN std_logic_vector(2 downto 0);
      Value1,Value2:IN std_logic_vector(31 downto 0);

      TargetAddress,SRC1,SRC2,instruction,PC,INPORTValueDecodeOut:OUT std_logic_vector(31 downto 0);--Target address to fetch stage at the same cycle
      RRI,SWAP,CALL,INTOut,SignExtendSignal,IMM_EASignal,RegDST,InEnable,sig32_16,IF_IDWrite:OUT std_logic;
      WBSignals:OUT std_logic_vector(2 downto 0);
      ALUSelectors,MEMSignals:OUT std_logic_vector(3 downto 0);
      T_NT:OUT std_logic_vector(1 downto 0)
  ) ;
end DecodeStage ;

architecture arch of DecodeStage is
signal CRR:std_logic;
begin
RegisterFile:entity work.decoder generic map(32) port map(interrupt=>INT,reset=>rst,clk=>clk,
instr=>IF_ID(15 downto 0),
RegWriteinput=>RegWriteFromWB,Swapinput=>SWAPFromWB,
Mem_Wb_Rd=>MEM_WBRd,Mem_Wb_Rs=>MEM_WBRs,Rs_from_fetch=>RsFromFetch,
value1=>Value1,value2=>Value2,
Target_Address=>TargetAddress,Rsrc=>SRC1,Rdst=>SRC2);

controlUnit:entity work.control_unit  generic map(32) port map(interrupt=>INT,reset=>Mux_Selector,clk=>clk,
OpCode=>IF_ID(15 downto 11),

 
--Control signals
RegWrite=>WBSignals(1),RegDST=>RegDST,MemToReg=>WBSignals(0),MemRd=>MEMSignals(3),MemWR=>MEMSignals(2),
SP=>MEMSignals(1 downto 0),
-- nop:0000    A: 0001    B :0010   INC:0011
 -- DEC:0100 ADD:0101  SUB:0110  NOT: 0111  AND: 1000  OR:    1001  SHL:1010  SHR:  1011
ALU=>ALUSelectors,PCWrite=>IF_IDWrite,IMM_EA=>IMM_EASignal,sign=>SignExtendSignal,CRR=>CRR,
In_enable=>InEnable,Out_enable=>WBSignals(2),thirtyTwo_Sixteen=>sig32_16,SWAP=>SWAP, CALL=>CALL);
INTOut<=IF_ID(48);
RRI<=IF_ID(49);
instruction(31 downto 16)<=(others=>'0');
instruction(15 downto 0)<=IF_ID(15 downto 0);
PC<=IF_ID(47 downto 16);
--TODO 
--predicition check to generate T_NT
T_NT<="11";
INPORTValueDecodeOut<=IF_ID(82 downto 51);
end architecture ; 