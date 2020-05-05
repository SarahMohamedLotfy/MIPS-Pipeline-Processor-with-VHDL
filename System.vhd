library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity ent is
  port (
    clk,rst,INT:IN std_logic;
    INPORT:IN std_logic_vector(31 downto 0);
    OUTPort:OUT std_logic_vector(31 downto 0)
  ) ;
end ent ;

architecture arch of ent is
-----------------------------------------fetch stage signals------------------------------------ 
signal instruction:std_logic_vector(16 downto 0);
signal pcnew:std_logic_vector(31 downto 0);
signal probINTsignal,probRstSignal,RRI:std_logic;--signals to propagte in the next stages.
------------------------------------------------------------------------------------------------

-----------------------------------------Decode stage signals------------------------------------ 
signal RegWriteinput,Swapinput:std_logic;
------------------------------------------------------------------------------------------------

-----------------------------------------Execute stage signals------------------------------------ 
signal EXALUResult:std_logic_vector(31 downto 0);
signal EX_MEMRegisterRd:std_logic_vector(2 downto 0);
signal EX_MEMRegWrite,EX_MEMSWAP:std_logic;
signal RegDst std_logic_vector(2 downto 0);
signal CCR:std_logic_vector(2 downto 0);
signal ZF:std_logic;
signal DataOut:std_logic_vector(31 downto 0);
signal AddrressEA_IMM:std_logic_vector(31 downto 0);

------------------------------------------------------------------------------------------------

-----------------------------------------Memory stage signals------------------------------------ 
signal MEMALUResult:std_logic_vector(31 downto 0);
signal MEM_WBRegisterRd:std_logic_vector(2 downto 0);
signal MEM_WBRegWrite,MEM_WBSWAP:std_logic;
------------------------------------------------------------------------------------------------

-----------------------------------------Decode stage signals------------------------------------ 

------------------------------------------------------------------------------------------------


-----------------------------------------intermediate registers signals------------------------------------ 
signal IF_IDRegIN,IF_IDRegOut:std_logic_vector(50 downto 0);
signal ID_EXRegIN,ID_EXRegOUT:in std_logic_vector(146 downto 0);
signal EX_MEMRegIN,EX_MEMRegOUT:in std_logic_vector(83 downto 0);
signal MEM_WBRegIN,MEM_WBRegOUT:in std_logic_vector(103 downto 0);
signal IF_IDFlush,ID_EXFlush,EX_MEMFlush,MEM_WBFlush:std_logic:='0';
signal IF_IDwrite,ID_EXwrite,EX_MEMwrite,MEM_WBwrite:std_logic:='1';
------------------------------------------------------------------------------------------------

begin
--------------------------------------------------------------Fetch ->> Decode------------------------------------------
Fetch:entity work.FetchStage  Generic map (wordSize=>16,PCSize=>32) 
port map(clk=>clk,reset=>rst,interrupt=>INT,instruction=>instruction,PCnew=>pcnew,intSignal=>probINTsignal,rstSignal=>probRstSignal);
 (15 downto 0) <=instruction;
IF_IDRegIN(47 downto 16) <=pcnew;
IF_IDRegIN(48) <=probINTsignal;
IF_IDRegIN(49) <=RRI;
IF_IDRegIN(50) <=probRstSignal;
IF_ID:entity work.Reg  generic map(n=>50) port map(input=>IF_IDRegIN,en=>IF_IDwrite,rst=>rst,clk=>clk,output=>IF_IDRegOUT);
-----------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------Decode ->>Execute ------------------------------------------
Decode:entity work.Alldecoder Generic map (n=>32) 
port map (
    interrupt=>INT,reset=>rst, clk=>clk,
	IF_ID=>IF_IDRegOUT,
	RegWriteinput=>RegWriteinput,
	Swapinput=>Swapinput,
	Mem_Wb_Rd=>,Mem_Wb_Rs=>,
    value1=>,value2=>
    Target_Address=>,
	Rsrc=>,
	Rdst=> ,
	RegWrite=>,
	RegDST=>,
	MemToReg=>,
	MemRd=>,
	MemWR=>,
	SP=>,
	ALU=>,
	PCWrite=>,
	IMM_EA=>,
	sign=>,
	CRR=>,
	In_enable=>,
	Out_enable=>,
	thirtyTwo_Sixteen=>,
	RRI=>RRI,
	SWAP=>,
	CALL=>);
-----------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------Execute ->> Memory ------------------------------------------
Execute:entity work.ExeStage port map(clk=>clk,rst=>rst,INT=>INT,
ID_EX=>ID_EXRegOUT,
EXALUResult=>EXALUResult,MEMALUResult=>MEMALUResult,INPORTValue=>INPORT,
MEM_WBRegisterRd=>MEM_WBRegisterRd,EX_MEMRegisterRd=>EX_MEMRegisterRd,
EX_MEMRegWrite=>EX_MEMRegWrite,MEM_WBRegWrite=>MEM_WBRegWrite,EX_MEMSWAP=>EX_MEMSWAP,MEM_WBSWAP=>MEM_WBSWAP,
RegDst=>RegDst,CCR=>CCR,ZF=>ZF,
DataOut=>DataOut,AddrressEA_IMM=>AddrressEA_IMM);


EX_MEMRegIN(0) <=probINTsignal;--interrupt signal
EX_MEMRegIN(1) <=probRstSignal;--reset signal
EX_MEMRegIN(2) <=RRI; --RRI signal 
EX_MEMRegIN(34 downto 3) <=EXALUResult; --ALU result 4bytes 
--EX_MEMRegIN(35) <=EX_MEMRegWrite;
-----------------------------------------------------------------------------------------------------------------------------------------







-- process(clk,rst)
-- begin 
--     if(falling_edge(clk))then
        
--     end if;
-- end process;

end architecture ; -- arch