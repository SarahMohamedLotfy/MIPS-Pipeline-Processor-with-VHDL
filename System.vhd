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
-----------------------------------------fetch stage signals------------------------------------ 
signal instruction:std_logic_vector(15 downto 0);
signal CurrentPC,INPORTValueFetchOut:std_logic_vector(31 downto 0);
signal probINTsignal,probRstSignal,RRIsignal,IF_IDFlushFromFetch:std_logic;--signals to propagte in the next stages.
------------------------------------------------------------------------------------------------

-----------------------------------------Decode stage signals------------------------------------ 
signal RegWriteinput,Swapinput,ZFToCheck, Mux_Selector_input:std_logic;
signal Mem_Wb_Rd,Mem_Wb_Rs: std_logic_vector(2 downto 0);
signal value1,value2,INPORTValueDecodeOut: std_logic_vector(31 downto 0);
signal Target_Address,Rsrc,Rdst,instructionDecodeout,pcDecodeout: std_logic_vector(31 downto 0);
signal REGdstSignal,probINTDecodeout: std_logic;
signal ALUSelectors,MEMSignalsDecodeOut: std_logic_vector(3 downto 0);
signal PCWrite,IMM_EA,sign: std_logic;
signal In_enable,Out_enable,thirtyTwo_Sixteen,RRI,SWAP, CALL,tempIF_IDwrite: std_logic;
signal Rs_from_fetch,WBsignalsDecodeOut: std_logic_vector(2 downto 0);
signal T_NTtoFetch:std_logic_vector(1 downto 0);
------------------------------------------------------------------------------------------------

-----------------------------------------Execute stage signals------------------------------------ 
signal EXALUResult,INPORTValueEXEOut:std_logic_vector(31 downto 0);
signal EX_MEMRegisterRd:std_logic_vector(2 downto 0);
signal EX_MEMRegWrite,EX_MEMSWAP:std_logic;
signal RegDstToExe_MEM,RsEXEOUT,RegDSTtofetchForwardingunit :std_logic_vector(2 downto 0);
signal CCR:std_logic_vector(2 downto 0);
signal ZF:std_logic;
signal DataOut:std_logic_vector(31 downto 0);
signal AddrressEA_IMM:std_logic_vector(31 downto 0);

------------------------------------------------------------------------------------------------

-----------------------------------------Memory stage signals------------------------------------ 
signal MEMALUResult,MemoryPC:std_logic_vector(31 downto 0);
signal MEM_WBRegisterRd:std_logic_vector(2 downto 0);
signal MEM_WBRegWrite,MEM_WBSWAP,MemoryReadSignalToFetch:std_logic;

------------------------------------------------------------------------------------------------


