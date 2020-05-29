library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity system is
  port (
    clk,rst,INT:IN std_logic;
    INPORT:IN std_logic_vector(31 downto 0);
    CRRFlags:OUT std_logic_vector(2 downto 0);
    OUTPort:OUT std_logic_vector(31 downto 0)
  ) ;
end system ;

architecture arch of system is

  ---------------------------------------System Signals----------------------------------------
  signal RTIHandler,INTHandler,RETHandler,CALLHandler:std_logic:='0';
  signal temp_CRR:std_logic_vector(2 downto 0);
  ---------------------------------------------------------------------------------------------
-----------------------------------------fetch stage signals------------------------------------ 
signal instruction:std_logic_vector(15 downto 0);
signal CurrentPC,INPORTValueFetchOut,EXSrc1,EXSrc2:std_logic_vector(31 downto 0);
signal probINTsignal,probRstSignal,RTIsignal,RETsignal,IF_IDFlushFromFetch:std_logic;--signals to propagte in the next stages.
signal RegWriteFromDecode,RegDstFromDecode,IDEXRegWriteToFetch,SwapFromDecode,IDEXSwapToFetch: std_logic;
signal RegRdFromEXE,RsFromDecode,RdFromDecode,IDEXRsTofetch,IDEXRtTofetch,RtFromDecode: std_logic_vector(2 downto 0);
signal Decode_MemRead,ExeMemRead,Mem_memRead,CALL,JZ_Taken: std_logic;
signal MemRegRd: std_logic_vector(2 downto 0);

------------------------------------------------------------------------------------------------

-----------------------------------------Decode stage signals------------------------------------ 
signal RegWriteinput,Swapinput,ZFToCheck, Mux_Selector_input:std_logic;
signal Mem_Wb_Rd,Mem_Wb_Rt: std_logic_vector(2 downto 0);
signal value1,value2,INPORTValueDecodeOut: std_logic_vector(31 downto 0);
signal Target_Address,Rsrc,Rdst,instructionDecodeout,pcDecodeout: std_logic_vector(31 downto 0);
signal REGdstSignal,probINTDecodeout: std_logic;
signal ALUSelectors,MEMSignalsDecodeOut: std_logic_vector(3 downto 0);
signal PCWrite,IMM_EA,sign: std_logic;
signal In_enable,Out_enable,thirtyTwo_Sixteen,RTIDecodeOut,RETDecodeOut,SWAP, CALLOUT,tempIF_IDwrite: std_logic;
signal Rs_from_fetch,WBsignalsDecodeOut: std_logic_vector(2 downto 0);
signal T_NTtoFetch:std_logic_vector(1 downto 0);
signal PCwriteHDU,tempIF_IDwriteHDU:std_logic;
------------------------------------------------------------------------------------------------

-----------------------------------------Execute stage signals------------------------------------ 
signal EXALUResult,INPORTValueEXEOut:std_logic_vector(31 downto 0);
signal EX_MEMRegisterRd:std_logic_vector(2 downto 0);
signal EX_MEMRegWrite,EX_MEMSWAP:std_logic;
signal RegDstToExe_MEM,RtEXEOUT,RegDSTtofetchForwardingunit :std_logic_vector(2 downto 0);
signal CRR:std_logic_vector(2 downto 0);
signal ZF,ZFfromExe,ALUFlagsEnable:std_logic;
signal DataOut:std_logic_vector(31 downto 0);
signal AddrressEA_IMM:std_logic_vector(31 downto 0);

------------------------------------------------------------------------------------------------

-----------------------------------------Memory stage signals------------------------------------ 
signal MEMALUResult,MemoryPC:std_logic_vector(31 downto 0);
signal MEM_WBRegisterRd:std_logic_vector(2 downto 0);
signal MEM_WBRegWrite,MEM_WBSWAP,MemoryReadSignalToFetch,ResumeSignalFromMemory:std_logic;

------------------------------------------------------------------------------------------------
-----------------------------------------intermediate registers signals------------------------------------ 
signal IF_IDRegIN,IF_IDRegOut:std_logic_vector(83 downto 0);
signal ID_EXRegIN,ID_EXRegOUT: std_logic_vector(179 downto 0);
signal EX_MEMRegIN,EX_MEMRegOUT: std_logic_vector(116 downto 0);
signal MEM_WBRegIN,MEM_WBRegOUT: std_logic_vector(105 downto 0);
signal IF_IDFlush,ID_EXFlush,EX_MEMFlush,MEM_WBFlush:std_logic:='0';
signal IF_IDwrite,ID_EXwrite,EX_MEMwrite,MEM_WBwrite:std_logic:='1';
------------------------------------------------------------------------------------------------

