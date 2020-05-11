library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity WBStage is
  port (
    clk,rst:in std_logic;
    MEM_WB:in std_logic_vector(105 downto 0);
    RegWriteToRegisterFile,Swap:out std_logic;
    PortOut,Value1,Value2:out std_logic_vector(31 downto 0);
    Rs,Rd:out std_logic_vector(2 downto 0)
  ) ;
end WBStage ;

architecture arch of WBStage is
signal SRC2,MemResult,ALUResult:std_logic_vector(31 downto 0);
signal tempSwap:std_logic;
signal WBsignals:std_logic_vector(2 downto 0) ;
begin
SRC2<=MEM_WB(31 downto 0);
tempSwap<=MEM_WB(32);
Swap<=MEM_WB(32);
Rs<=MEM_WB(35 downto 33);
Rd<=MEM_WB(38 downto 36);
-- memtoreg , regwrite , outenable
WBsignals<=MEM_WB(41 downto 39);
MemResult<=MEM_WB(73 downto 42);
ALUResult<=MEM_WB(105 downto 74);

RegWriteToRegisterFile<=WBsignals(1);
Value1 <= ALUResult when ( (WBsignals(1) ='1' and WBsignals(0) ='0' ) or (tempSwap='1' and WBsignals(1) = '1')) else MemResult when ( WBsignals(1) ='1' and WBsignals(0) ='1')  ;
PortOut<=ALUResult when WBsignals(2)='1';
Value2 <= SRC2 when (tempSwap='1' and WBsignals(1) = '1');

end architecture ; -- arch