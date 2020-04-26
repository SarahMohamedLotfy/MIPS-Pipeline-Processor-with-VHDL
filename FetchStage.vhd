Library IEEE;
use ieee.std_logic_1164.all;


ENTITY FetchStage IS
    Generic(addressBits: integer := 16;
            wordSize: integer :=16;
            PCSize: integer :=16;
			IFIDLength: integer :=16);
			
	PORT(
            PCReg: in STD_LOGIC_VECTOR(PCSize-1 DOWNTO 0);
			clk: in STD_LOGIC;
		
            IFIDBuffer: out STD_LOGIC_VECTOR(IFIDLength-1 DOWNTO 0);
			instruction: out STD_LOGIC_VECTOR(wordSize-1 DOWNTO 0)
		);

END FetchStage;


ARCHITECTURE FetchStageArch of FetchStage is

SIGNAL tmp:std_logic_vector(15 downto 0); --not used just dummpy variable
signal data_out:std_logic_vector(15 downto 0);

BEGIN

   instruction_memory: entity work.ram  port map (clk,'0','1',PCReg,tmp,data_out);
   instruction<=data_out;
--   IFIDBuffer<=instruction;


END ARCHITECTURE;