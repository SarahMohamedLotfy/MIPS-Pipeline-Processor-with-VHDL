library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity ent is
  port (
    clk,rst,INT:IN std_logic;
  ) ;
end ent ;

architecture arch of ent is



begin
Fetch:entity work.FetchStage  Generic map (wordSize=>16,PCSize=>32) port map(PCReg=>,clk=>reset=>,interrupt=>,instruction=>,PCnew=>,intSignal =>,rstSignal=>)


end architecture ; -- arch