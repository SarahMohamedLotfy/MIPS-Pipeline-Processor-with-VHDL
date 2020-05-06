library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity WBStage is
  port (
    clk,rst:std_logic;
    MEM_WB:std_logic_vector(102 downto 0);
    RegWriteToRegisterFile,Swap:std_logic;
    PortOut,Value1,Value2:out std_logic_vector(31 downto 0);
  ) ;
end ent ;

architecture arch of WBStage is
signal SRC2,MemResult,ALUResult:std_logic_vector(31 downto 0);
signal tempSwap:std_logic;
signal Rs,WBsignals:std_logic_vector(2 downto 0) ;
begin
SRC2<=MEM_WB(31 downto 0);
tempSwap<=MEM_WB(32);
Swap<=MEM_WB(32);
Rs<=MEM_WB(35 downto 33);
-- memtoreg , regwrite , outenable
WBsignals<=MEM_WB(38 downto 36);
MemResult<=MEM_WB(70 downto 39);
ALUResult<=MEM_WB(102 downto 71);

RegWriteToRegisterFile<=WBsignals(1);
Value1 <= ALUResult when ( (WBsignals(1) ='1' and WBsignals(0) ='0' ) or (tempSwap='1' and WBsignals(1) = '1')) else MemResult when ( WBsignals(1) ='1' and WBsignals(0) ='1')  ;
PortOut<=ALUResult when WBsignals(2)='1';
Value2 <= SRC2 when (tempSwap='1' and WBsignals(1) = '1');

end architecture ; -- arch