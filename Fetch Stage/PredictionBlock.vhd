library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
entity PredictionBlock is
  port (
    clk,JZ:std_logic;
    T_NT:in std_logic_vector(1 downto 0);
    --T/NT --> 00 Taken ,01 Not Taken , 10 not jz,11 not jz
    --if not jz then reset state
    CurrentPCIndex,DecodePCIndex: in std_logic_vector(9 downto 0);--read index from current pc ,, write index from decodepc to write new state.
    IF_IDFlush:OUT std_logic;
		state: out std_logic_vector(1 downto 0));--Read State To decision circuit
end PredictionBlock ;

architecture arch of PredictionBlock is
signal prediction_stateToWrite,StateRead:std_logic_vector(1 downto 0);
signal BHTWrite:std_logic;

begin
    BHTWrite<=not(T_NT(1));
    state<=StateRead;
Table:entity work.BHT generic map(n=>10) port map(ReadIndex=>CurrentPCIndex,WriteIndex=>DecodePCIndex,
clk=>clk,
Rd=>JZ, 
Wr=>BHTWrite,
predictionState=>prediction_stateToWrite,
state=>StateRead
);
PredicionFSM:entity work.FSM port map(clk=>clk,
inputState=>StateRead,T_NT=>T_NT,IF_IDFlush=>IF_IDFlush,
prediction_state=>prediction_stateToWrite);


end architecture ; -- arch