-----------------------------------------Memory system signals------------------------------------ 
signal memorySystemRd,memorySystemWr,InstrRequest,DataRequest,FetchStall,DataStall:std_logic:='0';
signal RTIFlagsEnable:std_logic;
signal MemoryInstrOut:std_logic_vector(15 downto 0):=(others=>'0');
signal MemoryDataToWrite,MemoryDataRead,MemResultSig,MemResultFromMemory:std_logic_vector(31 downto 0):=(others=>'0');
signal AddressToMemory:std_logic_vector(31 downto 0):=(others=>'0');
signal FlagsMemoryOut:std_logic_vector(2 downto 0):=(others=>'0');
------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------
-------------------------------------Counter Signals -------------------------------------------
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
signal outputCounter : std_logic_vector(0 downto 0);
signal resetCounter  : std_logic;
signal enableCounter : std_logic;
signal Flush_32_16   : std_logic:='0'; --flush signal when instruction is 32
signal ImmdiateValue : std_logic_vector(15 downto 0);
signal ReadImmd      : std_logic:='0';--enble to read immdiate
begin
--------------------------------------------------------------Fetch ->> Decode------------------------------------------
Fetch:entity work.FetchStage  Generic map (wordSize=>16,PCSize=>32) 
port map(clk=>clk,reset=>rst,interrupt=>INT,pcWrite=>PCwriteHDU,MemoryReadSignal=>MemoryReadSignalToFetch,ResumeSignalFromMemory=>ResumeSignalFromMemory,
DecodePC=>pcDecodeout,DecodeTargetAddress=>Target_Address,MemoryPC=>MemoryPC,T_NT=>T_NTtoFetch,INPORTValue=>INPORT,
EXDataOut=>DataOut,DecodeSrc1=>Rsrc,DecodeSrc2=>Rdst,EXSrc1=>EXSrc1,EXSrc2=>EXSrc2,
RegWriteFromDecode=>RegWriteFromDecode,RegDstFromDecode=>RegDstFromDecode,IDEXRegWriteToFetch=>IDEXRegWriteToFetch,
SwapFromDecode=>SwapFromDecode,IDEXSwapToFetch=>IDEXSwapToFetch,
      RegRdFromEXE=>RegRdFromEXE,RsFromDecode=>RsFromDecode,RdFromDecode=>RdFromDecode,
      IDEXRsTofetch=>IDEXRsTofetch,IDEXRtTofetch=>IDEXRtTofetch,RtFromDecode=>RtFromDecode,
      Decode_MemRead=>Decode_MemRead,ExeMemRead=>ExeMemRead,Mem_memRead=>Mem_memRead,
        	MemRegRd=>MemRegRd,MemResultFromMemory=>MemResultFromMemory,JZ_Taken=>JZ_Taken,

-- InstrPC=>CurrentPC,RRI=>RRIsignal,intSignal=>probINTsignal,rstSignal=>probRstSignal,IF_IDFlush=>IF_IDFlushFromFetch,INPORTValueFetchOut=>INPORTValueFetchOut);
-- IF_IDRegIN(15 downto 0) <=MemoryInstrOut when FetchStall = '0'  else (others=>'0') when FetchStall = '1' ;
instruction=>instruction,InstrPC=>CurrentPC,RET=>RETsignal,RTI=>RTIsignal,intSignal=>probINTsignal,rstSignal=>probRstSignal,INTHandler=>INTHandler,RTIHandler=>RTIHandler,RETHandler=>RETHandler,CALLHandler=>CALLHandler,IF_IDFlush=>IF_IDFlushFromFetch,  INPORTValueFetchOut=>INPORTValueFetchOut);

IF_IDRegIN(15 downto 0) <=(others=>'0')when  IF_IDFlush ='1' or Mux_Selector_input ='1'  else instruction;
IF_IDFlush <= outputCounter(0) or IF_IDFlushFromFetch;  

IF_IDRegIN(47 downto 16) <=CurrentPC;
IF_IDRegIN(48) <=probINTsignal;
IF_IDRegIN(49) <=RETsignal;
IF_IDRegIN(50) <=probRstSignal;
IF_IDRegIN(82 downto 51)<=INPORTValueFetchOut;
IF_IDRegIN(83) <=RTIsignal;