-----------------------------------------intermediate registers signals------------------------------------ 
signal IF_IDRegIN,IF_IDRegOut:std_logic_vector(82 downto 0);
signal ID_EXRegIN,ID_EXRegOUT: std_logic_vector(178 downto 0);
signal EX_MEMRegIN,EX_MEMRegOUT: std_logic_vector(114 downto 0);
signal MEM_WBRegIN,MEM_WBRegOUT: std_logic_vector(105 downto 0);
signal IF_IDFlush,ID_EXFlush,EX_MEMFlush,MEM_WBFlush:std_logic:='0';
signal IF_IDwrite,ID_EXwrite,EX_MEMwrite,MEM_WBwrite:std_logic:='1';
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
port map(clk=>clk,reset=>rst,interrupt=>INT,pcWrite=>'1',MemoryReadSignal=>MemoryReadSignalToFetch,
DecodePC=>pcDecodeout,DecodeTargetAddress=>Target_Address,MemoryPC=>MemoryPC,T_NT=>T_NTtoFetch,INPORTValue=>INPORT,

instruction=>instruction,InstrPC=>CurrentPC,RRI=>RRIsignal,intSignal=>probINTsignal,rstSignal=>probRstSignal,IF_IDFlush=>IF_IDFlushFromFetch,  INPORTValueFetchOut=>INPORTValueFetchOut);
IF_IDRegIN(15 downto 0) <=instruction;
IF_IDRegIN(47 downto 16) <=CurrentPC;
IF_IDRegIN(48) <=probINTsignal;
IF_IDRegIN(49) <=RRIsignal;
IF_IDRegIN(50) <=probRstSignal;
IF_IDRegIN(82 downto 51)<=INPORTValueFetchOut;
IF_ID:entity work.Reg(RegArch)  generic map(n=>83) port map(input=>IF_IDRegIN,en=>IF_IDwrite,rst=>rst,clk=>clk,output=>IF_IDRegOUT);
-----------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------Decode ->>Execute ------------------------------------------
Decode:entity work.DecodeStage port map(clk=>clk,rst=>rst,INT=>INT,Mux_Selector=>Mux_Selector_input,IF_ID=>IF_IDRegOUT,
RegWriteFromWB=>RegWriteinput,SWAPFromWB=>Swapinput,
MEM_WBRd=>Mem_Wb_Rd,MEM_WBRs=>Mem_Wb_Rs,RsFromFetch=>Rs_from_fetch,
Value1=>value1,Value2=>value2,
ImmdiateValue=>ImmdiateValue,ReadImmd=>ReadImmd,
TargetAddress=>Target_Address,SRC1=>Rsrc,SRC2=>Rdst,instruction=>instructionDecodeout,PC=>pcDecodeout,INPORTValueDecodeOut=>INPORTValueDecodeOut,
RRI=>RRI,SWAP=>SWAP,CALL=>CALL,INTOut=>probINTDecodeout,SignExtendSignal=>sign,
IMM_EASignal=>IMM_EA,RegDST=>REGdstSignal,InEnable=>In_enable,sig32_16=>thirtyTwo_Sixteen,IF_IDWrite=>tempIF_IDwrite,
WBSignals=>WBsignalsDecodeOut,T_NT=>T_NTtoFetch,
ALUSelectors=>ALUSelectors,MEMSignals=>MEMSignalsDecodeOut);



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
ID_EX:entity work.Reg(RegArch)  generic map(n=>179) port map(input=>ID_EXRegIN,en=>ID_EXwrite,rst=>rst,clk=>clk,output=>ID_EXRegOUT);
	
---------------------------------------ID_EX Buffer -----------------------------------------------------------------
ID_EXRegIN(31 downto 0 ) <= Rsrc; --Rscr1 
ID_EXRegIN(63 downto 32) <= Rdst; -- Rscr2 
ID_EXRegIN(95 downto 64) <=(others=>'0') when instruction(0)='1' else instructionDecodeout;
ID_EXRegIN(127 downto 96) <= pcDecodeout; --PC after incremented 

ID_EXRegIN(143) <= RRI; --RRI signal 
ID_EXRegIN(144) <= SWAP;
ID_EXRegIN(145) <= CALL;
ID_EXRegIN(146) <= probINTDecodeout;

ID_EXRegIN(142 downto 139) <=MEMSignalsDecodeOut;
ID_EXRegIN(134 downto 131) <=ALUSelectors;
ID_EXRegIN(135) <=sign;
ID_EXRegIN(136) <=IMM_EA;
ID_EXRegIN(137) <=REGdstSignal;
ID_EXRegIN(138) <=In_enable;

ID_EXRegIN(130 downto 128) <=WBsignalsDecodeOut;
ID_EXRegIN(178 downto 147) <=INPORTValueDecodeOut;


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


RegDst=>RegDstToExe_MEM,
CCR=>CCR,
RsReg=>RsEXEOUT,
WBsignals=>EX_MEMRegIN(114 downto 112),
MEMSignals=>EX_MEMRegIN(111 downto 108),
ZF=>ZFToCheck,
SWAP=>EX_MEMRegIN(32),
INTSignal=>EX_MEMRegIN(103),RRI=>EX_MEMRegIN(104)
,DataOut=>DataOut,
AddrressEA_IMM=>AddrressEA_IMM 
,SRC2out=>EX_MEMRegIN(31 downto 0));

