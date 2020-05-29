Library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.bus_multiplexer_pkg.all;

ENTITY FetchStage IS
    Generic(wordSize: integer :=16;
            PCSize: integer :=32);
			
	PORT(
            clk: in STD_LOGIC;
			reset: in std_logic:='0';
			interrupt,pcWrite,MemoryReadSignal,ResumeSignalFromMemory: in std_logic;
			DecodePC,DecodeTargetAddress,MemoryPC:IN std_logic_vector(PCSize-1 downto 0);
			T_NT:IN std_logic_vector(1 downto 0);
			INPORTValue,EXDataOut,DecodeSrc1,DecodeSrc2,EXSrc1,EXSrc2,MemResultFromMemory:IN std_logic_vector(31 downto 0);
			RegWriteFromDecode,RegDstFromDecode,IDEXRegWriteToFetch,SwapFromDecode,IDEXSwapToFetch:In std_logic;
			RegRdFromEXE,RsFromDecode,RdFromDecode,IDEXRsTofetch,IDEXRtTofetch,RtFromDecode:in std_logic_vector(2 downto 0);
			Decode_MemRead,ExeMemRead,Mem_memRead:in std_logic;
			MemRegRd:in std_logic_vector(2 downto 0);
			
--			instruction: in STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
			JZ_Taken:OUT std_logic; -- signal to system to reset zf when jz became taken.
			instruction: out STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0);
			InstrPC,INPORTValueFetchOut : out std_logic_vector(PCSize-1 downto 0);
			intSignal,rstSignal,IF_IDFlush,RET,RTI,INTHandler,RTIHandler,RETHandler,CALLHandler : out std_logic --interrupt signal output 
			  --restet signal output 
		);

END FetchStage;


ARCHITECTURE FetchStageArch of FetchStage is

SIGNAL tmp,tempInstruction:std_logic_vector(15 downto 0); --not used just dummpy variable
signal dummy,JZ,UnconditionBranch,RRISignal,RRIPCWrite,ActualPCWrite,IF_IDFLUSHSig,RRI: std_logic;
signal tINTHandler,tempInterrupt,tRTIHandler,tRETHandler,TempJZTaken,TempJZTakenOut:std_logic_vector(0 downto 0):="0";
signal tempPCnew: STD_LOGIC_VECTOR(PCSize-1 DOWNTO 0);
signal PCReg,PCRegValue: STD_LOGIC_VECTOR(PCSize-1 DOWNTO 0);
signal State:std_logic_vector(1 downto 0);
signal currentPCIndex:std_logic_vector(9 downto 0);
signal oldTargetAddress,Target:std_logic_vector(31 downto 0);--in case of wrong prediction.
signal handlerEn,CALLSIG:std_logic;

---------------------------------------------------forwarding signals -----------------------------------
signal TargetSelector:std_logic_vector(2 downto 0);
signal BranchHazardPcWrite,BranchHazardIFIDFlush:std_logic;
signal MUXTargetAddressInput:bus_array(7 downto 0)(31 downto 0);