IF_IDwrite<= tempIF_IDwriteHDU;
IF_ID:entity work.Reg(RegArch)  generic map(n=>84) port map(input=>IF_IDRegIN,en=>IF_IDwrite,rst=>rst,clk=>clk,output=>IF_IDRegOUT);
-----------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------Decode ->>Execute ------------------------------------------
Decode:entity work.DecodeStage port map(clk=>clk,rst=>rst,INT=>INT,Mux_Selector=>Mux_Selector_input,IF_ID=>IF_IDRegOUT,
RegWriteFromWB=>RegWriteinput,SWAPFromWB=>Swapinput,
MEM_WBRd=>Mem_Wb_Rd,MEM_WBRs=>Mem_Wb_Rt,RsFromFetch=>Rs_from_fetch,
Value1=>value1,Value2=>value2,
ImmdiateValue=>ImmdiateValue,ReadImmd=>ReadImmd,ZF=>ZFToCheck,JZ_Taken=>JZ_Taken,
TargetAddress=>Target_Address,SRC1=>Rsrc,SRC2=>Rdst,instruction=>instructionDecodeout,PC=>pcDecodeout,INPORTValueDecodeOut=>INPORTValueDecodeOut,
RET=>RETDecodeOut,RTI=>RTIDecodeOut,SWAP=>SWAP,CALL=>CALLOUT,INTOut=>probINTDecodeout,SignExtendSignal=>sign,
IMM_EASignal=>IMM_EA,RegDST=>REGdstSignal,InEnable=>In_enable,sig32_16=>thirtyTwo_Sixteen,IF_IDWrite=>tempIF_IDwrite,
WBSignals=>WBsignalsDecodeOut,T_NT=>T_NTtoFetch,
ALUSelectors=>ALUSelectors,MEMSignals=>MEMSignalsDecodeOut);


RegWriteFromDecode<=WBsignalsDecodeOut(1);
RegDstFromDecode<=REGdstSignal;
SwapFromDecode<=SWAP;
RsFromDecode<=instructionDecodeout(10 downto 8);
RdFromDecode<=instructionDecodeout(4 downto 2);
RtFromDecode<=instructionDecodeout(7 downto 5);
Decode_MemRead<=MEMSignalsDecodeOut(3);

Rs_from_fetch<=instruction(10 downto 8);
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-----------------------------Counter set signals-------------------------------
-------------------------------------------------------------------------------
------------------------------------------------------------------------------- 
--resetCounter<='1'when(thirtyTwo_Sixteen='1' nor  outputCounter="1")else'0'; ---reset counter when it reach the decode 
enableCounter<=instruction(0);
resetCounter<='0' when (enableCounter='1') else '1';
Flush_32_16<='1' when outputCounter="1" else '0'; --when instrucion(0) = "1" >>32bit>>flush 
ReadImmd<='1'when outputCounter="1" else '0';
ImmdiateValue<=instruction;

-----------------------

ID_EX:entity work.Reg(RegArch)  generic map(n=>180) port map(input=>ID_EXRegIN,en=>ID_EXwrite,rst=>rst,clk=>clk,output=>ID_EXRegOUT);
	
---------------------------------------ID_EX Buffer -----------------------------------------------------------------
ID_EXRegIN(31 downto 0 ) <= Rsrc; --Rscr1 
ID_EXRegIN(63 downto 32) <= Rdst; -- Rscr2 
ID_EXRegIN(95 downto 64) <= instructionDecodeout;
ID_EXRegIN(127 downto 96) <= pcDecodeout; --PC after incremented 

ID_EXRegIN(143) <= RETDecodeOut; --RET signal
ID_EXRegIN(179) <= RTIDecodeOut; --RTI signal 
ID_EXRegIN(144) <= SWAP ;
ID_EXRegIN(145) <= CALLOUT ;
ID_EXRegIN(146) <= probINTDecodeout ;

ID_EXRegIN(142 downto 139) <=MEMSignalsDecodeOut;
ID_EXRegIN(134 downto 131) <=ALUSelectors ;
ID_EXRegIN(135) <=sign ;
ID_EXRegIN(136) <=IMM_EA ;
ID_EXRegIN(137) <=REGdstSignal ;
ID_EXRegIN(138) <=In_enable ;