EX_MEMRegIN(102 downto 100)<=RegDstToExe_MEM;
RegDSTtofetchForwardingunit<=RegDstToExe_MEM;
EX_MEMRegIN(35 downto 33)<=RsEXEOUT;
EX_MEMRegIN(107 downto 105)<=CCR;
CRRFlags<=CCR;
EX_MEMRegIN(67 downto 36)<=DataOut;
EX_MEMRegIN(99 downto 68)<=AddrressEA_IMM;

EXALUResult <= EX_MEMRegOUT( 67 downto 36);
EX_MEMRegisterRd<=EX_MEMRegOUT( 102 downto 100);
EX_MEMRegWrite<=EX_MEMRegOUT(113);
EX_MEMSWAP<=EX_MEMRegOUT(32);
MEMALUResult <=MEM_WBRegOUT(105 downto 74);
MEM_WBRegisterRd<=MEM_WBRegOUT(38 downto 36);
MEM_WBRegWrite<=MEM_WBRegOUT(40);
MEM_WBSWAP<=MEM_WBRegOUT(32);

EX_MEM:entity work.Reg(RegArch)  generic map(n=>115) port map(input=>EX_MEMRegIN,en=>EX_MEMwrite,rst=>rst,clk=>clk,output=>EX_MEMRegOUT);

-----------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------Memory ->> Write Back ------------------------------------------
MemoryStage:entity work.memory port map(reset=>rst, clk=>clk,
EX_MEM=>EX_MEMRegOUT,
Rsrc2=>MEM_WBRegIN(31 downto 0),
ALUresult=>MEM_WBRegIN(105 downto 74),
 MemoryReuslt=>MEM_WBRegIN(73 downto 42)
  ,SWAP=>MEM_WBRegIN(32)
  ,Rs=>MEM_WBRegIN(35 downto 33)
  ,Rd=>MEM_WBRegIN(38 downto 36),
  WBsignals=>MEM_WBRegIN(41 downto 39),
  MemoryReadSignalToFetch=>MemoryReadSignalToFetch,MemoryPC=>MemoryPC);


MEM_WB:entity work.Reg(RegArch)  generic map(n=>106) port map(input=>MEM_WBRegIN,en=>MEM_WBwrite,rst=>rst,clk=>clk,output=>MEM_WBRegOUT);

WBStage:entity work.WBStage port map (clk=>clk,rst=>rst,MEM_WB=>MEM_WBRegOUT,RegWriteToRegisterFile=>RegWriteinput,Swap=>Swapinput,PortOut=>OUTPort,Value1=>value1,Value2=>value2,Rs=>Mem_Wb_Rs,Rd=>Mem_Wb_Rd);

-----------------------------------------------------------------------------------------------------------------------------------------

counter:entity work.counter generic map(1) port map(enable=>enableCounter, reset=>resetCounter, clk=>clk, output=>outputCounter);

----------------------------------------------------------Hazard Detection Unit --------------------------------------------------------------------------
--Hazard_detection_unit:entity work.hazard_detection_unit port map(ID_EX_RegisterRt=> instructionDecodeout(7 downto 5), IF_ID_RegisterRs=> IF_IDRegIN(10 downto 8),IF_ID_RegisterRt=> IF_IDRegIN(7 downto 5),ID_EX_MemRead => MEMSignalsDecodeOut(3),reset => rst, PCwrite=>PCwrite ,IF_ID_write =>tempIF_IDwrite,ControlUnit_Mux_Selector => Mux_Selector_input);

-----------------------------------------------------------------------------------------------------------


-- process(clk,rst)
-- begin 
--     if(falling_edge(clk))then
        
--     end if;
-- end process;

end architecture ; -- arch