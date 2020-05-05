library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity Alldecoder is 
generic (n:integer := 32);
port(	
<<<<<<< HEAD
  interrupt,reset, clk: in std_logic;
	IF_ID:in std_logic_vector(13 downto 0);
=======
  clk: in std_logic;
	IF_ID:in std_logic_vector(50 downto 0);
>>>>>>> 53f7a0318c4503e9776e37dd719f248fa46ea5bb
	RegWriteinput,Swapinput:in std_logic;
	Mem_Wb_Rd,Mem_Wb_Rs: in std_logic_vector(2 downto 0);
  value1,value2 :in std_logic_vector(31 downto 0);
 
  Target_Address,Rsrc,Rdst :out std_logic_vector(n-1 downto 0);
	
	--Control signals
	RegWrite,RegDST,MemToReg,MemRd,MemWR: out std_logic;
	SP: out std_logic_vector(2-1 downto 0) ;
	ALU: out std_logic_vector(4-1 downto 0) ;
	PCWrite,IMM_EA,sign,CRR: out std_logic;
	In_enable,Out_enable,thirtyTwo_Sixteen,RRI,SWAP, CALL: out std_logic
);
end entity;

architecture decoder_arch of Alldecoder is
  
component decoder is 
generic (n:integer := 32);
port(	
  interrupt,reset, clk: in std_logic;
	IF_ID:in std_logic_vector(8 downto 0);
	RegWriteinput,Swapinput:in std_logic;
	Mem_Wb_Rd,Mem_Wb_Rs: in std_logic_vector(2 downto 0);
  value1,value2 :in std_logic_vector(31 downto 0);
 
  Target_Address,Rsrc,Rdst :out std_logic_vector(n-1 downto 0)
); 
end component;

component control_unit is 
port(	
  interrupt,reset,clk: in std_logic;
	OpCode: in std_logic_vector(5-1 downto 0) ;
	--Control signals
	RegWrite,RegDST,MemToReg,MemRd,MemWR: out std_logic;
	SP: out std_logic_vector(2-1 downto 0) ;
	ALU: out std_logic_vector(4-1 downto 0) ;
	PCWrite,IMM_EA,sign,CRR: out std_logic;
	In_enable,Out_enable,thirtyTwo_Sixteen,RRI,SWAP, CALL: out std_logic
);
end component;


signal RegWrites,RegDSTs,MemToRegs,MemRds,MemWRs,PCWrites,IMM_EAs,signs,CRRs,In_enables,Out_enables,thirtyTwo_Sixteens,RRIs,SWAPs, CALLs:  std_logic;
signal SPs: std_logic_vector(2-1 downto 0);
signal ALUs: std_logic_vector(4-1 downto 0);
signal Target_Addresss,Rsrcs,Rdsts : std_logic_vector(n-1 downto 0);

begin
<<<<<<< HEAD
contol_unitt : control_unit port map ( interrupt, reset, clk, IF_ID(4 downto 0),RegWrites,
=======
contol_unitt : control_unit port map ( IF_ID(18), IF_ID(16), clk, IF_ID(15 downto 11),RegWrites,
>>>>>>> 53f7a0318c4503e9776e37dd719f248fa46ea5bb
RegDSTs,MemToRegs,MemRds,MemWRs,SPs,ALUs,PCWrites,IMM_EAs,signs,CRRs,
In_enables,Out_enables,thirtyTwo_Sixteens,RRIs,SWAPs, CALLs
	);
	
<<<<<<< HEAD
decoderr : decoder port map ( interrupt,reset, clk,IF_ID(13 downto 5 ),RegWriteinput,Swapinput,Mem_Wb_Rd,Mem_Wb_Rs,
=======
decoderr : decoder port map ( IF_ID(18),IF_ID(16), clk,IF_ID(27 downto 19 ),RegWriteinput,Swapinput,Mem_Wb_Rd,Mem_Wb_Rs,
>>>>>>> 53f7a0318c4503e9776e37dd719f248fa46ea5bb
value1,value2,Target_Addresss,Rsrcs,Rdsts); 
    
  Target_Address <= Target_Addresss;
	Rsrc <=Rsrcs ;
	Rdst <=Rdsts ;
	
	--Control signals
	RegWrite <= RegWrites;
	RegDST <=RegDSTs ;
	MemToReg <= MemToRegs;
	MemRd <= MemRds;
	MemWR<=MemWRs;
	SP <=SPs  ;
	ALU <=ALUs ;
	PCWrite <= PCWrites;
	IMM_EA <= IMM_EAs;
	sign <=signs ;
	CRR <= CRRs;
	In_enable <=In_enables ;
	Out_enable <= Out_enables;
	thirtyTwo_Sixteen <= thirtyTwo_Sixteens;
	RRI<=RRIs;
	SWAP<= SWAPs;
	CALL<= CALLs;
end architecture;

  