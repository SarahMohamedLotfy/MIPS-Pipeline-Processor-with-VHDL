library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity Alldecoder is 
generic (n:integer := 32);
port(	
  clk: in std_logic;
	IF_ID:in std_logic_vector(50 downto 0);
	RegWriteinput,Swapinput:in std_logic;
	Mem_Wb_Rd,Mem_Wb_Rs: in std_logic_vector(2 downto 0);
  value1,value2 :in std_logic_vector(31 downto 0);
 
  Target_Address,Rsrc,Rdst,PC :out std_logic_vector(n-1 downto 0);
	
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
	IF_ID:in std_logic_vector(5 downto 0);
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
contol_unitt : control_unit port map ( IF_ID(18), IF_ID(16), clk, IF_ID(15 downto 11),RegWrites,
RegDSTs,MemToRegs,MemRds,MemWRs,SPs,ALUs,PCWrites,IMM_EAs,signs,CRRs,
In_enables,Out_enables,thirtyTwo_Sixteens,RRIs,SWAPs, CALLs
	);
	
decoderr : decoder port map ( IF_ID(18),IF_ID(16), clk,IF_ID(10 downto 5 ),RegWriteinput,Swapinput,Mem_Wb_Rd,Mem_Wb_Rs,
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
	PC <= IF_ID(50 downto 19 );
end architecture;

  