LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.bus_multiplexer_pkg.all;
entity ExeStage is
  port (
    clk,rst,INT:in std_logic;
    ID_EX:in std_logic_vector(146 downto 0);
    EXALUResult,MEMALUResult,INPORTValue:in std_logic_vector(31 downto 0);--IN port value is an input from system that read in execute cycle direct from system.
    MEM_WBRegisterRd,EX_MEMRegisterRd:IN std_logic_vector(2 downto 0);
    EX_MEMRegWrite,MEM_WBRegWrite,EX_MEMSWAP,MEM_WBSWAP:IN std_logic;
    RegDst,CCR:out std_logic_vector(2 downto 0);--CCR output of reg , but ZF output direct from ALU to use in feedback check in branch decision.
    ZF:OUT std_logic;
    DataOut,AddrressEA_IMM:out std_logic_vector(31 downto 0)
  
) ;
end ExeStage ;

architecture EXeStagearch of ExeStage is
signal MUXAInput,MUXBInput :bus_array(3 downto 0)(31 downto 0);
signal MUXSRC2_signInput,MUXALUResult_PC1Input,MUXTempA_INPORTInput:bus_array(1 downto 0)(31 downto 0);
signal MUXRt_RdInput:bus_array(1 downto 0)(2 downto 0);
signal IMM_EAbit,CallBit,REGdstSignal,INEnableSignal:std_logic_vector(0 downto 0);
signal signType,RRI,SWAP,INTSignal,OVF:std_logic;
signal UpperInstr:std_logic_vector(19 downto 0);
signal PC_1,SRC1,SRC2,SignExtendOut,tempA,A,B,ALUResult,MUXSRC2_signOutput:std_logic_vector(31 downto 0); 
signal ALUSelectors,EA_Part,MEMSignals:std_logic_vector(3 downto 0);
signal CCRRegister,Rs,Rt,Rd,WBsignals:std_logic_vector(2 downto 0);--ZF,SignFlag,Carry
signal MUXASel,MUXBSel:std_logic_vector(1 downto 0):="00";

begin
CCR_Reg:entity work.Reg generic map(n=>3) port map(input=>CCRRegister,en=>'1',rst=>rst,clk=>clk,output=>CCR);
ZF<=CCRRegister(0);
SRC1<=ID_EX(31 downto 0);
SRC2 <= ID_EX(63 downto 32);
Rs<=ID_EX(74 downto 72);
Rt <= ID_EX(71 downto 69);
Rd <= ID_EX(68 downto 66);
EA_Part<=ID_EX(68 downto 65);
UpperInstr(19 downto 16) <=ID_EX(68 downto 65);-- 20 bits represent EA or IMM.
UpperInstr(15 downto 0) <=ID_EX(95 downto 80);-- 20 bits represent EA or IMM.
PC_1 <= ID_EX(127 downto 96);
--WB signals memtoReg,regWrite,outenable
WBsignals <= ID_EX(130 downto 128);

ALUSelectors<=ID_EX(134 downto 131);
signType<=ID_EX(135);
IMM_EAbit(0)<=ID_EX(136);
REGdstSignal(0)<=ID_EX(137);
INEnableSignal(0)<=ID_EX(138);
--memRead,memWrite,spType
MEMSignals<=ID_EX(142 downto 139);
RRI<=ID_EX(143);
SWAP<=ID_EX(144);
CallBit(0)<=ID_EX(145);
INTSignal<=ID_EX(146);


MUXRt_RdInput(0)<= Rt;
MUXRt_RdInput(1)<= Rd;
-- Rt , Rd to select the dest reg.
MUXDst:entity work.mux generic map(bus_width=>3,sel_width=>1) port map(input=>MUXRt_RdInput,sel=>REGdstSignal,output=>RegDst);
MUXSRC2_signInput(0)<=SRC2;
MUXSRC2_signInput(1)<=SignExtendOut;
--SRC2 ,output of sign extend block mux 
MUXSRC2:entity work.mux generic map(bus_width=>32,sel_width=>1) port map(input=>MUXSRC2_signInput,sel=>IMM_EAbit,output=>MUXSRC2_signOutput);
MUXAInput(0)<=SRC1; 
MUXAInput(2)<=EXALUResult;
MUXAInput(1)<=MEMALUResult;
--mux tempA select SRC1 or ALUResult from mem or EXE stage
MUXTempmpA:entity work.mux generic map(bus_width=>32,sel_width=>2) port map(input=>MUXAInput,sel=>MUXASel,output=>tempA);

MUXTempA_INPORTInput(0)<=tempA;
MUXTempA_INPORTInput(1)<=INPORTValue;

--mux A select tempA or input port value.
MUXA:entity work.mux generic map(bus_width=>32,sel_width=>1) port map(input=>MUXTempA_INPORTInput,sel=>INEnableSignal,output=>A);


MUXBInput(0)<=MUXSRC2_signOutput;
MUXBInput(2)<=EXALUResult;
MUXBInput(1)<=MEMALUResult;

--mux B select SRC2 or ALUResult from mem or EXE stage
MUXB:entity work.mux generic map(bus_width=>32,sel_width=>2) port map(input=>MUXBInput,sel=>MUXBSel,output=>B);

MUXALUResult_PC1Input(0)<=ALUResult;
MUXALUResult_PC1Input(1)<=PC_1;

-- alu result or pc+1 mux
MUXResult:entity work.mux generic map(bus_width=>32,sel_width=>1) port map(input=>MUXALUResult_PC1Input,sel=>CallBit,output=>DataOut);



AddrressEA_IMM<=B;

ALU:entity work.ALU2 generic map (size=>32) port map(S=>ALUSelectors,A=>A,B=>B,F=>ALUResult,ZF=>CCRRegister(0),SignF=>CCRRegister(1),OVF=>OVF,Cout=>CCRRegister(2));

Forwarding:entity work.ForwardingUnit port map(MEM_WBRegisterRd,EX_MEMRegisterRd,Rs,Rt,EX_MEMRegWrite,MEM_WBRegWrite,EX_MEMSWAP,MEM_WBSWAP,MUXASel,MUXBSel);


end EXeStagearch ; 