ID_EXRegIN(130 downto 128) <=WBsignalsDecodeOut ;
ID_EXRegIN(178 downto 147) <=INPORTValueDecodeOut;


IDEXRegWriteToFetch<=ID_EXRegOUT(129);
IDEXSwapToFetch<=ID_EXRegOUT(144);
RegRdFromEXE<=RegDstToExe_MEM;
IDEXRsTofetch<=ID_EXRegOUT(74 downto 72);
IDEXRtTofetch<=ID_EXRegOUT(71 downto 69);
EXSrc1<=ID_EXRegOUT(31 downto 0);
EXSrc2<=ID_EXRegOUT(63 downto 32);
ExeMemRead<=ID_EXRegOUT(142);
------------------------------------------------------------------------------------------------------------------------------------------
-------------------------
--------------------------------------------------------------Execute ->> Memory ------------------------------------------
Execute:entity work.ExeStage port map(clk=>clk,rst=>rst,INT=>INT,
ID_EX=>ID_EXRegOUT,
EXALUResult=>EXALUResult,
MEMALUResult=>MEMALUResult,
MEM_WBRegisterRd=>MEM_WBRegisterRd
,EX_MEMRegisterRd=>EX_MEMRegisterRd,
EX_MEMRegWrite=>EX_MEMRegWrite,
MEM_WBRegWrite=>MEM_WBRegWrite,
EX_MEMSWAP=>EX_MEMSWAP,
MEM_WBSWAP=>MEM_WBSWAP,


RegDst=>RegDstToExe_MEM,ALUFlagsEnable=>ALUFlagsEnable,
CRR=>CRR,
RtReg=>RtEXEOUT,
WBsignals=>EX_MEMRegIN(114 downto 112),
MEMSignals=>EX_MEMRegIN(111 downto 108),
ZF=>ZFfromExe,
SWAP=>EX_MEMRegIN(32),
INTSignal=>EX_MEMRegIN(103),RET=>EX_MEMRegIN(104),RTI=>EX_MEMRegIN(115),CALL=>EX_MEMRegIN(116),
DataOut=>DataOut,
AddrressEA_IMM=>AddrressEA_IMM 
,SRC2out=>EX_MEMRegIN(31 downto 0));

EX_MEMRegIN(102 downto 100)<=RegDstToExe_MEM;
RegDSTtofetchForwardingunit<=RegDstToExe_MEM;
EX_MEMRegIN(35 downto 33)<=RtEXEOUT;
EX_MEMRegIN(107 downto 105)<=CRR;


-- Flags2_1: process(RTIFlagsEnable,ResumeSignalFromMemory,ALUFlagsEnable,JZ_Taken,FlagsMemoryOut,CRR)
-- begin
--   if(RTIFlagsEnable='1' and ResumeSignalFromMemory='0')then
--     CRRFlags(2 downto 1)<=FlagsMemoryOut(2 downto 1);
--     elsif(ALUFlagsEnable='1')then
--       CRRFlags(2 downto 1)<=CRR(2 downto 1);
--   end if;  
-- end process Flags2_1;
-- Flags0: process(RTIFlagsEnable,ResumeSignalFromMemory,ALUFlagsEnable,JZ_Taken,FlagsMemoryOut,CRR)
-- begin
--     if(JZ_Taken='1')then
--       CRRFlags(0) <='0';
--     elsif(RTIFlagsEnable='1' and ResumeSignalFromMemory='0')then
--     CRRFlags(0)<=FlagsMemoryOut(0);
--     elsif(ALUFlagsEnable='1')then
--       CRRFlags(0)<=CRR(0);
--   end if;  
-- end process Flags0;
--Flags Logic
temp_CRR(2 downto 1)<=FlagsMemoryOut(2 downto 1) when RTIFlagsEnable='1' and ResumeSignalFromMemory='0' else CRR(2 downto 1) when ALUFlagsEnable='1';
--ZF 
temp_CRR(0) <='0' when JZ_Taken='1' else FlagsMemoryOut(0) when RTIFlagsEnable='1'and ResumeSignalFromMemory='0' else  CRR(0)when ALUFlagsEnable='1';

CRRFlags<=temp_CRR when JZ_Taken='1' or (RTIFlagsEnable='1'and ResumeSignalFromMemory='0') or ALUFlagsEnable='1';

EX_MEMRegIN(67 downto 36)<=DataOut;
EX_MEMRegIN(99 downto 68)<=AddrressEA_IMM;


