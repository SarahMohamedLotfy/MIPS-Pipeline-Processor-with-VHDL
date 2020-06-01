LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use work.bus_multiplexer_pkg.all;
entity ExeStage is
  port (
    clk,rst,INT:in std_logic;
    ID_EX:in std_logic_vector(179 downto 0);
    EXALUResult,MEMALUResult:in std_logic_vector(31 downto 0);--IN port value is an input from system that read in execute cycle direct from system.
    MEM_WBRegisterRd,EX_MEMRegisterRd:IN std_logic_vector(2 downto 0);
    EX_MEMRegWrite,MEM_WBRegWrite,EX_MEMSWAP,MEM_WBSWAP:IN std_logic;
    RegDst,CRR,RtReg,WBsignals:out std_logic_vector(2 downto 0);--CRR output of reg , but ZF output direct from ALU to use in feedback check in branch decision.
    MEMSignals:out std_logic_vector(3 downto 0);
    ZF,SWAP,INTSignal,RET,RTI,CALL,ALUFlagsEnable:OUT std_logic;
    DataOut,AddrressEA_IMM,SRC2out:out std_logic_vector(31 downto 0)
) ;
end ExeStage ;

architecture EXeStagearch of ExeStage is
signal MUXAInput,MUXBInput :bus_array(3 downto 0)(31 downto 0);
signal MUXSRC2_signInput,MUXALUResult_PC1Input,MUXTempA_INPORTInput:bus_array(1 downto 0)(31 downto 0);
signal MUXRt_RdInput:bus_array(1 downto 0)(2 downto 0);
signal IMM_EAbit,CallBit,REGdstSignal,INEnableSignal:std_logic_vector(0 downto 0);
signal MUXResultSel:std_logic_vector(0 downto 0):="0";
signal signType,OVF:std_logic;
signal UpperInstr:std_logic_vector(19 downto 0);
signal PC_1,SRC1,SRC2,SignExtendOut,tempA,A,B,ALUResult,MUXSRC2_signOutput,INPORTValue:std_logic_vector(31 downto 0); 
signal ALUSelectors,EA_Part:std_logic_vector(3 downto 0);
signal Rs,Rt,Rd:std_logic_vector(2 downto 0);--ZF2,SignFlag1,Carry0
signal MUXASel,MUXBSel:std_logic_vector(1 downto 0):="00";
--signal CRREnable:std_logic:='0';
signal Opcode:std_logic_vector(4 downto 0);
signal HasRt:std_logic;
begin
  HasRt<=(not(Opcode(4)) and Opcode(3) and not(Opcode(2))) or(not(Opcode(4)) and Opcode(2) and not(Opcode(3))and Opcode(1));--to indicate that the instruction has rt field to use in forwarding not to neglect data hazard with Rt 
  --in 00101 ,out 00100 ,swap 00110 ,nop 00000
  ALUFlagsEnable<='0' when (Opcode="00101" or Opcode="00100" or Opcode="00110"  or Opcode="00000") else '1'; 
--CRR_Reg:entity work.Reg generic map(n=>3) port map(input=>CRR,en=>CRREnable,rst=>rst,clk=>clk,output=>CRR);
ZF<=CRR(0);
SRC1<=ID_EX(31 downto 0);
SRC2 <= ID_EX(63 downto 32);
SRC2out <=ID_EX(63 downto 32);
Opcode<=ID_EX(79 downto 75);
Rs<=ID_EX(74 downto 72);
RtReg<=ID_EX(71 downto 69);
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
IMM_EAbit(0)<=ID_EX(136);-- zero for rs
REGdstSignal(0)<=ID_EX(137);
INEnableSignal(0)<=ID_EX(138);
--memRead,memWrite,spType
MEMSignals<=ID_EX(142 downto 139);

RET<=ID_EX(143);
RTI<=ID_EX(179);
SWAP<=ID_EX(144);
CallBit(0)<=ID_EX(145);
CALL<=ID_EX(145);
INTSignal<=ID_EX(146);
INPORTValue<=ID_EX(178 downto 147);

MUXRt_RdInput(0)<= Rd;
MUXRt_RdInput(1)<= Rs;
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
MUXALUResult_PC1Input(1)<=std_logic_vector(unsigned(PC_1));
MUXResultSel<="1" when CallBit="1" or INTSignal='1' else "0" when CallBit/="1" and  INTSignal/='1';
-- alu result or pc+1 mux
MUXResult:entity work.mux generic map(bus_width=>32,sel_width=>1) port map(input=>MUXALUResult_PC1Input,sel=>MUXResultSel,output=>DataOut);



AddrressEA_IMM<=B;

ALU:entity work.ALU2 generic map (size=>32) port map(S=>ALUSelectors,A=>A,B=>B,F=>ALUResult,ZF=>CRR(0),SignF=>CRR(1),OVF=>OVF,Cout=>CRR(2));

Forwarding:entity work.ForwardingUnit port map(HasRt,MEM_WBRegisterRd,EX_MEMRegisterRd,Rs,Rt,EX_MEMRegWrite,MEM_WBRegWrite,EX_MEMSWAP,MEM_WBSWAP,MUXASel,MUXBSel);

SignExtendModule:entity work.signextend port map(signType=>signType,-- 0 extend IMM , 1 extend EA
Address=>UpperInstr,
output=>SignExtendOut);

end EXeStagearch ; 