BEGIN
	--CALL<=CALLSIG when BranchHazardPcWrite='1' else '0';
   instruction_memory: entity work.ram generic map(1) port map (clk,'0','1',PCRegValue,tmp,tempInstruction);
  
   --PCnew is a value of pc after incremented 
   	--PCAdder:entity work.adder generic map(PCSize)port map(PCReg,"00000000000000000000000000000001",'0',tempPCnew,dummy);
	
	PC_Reg: entity work.Reg(RegFalling) generic map(32) port map(input=>tempPCnew,en=>ActualPCWrite,rst=>'0',clk=>clk,output=>PCRegValue);
	intSignal <=tINTHandler(0);
	tempInterrupt(0)<=interrupt;
	INTHandler<=tINTHandler(0);

	RTIHandler<=RTI when ResumeSignalFromMemory='0' else '0' when ResumeSignalFromMemory='1';

	RETHandler<=RET when ResumeSignalFromMemory='0' else '0' when ResumeSignalFromMemory='1';

	
	interruptBit:entity work.reg(RegArch) generic map(1) port map(input=>tempInterrupt,en=>interrupt,rst=>ResumeSignalFromMemory,clk=>clk,output=>tINTHandler);
	
	JZTakenBit:entity work.reg(RegArch) generic map(1) port map(input=>TempJZTaken,en=>'1',rst=>'0',clk=>clk,output=>TempJZTakenOut);
	JZ_Taken<=TempJZTakenOut(0);
	oldTargetAddress<=Target when jz='1' ;

	INPORTValueFetchOut<=INPORTValue when reset ='0' else (others=>'0') when reset='1' ;
	--reset signal output 
	rstSignal <=reset;
	
	instruction<=(others=>'0') when reset = '1' else tempInstruction when reset ='0';
	PCReg <="00000000000000000000000000001111" when (reset ='1') else PCRegValue when reset='0';
	InstrPC<=PCReg when rising_edge(clk);
	
	ActualPCWrite<='1' when ((RTIHandler='0' and pcWrite='1' and (BranchHazardPcWrite='1') and RETHandler='0' and interrupt ='0' and tINTHandler/="1" ) or MemoryReadSignal='1') else '0';
	
	currentPCIndex<=PCRegValue(9 downto 0) when rising_edge(clk);
	--resume signal from memory to continue the pipe logic.
	IF_IDFlush<= '1' when ((IF_IDFLUSHSig='1' or BranchHazardIFIDFlush='1' or RTIHandler='1' or RETHandler='1' or interrupt='1' or  tINTHandler="1" ) and ResumeSignalFromMemory='0') else '0';

	DecisionCircuit:entity work.decision port map(PCreg=>PCReg,DecodePC=>DecodePC,TargetAddress=>Target,oldTargetAddress=>oldTargetAddress,MemoryPC=>MemoryPC,
	rst=>reset,clk=>clk,ReadFromMemorySignal=>MemoryReadSignal,JZ=>JZ,UnconditionBranch=>UnconditionBranch,
	T_NT=>T_NT,State=>State,IF_IDFLUSH=>IF_IDFLUSHSig,
	
	PCnext=>tempPCnew,JZ_Taken=>TempJZTaken(0));

	CheckBranch:entity work.Check_Branches port map(OpCode=>instruction(15 downto 11),
	JZ=>JZ,CALL=>CALLSIG,unconditionalBranch=>UnconditionBranch);

	CheckRRI:entity work.Check_RRI port map(OpCode=>instruction(15 downto 11),
	
	RRI=>RRISignal,RET=>RET,RTI=>RTI,
	PCwrite=>RRIPCWrite);

	Predicition:entity work.predictionblock port map(
		clk=>clk,JZ=>JZ,
		T_NT=>T_NT,
		--T/NT --> 00 Taken ,01 Not Taken , 10 not jz,11 not jz
		--if not jz then reset state
		CurrentPCIndex=>currentPCIndex,DecodePCIndex=>DecodePC(9 downto 0),--read index from current pc ,, write index from decodepc to write new state.
		IF_IDFlush=>IF_IDFLUSHSig,state=>State);--Read State To decision circuit)




	-------- forwarding target unit------
BranchHazardUnit:entity work.branchhazard generic map(
	RBits=>3,
	RtBits=>3,
	selector=>3)
port map(
   reset=>reset,
   clk=>clk,
   JZ=>JZ,CALL_JMP=>UnconditionBranch,
   Rs_instr_fetch=>tempInstruction(10 downto 8), --1
   Reg_write_decode=>RegWriteFromDecode,--2
   RegDst_decode=>RegDstFromDecode,--3
   Reg_Rd_EX=>RegRdFromEXE,--4
   Rs_instr_decode=>RsFromDecode,--5
   Rd_instr_decode=>RdFromDecode,--6
   ID_EX_RegWrite=>IDEXRegWriteToFetch,--7
   ID_EX_instr_Rs=>IDEXRsTofetch, --8
   ID_EX_instr_Rd=>IDEXRtTofetch, --9
   Rd_decode=>RtFromDecode, --10
   Swap_decode=>SwapFromDecode,--11
   ID_EX_swap=>IDEXSwapToFetch,--12
   Decode_MemRead=>Decode_MemRead,ExeMemRead=>ExeMemRead,Mem_memRead=>Mem_memRead,
   MemRegRd=>MemRegRd,
   PC_write=>BranchHazardPcWrite,
   IF_ID_flush=>BranchHazardIFIDFlush,
   Target_Selector=>TargetSelector

   ); 

   MUXTargetAddressInput(7)<=(others=>'0');
   MUXTargetAddressInput(6)<=MemResultFromMemory;
   MUXTargetAddressInput(1)<=EXDataOut;
   MUXTargetAddressInput(2)<=DecodeSrc2;
   MUXTargetAddressInput(3)<=DecodeSrc1;
   MUXTargetAddressInput(4)<=EXSrc2;
   MUXTargetAddressInput(5)<=EXSrc1;
   MUXTargetAddressInput(0)<=DecodeTargetAddress;
   
   

-- alu result or pc+1 mux
MUXTarget:entity work.mux generic map(bus_width=>32,sel_width=>3) port map(input=>MUXTargetAddressInput,sel=>TargetSelector,output=>Target);



END ARCHITECTURE;