--zero flag to decode check is zf from alu or zeroflag from memory in case of interrupt return
ZFToCheck <=CRRFlags(0);

EXALUResult <= EX_MEMRegOUT( 67 downto 36);
EX_MEMRegisterRd<=EX_MEMRegOUT( 102 downto 100);
EX_MEMRegWrite<=EX_MEMRegOUT(113);
EX_MEMSWAP<=EX_MEMRegOUT(32);
MEMALUResult <=MEM_WBRegOUT(105 downto 74);
MEM_WBRegisterRd<=MEM_WBRegOUT(38 downto 36);
MEM_WBRegWrite<=MEM_WBRegOUT(40);
MEM_WBSWAP<=MEM_WBRegOUT(32);

Mem_memRead<=EX_MEMRegOUT(111);
MemRegRd <= EX_MEMRegOUT( 102 downto 100);

EX_MEM:entity work.Reg(RegArch)  generic map(n=>117) port map(input=>EX_MEMRegIN,en=>EX_MEMwrite,rst=>rst,clk=>clk,output=>EX_MEMRegOUT);

-----------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------Memory ->> Write Back ------------------------------------------

MemoryStage:entity work.memory port map(reset=>rst, clk=>clk,
EX_MEM=>EX_MEMRegOUT,
Rsrc2=>MEM_WBRegIN(31 downto 0),
ALUresult=>MEM_WBRegIN(105 downto 74),
 MemoryReuslt=>MemResultSig
  ,SWAP=>MEM_WBRegIN(32)
  ,Rt=>MEM_WBRegIN(35 downto 33)
  ,Rd=>MEM_WBRegIN(38 downto 36),RTIFlagsEnable=>RTIFlagsEnable,
  WBsignals=>MEM_WBRegIN(41 downto 39),FlagsOut=>FlagsMemoryOut,
  INTHandlerIN=>INTHandler,RTIHandlerIN=>RTIHandler,RETHandlerIN=>RETHandler,CALLHandlerIN=>CALLHandler,
  --rd=>memorySystemRd,Wr=>memorySystemWr,DataToWrite=>MemoryDataToWrite,DataRead=>,DataRequest=>DataRequest,
  MemoryReadSignalToFetch=>MemoryReadSignalToFetch,ResumeSignalFromMemory=>ResumeSignalFromMemory,MemoryPC=>MemoryPC);
  MEM_WBRegIN(73 downto 42)<=MemResultSig;
  MemResultFromMemory<=MemResultSig;

MEM_WB:entity work.Reg(RegArch)  generic map(n=>106) port map(input=>MEM_WBRegIN,en=>MEM_WBwrite,rst=>rst,clk=>clk,output=>MEM_WBRegOUT);

WBStage:entity work.WBStage port map (clk=>clk,rst=>rst,MEM_WB=>MEM_WBRegOUT,RegWriteToRegisterFile=>RegWriteinput,Swap=>Swapinput,PortOut=>OUTPort,Value1=>value1,Value2=>value2,RtToDecode=>Mem_Wb_Rt,RdToDecode=>Mem_Wb_Rd);

-----------------------------------------------------------------------------------------------------------------------------------------

-- MemorySystem:work.memorysystem port map(clk=>clk,rst=>rst,WR=>memorySystemWr,RD=>memorySystemRd,Instr=>InstrRequest,Data=>DataRequest,address=>AddressToMemory,Datain=>MemoryDataToWrite,

-- DataStall=>DataStall,InstrStall=>FetchStall,
-- DataOut=>);
counter:entity work.counter generic map(1) port map(enable=>enableCounter, reset=>resetCounter, clk=>clk, output=>outputCounter);

----------------------------------------------------------Hazard Detection Unit --------------------------------------------------------------------------
Hazard_detection_unit:entity work.hazard_detection_unit port map(ID_EX_RegisterRegdst=> RegDstToExe_MEM, IF_ID_RegisterRs=> IF_IDRegOUT(10 downto 8),IF_ID_RegisterRt=> IF_IDRegOUT(7 downto 5),ID_EX_MemRead => EX_MEMRegIN(111),reset => rst, PCwrite=>PCwriteHDU ,IF_ID_write =>tempIF_IDwriteHDU,ControlUnit_Mux_Selector => Mux_Selector_input);

-----------------------------------------------------------------------------------------------------------


-- process(clk,rst)
-- begin 
--     if(falling_edge(clk))then
        
--     end if;
-- end process;

end architecture ; -- arch